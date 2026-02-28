---
layout: post
title: Symfony in 200 lines
categories: article
tags: php

---
In 2013, Fabien Potencier [blogged][fabien-blog] about a One File
challenge: creating a Symfony app in 1 file and under 200 lines of code.
The series never finished, but it initiated the Symfony Flex project. With
more than 10 years of innovation, can we complete this challenge today?

[fabien-blog]: https://fabien.potencier.org/packing-a-symfony-full-stack-framework-application-in-one-file-introduction.html

<aside class="side" data-type="Special thanks">
Special thanks go to Symfony core team member [Yonel Ceruto](https://github.com/yceruto).
When I jokingly restarted this challenge in 2024, he jumped on
the topic and [contributed](https://github.com/symfony/symfony/pull/57408)
some better default behavior to the Symfony Kernel for minimal applications.
</aside>

## Minimal Skeleton

At the time of Fabien's challenge, every new Symfony project used the
[Symfony Standard Edition][se]. This repository installed `symfony/symfony`,
Doctrine, Monolog and SwiftMailer. It always installed all directories and files of
a Symfony application back then.

Symfony Flex radically changed this. This Composer plugin creates
configuration and files on the fly when installing a dependency. For
instance, you only get the `src/Entity/` directory when you install the
Doctrine ORM.

With Flex, the Symfony Standard Edition made way for the [Symfony
Skeleton][skeleton]. This contains one file (`composer.json`) with the
least amount of dependencies required to start a Symfony application. The
big `symfony/symfony` package, including all Symfony packages, no longer
exists. You'll install each Symfony component, bundle and bridge
individually whenever you need them.

Different variants of this skeleton exist, like the [Webapp variant][webapp]
that installs more libraries commonly found in web applications. For our
One file challenge, we want the least amount of files and dependencies. The
minimal skeleton will be our starting point!

<aside class="side" data-type="example">
You can follow along with this blogpost using the [demo repository on
GitHub](https://github.com/wouterj-nl/symfony-onefile/). The commit history
follows the steps in this post.
</aside>

Create a new project with this skeleton using `composer create-project` or
[the `symfony` CLI][cli]:

```terminal
$ symfony new symfony-onefile
```

This gives us a great starting point for the challenge, but Symfony Flex
gave us a lot more files!

```text
symfony-onefile/
├── bin/
│   └── console
├── config/
│   ├── bundles.php
│   ├── packages/
│   │   ├── cache.yaml
│   │   ├── framework.yaml
│   │   └── routing.yaml
│   ├── preload.php
│   ├── routes/
│   │   └── framework.yaml
│   ├── routes.yaml
│   └── services.yaml
├── public/
│   └── index.php
├── src/
│   ├── Controller/
│   │   └── .gitignore
│   └── Kernel.php
├── var/
├── vendor/
├── .editorconfig
├── .env
├── .env.dev
├── composer.json
├── composer.lock
└── symfony.lock
```

[se]: https://github.com/symfony/symfony-standard
[skeleton]: https://github.com/symfony/skeleton
[webapp]: https://github.com/symfony/webapp-pack
[cli]: https://symfony.com/download

## Default Configuration

Most files are in the `config/` directory; this is a good start to make our
project smaller!

The Flex recipes are doing two things: provide sensible configuration for
the application and showcasing other common configuration options. The
latter means recipes come with a lot of commented configuration that might
be useful. Let's remove the commented configuration.

While we're at it, let's also remove test and production-specific
configuration. This application is going minimal instead of production
ready, so we're not interested in these other environments.

```diff
 # config/packages/cache.yaml
 framework:
     cache:
-        # Unique name of your app: used to compute stable namespaces for cache keys.
-        #prefix_seed: your_vendor_name/app_name
-
-        # The "app" cache stores to the filesystem by default.
-        # The data in this cache should persist between deploys.
-        # Other options include:
-
-        # Redis
-        #app: cache.adapter.redis
-        #default_redis_provider: redis://localhost
-
-        # APCu (not recommended with heavy random-write workloads as memory fragmentation can cause perf issues)
-        #app: cache.adapter.apcu
-
-        # Namespaced pools use the above "app" backend by default
-        #pools:
-            #my.dedicated.cache: null
```

```diff
 # config/packages/framework.yaml
-# see https://symfony.com/doc/current/reference/configuration/framework.html
 framework:
     secret: '%env(APP_SECRET)%'
-
-    # Note that the session will be started ONLY if you read or write from it.
     session: true
-
-    #esi: true
-    #fragments: true
-
-when@test:
-    framework:
-        test: true
-        session:
-            storage_factory_id: session.storage.factory.mock_file
```

```diff
 # config/packages/routing.yaml
 framework:
     router:
-        # Configure how to generate URLs in non-HTTP contexts, such as CLI commands.
-        # See https://symfony.com/doc/current/routing.html#generating-urls-in-commands
         default_uri: '%env(DEFAULT_URI)%'
-
-when@prod:
-    framework:
-        router:
-            strict_requirements: null
```

This leaves us only with a couple config values:

 * `framework.cache` exists, but is empty. We can remove this file entirely
 * `framework.secret`. This option is only used for remember-me
   functionality and signing URLs/ESI in Symfony. For the sake of the challenge, we can
   remove it, but I don't recommend doing this in any real app
 * `framework.session`. Our minimal application won't need session storage.
   We can remove this safely
 * `framework.router.default_uri`. While very useful when generating URLs
   in e.g. console commands, this is not something we want in our minimal
   app

In other words, we can remove all configuration file in `config/packages/`.
That's -44 lines of code already!

### Environment Variables

Now we removed all package configuration, we can also take a look at the
`.env` and `.env.dev` files. We've removed the usage of the `APP_SECRET`
and `DEFAULT_URI` env vars, so we can remove those.

That leaves us with `APP_ENV` and `APP_SHARE_DIR`. Both are very useful for
proper deployments of the application. For this challenge, we can
remove them without creating issues.

After deleting the `.env` and `.env.dev` files, we also need to remove the
`symfony/dotenv` Composer dependency. Otherwise, Symfony will keep trying
to load the `.env` file.

```terminal
$ composer remove symfony/dotenv
```

### Routing

Next up, let's look at the routing configuration.

The `routes/framework.yaml` file contains only environment-specific
configuration. We can remove that file. The `routes.yaml` loads routes from
our controller class. This is still required for our minimal application
for now (spoiler: we'll remove it later!).

## Moving Configuration in the Kernel

There are some other files in the `config/` directory that we can simplify
a lot. First, we need to learn a bit about the core of every Symfony
application: the Kernel.

Every application defines this class and you can find it in `src/Kernel.php`.
This class boots up the whole Symfony application: loading all bundles,
configuring the service container, loading the route configuration,
starting the request lifecycle, returning the response, etc.

Let's start with loading the bundles: The `config/bundles.php` file returns
a list of bundles to register. This is actually just a convention: the
`Kernel::registerBundles()` method must return the list of enabled bundles. The
`MicroKernelTrait` ships an [implementation of this
method](https://github.com/symfony/symfony/blob/1d6106e566188f714b72a68932cae3fe899939de/src/Symfony/Bundle/FrameworkBundle/Kernel/MicroKernelTrait.php#L146-L160)
that just so happens to load the `config/bundles.php` file.

Interestingly, this method contains one other bit of logic:

```php
trait MicroKernelTrait
{
    // ...
    public function registerBundles(): iterable
    {
        if (!is_file($bundlesPath = $this->getBundlesPath())) {
            yield new FrameworkBundle();

            return;
        }

        // ...
    }
}
```

In other words, if the `config/bundles.php` file does not exist, it
defaults to registering only the Symfony FrameworkBundle. Our minimal
`bundles.php` also only loaded the FrameworkBundle, so we can delete
the file altogether.

### Service Container Configuration

The next job of the Kernel is to create the service container and load all
services based on our configuration. You are probably used to the service
configuration living in `config/services.yaml`.

This again is just a convention from the `MicroKernelTrait`. The real hero
is `Kernel::registerContainerConfiguration()`. The [implementation of the
trait](https://github.com/symfony/symfony/blob/1d6106e566188f714b72a68932cae3fe899939de/src/Symfony/Bundle/FrameworkBundle/Kernel/MicroKernelTrait.php#L50-L64)
calls the `configureContainer()` method, which imports the `services.yaml`
file (and environment-specific files).

We can transform the YAML configuration to PHP code and override this method
in our app's Kernel:

```php
class Kernel extends BaseKernel
{
    use MicroKernelTrait;

    private function configureContainer(ContainerConfigurator $container, LoaderInterface $loader, ContainerBuilder $builder): void
    {
        $container->services()
            ->defaults()
                ->autowire(true)
                ->autoconfigure(true)
            ->load('App\\', __DIR__)
      ;
    }
}
```

### Moving Routing Configuration to the Kernel

I promised to get back to the `routes.yaml` file. You might have guessed
it: this file is also [just a convention from the MicroKernelTrait](https://github.com/symfony/symfony/blob/1d6106e566188f714b72a68932cae3fe899939de/src/Symfony/Bundle/FrameworkBundle/Kernel/MicroKernelTrait.php#L75-L91).

The `registerContainerConfiguration()` method configures the Routing
component to load its routes from the `loadRoutes()` method. This method
then calls the `configureRoutes()` method, which imports the
`config/routes.yaml` file and its friends. We could also convert the YAML file
to PHP code and override `configureRoutes()`.

However, `loadRoutes()` has one more trick:

```php
private function configureRoutes(RoutingConfigurator $routes): void
{
    // ...
    if (false !== ($fileName = (new \ReflectionObject($this))->getFileName())) {
        $routes->import($fileName, 'attribute');
    }
}
```

The Kernel class itself is always configured to find methods with the
`#[Route]` attribute. If we define the controller method in the Kernel
class, we don't need any routing config.

As an example, let's add a homepage controller and remove the
`config/routes.yaml` file:

```php
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class Kernel extends BaseKernel
{
    // ...

    #[Route('/')]
    public function home(): Response
    {
        $loc = count(file(__FILE__));

        return new Response(<<<EOF
            <!doctype html>
            <title>Symfony One File Challenge</title>
            <h1>Symfony One File Challenge: {$loc} lines</h1>
            EOF);
    }
}
```

### Cleaning up the Config Folder

After moving all these things to the Kernel class, the `config/` folder now
only contains two auto-generated files: `preload.php` and `reference.php`. We
can remove the whole directory now.

That removes a total of 827 lines of code!

## Merging Front Controllers

We've removed quite a lot of files and lines in our minimal application.
Let's take another look at the file structure:

```text
symfony-onefile/
├── bin/
│   └── console
├── public/
│   └── index.php
├── src/
│   └── Kernel.php
├── var/
├── vendor/
├── .editorconfig
├── composer.json
├── composer.lock
└── symfony.lock
```

Only three application files are left:
* `src/Kernel.php`: the file holding our entire application (kernel, config
  and controller)
* `public/index.php`: the front controller to handle HTTP request to our
  app
* `bin/console`: the front controller to handle CLI commands of our app

If we manage to merge the two front controllers into one, we might even be
able to merge our Kernel class definition in there.

Both front controllers use the [Symfony Runtime component](https://symfony.com/doc/current/components/runtime.html).
The files return a closure that is picked up by this component. The
closure returns an `Application` with our Kernel for CLI commands, and our
Kernel for HTTP requests. We can use PHP's `PHP_SAPI` constant to
determine if a file is called from an CLI context or HTTP one:

```php
<?php // app.php

use App\Kernel;
use Symfony\Bundle\FrameworkBundle\Console\Application;

require_once __DIR__.'/vendor/autoload_runtime.php';

return function (array $context) {
    $kernel = new Kernel($context['APP_ENV'], (bool) $context['APP_DEBUG']);

    return 'cli' === PHP_SAPI ? new Application($kernel) : $kernel;
};
```

It looks like we should now be able to delete the `bin/console` and
`public/index.php` files.

If you're using the Symfony CLI webserver, it will also automatically
detect our new `app.php` front controller. Restart the server, go to your
browser and you should still see our custom controller. And calling the
front controller using `php app.php` also still gives us the command
interface. Success!

### One File Application

We're so close now! Let's try merging the last two remaining files into
one by moving the `Kernel` class definition from `src/Kernel.php` to
our new `app.php` file.

When you try this, you'll see an error like `Expected to find class
"App\app" in file "symfony-onefile/app.php"`. This is because we are still
trying to auto-discover service definitions in the `configureContainer()`
method. As our single file application doesn't need any services, we can
remove this method override (the Kernel always registers itself as a
service).

## Conclusion

With that, we've reached the end of this challenge. Our entire Symfony
application is now nothing more than one file, one class, one method and
one closure:

```php
<?php

use Symfony\Bundle\FrameworkBundle\Console\Application;
use Symfony\Bundle\FrameworkBundle\Kernel\MicroKernelTrait;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Kernel as BaseKernel;
use Symfony\Component\Routing\Attribute\Route;

require_once __DIR__.'/vendor/autoload_runtime.php';

class Kernel extends BaseKernel
{
    use MicroKernelTrait;

    #[Route('/')]
    public function home(): Response
    {
        $loc = count(file(__FILE__));

        return new Response(<<<EOF
            <!doctype html>
            <title>Symfony 1 file challenge</title>
            <h1>Symfony 1 file challenge: {$loc} lines</h1>
            EOF);
    }
}

return function (array $context) {
    $kernel = new Kernel($context['APP_ENV'], (bool) $context['APP_DEBUG']);

    return 'cli' === PHP_SAPI ? new Application($kernel) : $kernel;
};
```

With only 32 lines, we've more than reached the goal of less than 200 lines!
Using more [code golf](https://en.wikipedia.org/wiki/Code_golf) techniques,
you can probably reduce it more if you want to.

Along the way, I hope you've learned some insights on how the Symfony
Kernel works. The `MicroKernelTrait` helps us by providing the
conventions we know from Symfony. However, everything is adaptable to
whatever convention you would like to use!
