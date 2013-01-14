---
layout: post
title: "Hoe je een Symfony2 project omzet in composer"
description: ""
category: php
tags: [symfony2]
type: article
---
De architectuur van Symfony2 geeft je veel mogelijkheden tot het gebruik van
code van andere en niet zelf 'het wiel uitvinden'. Composer is de tool die je
het makkelijk voor je maakt om code van andere te importeren in je project.
Helaas is Composer pas uitgekomen nadat Symfony2.0 is uitgekomen en daarom is
Symfony2.0 niet standaard via composer verkrijgbaar, maar je kan je project wel
omzetten tot een composer project.
<!--more-->

### Symfony2 is een groot begrip

Symfony2 is een heel algemeen begrip. In feite verwijs je naar [alle Symfony2
componenten](http://symfony.com/doc/current/components) als je het begrip
'Symfony2' gebruikt. Dit is vaak fout en je bedoelt vaak het 'Symfony2 Framework'. 
Dat is de SymfonyFrameworkBundle in combinatie met alle componenten. De
FrameworkBundle maakt van alle losse componenten een bruikbaar framework.

Als laatst zul je bijna nooit het Symfony2 Framework downloaden, maar de
'Symfony2 Standard Edition'. Dit is een standaard mappenstructuur, met
configuratie en alles eromheen die je eigenlijk altijd zal gaan gebruiken. Maar
dit hoeft niet, je kunt hem aanpassen zover je wilt (zie ook
["How to override Symfony's Default Directory Structure](http://symfony.com/doc/current/cookbook/configuration/override_dir_structure.html)).

Nu is dit allemaal een beetje muggenziften en raad ik je aan mensen nooit te
verbeteren als ze deze begrippen door elkaar halen, maar het is wel essentieel
om Symfony2 een beetje door te krijgen. En het is zeker essentieel om straks
door te krijgen.

### Symfony en Composer

Composer is een dependency manager. Kort gezegd kun je hiermee makkelijk code
van anderen in je project downloaden en zorgen dat je de juiste versies hebt.
Mocht je meer willen weten raad ik je aan mijn eerdere tutorial over Composer te
lezen: "Werken met composer"

Toen Symfony2 uitkwam was Composer nog niet uitgekomen. Symfony2 heeft daarom
zijn eigen kleine dependency manager ontwikkeld (de `lock` bestanden), met 
het vooruit zicht dat ze over een paar maanden Composer gaan gebruiken. En vanaf
Symfony Framework 2.0.5 zijn ze ook Composer gaan gebruiken.

Nu komt helaas het jammere: De Symfony2 Standard Edition is pas Composer gaan
gebruiken vanaf versie 2.1. Mocht je nu aan een nieuw project beginnen is dat
niet erg, je gaat dan toch 2.1 gebruiken. Maar als je nu een 2.0 project hebt is
het wel een probleem, bundles zijn makkelijk verkrijgbaar via Composer en veel
moeilijker via de `lock` bestanden.

Nu kunnen we de Symfony2 Standard Edition gaan aanpassen en zo composer gaan
gebruiken. Tijd om te beginnen met code!

### Stap 1. `composer.json` maken

Als eerst moeten we een `composer.json` bestand maken waarin we de
dependencies gaan zetten. Deze houden we nu zo simpel mogelijk en dus vullen we
hier alleen de `require` items in:

    {
        "require": {
        }
    }

### Stap 2. Symfony2 framework toevoegen

De basis dependency is natuurlijk het Symfony2 Framework. Deze is beschikbaar
via de [symfony/symfony](https://packagist.org/packages/symfony/symfony)
package. We pakken versie 2.0.x om de nieuwste 2.0 versie te krijgen. Merk
tevens op dat we hier zien dat hij nog 4 andere packages met dit framework gaat
downloaden: `twig/twig`, `swiftmailer/swiftmailer`, `monolog/monolog` en
`doctrine/common`. Deze packages heeft het framework minimaal nodig om te
werken.
