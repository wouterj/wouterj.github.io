---
layout: post
title: Manage environment variables in Kubernetes with Flux CD
categories: article
tags: kubernetes, flux

---
Following the [Twelve-factor app](https://12factor.net) methodology, most
web applications are (partially) configured through environment variables.
When changing the environment variables, you don't want to completely
redeploy the whole application. We're using [Flux CD](https://fluxcd.io) to
achieve this in Kubernetes without building a new version of the
application's Helm chart.

Flux CD is a GitOps tool. It runs as an operator in the Kubernetes cluster.
This operator synchronizes Kubernetes resources from a *source* (in our
case, a private GitLab repository) to the cluster. Whenever you change the
repository, the resource will change in the cluster.

In this GitLab repository, we define the environment variables from the
application in a ConfigMap:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
    name: gitops-our-application
    namespace: production
data:
    APP_ENV: prod
    # ...
```

Sensitive environment variables (e.g. the database DSN) can be put in a
Secret. Encrypt these values in the Git repository using [SOPS](https://getsops.io).
Flux will automatically decrypt them when creating the Secret resource in
the cluster.  
You can of course also store sensitive config in a secret vault.

After creating these resources, we need to import them into our
deployments. This can be done by using `envFrom`, referencing the resources
created by Flux:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: our-application
  namespace: production
spec:
  template:
    spec:
      containers:
        - # ...
          # [!code focus:5]
          envFrom:
            - configMapRef:
                name: gitops-our-application
            - secretRef:
                name: gitops-our-application
```

Now we're set! Upon releasing this Helm chart, the deployment will read the
environment variables from the ConfigMap and Secret. Whenever we change the
files in the GitLab repository, Flux will update these in the cluster
within minutes.

However... Kubernetes doesn't restart the pod when the mounted ConfigMap or
Secret changes. When the environment variables change, the application won't
read the new environment variables until after a new deploy. The
[Reloader](https://github.com/stakater/Reloader) operator solves this, by
forcing Kubernetes to restart the pod when the mounted ConfigMap or Secret
changes. After installing the operator, add the appropriate annotation:

```yaml
kind: Deployment
# ...
spec:
  template:
    metadata:
      # [!code focus:2]
      annotations:
        reloader.stakater.com/auto: "true"
  # ...
```

Now, an update of the ConfigMap in the GitLab repository triggers Flux to
update it in the cluster. This then triggers Reloader to force a restart of
the pods. Within a minute after committing, the application will have the
new config values without a complete redeploy!
