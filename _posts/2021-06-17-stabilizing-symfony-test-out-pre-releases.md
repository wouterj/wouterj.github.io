---
layout: post
title: 'Stabilizing Symfony: Testing out the pre-release'
categories: article
tags: symfony contribute pre-release

---
Symfony has a very rigid [release schedule][releases] since Symfony 3.0.
Predictable releases are often mentioned as a major advantage. Did you
know that this schedule also includes a 2 month "stabilization phase"?
This phase gives time to all libraries and bundles to catch up. In
today's [SymfonyWorld Keynote][keynote], Fabien emphasized that testing
pre-releases is one of the best contributions you can make. Let's see
how you can help Symfony by reservering 30 minutes during these 2
months!

## A quick Introduction to the Backwards Compatibility Promise

It's important to understand the [backwards compatibility promise][bc].
Projects used by many applications can't simply change behavior of
features. Applications (and its developers) rely on stability of the
framework. In short, Symfony's promise is that your application should
be able to upgrade from x.0 to x.4 *without any code changing efforts*.

<aside class="side" data-type="BC Promise">
The [promise][bc] does define some boundaries of the backwards
compatibility. For instance, if you use internal classes or an
experimental feature, there is a chance you need to make changes when
upgrading.
</aside>

Before releasing a new minor version (e.g. 5.3.0), the Symfony Core team
needs to make sure 2 conditions are true:

- All changes to existing features are backwards compatible
- All new features must be stable.

The last point is important: Once a feature lands in a stable release,
it's no longer possible to change its behavior.

Now you know the main challenges Symfony is facing when releasing a new
minor version, let's see how you can help!

## Reporting Issues during Stabilization

New features are often tested in little demo applications. As we all
know, small demo applications often work much better than real life
applications. This is why bugs and backwards compatibility breaks
sometimes go completely unnoticed until real life applications start
upgrading.

Receiving feedback from real life applications is crucial: Symfony's
only goal is to help you make real stuff in your daily jobs. It's great
to receive bug reports, at all times. Yet, it's significantly more
difficult to fix backwards compatibility breaks or bugs after a stable
release.

Imagine there is a backwards compatibility break (BC break) that
resulted in a PHP error. Applications that already upgraded fixed their
code to remove this error. This means that removing the BC break is also
a BC break in itself!

This is why testing pre-releases is critical. Pre-releases are not
covered by the BC promise. If you find a problem, we can fix the
break without yet another deprecation layer.

## How to Test Pre-Releases

I hope by now, you understand the value of pre-release testing. But now,
how do you do this? Is it really just 30 minutes?

### Testing Pre-Releases in Applications

Most people maintain Symfony applications: private projects using the
Symfony framework as a base. These projects can test pre-releases in 3
steps:

<aside class="side" data-type="Quick note on stability flags">
During stabilization, Symfony releases a beta or RC (Release Candidate)
release almost on a weekly basis. Seeing the first beta release is great
indicator that Symfony has started with the stabilization phase.

The RC releases are almost stable: They will probably no longer break
compatibility and the big issues are fixed.

However, as bugs are continously fixed during the stabilization phase,
the dev branch is more stable than a pre-release made a couple days ago.
It's often a great idea to use `@dev` instead of `@beta` or `@rc`.
</aside>

1. Update your `composer.json` to allow the next dev release. E.g.
   change `5.3.*` to `5.4@dev` for all `symfony/*` packages.  
   Make sure to also update the `extra.symfony.require` key if it's
   present
2. Add `"minimum-stability": "dev"` and `"prefer-stable": true` to your
   `composer.json` file. This tells Composer to install dev versions,
   but use stable versions for all your non-Symfony packages
3. Update your dependencies and run your test suite

Hopefully, your tests will pass. If it doesn't, it means there is a BC
break or bug in the upcoming release.
In that case, you can [report a bug][bugreport] to Symfony. It's great
to also provide a reproducer: some code that allows everyone to
experience the bug you found. It's hard to fix a bug if you don't
experience it ;)

There is also a great benefit for you: You already tested your
application with the upcoming version. You may find yourself fixing some
deprecations at a boring Friday afternoon. Before you know it, your
applications is ready for the next release!

### Testing Pre-Releases in Packages

Open source packages often test against multiple versions of their
dependencies (e.g. they test support for Symfony 4 and 5).

You can also add a "dev" version to test your package with the next
version of your dependencies. When running the dev tests, you can use
this one-liner to allow dev dependencies:

```shell
perl -pi -e "s/^}\$/,\"minimum-stability\":\"dev\"}/" composer.json
```

This means your package now also tests against the dev dependencies.
This is a great way to see if you support upcoming versions, as well as
discovering bugs in your dependencies early. Depending on the stability
of your dependencies, it can be a good idea to allow the dev tests to
fail (e.g. using `allow_failures` in Travis CI).

I've used this technique in my own packages, which you can use as an
example:

* [GitHub Actions][github]
* [Travis CI][travis]

## Take Home's

- Contributing to Symfony doesn't only include writing code
- Bugs are much more easily fixed in a pre-release
- Please test pre-releases (of any software) and report issues you find

[releases]: https://symfony.com/releases
[keynote]: https://live.symfony.com/2021-world/schedule#session-598
[bc]: https://symfony.com/bc
[bugreport]: https://symfony.com/doc/current/contributing/code/bugs.html
[travis]: https://github.com/wouterj/WouterJEloquentBundle/blob/4284b3c56c1f04bc9faf31783e702d292afc455f/.travis.yml#L37-L40
[github]: https://github.com/wouterj/WouterJEloquentBundle/blob/2.x/.github/workflows/tests.yml#L68-L74
