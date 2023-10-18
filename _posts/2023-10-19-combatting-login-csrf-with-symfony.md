---
layout: post
title: Combatting Login CSRF with Symfony
categories: article

---
Cross-site Request Forgery (CSRF) is one of the traditional vulnerabilities
that web applications have to deal with. Every web framework - including
Symfony - supports CSRF protection out of the box. A lesser known
vulnerability is *Login CSRF*, a special kind of CSRF attack.

## How a CSRF Attack Works

A [CSRF attack][1] takes advantage of the sessions in the browser. If you
login to a website, your authentication token is stored in a session. This
means that you're still logged in if you switch to another page of the
website.

The browser also remembers this session when visiting other websites. This
is nice, as it allows you to go back to the website and still be logged in.
However, attackers are using this to make requests from their website to
your website using the remembered authentication session. This means that,
without CSRF protection, it can use your website as if it was the user.

For instance, an attacker can trick the user into thinking they are on your
website and show them a form that looks like the login:

```html
<form action="https://yourwebsite.com/profile/change_password" method="POST">
    <label>Username <input type="text" name="username"></label>

    <label>Password <input type="password" name="current_password"></label>

    <input type="hidden" name="new_password" value="...">

    <button type="submit">Login</button>
</form>
```

In reality (looking at the `action` and `type="hidden"` input), this form
changes the password of the user to something that is known only by the
attacker, giving them access to their account. Attacks can also do any
other action on your website, like buying goods or transfering money to
their account.

## How Login CSRF Attacks are Different

The CSRF attacks described above are *using the authenticated session* to
act as a user. [Login CSRF attacks][2] are the opposite: they *force an
authenticated session* to let the user act as them.

How does that work? When someone visits the website of an attacker, they
make a request to ``yourwebsite.com/logout`` to force an unauthenticated
session and then make a request to ``yourwebsite.com/login`` with
credentials of an account that they control.

<aside class="side" data-type="side note">
With the introduction of `Secure` and `SameSite` cookie flags, there has
been a feeling that [CSRF is dead][4]. Login CSRF is a good example of a
situation where these cookie flags won't protect your users against a CSRF
attack. While the web is more secure thanks to these cookie flags, CSRF
still has its function in modern web applications.
</aside>

This can have serious consequences for the user, depending on the
functionality of your website. E.g. ["Robust Defenses for Cross-Site Request
Forgery" (Barth, Jackson, Mitchell, 2008)][3] mention that this attack is
used to let users unknowingly connect their creditcard to the PayPal
account of the attacker. It is also used to get access to a user's Google
account, or using it to track the user's search terms and locations.

The risk of Login CSRF attacks is often considered to be lower. Most users
are expected to notice when they are logged in to someone else's account on
the website (hence it's a good idea to make this visible on all pages!).
However, the consequences can be very high when a user doesn't notice. If
you're using Symfony, protecting against them is very easy and I would
recommend always doing this.

## Protecting against Login CSRF

A login CSRF attack can include two steps: first a call to logout to force
the website in a known state, and then a login with the attackers
credentials. Let's protect both steps!

### Protecting Login

Protecting against login CSRF attacks is similar to protecting against
other CSRF attacks. When rendering the login form, you create a randomized
token which you submit along with the rest of the form. When handling the
submission, this token is checked for validity.

When using Symfony's built-in `form_login` authenticator, generating and
validating this randomized token is mostly automated for you. First, enable
CSRF protection in the authenticator:

```yaml
security:
    # ...
    firewalls:
        main:
            form_login:
                # ...
                enable_csrf: true
```

And then, add a hidden CSRF token to your login form template:

{% raw %}
```twig
<!-- csrf_token() takes care of correctly generating and storing the CSRF token -->
<input type="hidden" name="_csrf_token" value="{{ csrf_token('authenticate') }}">
```
{% endraw %}

That's it! Your users are safe against this attack now!

When you're using a custom login form authenticator, you'll have to add
[the `CsrfTokenBadge`][6] with the CSRF token from the request. The
security system will then validate this token for you.

### Protecting Logout

<aside class="side" data-type="Symfony <6.2">
The `enable_csrf` option is new in Symfony 6.2. If you're stuck on
an older version, you need to use `csrf_token_generator: security.csrf.token_manager`
instead. Read more about it in [the documentation][5].
</aside>

You can protect logout in a similar way by enabling CSRF protection in the
config:

```yaml
security:
    # ...
    firewalls:
        main:
            logout:
                # ...
                enable_csrf: true
```

If you're already using the ``logout_path()`` Twig helper function to
generate a URL to your logout route, this is all you had to do! The Twig
function generates a unique CSRF token and attaches it to the URL.

Otherwise, replace links to the logout page with this Twig function in your
Twig templates:

{% raw %}
```twig
<a href="{{ logout_path() }}">Logout</a>
```
{% endraw %}

## Take Homes

* Make sure your login/logout actions are also protected against CSRF
  attacks
* While cookies have become more secure in recent years, CSRF protection
  still needs attention

[1]: https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html
[2]: https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html#login-csrf
[3]: https://seclab.stanford.edu/websec/csrf/csrf.pdf
[4]: https://scotthelme.co.uk/csrf-is-really-dead/
[5]: https://symfony.com/doc/5.4/reference/configuration/security.html#reference-security-logout-csrf
[6]: https://symfony.com/doc/current/security/custom_authenticator.html#passport-badges
