---
layout: post
title: Symfony 20 year!
categories: article
tags: php

---
This year, Symfony [celebrates its 20 year anniversary](https://symfony.com/20years).
Let's dive into some statistics of years of making web development history.

<aside class="side" data-type="Acknowledgement">
The graphs and metrics in this post are heavily inspired and based on
[Daniel Stenberg's curl dashboard](https://curl.se/dashboard.html). If you
enjoy data and open source project, go give that dashboard a visit.
</aside>

This post features graphs, with some annotations of things I remember and
observe in the graphs. If you find any other interesting stuff, please share
it! All data and graphs for this project are on
[GitHub](https://github.com/wouterj-nl/symfony-stats). Some graph are
better viewed in full size, clicking on a graph opens a full size window.

Like many projects at that time, Symfony 1 started with Subversion and a
self-hosted code platform at [trac.symfony-project.org](https://web.archive.org/web/20100419194120/http://trac.symfony-project.org/report).
During the development phase of Symfony 2, the project
[moved to Git](https://symfony.com/blog/symfony-2-migration-to-git). To
keep the scope of all data extraction for this post manageable, I decided to
focus on all statistics starting at Symfony 2.0 and only take the main
mono-repository into account.

{% include image.html src="/img/sf-stats/release-number.svg" alt="" class="figure" %}

As a start, let's list all Symfony releases. Today, with 8.0.2 just over a
week old, the project has had 699 *stable* releases (excluding
alpha/beta/rc).

At first, the releases were done naturally: Patch releases when enough bugs
are fixed, and a minor release when features are stabilized.

In October 2012, Symfony adopted [a time-based release process](https://symfony.com/blog/a-new-release-process-for-symfony)
that is familiar to what's in use today. Symfony started adopting
Semantic Versioning, deprecations and smooth upgrade paths. While gaining
more experience with these new methodologies throughout the 2.x series, the
release cycle [changed a couple times](https://symfony.com/blog/symfony-3-0-the-roadmap).

You can see releases "stacking up" in the graph on the same day, as
multiple minor versions were supported at the same moment. This went as
crazy as supporting Symfony 2.7 (released in 2015 on PHP 5.3.9!), 2.8, 3.4,
4.0 and 4.1 all at the same time in early 2019. After this, you can see the
graph settle at the [steady pace we are used to today](https://symfony.com/releases).

Other statistics in this post are calculated for every "latest" release.
For instance, the data is generated for 4.0.0, 4.0.1, etc. until the
release of 4.1.0, and then continues with 4.1.1, 4.1.2, etc. Eventhough 4.0
and 4.1 were maintained at the same time, we ignore future 4.0 patch
releases.

{% include image.html src="/img/sf-stats/components-over-time.svg" alt="" class="figure" %}

Almost every minor/major Symfony version introduced a new component
(excluding component bridges like Mailer integrations). In fact, the
latest Symfony 7.4/8.0 release is the 3rd release without a new component!

Symfony 2.0 packaged 32 components, almost tripled with 80 components and
[308 total packages in the Symfony 8.0](https://symfony.com/stats/downloads).

{% include image.html src="/img/sf-stats/merges-over-time.svg" alt="" class="figure" %}

Since the end of 2013, Symfony uses a CLI tool to merge pull request. This
labels every merge as "minor" (important work, but not noteworthy in a
changelog), "bug" (a fixed bug) or "feature" (new features).

Mapping the merges by type for each months gives a mostly chaotic graph.
You can see a big drop in feature merges before the releases in May and
November, especially during the release of a new major every 2 years.
During this period, the community focuses on stabilizing the existing
features and helping the ecosystem with adding support for the new major
version.

And one thing is for sure: Activity hasn't slowed down after 11 years since
Symfony 2.0!

## Contributors

So who are these people that make Symfony possible? Let's take a close look
at some contributor statistics.

{% include image.html src="/img/sf-stats/authors-per-month.svg" alt="" class="figure" %}

An average of 60 unique authors contribute code to Symfony every month.
Over the years, this number has gone up and down but still is pretty stable
since 2012.

<figure class="figure figure-1-2">
{% include image.html src="/img/sf-stats/95-percent.svg" alt="" %}
{% include image.html src="/img/sf-stats/80-percent.svg" alt="" %}
{% include image.html src="/img/sf-stats/50-percent.svg" alt="" %}
</figure>

In total, 340 individual contributors own 95% of the commits in 2025.
At 6 people are responsible for 50% of the commits for years. This shows
the strength of Symfony and its community: It's not just a couple of
contributors doing the work but hundreds of people working together to help
everyone move forward!

Interestingly, the peak in 2019-2021 is also visible
[the curl project](https://curl.se/dashboard1.html#authors-of-95-percent).

{% include image.html src="/img/sf-stats/firsttimers.svg" alt="" class="figure" %}

50% of the commit authors every month are new contributors that didn't
commit anything to the project before. It's amazing to me how many new
people keep finding the project and sharing new insights.

{% include image.html src="/img/sf-stats/author-remains.svg" alt="" class="figure" %}

<aside class="side" data-type="Accuracy">
This graph groups lines by commit author email. Of all metadata available
on git commits, the author is email is probably most specific. However,
there are still inaccuracies if for instance people changed their e-mail
address.
</aside>

Of all the new work committed every month, how much individual contributors
own at least 1 line in the current codebase? As it turns out, the answer to
that question is 2820 different authors in 8.0.2! With many authoring more
than 10 lines of code.

In Symfony 8.0, 15 authors own more than 10,000 lines in the codebase, with
2 authors more than 100,000 lines of code. Can you guess who they are?

1. 129,747 [Fabien Potencier](https://github.com/fabpot)
1. 119,275 [Nicolas Grekas](https://github.com/nicolas-grekas)
1. 47,490 [Bernhard Schussek](https://github.com/webmozart)
1. 20,639 [Alexander M. Turek](https://github.com/derrabus)
1. 19,913 [Mathias Arlaud](https://github.com/mtarld)
1. 17,385 [Alexandre Daubois](https://github.com/alexandre-daubois)
1. 13,594 [Jérémy Derussé](https://github.com/jderusse)
1. 13,518 [Grégoire Pineau](https://github.com/lyrixx)
1. 13,104 [Wouter de Jong](https://github.com/wouterj)
1. 13,057 [Ryan Weaver](https://github.com/weaverryan)
1. 12,654 [Kévin Dunglas](https://github.com/dunglas)
1. 11,929 [Dariusz Rumiński](https://github.com/keradus)
1. 11,689 [Oskar Stark](https://github.com/OskarStark)
1. 11,529 [Christian Flothmann](https://github.com/xabbuh)
1. 11,124 [Thomas Calvet](https://github.com/fancyweb)

A special memory to Ryan Weaver, who [passed away earlier this year after
battling with cancer](https://symfony.com/blog/remembering-ryan-weaver-teacher-core-team-member-friend).
His legacy will live on in the Symfony community in ways you can't always
describe, but these statistics underline it in ways we can describe.

## Code

The contributors bring us to the code itself and by far my most favorite
graph of this post!

{% include image.html src="/img/sf-stats/codeage.svg" alt="" class="figure" %}

<aside class="side" data-type="Accuracy">
This graph uses all lines of code in XML and PHP files, excluding datasets
like Intl. However, things like a namespace declaration, license file
header, etc. are very static over the years.
</aside>

This graph plots how much lines of code written in any year are still
*untouched* in the latest releases. And it contains so many details about
the history of the framework!

First, you can see the 2.1 release more than doubling the lines of code of
the framework at the end of 2012. This followed a 3 year period of more
2.x releases before releasing 3.0 at the end of 2015. 

You can see the rhythmic minor releases every 6 months. Each minor version
brings about 50,000 new lines of code to the codebase. With Symfony 4.3
adding the most new lines of code. This release [introduced the Mailer, Mime
and HttpClient components](https://symfony.com/blog/symfony-4-3-curated-new-features).

The little peaks every 2 years followed by a steep drop? That's the x.4 release,
immediately followed by the next major release removing all backwards
compatibility layers. It surprises me that the total lines cleaned up every
major version is worth more or less a full minor version (50k lines!). This
shows how crucial this is in keeping the codebase manageable.

The big change of existing lines in early 2019 is [the project switching
from oldschool `array()` syntax to `[]`](https://github.com/symfony/symfony/pull/29903).

The major version released end of 2021 removed more than a minor release
worth of code. This was the removal of [the old authentication system](https://github.com/symfony/symfony/pull/41613)
from the Security component.

Symfony 8.0 packs 9 times more code than the 2.0 release. Still, thanks to
the introduction of [Symfony Flex](https://fabien.potencier.org/symfony4-workflow-automation.html)
in Symfony 4, you only install the components required for your
application.

All in all, more than one third of the code in 8.0 is older than 6 years.
This speaks volumes for the maturity of the framework! 

{% include image.html src="/img/sf-stats/added-per-line.svg" alt="" class="figure" %}

This graph plots of the relation between total lines of code at a specific
release, and number of lines added/changed in that release. I must admit to
not fully understand what the multiplier exactly means, but it is telling
that this number still rises while the codebase is 9 times bigger than
at the start.

{% include image.html src="/img/sf-stats/complexity.svg" alt="" class="figure" %}

The cyclomatic complexity of the Symfony codebase slightly increases over
time, although it remains mostly stable.

It is however interesting to see the evolution of the most complex method
in the codebase. For years, the [custom pluralization rules](https://github.com/symfony/symfony/blob/4.3/src/Symfony/Component/Translation/PluralizationRules.php#L33-L195)
in the Translation component topped the list.

But since migrating to the
[ICU MessageFormat](https://symfony.com/doc/8.0/reference/formats/message_format.html),
the [Debug Class Loader](https://github.com/symfony/symfony/blob/6.1/src/Symfony/Component/ErrorHandler/DebugClassLoader.php#L356-L662)
has taken over. This class is responsible for most of the deprecation
reporting for deprecated classes, changed method signatures, return types
and new interface methods.

Recently, the [Redis cache connection](https://github.com/symfony/symfony/blob/7.3/src/Symfony/Component/Cache/Traits/RedisTrait.php#L91-L491)
has taken over the worst method spot, due to supporting many different
Redis extensions/libraries.

{% include image.html src="/img/sf-stats/comments.svg" alt="" class="figure" %}

Using a very minimalistic script, I also counted the lines of comment in
PHP files. This includes (multi-)line doc comments, and full line comments
starting with `//` or `#`.

In 2.0, almost 40% of the lines of code were comments. This was in part due
to "Captain Obvious" PHPdoc comments like ["Constructor."](https://github.com/symfony/symfony/blob/2.0/src/Symfony/Component/HttpKernel/Kernel.php#L67)
at every `__construct()` method. Symfony also used to have a convention of
adding PHPdoc comments containing only `{@inheritdoc}` when overriding a
parent method. Over the years, practices changed the share of comments
decreased.

Lately, the introducing of PHP native types and attributes helped making
even more comments redundant.

Of course, comments also add useful context to lines of code. Maybe this is
a metric we should focus on getting higher again in 2026!

## Documentation

That brings us to my favorite corner of software: Documentation. We've seen
the Symfony codebase grow immensely over the years, how does the
documentation compare with this?

{% include image.html src="/img/sf-stats/docs-over-time.svg" alt="" class="figure" %}

<aside class="side" data-type="Accuracy">
The Symfony documentation uses a maximum line length around 72 characters,
meaning the number of lines of documentation is a good indicator of words
of documentation.
</aside>

While not as fast as the codebase, the Symfony documentation has grown an
incredible 4 times since the initial 2.0 release. This is an impressive
statistic, given the limited size of the documentation team and
contributors. Still, the [documentation GitHub repository](https://github.com/symfony/symfony-docs)
is one of the top active projects (for instance double the amount of
contributors compared to React).

Also interesting to see some of the drops in lines of documentation with
major releases. With the removal of XML and PHP Config Builder
configuration formats in Symfony 8.0, a lot of code examples and
documentation could be removed from the documentation. This not only
reduces the size of the documentation, but also improves developer
experience!

{% include image.html src="/img/sf-stats/lines-per-docs.svg" alt="" class="figure" %}

It is also interesting to compare the number of documentation lines with
1,000 lines of Symfony code.

The initial release had relatively the most documentation, rapidly dropping
when Symfony 2.1 doubled its code size at the end of 2012. In 2016, the
documentation team [reorganized the docs](https://symfony.com/blog/introducing-the-new-symfony-documentation)
from books & cookbooks to the guides we have now.
Since then, this metric has been slowly decreasing but mostly stable.

Less documentation does not have to be a negative metric. Over the years,
the documentation team has gained tons of experience in writing more
concise and favoring code examples over large walls of text.

## Conclusion

A huge congrats to Fabien for driving the Symfony project forward for 20
years. If these graphs proofed me anything, it is that the Symfony
community has evolved over the many years and still is buzzing everywhere!

If you have more ideas on data to investigate, or want to try out my (very
hacky) scripts on other projects, go over to the scripts on
[GitHub](https://github.com/wouterj-nl/symfony-stats). But be warned: the
scripts may break at any time and running them can take a loooong time.
