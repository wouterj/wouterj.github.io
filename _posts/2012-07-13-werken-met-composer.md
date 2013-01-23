---
layout: post
title: "Werken met Composer"
description: ""
category: php
tags: [development]
type: article
---
Je hebt vast wel eens gewerkt met Ruby of Node.js en je hebt vast wel eens
gedroomd hoe geweldig het niet zal zijn om een Gem (ruby) of Npm (node.js) te
hebben voor PHP. Nu is het tijd om je dromen werkelijkheid te maken!

<!--more-->

## Wat is een dependency manager?

Met een dependency manager kun je makkelijk en snel libaries, die je project
gebruikt, inladen. Deze libaries worden vaak third-party libaries genoemd. Het
Symfony Framework gebruikt bijv. voor het mailen Swiftmailer, dat is een
third-party libary. Als je een website maakt met jQuery dan is jQuery een
third-party libary voor jou website.

Deze libaries moest je eerst altijd handmatig downloaden en dan in je project
plaatsen. Als je een nieuwe versie wilde moest je het weer opnieuw downloaden
en die andere verwijderen.

Een dependency manager helpt je hierbij, nouja helpen, je hoeft er eigenlijk
bijna niks meer voor te doen. Als je een project maakt maak je een
`composer.json` bestand waarin je schrijft welke third-party libaries je wilt
en welke versie. Vervolgens hoef je alleen maar `composer install` uit te
voeren en je hebt alle benodigde libaries.

## Composer installeren (windows)

Als eerst moeten we natuurlijk composer installeren. Dat doen we door naar de
[download pagina](http://getcomposer.org/download/) te gaan en de laatste
versie te downloaden.

Als je het hebt gedownload kun je composer gebruiken via het command panel
(cmd). Als je hier nog nooit mee hebt gewerkt even een korte tutorial:

---

Als je het cmd opent (ga naar Start en vul bij ‘zoekopdracht starten’ cmd in)
zie je een zwart scherm voor je. Je ziet hier eerst het path waar we inzitten
en daarna een `>` en daarna kan je typen.

Het CMD werkt met commands om alles te doen. Stel we zijn nu in `C:\Users\Acme`
en we willen naar `C:\Users\Acme\projects` dan doen we: 

    C:\Users\Acme> cd projects

Stel we willen naar `E:\wamp\www\myProject` dan moet dat in 2 stappen: Eerst
moeten we naar de andere schrijf (E) en daarna gaan we naar de juiste map:

    C:\Users\Acme\projects> e:
    E:\> cd wamp/www/myProject

Dit spreekt wel voorzich denk ik. Als je nu wilt weten welke bestanden er in
deze map zitten gebruik je het ls command:

    E:\wamp\www\myProject> ls
    css         img         js
    index.php   .htaccess

---

I.p.v. de standaard command (cd, ls, enz.) kun je ook programma’s toevoegen als
command. Dit doe je door dat programma aan de omgevingsvariabele PATH toe te
voegen. 

### PHP

Het is nu nodig dat we PHP toevoegen als programma. Eerst zoeken we de locatie
op van php.exe (in mijn geval E:\wamp\bin\php\php5.4.0\php.exe). Nu klikken we
met de rechtermuisknop op Computer en dan eigenschappen > Geavanceerde
systeeminstellingen > Geavanceerd > Omgevingsvariabelen… Daarin klikken we
dubbel op PATH en dan voegen we onze map (dus zonder bestandsnaam) toe aan deze
variabele door deze te scheiden met de vorige map met een `;`.

Nu kunnen we in ons CMD PHP gebruiken. Stel we hebben het composer.phar bestand
gedownload in `C:\Programs`. Dan kunnen we nu het composer bestand aanroepen
met PHP:

E:\wamp\www\myProject> php C:\Programs\composer.phar install

### Composer shortcut

Maar dat is zoveel typewerk vind je niet? Daarom gaan we dit wat verbeteren. We
verplaatsen composer.phar even naar een map die wat logischer is, in mijn geval
heb ik het in dezelfde map als PHP gezet. In dezelfde map maken we een
bestandje genaamd `composer.bat`. Hierin plaatsen we het volgende:

    @echo off
    php "E:\wamp\bin\php\php5.4.0\composer.phar" %*

Wat dit doet is dat we ons php command aanroepen (`php` op regel 2) vervolgens
roepen we ons composer.phar bestandje aan en dan met `%*` geven we aan dat alle
argumenten worden overgenomen en doorgegeven aan composer.phar.

We moeten vervolgens deze map, mocht dat nog niet zo zijn, weer toevoegen aan
de omgevingsvariabelen.

We hebben nu dus eigenlijk een bestandje gemaakt met een shortcut erin, i.p.v.
`php E:\wamp\bin\php\php5.4.0\composer.phar install` hoeven we nu alleen
`composer install` te gebruiken. Er wordt dan het bestandje `composer.bat`
aangeroepen die vervolgens weer ons oude command aanroept en het argument
`install` doorgeeft aan de composer.phar.

### GIT

Composer werkt met GIT, mocht je dat dus niet op je computer hebben staan dan
moet je dat installeren (lees
[hier](http://git-scm.com/book/en/Getting-Started-Installing-Git#Installing-on-Windows)
hoe) en vervolgens weer het path naar sh.exe in je omgevingsvariabele
toevoegen.

## Aan het werk

Nou dan kunnen we eindelijk aan de slag. We gaan naar ons project en maken een
`composer.json` bestand aan waarin we in JSON allemaal settings kunnen
instellen. 

Stel ik heb nu een project en nu wil ik Swiftmailer gebruiken. Dan moeten we
eerst kijken hoe de Swiftmailer package heet (een third-party libary heet in
Composer een package). Hiervoor gaan we naar
[packagist.org](http://packagist.org/), de site met alle packages voor
composer. We zoeken hier op Swiftmailer en krijgen swiftmailer/swiftmailer als
resultaat, dat is de gene die we zoeken. Een package naam bestaat altijd uit
een organisatienaam en een project naam (organisatie/project). Als jij bijv.
een Swiftmailer extensie schrijft en die als package openstelt wordt dat
JouNaam\Swiftmailer-extension.

Nu klikken we op deze package en we zien dan wat informatie over deze package
met onder anderen de versies. Bij het instellen welke package we willen moeten
we ook altijd een versie instellen. Deze versie kun je op verschillende
manieren opbouwen:

    2.1.*
    >= 2.1.0, <2.2.5
    2.1.13

In het eerste geval gebruiken we de `*` wildchart, dat staat voor elk getal. In
ons geval betekend 2.1.\* dus dat het 2.1.0 kan zijn, maar ook 2.1.29, enz.
Zolang het maar begint met 2.1.

Je kan ook een range selecteren. In het tweede geval doen we dat, we zeggen pak
op zijn minst versie 2.1.0, maar niet hoger dan versie 2.2.5. In het 3e geval
hebben we gewoon een exacte versie ingevuld.

Nu we de versie weten (we gaan voor 4.2.\*) kunnen we het instellen zodat
composer het gaat inladen. Dat doen we door in `composer.json` de require
parameter in te vullen:

    {
        "require" : {
            "swiftmailer\swiftmailer" : "4.2.*"
        }
    }

Stel dat we nu ook nog Propel willen inladen. Dan gaan we weer zoeken op propel
en vinden we de propel\propel package. Deze heeft maar 1 versie en dus gaan we
die er ook bij zetten:

    {
        "require" : {
            "swiftmailer\swiftmailer" : "4.2.*",
            "propel\propel" : "dev-master"
        }
    }

Nu we alle packages hebben gedefinieerd kunnen we ze gaan installeren door de
composer command aan te roepen:

    cd path/to/myProject
    composer install

De packages worden nu in de vendor map gezet, vendors is weer zo’n andere naam
voor third-party libaries.

### Autoloader

Als je vaak met klassen werkt en projecten/libaries zul je merken dat elk
project zijn eigen autoloader hebt. Je hebt dan in ons geval 3 autoloaders
geregistreerd. Dat is natuurlijk iets teveel van het goede en daarom komt
Composer met zijn eigen autoloader. Deze kun je includen en dan wordt alles
automatisch goed geladen.

Aangezien je naast de packages ook nog je eigen klassen hebt die ingeladen
moeten worden kun je de autoloader instellen waar hij naar jou klassen moet
gaan zoeken. Ik plaats bijv. alles in een `src` map, we geven dan aan dat hij
naar klassen kan zoeken in de src map:

    {
        "require" : {
            "swiftmailer\swiftmailer" : "4.2.*",
            "propel\propel" : "dev-master"
        },
        "autoload" : {
            "psr-0" : { "" : "src/" }
        }
    }

Dit komt wellicht wat vaag over, maar PSR-0 is de standaard waaraan alle
klassenamen zich moeten houden en we kunnen dan aangeven dat er naar een
bepaalde namespace gezocht moet worden in een bepaalde map. In dit geval hebben
we een lege namespace, wat staat voor alle namespaces, en die kunnen gezocht
worden in de src map.

Je kan nog veel meer met het composer.json bestand. Daarom raad ik je aan <a
href="http://getcomposer.org/doc/">de documentatie van composer</a> uitgebreid
te lezen en wat online voorbeelden te zoeken. Een voorbeeld die ik heb gemaakt
is <a href="https://github.com/WouterJ/Decres">Decres</a> of kijk bijv. eens
naar <a href="https://github.com/symfony/symfony">Symfony</a>. 

## Packages updaten

Als je je packages eenmaal hebt geïnstalleerd wordt er een composer.lock
bestand aangemaakt die aangeeft welke versies er nu zijn geïnstalleerd.

Stel dat Swiftmailer een nieuwe versie heeft (bijv. 4.2.5) en die wil jij ook
hebben, dan hoef je alleen maar `composer update` uit te voeren en de packages
worden geüpdatet.

## …en nu kan je

Na deze les heb je geleerd hoe composer werkt en hoe je hem kan installeren. Nu
kun je hier natuurlijk wat problemen mee krijgen, laat dan even een reactie
achter dan zal ik je zo goed mogelijk proberen te helpen.

Maar deze tutorial heb ik niet zomaar geplaatst, ik ben namelijk bezig met het
schrijven van een tutorial over het Symfony Framework. Blijf me volgen en
misschien kom je halverwege deze vakantie wel de eerste berichten tegen. Om je
alvast warm te maken en een idee te geven hoe makkelijk het is om Symfony te
downloaden met composer:

    composer create-project symfony/framework-standard-edition
