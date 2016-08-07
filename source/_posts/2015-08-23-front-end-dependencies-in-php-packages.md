---
layout: post
title: How to Manage Front-end Dependencies in PHP Packages
categories:
- article
tags:
- symfony
- frontend

---
In this era of decoupling, lots of features are seperated into smaller
libraries. If your bundle uses a PHP library, adding it to `composer.json`
is quite easy. But what about frontend dependencies, like jQuery?

Well, that's easy too!

## Meet Bower

[Bower][bower] is a simple package manager for web dependencies, just like what
Composer is doing for PHP.

To install it, make sure you have NodeJS and NPM installed and then install the
bower package:

    [bash]
    $ npm install -g bower

For information about using Bower in Symfony, read [the official Symfony
docs][sf_docs].

## How to use Bower in a PHP Project?

Let's assume someone installs your bundle into their project. They would do
this using Composer. So when running `bower install` in the Symfony project, it
isn't aware of the `bower.json` file somewhere hidden in the `vendor` directory.

To solve this problem, you can create a *virtual bower package* for your PHP
package. This virtual package will just contain a `bower.json` file and will
have the same versions as the Composer package of the bundle. When installing a
bundle, users can add the virtual package as dependency in their `bower.json`.
After that, when running `bower install`, Bower recognizes the new requirement
in the application's `bower.json` file and resolves/installs all depedencies.

"So I need to maintain 2 repositories?", you would say. Good news: You don't
have to, continue reading!

## Create a `bower.json` File for your Bundle

First things first, let's make a `bower.json` file by running the init command:

    [bash]
    $ bower init

Your `bower.json` file looks something like this:

    [json]
    {
        "name": "...",
        "version": "...",
        "authors": ["..."],
        "keywords": ["..."],
        "license": "MIT",
        "ignore": [
            "**/.*",
            "node_modules",
            "bower_components",
            "test",
            "tests"
        ]
    }

The `ignore` option might be new to you. This is caused by the differences
between JS and PHP development. In JS, most of the source directories aren't
used, only a minified file is used. Bower wants to be nice and tries to remove
as much unneeded files and directories as possible. So, after downloading the
dependency, it removes everything that matches the glob patterns in the
`ignore` option.

Imagine what happends if we only have one ignore pattern: `["*"]`: Everything
will be ignored. Isn't that exactly what we want for the bundle? We can add the
`bower.json` file in the PHP repository and just let it ignore all files in
there.

## Registering the packages

Now you can register both packages:

 * Register your repository as a Composer PHP package (your bundle);
 * Register the same repository as a Bower package (the frontend dependencies).

Assume your bundle is called ``acme/blog-bundle``, your Bower package might be
called ``acme-blog-bundle``. Installation now consists of 2 steps:

    [bash]
    $ composer require acme/blog-bundle
    $ bower install --save acme-blog-bundle

## Extra: Being open for people that don't use Bower

The current set-up requires people to use Bower. Forcing people to use new
tools isn't good, especially if it's about a Node dependency (although there is
a [PHP port of Bower][port]).

To solve this problem, commit the front-end dependencies in the bundle. This
means that people always get a working bundle. If they want to have the latest
versions of their frontend dependencies, they could add the virtual package in
their Bower dependencies, as explained above.

But this means a bundle has to support 2 different paths for the dependencies:

 * `bundles/acmeblog/vendor` when Bower isn't used in the project;
 * `bower_packages` (or any other configured URL) when the user used the
   virtual Bower package.

In the CmfTreeBrowserBundle, we solved this problem by having a
`scripts.html.twig` template like this:

{% verbatim %}

    [html+twig]
    {# CmfTreeBrowserBundle/Resources/views/Base/scripts.html.twig #}
    <script src="{{ asset(assetsBasePath ~ '/jquery/dist/jquery.min.js') }}">
    </script>

{% endverbatim %}

You see the `assetsBasePath` variable in front of the path, this can be set to
the path to the frontend dependencies. The main template file now looks like:

{% verbatim %}

    [html+twig]
    {# CmfTreeBrowserBundle/Resources/views/Base/tree.html.twig #}
    {% include 'CmfTreeBrowserBundle:Base:scripts.html.twig' with {
        assetsBasePath: 'bundles/cmftreebrowser/vendor'
    } %}

{% endverbatim %}

This will retrieve the files installed with the bundle. When a user uses Bower,
they override this file with the new base path:

{% verbatim %}

    [html+twig]
    {# app/Resources/views/CmfTreeBrowserBundle/Base/tree.html.twig #}
    {% include 'CmfTreeBrowserBundle:Base:scripts.html.twig' with {
        assetsBasePath: 'bower_packages'
    } %}

{% endverbatim %}

This will pick the scripts from `/web/bower_packages/jquery/dist/jquery.min.js`
and you're ready to upgrade jQuery whenever you want in your app!

 [bower]: http://bower.io/
 [sf_docs]: https://symfony.com/doc/current/cookbook/frontend/bower.html
 [port]: http://bowerphp.org/
