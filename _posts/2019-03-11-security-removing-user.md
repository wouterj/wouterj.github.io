---
layout: post
title: 'Symfony Security: Is Security about User management?'
categories: experiment
tags: symfony security

---
Symfony 2 completely renewed Symfony. Symfony 3 gave us a completely refactored
and improved Form component. Symfony 4 gave us a renewed dependency injection
experience. Let's fix Security in Symfony 5! To start with: The concept of
users in security.

The Security guide has 36 official documentation articles. This means it's
by far record holder. The Dependency Injection component is on place two with
just 26 articles. Also, a book about Security is in [leanpub's top selling
Symfony list][leanpub] (congratz [Joshua][jaytaph]!). The Security component
needs fixing! *What can we do?*

## What's the problem?

Users are *your* domain logic. Yet, the component forces your user to implement
`UserInterface`. This requires you to define a *salt* (mostly empty),
*username* (probably `return $this->getEmail();`) and *password* (I hope you
aren't using tokens in your API?).

<aside class="side" data-type="Reference">
In the blogpost, Iltar van der Berg uses two objects: A domain `User` and
`SecurityUser`. The security user provider creates a `SecurityUser` based on
information from the domain `User`. This way, the domain `User` becomes
decoupled from the Security component.
</aside>

You can [decouple the security user from your domain one][decoupling-user].
Yet, doing so means that you have to write a custom service to get the
domain user in your controller/services. All Security `getUser()` methods will
return the Security user and not the domain one. That means writing custom core
functionality to fix a problem in the component.

### What is Security without a User?

A lot actually. The core of the Security component needs no users. *Token*
objects (not related to API tokens) contain all necessary information about the
user. After authentication, the user object is saved in this token, together
with the credentials and the roles.

![User and Token UML diagram](/img/security1-current-uml.png)

<aside class="side" data-type="Symfony internals">
The Security component consists of separate layers. The *Core
subcomponent* contains the generic Security objects and abstractions. The *Http
subcomponent* integrates this Core system with the HTTP world of requests,
sessions and login forms. Learn more about this in [this great talk from Kris
Wallsmith](https://www.youtube.com/watch?v=xQyEXzug7P8).
</aside>

At this point, you might wonder why there are two objects: Token and User.
They both contain the username, user roles and password... I agree, we can
remove one of the two concepts.

The user object also creates another problem: The user object is part of the
authenticated token. This means it's serialized when the token is stored in the
session. This means your user object has to be serializable: It needs to remove
plain text passwords, resources and other stuff you don't want to serialize.

## Is there a way to fix it?

Yes: remove users. Wait, whaat?! Security is all about getting a user, right?
Well, I don't think so. Security is about securing your resources (pages,
files, etc.). That's all security should provide as a base. To do this, a
unique identifier is needed to identify who is asking permission to access.
This means we get the user feature as a very nice bonus, but it isn't the main
goal of Security.

With that in mind, I've described why users cause problems. I've also already
shown what other unique identifer Security has besides the User object: Tokens.
Actually, everything Security needs is already in these tokens, so no need for
user objects in the component!

However, being able to typehint for `UserInterface` in the controller is great.
Removing users from the component make this is impossible: The Security
component can no longer relate the token with a user object that you created.

To fix this, tokens can save a plain text identifier for the user. You can set
this to the id of your domain user. The component can provide some automatic
loaders of this Client entity based on the ID, like the current user
providers.

![Proposed UML diagram](/img/security1-proposed-uml.png)

## How does this Impact my Code?

As a base, this means your user object does no longer contain anything from the
Security component.

#### Before

```php
use Symfony\Component\Security\Core\User\UserInterface;

class ApiUser implements UserInterface
{
    private $email;
    private $roles;

    public function __construct($email, array $roles)
    {
        $this->email = $email;
        $this->roles = $roles;
    }

    public function getUsername()
    {
        return $this->email;
    }

    public function getPassword()
    {
        return 'none';
    }

    public function getSalt()
    {
        return null;
    }

    public function getRoles()
    {
        return $this->roles;
    }

    // ...
}
```

#### After

```php
class User
{
    private $email;
    private $roles;

    public function __construct($email, $roles)
    {
        $this->email = $email;
        $this->roles = $roles;
    }

    public function getEmail()
    {
        return $this->email;
    }

    public function getRoles()
    {
        return $this->roles;
    }
}
```

When you want to use `getUser()` functions, you only have to implement a simple
interface:

```php
use Symfony\Component\Security\Core\IdentityInterface;

class User implements IdentityInterface
{
    // ...

    public function getIdentifier()
    {
        return $this->id;
    }
}
```

As you can see, this all becomes way more flexible. Your user only needs to
have some unique identifier and all other information is in the tokens.

The benefit of this is that the Security component only needs to serialize the token
in the session. This means your user object or whatsoever doesn't need to be
serializable, doesn't need to erase credentials, cetera.

## Take Home's

 * Security isn't about the user
 * Users are *your domain*, a framework should not interfere with that
 * Identifiers link objects with the same meaning

Of course, this post is just proposing ideas. I'm sure there will be
difficulties to integrate this into the Symfony code. But I believe it is
necessary to rethink what's needed in the Symfony Security component.
Integrating the Security component should be easier. Reducing classes that need
to be modified to use Security helps with this.

 [leanpub]: https://leanpub.com/bookstore/type/book/sort/lifetime_earnings?search=symfony
 [jaytaph]: https://leanpub.com/u/jaytaph
 [decoupling-user]: https://stovepipe.systems/post/decoupling-your-security-user
