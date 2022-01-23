---
layout: post
title: 'Meet the new Symfony Security: Authenticators'
categories: article
tags: symfony security
star: true

---
After more than half a year of work and discussions, Symfony 5.1 ships
with an experimental and revisited Security system. I'm incredibly
excited about this system, as I think it opens up the component for a
lot of possibilities. That's why in the coming week, I'll publish a
series of blogposts about this new system. I hope you'll be just as
excited as I am and help realising the full potential with us!

<aside class="side" data-type="Try it yourself!">
If you're using Symfony 5.1, the SecurityBundle comes with all tools you
need! Set `security.enable_authenticator_manager` to `true` to enable the
new system!

Please be aware that this new system in experimental. It may contain
backwards compatibility breaks in 5.2. However, I don't like to ruin the
life of early-testers so we keep this to the bare minimum. Please give it
a go and report any suggestions, problems, bugs, leaks or whatever!
</aside>

So... what is so different about this new system? It would like to
summarize it in three topics:

* [It removes everything but Guard](#removed-everything-but-guards)
* [It refactored to an event-based System](#moved-to-an-event-based-system)
* [It introduces the next generation of Guards](#the-next-generation-of-guards)

## Removed everything but Guards

Since Symfony 2.0, the authentication system of Symfony can be drawn
like this:

![Symfony Security](/img/security2-providers-listeners.png)

This diagram has set-up 2 firewalls (yellow and red). The yellow
firewall has 2 different ways to authenticate (e.g. login form and json
login) and the red firewall has one way to authenticate (e.g. JWT).

A *firewall listener* extracts all necessary information from the
request (e.g. username, password, csrf token). This is passed into a
global *authentication manager*, which then calls the required
*authentication provider* (e.g. one that can authenticate a username and
password).

If you were to write your own custom authentication, you would most
likely need to provide a custom *listener*. This listener needs to do
all stuff: calling the manager, storing the authenticated token, setting
up the session (e.g. migrating it) and creating a correct response. It's
very easy to forget a step, resulting in a less secure or broken
authentication. Hence, if you look at Symfony's own firewall listeners,
you can find minor inconsistencies as well.

The new authenticator system can be drawn like this:

![Symfony Authenticators](/img/security2-authenticators.png)

1. There is *only one* listener, provided by Symfony, that passes the
   request into an authenticator manager
2. There is *one* authenticator manager per firewall. This manager calls
   the correct authenticator, which authenticates the request and
   returns a response

You now only need to write a custom authenticator. The authenticator
manager (maintained by Symfony) takes care of session management,
storing the token, remember me functionality, etc. So there are less
things to forget!

This may appear to be similar to Guards in the current system... It is!
However, the internal logics of the component was still using the
listeners and providers. This new system makes them all use exactly the
same interface: Authenticators. This makes it easier to understand and
contribute to the Security component.

As there now is one authenticator manager per firewall, the manager
knows how to authenticate a request and return a success response. **This
also allowed us to add programmatic login to Symfony**: The manager is
now finally able to authenticate a User object and return a success
response.

## Moved to an Event-based System

Symfony's HttpKernel component is built around
[5 kernel events](https://symfony.com/doc/current/components/http_kernel.html#httpkernel-driven-by-events).
Listeners to these events execute the core process of Symfony: finding a
controller, executing that controller and handling the response. You can
also create your own event listeners on these events, so you can
completely customize and extend this core process.

<aside class="side" data-type="Here's how you can help">
I can imagine Symfony providing a *login throttling listener*, which
blocks login for a couple of minutes after too many failed attempts.

Or e.g. a monolog logger to log failed attempts (such that you can
analyse them and block misbehaving IPs or the like).

You can probably come up with even better ideas of listeners! Please
contribute them to Symfony.
</aside>

Up to now, the Security component didn't use events for this purpose.
This made many parts of the component quite hard to extend or customize.
That's why this new system is built around 3 main events:

`VerifyAuthenticatorCredentialsEvent`
: This is the most important event. Its listeners validate any
credentials returned from the authenticator (e.g. a password or CSRF
token).

`LoginSuccessEvent`
: If all credentials were valid, this event is dispatched. The core
system uses this to e.g. create a remember me cookie or upgrade the
password hash.

`LoginFailureEvent`
: If there was an error or credentials are not correct, this event is
dispatched.

All core logic is now executed as listener on these events. E.g. if an
authenticator requires a password to be validated, a listener on
`VerifyAuthenticatorCredentialsEvent` will do this for you. Things like
user checkers, session strategies, remember me cookies, password
upgrading are all done inside event listeners.

## The Next Generation of Guards

<aside class="side" data-type="Here's how you can help">
It would be lovely to have many more modern authenticators inside
Symfony core:

* Third-party/redirections: SAML, OAuth, ...
* API tokens: JWT, JOSE, PASETO, Windows Identity Foundation, ...
* "Magic links" sent via Notifier component
</aside>

A few years ago,
[Guards](https://symfonycasts.com/blog/guard-authentication) where
introduced to provide a better extension point for Security. The new
system started with this exact Guard interface as a base. The event
based logic introduced a centralized credentials checking. This removed
the need for a `checkCredentials()` method in the Guard interface. Later
on, we introduced some more changes to the interface: The next generation
`AuthenticatorInterface` was born!

The big change from the Guard interface you may know is that
`getCredentials()` and `getUser()` are merged into one method:
`authenticate(Request $request)`. And, as mentioned before,
`checkCredentials()` is gone.

This new `authenticate()` method creates a *Security Passport*. This is
a new concept in authenticators. **A passport contains the user and any
credentials needed to authenticate.** This extra information is provided
using *Passport Badges*. Listeners on the
`VerifyAuthenticatorCredentialsEvent` will validate and check the
passport and all its badges. If *all* badges are resolved, the user is
succesfully authenticated.

Let's see the passport in action. Assume we're building a form login:

```php
// ...
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Security\Core\Exception\UsernameNotFoundException;
use Symfony\Component\Security\Http\Authenticator\AuthenticatorInterface;
use Symfony\Component\Security\Http\Authenticator\Passport\Badge\CsrfTokenBadge;
use Symfony\Component\Security\Http\Authenticator\Passport\Credentials\PasswordCredentials;
use Symfony\Component\Security\Http\Authenticator\Passport\Passport;
use Symfony\Component\Security\Http\Authenticator\Passport\PassportInterface;

class FormAuthenticator implements AuthenticatorInterface
{
    // ...

    public function authenticate(Request $request): PassportInterface
    {
        // find a user based on an "email" form field
        $user = $this->userRepository->findOneByEmail($request->get('email'));
        if (!$user) {
            throw new UsernameNotFoundException();
        }

        // return the Security passport
        return new Passport(
            // add the user we've just found
            $user,
            // add credentials from the "password" form field
            new PasswordCredentials($request->get('password')),
            [
                // and CSRF protection using a "csrf_token" field
                new CsrfTokenBadge('loginform', $request->get('csrf_token'))

                // and add support for upgrading the password hash
                new PasswordUpgradeBadge(
                    $request->get('password'),
                    $this->userRepository
                )
            ]
        );
    }
}
```

<aside class="side" data-type="Here's how you can help">
I've talked before on [removing the User object from Security]({% post_url 2019-03-11-security-removing-user %}).
The main passport interface does not require a user. I invite anyone to
build a system that works without user and submit it to Symfony.
</aside>

This gives an authenticator all power about what is needed for
successful authentication. At the same time, the most important piece is
handled centralized in an event listener. This makes applications less
vunerable, as security leaks will be fixed by the Symfony Security
team. You can also write your own listener to resolve a badge before a
listener of Symfony, to customize the checks.

There also is a `CustomCredentials` class that you can use to call a
custom method to check credentials and a `SelfCheckingPassport` in case
you don't need Symfony to check any credentials (e.g. when using API tokens).

## Next up

I plan to write at least two more blogposts about the new system in the
coming weeks. We'll write real code for a real custom logins on both of these:

* Writing a custom authenticator: Passwords & Badges
* Customizing security using event listeners
