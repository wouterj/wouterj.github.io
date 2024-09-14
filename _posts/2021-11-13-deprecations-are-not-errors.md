---
layout: post
title: 'Deprecations are not like E_ERROR, E_WARNING, and E_NOTICE'
categories: article
tags: backwards-compatibility
star: true

---
Every now and then, there seems to be a lot of fuss in the PHP community
about deprecations. In these discussions, deprecations are often
discussed as if they are fatal errors. I think that is very wrong. Let's
reduce our expectations of deprecations. It'll make everyones live much
less stressful.

## Why we were Afraid of Change in the Past

<aside class="side" data-type="side note">
I can't think of a world without deprecations and backwards
compatibility nowadays. The PHP community has matured fast. The
semantic versioning specification, which I think has ignited the
backwards compatibility movement, was published only 8 years ago
in 2013. In this same year, Symfony triggered its first ever deprecation
notice.
</aside>

In the past, the only way to know about a change in the next version was
by reading the CHANGELOGs. Every change required you to manually check
if your code was affected.

Mind you, even Composer was not a thing 8 years ago. Most applications
would just copy past the vendor code in their project (sometimes even
altering code in the vendor).

This took time, a lot of time. As a consequence, languages and
libraries were very restricted in how they could evolve.

## Why PHP Developers are Afraid of any `E_*` being Reported

PHP had a habit of trying to "fix" incorrect code. Forgot the quotes
around a string? No worries, [PHP still interpreted it as a
string](https://3v4l.org/m0l3p) if the constant wasn't found. It
triggered an `E_NOTICE` to let you know that PHP found something
unexpected but tried to continue.

This can produce unexpected behavior (e.g. what if you meant a constant,
but you made a typo?). As a result, PHP developers have become extremely
careful with anything being reported. Even though it's not a direct fatal
error, many of us correctly consider notices to be something that must
be fixed.

However, this also makes us very careful with `E_DEPRECATED`. After all,
it's reported and it starts with `E_`. That MUST be fixed as soon as
possible, right? ...right?

## Why Deprecations are Different

Deprecations are not like notices, warnings or errors. Deprecations are
the cornerstone in *smooth upgrade paths*. This smooth upgrade path
contains a couple steps:

1. A contributor makes a backwards compatibility breaking change
2. The contributor introduces a "BC layer" to make sure the old API
   also works. This "BC layer" triggers a deprecation, notifying that
   you're using a legacy API
3. In the next major version, a maintainer removes the "BC layer" and
   the new API is the only available API

This means that a *user* can use the old API as long as they want, until
they want to upgrade to the next major version.

<aside class="side" data-type="side note">
The smooth upgrade path is such an improvement that most maintainers
have to get used to it. Most developers love refactoring legacy bits,
and I think it's normal to "overshoot" it at first. Maintainers will
learn from this (I'm sure the hard upgrade from Symfony 3.4 is not
repeated again).

Give them constructive feedback on what made an upgrade hard for your
applications. Don't judge them for making changes, help them improve
further changes.
</aside>

A deprecation is a major help for us *users*. Instead of being notified
only after the major release (by reading the CHANGELOG), we get notified
years or months in advance. For instance, you have at least 3 years to
fix any deprecation that Symfony gives you.

## You don't have to run Deprecation-free

Using a deprecated feature doesn't result in unpredictable behavior,
like PHP's notices do. They don't signal a bug, like warnings and errors
do. They just tell you that you have some work to do before upgrading to
the next major version. That's all!

With deprecations, you can prioritize upgrade work and reserve some time
for it in a 2 or 3 year timespan. Backwards compatibility breaks are no
longer ad-hoc tasks, they become plannable tasks.

Is your business busy the next few months? Fine! Your apps remain
running with tons of deprecations for months to come. There will always
be a boring week in the summer break were you can fix a couple
deprecations.

Most often, when a new deprecation is introduced, the major version is not
even being worked on. For instance, if PHP triggers a deprecation now,
you're notified of a breaking change in PHP 9. Do you know the release
date of PHP 9? I don't (probably one or two years from now?). Is it
really worth worrying so much today about a breaking change in an
unknown future?

## Don't Judge your Vendor Code for not running Deprecation-free

The same applies to any vendor code that your app is using. Getting
deprecation notices from a vendor library? That's fine. You can reserve
some time and contribute a fix for one or two deprecations to the open
source project.

If we all do it, the open source project will support the new major
version months before it's even released.

## How to Hide and Log Deprecations

If you are using the default PHP error handler, you're left to either
hide deprecations or output them like all other errors. Symfony has a
small [`symfony/error-handler`](https://github.com/symfony/error-handler)
package that allows you to register [PSR-3 loggers](https://php-fig.org/psr/psr-3/)
for a specific error level. Besides, it automatically hides
deprecations from the normal output.

Using this code, all deprecations are logged to ``deprecation.log`` and
the normal error handler is used for all other errors:

```php
<?php

require_once 'vendor/autoload.php';

use Psr\Log\AbstractLogger;
use Symfony\Component\ErrorHandler\ErrorHandler;

ErrorHandler::register()
    ->setDefaultLogger(new class extends AbstractLogger {
        public function log($level, string|\Stringable $message, array $context = []): void
        {
            $formattedLogLine = sprintf(
                '[%s] %s: %s%s'.PHP_EOL,
                date('Y-m-dTH:i:s.uP'),
                $level,
                (string) $message,
                ($context['exception'] ?? false) instanceof \Throwable
                    ? sprintf(' in %s:%s', $context['exception']->getFile(), $context['exception']->getLine())
                    : ''
            );

            file_put_contents(__DIR__.'/deprecations.log', $formattedLogLine, \FILE_APPEND);
        }
    }, \E_DEPRECATED | \E_USER_DEPRECATED)
;

// "null" argument deprecated as of PHP 8.1
var_dump(str_contains('foo', null));
```

## Take Home's

- Don't try to run deprecation free until you want to upgrade to a new
  major
- Don't judge maintainers triggering deprecations, thank them for
  letting you know about a big change way in advance
- Deprecations make upgrade tasks plannable, instead of ad-hoc
