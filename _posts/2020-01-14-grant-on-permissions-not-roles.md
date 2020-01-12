---
layout: post
title: 'Grant on Permissions, not Roles'
categories: article
tags: symfony security

---
Symfony uses a very flexible voter approach to grant access for a user.
As this is often based on domain-specific requirements and decisions,
the voters that come with Symfony are very basic. I would even argue
that it's better if you not use them, and only rely on custom security
voters.

## Terminology

In Symfony security, the string `ROLE_USER` can actually mean a lot of
things, let's first establish a common meaning:

What you pass into `isGranted()` calls is a *security attribute*. It
*can* start with `ROLE_`, but any other text is possible as well.

A user has *security roles*. These are returned by `UserInterface#getRoles()`
and always start with `ROLE_`.

The `roles` setting in your access control is passed into
`AccessDecisionManager#decide()` (which is also what `isGranted()`
uses). While the setting is named "roles", this is actually a
*security attribute*.

## Meet the Role Voters

<aside class="side" data-type="Vote strategy">
By default, Symfony's election is "affirmative". This means that if one voter
votes for GRANT, the user is granted. This strategy can be changed using
[``security.access_control_manager.strategy``]().
</aside>

If you call ``isGranted()`` in some way, a small election organized by Symfony
Security takes place. Each voter votes GRANT, DENY or ABSTAIN. Voters
vote for a specific *security attribute*, with some optional context
(the 2nd argument of `isGranted()`).

Voters are powerful, but, as said in the intro, often depent on lots of
business logic. This is why Symfony cannot provide many voters. To make
the security system work, it comes with two very primitive voters:
``RoleVoter`` and ``RoleHierarchyVoter``.

These voters activate as soon as the *security attribute* starts with
``ROLE_`` (e.g. ``isGranted('ROLE_USER')`` or ``isGranted('ROLE_ADMIN')``).
They check if the current user has this role (or if the
[role hierarchy][role-hierarchy] contains this role).

## What's wrong With Voting based on Roles?

Voting on a role is very easy: It's supported by default and gets the job done.
Yet, it doesn't add any flexibility. Also, complex cases result in a
lots of code in a controller and often code duplication.

**Roles belong to authentication (identification), rather than
authorization.**

![roles groups users](/img/security-roles-as-identification.png)

Roles defines the role (or function/task) of this user on the website.
Someone might be the "modator" on this forum, just a regular visitor or
some premium plan member. That's their role. *Roles allows your
application to group different users together. This makes granting
permissions easier.* For instance, it's difficult to describe that users
John, Marc and William are allowed to edit all posts. It's easier to
group them as being "the moderators" of this website. You can then grant
the permissions "edit all posts" to the "moderators" role.

So rather than using roles as permissions, you relate permissions to
specific roles. These permissions are then voted on by a custom voter.
This allows you to change permissions throughout your code base easier
and keep your controllers thin.

## Grant Access for Permissions

For this example, let's create a voter for a blog post. We want to end
up with a call like `isGranted("POST_EDIT", $blogPost)`. The voter
should then decide if the current user is allowed to edit the blog post.
They should be allowed if any of these is true:

* If it's a *user*, it should be the author of the post
* If it's a *moderator*, it should always be allowed
* If it's a *senior user*, it should be senior for that specific topic

Do you see how we now relate the *role of the user* to the *specific
permission of editing a blog post*?

## Creating the Voter

<aside class="side" data-type="Without MakerBundle">
If you don't have the maker bundle, either install it or create a PHP
class that extends the `Voter` class.
</aside>

So the solution is to create your own voter. It's a PHP class
implementing Symfony's `VoterInterface`. For easy usage, there is an
abstract class named `Voter`. If you have the [MakerBundle]() installed,
you're lucky:

```bash
$ bin/console make:voter
```

### Specify if the Voter Supports this Call

The `Voter#supports()` returns a boolean, depending on whether it wants
to join the election for this *security attribute* and *context*. In
this example, the security attribute should be `POST_EDIT` and the
entity should be instance of `BlogPost`:

```php
// ...
class BlogPostVoter extends Voter
{
    protected function supports($attribute, $subject)
    {
        return 'POST_EDIT' === $attribute
            && $subject instanceof \App\Entity\BlogPost;
    }

    // ...
}
```

### Write the Decision Logic

If the voter indicated that it supported this call,
`Voter#voteOnAttribute()` is called. This method implements the
permission logic:

```php
// ...
class BlogPostVoter extends Voter
{
    private $decisionManager;

    public function __construct(AccessDecisionManager $decisionManager)
    {
        $this->decisionManager = $decisionManager;
    }

    // ...

    /**
     * @param BlogPost $blogPost
     */
    protected function voteOnAttribute($attribute, $blogPost, TokenInterface $token)
    {
        $user = $token->getUser();
        // if the user is anonymous, do not grant access
        if (!$user instanceof UserInterface) {
            return false;
        }

        // if the user is a moderator, always allow
        if ($this->decisionManager->decide($token, ['ROLE_MODERATOR'])) {
            return true;
        }

        // Allow if the user is senior on this topic
        if ($user->isSeniorIn($blogPost->getTopic()) {
            return true;
        }

        // Allow if the user wrote this post
        if ($blogPost->getAuthor() === $user) {
            return true;
        }

        // Otherwise, deny access
        return false;
    }
}
```

As you see, in the voter we do call `decide()` with a role. But that's
fine, this class is meant to relate permissions (`POST_EDIT`) to a
user's role on the website.

We can now use `isGranted('POST_EDIT', $blogPost)` in our application to
check if the user is allowed to edit the blog post. The access decision
manager will call our custom voter to decide on this. If we ever need
more complex logic to check, we only have to update the code in the
voter.

It's often a good idea to create one voter per entity. This voter can be
extended to also vote on `POST_CREATE`, `POST_DELETE`, etc. To check if
a Create button should be shown, I recommend passing the FQCN as context
as there is no object yet (e.g.
`is_granted('POST_CREATE', 'App\Entity\BlogPost')`).

## Make your Voters Dynamic (Access Logic in the Database)

Instead of hardcoding all your permissions in the voters, you can also
read information from the database inside your voter. This allows you to
persist permissions in the database, which can then be managed by users
in an admin panel or the like.

<aside class="side" data-type="Caution">
This example is just to illustrate the flexibility of the Voter
principle. It isn't necessarily battle-tested or recommended for
production usage.
</aside>

In the most generic way, you can create a `Permission` entity that
specifies which roles are required for a specific security attribute. It
may also use Symfony's [ExpressionLanguage component][expressions]) to
check additional conditions:

```php
class PermissionVoter implements VoterInterface
{
    // ...

    // this vote() method is the only required method of VoterInterface
    // it should return ACCESS_ABSTAIN (i.e. not supported),
    // ACCESS_GRANTED or ACCESS_DENIED.
    protected function vote(TokenInterface $token, $subject, array $attributes)
    {
        $attribute = $attributes[0];

        // find all stored permissions for this attribute and subject
        $permissions = $this->permissionRepository->findBy([
            'attribute' => $attribute,
            'subject' => $subject,
        ]);

        // do not deny/grant if there is no permission for this
        // attribute and subject
        if (0 === count($permissions)) {
            return self::ACCESS_ABSTAIN;
        }

        foreach ($permissions as $permission) {
            // continue if the role of the user does not match the role
            // of this permission
            if (!$this->decisionManager->decide($token, [$permission->getRole()])) {
                continue;
            }

            // if the permission has an extra expression, verify this is
            // true, otherwise grant access directly
            $expr = $permission->getExpression();
            if ($expr) {
                if ($this->decisionManager->decide($token, [$expr])) {
                    return self::ACCESS_GRANTED;
                }
            } else {
                return self::ACCESS_GRANTED;
            }
        }

        // in any other case, deny access
        return self::ACCESS_DENIED;
    }
}
```

## Take Home's

* Roles are identification: They allow your application to group
  similar types of users
* Voters relate roles to specific permissions
* Avoid granting access based on roles in your application, consider
  writing a custom voter for them

 [role-hierarchy]: https://symfony.com/doc/current/security.html#security-role-hierarchy
 [github]: https://github.com/wouterj-nl/vote-on-permissions
 [expressions]: https://symfony.com/doc/current/security/expressions.html
