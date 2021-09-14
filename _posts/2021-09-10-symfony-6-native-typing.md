---
layout: post
title: 'Symfony 6: PHP 8 Native Types & Why we Need YOU'
categories: article
tags: symfony pre-release contribute

---
A very exciting time is coming with the biggest change for Symfony since
Symfony 2.0: Symfony 6 has native PHP types on all its methods where it
is possible. This will be a great push towards type safety in the PHP
open source communities! [Nicolas][nicolas-grekas] and
[Alexander][derrabus] have been working on and off for 2 years to create
the best upgrade experience possible.<br>
Now, 2.5 months before the stable release, it is *YOUR* time to shine!
Especially if you maintain any open source project (not even directly
linked to Symfony), we would love to hear from you to make sure the
upgrade isn't dramatically hard.

As of Symfony 5.4, the debug class loader (which is used in Symfony
applications in the dev/test env) will check return type compatibility
and warn you if a method is incompatible. Even more... it can fix it
automatically for you! [Read more about this feature in the Symfony
docs.][doc]

## Symfony Applications Upgrade Plan

The upgrade plan is slightly different for open source packages and
applications. This section describes your upgrade plan if you're
building applications using the Symfony framework (or only some
components).

The techniques and tools created to make this experience as smooth as
possible are brand-new. Please install 5.4-dev now and let us [know about
any issue][bug].

```bash
$ composer config minimum-stability dev
# now, modify all Symfony constraints to "^5.4" in "composer.json", then:
$ composer update 'symfony/*'
```

### When upgrading to Symfony 5.4

First, upgrade to Symfony 5.4. Besides fixing all "normal" deprecations,
you also need to fix some type declarations.

In PHP, it is possible to define a return type when the parent
declaration doesn't define it (yet):

```php
interface UserInterface
{
    public function getRoles();
}

class User implements UserInterface
{
    // valid!
    public function getRoles(): array
    {
        // ...
    }
}
```

At the other hand, you must define a return type if your parent does
(remember, Symfony 6 will define return types!). This means that 5.4 is
your time to add return types to all methods (especially those
overriding or implementing methods from Symfony).

Symfony provides a small utility in the [`symfony/error-handler` component][error-handler]
to automatically add the required return types. First, generate a
complete classmap of your application using Composer. Then, run the
utility:

```bash
# (1) Make sure "exclude-from-classmap" is not set in your "composer.json"

# (2) Generate the classmap ("-o" is important!)
$ composer dump-autoload -o

# (3) Run the patch script
$ ./vendor/bin/patch-type-declarations
```

Once you've fixed them (and running this script above will do it all for
you), you're ready to upgrade to Symfony 6!

### When using Symfony 6.x

After upgrading to Symfony 6.0, you can start adding parameter types.
Parameter type compatibility is inverted compared to return types: a
child may not set the type if the parent already does, but a child
cannot set the type before the parent:

```php
interface FormTypeGuesserInterface
{
    public function guessType($class, $property);
}

class CustomTypeGuesser implements UserInterface
{
    // error!
    public function guessType(string $class, string $property)
    {
        // ...
    }
}
```

For this reason, you cannot add these parameter types in 5.4.

## Symfony Bundle Maintainers Compatibility Plan

Unfortunately, open source maintainers can experience some more trouble
when adding return types. This is because you probably care about not
breaking backwards compatibility. And, as noted before, defining a
return type means all users overriding/implementing the method must
define it as well.

### Document the Return Type

First, you can add return types only on safe methods. These are methods
that should not be extended by users of your package. The patch tool
from Symfony defines safe methods as any method that:

- Is in the `Tests` namespace
- Is `final` or `@final` (or its class)
- Is `@internal` (or its class)
- Is `private`

Use ``force=2`` to only patch types for these safe methods:

```bash
# you can set the minimum PHP version, e.g. "static" won't be added
# as a return type for 7.4
$ SYMFONY_PATCH_TYPE_DECLARATIONS="force=2&php=7.4" ./vendor/bin/patch-type-declarations
```

Now, you have to check if there are any methods that would produce an
error in Symfony 6. The quickest way to do this is running the same
script again. Any deprecation in the output is an incompatible method.

If you don't see any deprecation: Congratulations! You are compatible with
Symfony 6 and can allow `^6.0` to your Symfony dependencies without having
to break compatibility for your users.

### Fix all Return Types

Some bundles may discover that they need to add return types to methods
that might be overridden or implemented. As this causes a backwards
compatibility break, you probably don't want to do this in a minor
release.

Instead, make sure you properly document the correct return type using
the `@return` PHPDoc. This will create the useful deprecations for your
users to know they have to update their PHP return types. The patch
script can add this PHPDoc for methods that implement/override from
third party classes/interfaces:

```bash
$ SYMFONY_PATCH_TYPE_DECLARATIONS=force=phpdoc ./vendor/bin/patch-type-declarations
```

After this minor release with all deprecations, you can safely add all
the missing return types in the next major version.

The downside of this process is that you cannot support Symfony 6 until
this major release of your own package. Make sure you keep on reading to
know how you can maybe even avoid this!

## We need YOU to make everyone's life better

As you can see in this post, adding return types can have quite an
impact on the community. Some return types might cause many packages to
release a new major version, potentially messing up any roadmaps or
other processes.

This is why we welcome you to report any return type deprecation that is
causing you to break compatibility in your package. You can do so in
[this GitHub issue][github].

We don't promise anything, but based on the feedback we might postpone
some return types to Symfony 7 (to give you 2 more years to release a
new major version). We've already done so for some common methods found
in the Symfony bundles (e.g. `Command::execute(): int` and
`VoterInterface::vote(): int`).

## Take Home's

- Symfony 6 will be type safe
- There is a `patch-type-declarations` script in Symfony 5.4+ that
  automatically makes your code compatible
- Open source maintainers have 2.5 months to help us reduce the impact
  of this change

[nicolas-grekas]: https://github.com/sponsors/nicolas-grekas
[derrabus]: https://github.com/derrabus
[doc]: https://symfony.com/doc/5.4/setup/upgrade_major.html#upgrading-to-symfony-6-add-native-return-types
[error-handler]: https://symfony.com/components/ErrorHandler
[bug]: https://github.com/symfony/symfony/issues/new/choose
[github]: https://github.com/symfony/symfony/issues/43021
