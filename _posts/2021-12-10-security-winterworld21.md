---
layout: post
title: 'Using the SecurityBundle in Symfony 6'
categories: talk
tags: symfony

---
At SymfonyWorld Winter 2021, I talked about using the new Symfony
authentication system in your applications in Symfony 6. We discussed
the important changes to the Security component, what we tried to
improve with each change, and how you can use these to make a more
secure application quicker.

<embed src="/assets/uploads/sfwinterworld21-talk.pdf" class="post__slides">

## References & Features

* The security makers in [Symfony MakerBundle](https://symfony.com/bundles/SymfonyMakerBundle/current/index.html)
* [Minimalized `UserInterface`](https://symfony.com/doc/current/security/#the-user)
* SymfonyCasts [VerifyEmailBundle](https://github.com/SymfonyCasts/verify-email-bundle)
  and [ResetPasswordBundle](https://github.com/SymfonyCasts/reset-password-bundle)
* Built-in [form login authenticator](https://symfony.com/doc/current/security/#form-login) and
  [json login authenticator](https://symfony.com/doc/current/security/#json-login)
  ([all built-in authenticators](https://symfony.com/doc/current/security.html#authenticating-users))
* The new Security profiler
* [LexikJWTAuthenticationBundle](https://github.com/lexik/LexikJWTAuthenticationBundle),
  [OneloginSamlBundle](https://github.com/hslavich/OneloginSamlBundle),
  [WebauthnSymfonyBundle](https://github.com/web-auth/webauthn-symfony-bundle),
  [KnpUOauth2ClientBundle](https://github.com/knpuniversity/oauth2-client-bundle) and
  [SchebTwoFactorBundle](https://symfony.com/bundles/SchebTwoFactorBundle/current/index.html)
* The new [Security event cycle](https://symfony.com/doc/current/security/#security-events)
* The new [`debug:firewall` command](https://symfony.com/blog/new-in-symfony-5-4-profiler-improvements#more-security-information-in-the-profiler)
* Symfony [security Passports](https://symfony.com/doc/current/security/custom_authenticator.html#security-passport)
* The new `required_badges` setting
* Implementing [custom authenticators](https://symfony.com/doc/current/security/custom_authenticator.html)
* [Using the new authentication system in Symfony 5](https://symfony.com/doc/5.2/security/experimental_authenticators.html)
* All code of this talk in an example application: <https://github.com/wouterj-nl/security-winterworld21>
