---
layout: post
title: 'Understanding Symfony Security by Using it Standalone'
categories: article
tags: symfony security

---
Setting up big Symfony components in a blank PHP project helps a lot to
understand it. You'll grasp the main architecture of the component much easier
this way. Let's try to understand Symfony Security by doing exactly this!

## Security 101

On almost all platforms, security consists of two phases: Authentication and
Authorization. Let's quickly discuss them before digging deep into Symfony
security:

![Authentication and Authorization](/img/security-phases.png)

1. **Who are you?** is the main question of *Authentication*. Every HTTP request
   again, we have to find out who the requester is. At first visit to a site,
   this is usually a login form. A second request often uses a session stored
   after logging in to find out who you are. An API call often uses API tokens
2. **Are you allowed to do this?** is the question answered during
   *Authorization*. Every request involves an action. For instance, you are
   reading this blog article, I'm editing it at the moment, over 10 years I'll
   probably delete it, etc. During authorization, we find out if the person
   identified in (1) is allowed to do the action he wants to do

## Set-up our Blank Project

<aside class="side" data-type="example">
The final project of this blogpost can be found at
[github](https://github.com/wouterj-nl/security-standalone).
</aside>

Setting up a blank project is nothing more than creating a new directory. In
the directory, we'll use [Composer](https://getcomposer.org/) to install the
Security Core component:

```bash
$ mkdir security-101
$ cd security-101
$ composer require symfony/security-core
```

Security contains a couple sub components: Core, Http, Guard, Csrf. In this
post, we'll focus on the core only. In a funny plot twist, you'll directly
discover what HTTP is doing if you're reading the side notes!

## Authentication Input: The token

The question "who are you?" can only be answered if we have input from the user
world (there must be a "you"). This input can be anything. As already
explained, the values of the login form upon login is one example of this
input. In all requests after the user logged in, a browser session represents
the input from user world.

<aside class="side" data-type="Symfony internals">
The HTTP Security component uses listeners attached to
[`kernel.request`](https://symfony.com/doc/current/reference/events.html#kernel-request)
to create tokens. For instance, the
[`UsernamePasswordFormAuthenticationListener`](https://github.com/symfony/security/blob/88588499b5c3ed78becea8e0c4ec8d81e0e4f483/Http/Firewall/UsernamePasswordFormAuthenticationListener.php)
creates a `UsernamePasswordToken` based on the login form submit.
</aside>

As our goal is just to write one working PHP file, we'll use static strings as
"input from the user":

```php
<?php // secure.php

require_once 'vendor/autoload.php';

use Symfony\Component\Security\Core\Authentication\Token\UsernamePasswordToken;

$token = new UsernamePasswordToken('wouter', 'pa$$word', 'default');
```

This type of token is most often used in traditional applications, it holds a
username and a password (ignore that third argument for the moment). Other
tokens are for instance a `RememberMeToken`, which uses a browser cookie, or
you can create an `BearerToken` that contains a header used for API requests.

### Let's Authenticate the Token: Meet the AuthenticationManager

Now we have the token representing the user input, it's time to authenticate
it. The Security component provides an `AuthenticationManagerInterface` for this.
By default, only one implementation of this interface is provided: The
`AuthenticationProviderManager`. Its name is quite confusing, it's not managing
*authentication providers*, but it is the *authentication manager* based on
*authentication providers*.

`AuthenticationProviderInterface` classes do the hard work for this manager:
They transform an unauthenticated token into an authenticated token. In other
words, they transform user input into a security identity.

<aside class="side" data-type="Symfony internals">
[Other authentication providers](https://github.com/symfony/security/tree/88588499b5c3ed78becea8e0c4ec8d81e0e4f483/Core/Authentication/Provider)
are for instance a `RememberMeAuthenticationProvider` (authenticating a remember-me
cookie) and an `AnonymousAuthenticationProvider` (which always returns a token
representing an anonymous user).
</aside>

The most commonly used provider is the `DaoAuthenticationProvider` (**D**ata
**A**ccess **O**bject). It uses a *user provider* to find a user matching the
input from somewhere and then matches the password (using a *password encoder*).

### Set-up some User Resources: The UserProvider

To get things working, we first define a class able to load users from "some
resource". In this case, we use the `InMemoryUserProvider` that fetches users
from a PHP array.

<aside class="side" data-type="Symfony internals">
[Other user providers](https://github.com/symfony/security/tree/88588499b5c3ed78becea8e0c4ec8d81e0e4f483/Core/User)
load users from a database or LDAP servers.
</aside>

```php
// secure.php
use Symfony\Component\Security\Core\User\InMemoryUserProvider;
// ...

$userProvider = new InMemoryUserProvider([
    'wouter' => [
        'password' => 'pa$$word',
        'roles' => ['TITLE_SUPERVISOR']
    ],
]);

// As an example of this class, let's find the user:
$wouterUser = $userProvider->loadUserByUsername('wouter');
```

### Safety first: Encrypted User Passwords

Saving plain texts passwords is a no-go for web applications. They are often
encoded using for instance bcrypt or sha256. This is abstracted in *password
encoders*. They are able to encode a plain text password and check whether the
password entered by the user was valid:

```php
// secure.php
use Symfony\Component\Security\Core\Encoder\EncoderFactory;
use Symfony\Component\Security\Core\Encoder\PlaintextPasswordEncoder;
use Symfony\Component\Security\Core\User\User;
// ...

$encoderFactory = new EncoderFactory([
    // we take the easiest road: plain text passwords
    User::class => new PlaintextPasswordEncoder(),
]);

// First, get the encoder associated with our user (other users
// can use other encoders).
$encoderFactory->getEncoder(User::class)
    // Then, check whether some input matches our user's password:
    ->isPasswordValid($wouterUser->getPassword(), 'pa$$word', '');
```

### Instantiating the Authentication Manager

Yay, it took quite some effort, but we're ready to create the
`AuthenticationProviderManager`!

<aside class="side" data-type="Symfony internals">
If you look closely, the `'default'` string is equal to the one provided in the
token: This is the *provider key*. It is used to make sure the token is from
our application and also to know which provided should handle the token
(multiple providers might be able to handle a `UsernamePasswordToken`).
</aside>

```php
// secure.php
use Symfony\Component\Security\Core\Authentication\AuthenticationProviderManager;
use Symfony\Component\Security\Core\Authentication\Provider\DaoAuthenticationProvider;
use Symfony\Component\Security\Core\User\UserChecker;
// ...

$authenticationManager = new AuthenticationProviderManager([
    new DaoAuthenticationProvider(
        $userProvider,
        new UserChecker(),
        'default',
        $encoderFactory
    ),
]);
```

As you see, there is one more class: The `UserChecker`. It checks some "user
flags" after it is fetched from the user provider. This includes for instance
whether the user is activated, banned, etc.

### Authenticating the Token

<aside class="side" data-type="Symfony internals">
The firewall listeners of Http security also call the authenticate method
directly. See for instance the
[`UsernamePasswordFormAuthenticationListener`](https://github.com/symfony/security/blob/88588499b5c3ed78becea8e0c4ec8d81e0e4f483/Http/Firewall/UsernamePasswordFormAuthenticationListener.php#L100).
</aside>

Finally – we're more than halfway the post now – we are able to authenticate
the token we created:

```php
// secure.php

// ...

$authenticatedToken = $authenticationManager->authenticate($inputToken);

echo 'Hello '.$authenticatedToken->getUsername().'!';
```

## Authorize Actions: The AccessDecisionManager

<aside class="side" data-type="Symfony internals">
Symfony security started as a direct port of JAVA's [Spring
Security](https://spring.io/projects/spring-security). This is why the naming
is often quite different from the rest of Symfony. It however, gives you two
documentations to understand Security!
</aside>

Now we've authenticated the user input and the Security system validated our
input, it's time to answer the *Are you allowe to do this?* question. Let me
introduce you to yet another "manager": `AccessDecisionManagerInterface`.

The default implementation uses "Security voters" to decide whether the user is
allowed to execute an action. These voters are provided with an *attribute*
(representing the action) and optionally some context (i.e. the subject of the
action).

<aside class="side" data-type="Symfony internals">
In the Http component, an [`AccessListener`](https://github.com/symfony/security/blob/88588499b5c3ed78becea8e0c4ec8d81e0e4f483/Http/Firewall/AccessListener.php)
checks access using this manager based on the configured `access_control`
rules.
</aside>

```php
// secure.php
use Symfony\Component\Security\Core\Authorization\AccessDecisionManager;
// ...

$accessDecisionManager = new AccessDecisionManager([
    // ... voters
]);
```

The default voters of Symfony are a bit strange, they don't validate an action,
but validate the user's identity. One of them is the `RoleVoter`. It checks
whether `User#getRoles()` contains the provided attribute:

<aside class="side" data-type="Symfony internals">
A `RoleHierarchyVoter` is also provided, which understands hierarchies in
roles (i.e. "admin is a user"). [Another default voter](https://github.com/symfony/security/tree/88588499b5c3ed78becea8e0c4ec8d81e0e4f483/Core/Authorization/Voter)
is the `AuthenticatedVoter`, which checks if the token is fully authenticated,
anonymous, etc.
</aside>

```php
// secure.php
use Symfony\Component\Security\Core\Authorization\Voter\RoleVoter;
// ...

$accessDecisionManager = new AccessDecisionManager([
    // TITLE_ is the prefix an attribute must have in order to be
    // managed by this voter
    new RoleVoter('TITLE_'),
]);

// now we can use the access decision manager to see if the
// authenticated token has the "supervisor" role:
$isSupervisor = $accessDecisionManager->decide(
    $authenticatedToken,
    ['TITLE_SUPERVISOR']
);

// If we add a custom voter, we would be able to i.e. test if we are
// able to view a user's profile:
$canViewProfile = $accessDecisionManager->decide(
    $authenticatedToken,
    ['VIEW'],
    $authenticatedToken->getUser() // some context for the "view" action
);
```

## Relation with the Symfony Framework

Now, if we take a look at the configuration for the SecurityBundle, we'll find
many relations with the architecture used above:

```yaml
security:
    # Providers: UserProvider classes
    providers:
        in_memory:
            # indicating the InMemoryUserProvider
            memory: ~

    # The UserPasswordEncoders
    encoders:
        Symfony\Component\Security\Core\User\UserInterface: plaintext

    # Firewalls are listeners of the HTTP component that
    # execute authentication based on paths
    firewalls:
        # ...

        # Each firewall configures a list of authentication providers
        # used for this AuthenticationProviderManager. I.e. all
        # firewalls are one AuthenticationProviderManager (and thus,
        # one security system).
        main:
            # AnonymousAuthenticationProvider
            anonymous: true

            # Use UsernamePasswordToken and DaoAuthenticationProvider
            http_basic: true
            form_login: true

    # Relate to AccessDecisionManager#isGranted() calls for
    # specific paths
    access_control:
        - { path: ^/admin, roles: ROLE_ADMIN }
        - { path: ^/profile, roles: ROLE_USER }
```

## Take Home's

I hope this posts has provided you some insights in how the Security component
works.

* Security HTTP is only a small layer converting HTTP requests into input for
  the Security system
* There are many similarities between the config in the Symfony framework and
  the workings of the Security Core component
* A complete working implementation of the Security component can be achieved
  in 20 lines of PHP

In this posts, you might have also observed some weird things. I'll go into
further detail on them in later posts.

* There is no build-in authorization for API tokens
* The token representing user input is the same as the authenticated token
* Authorization by default is on the *identity* rather than the *action*
