---
layout: post
title: "Hoe leer ik Symfony2?"
thumbnail: symfony-leren-thumb.png
category: php
tags: [symfony2]
type: article
---
Bijna iedereen weet wel dat ik een fan ben van Symfony2 en alles wat er mee te
maken heeft. Door mijn enthousiasme wil iedereen het wel eens proberen en
daardoor krijg ik vaak de vraag hoe je nu het beste Symfony2 kunt leren.

<!--more-->

## Stappen

Symfony2 leer je in stappen. Je begint met een introductie, vervolgens kun je
beslissen of je door wilt gaan, dan ga je wat dieper de stof in en kun je al
beginnen met je eerste Symfony2 applicaties. Daarna kun je nog dieper de stof
in, extra dingen leren en zelfs de Symfony2 code in kijken.

## Voorkennis

Het is goed om al OO kennis te hebben. De OO syntax in PHP moet je sowieso goed
beheersen, maar het OO denken kan ook goed van pas komen.

Symfony2 maakt gebruik van de nieuwste methodes en technieken, sommige zul je
gaandeweg wel leren (zoals Dependency Injection), maar andere moet nu al paraat
hebben. De belangrijkste daarvan is de namespaces ondersteuning in PHP.

Als je compleet nieuw bent in OO raad ik je aan Symfony2 nog even weg te
leggen. Leer eerst [het OO denken](http://wouterj.nl/serie/orienteer-je-in-objecten/)
en [de OO syntax](http://phptuts.nl/view/45/). Daarna moet je eerst daarmee wat
gaan spelen. Lees ook eens
[From flat PHP to Symfony2](http://symfony.com/doc/2.0/book/from_flat_php_to_symfony2.html),
hierin laten we je de concrete voordelen zien van een framework.

Als je net begint met frameworks zul je het gevoel hebben dat je door het
framework erg beperkt wordt in wat je kan (dit is natuurlijk niet zo). Daarom
kan het soms beter zijn om een stapje terug te doen en te gaan werken met een
Micro framework. Ik raad dan aan om [Silex](http://silex.sensiolabs.org) te
gaan gebruiken. Deze is erg simpel en gemaakt door het Symfony2 team. Hierdoor
kom je al in aanraking met componenten en technieken in Symfony2, waardoor de
overstap naar Symfony2 makkelijker wordt.

## Stap 1: De kennismaking

Oké, je bent klaar om te beginnen met Symfony2. Tijd om Symfony2 eens voor te
stellen en te beslissen of je het een leuk framework vindt. Lees hiervoor de
[quick tour](http://symfony.com/doc/current/quick_tour/) in de Symfony2
documentatie.  Deze serie bestaat uit 4 hoofdstukken van ong. 10 minuten
leestijd. Daarin wordt je alle basis uitgelegd die je nodig hebt voor een
Symfony2 applicatie.  Je kunt na deze tutorial al beginnen aan je eigen
applicatie.

## Stap 2: Dieper in de stof

Nu je hebt besloten door te gaan met Symfony2 kun je beginnen aan
"[the book](http://symfony.com/doc/current/book/)". Dit is de bijbel voor
Symfony2 developers, dit legt echt alles uit wat je nodig hebt tot het maken
van volledige applicaties. Het is een ideale serie voor beginners, maar ook
experts verwijzen er nog regelmatig even naar om even je kennis op te frissen.

Lees deze serie zeker niet in 1 keer door. Begin met het lezen van het eerste
hoofdstuk, *"Symfony2 and HTTP fundamentals"* en lees alle volgende
hoofdstukken wanneer je het nodig hebt.

Begin bijv. met het maken van een pastbin systeem. Dan moet je eerst Symfony2
installeren, hiervoor lees je *"Installing and Configuring Symfony"*.
Nadat je dit hebt gedaan ga je aan de slag met je eerste pagina, je leest dan
*"Creating Pages in Symfony2"*. Daarvoor heb je routing en controller
kennis voor nodig, lees die pagina's ook. Ook moet je templates kunnen maken,
dus begin je ook aan die pagina. Ga zo langzamerhand de hele serie af.

## Stap 3: Klaar voor het echte werk!

Nu je eerste applicatie af is en je alle nuttige hoofdstukken van *The book*
hebt gelezen kun je ook nog de andere hoofdstukken lezen, vooral *"Service
Container"* en *"Testing"* raad ik aan te lezen.

Nu kun je in principe beginnen aan het echte werk. Begin met je eigen projecten
en kijk hoever je komt. De Symfony2 documentatie bevat nog een laatste serie
waar je zeker nog even naar moet kijken:
"[The cookbook](http://symfony.com/doc/current/cookbook/)". Hierin staat
allemaal side-informatie, allemaal dingen die je kunt doen met Symfony2, extra
tips en nog veel meer.

## Stap 4: Duik de code in

Als laatste raad ik je aan de code in te duiken. Functies gebruiken zonder te
weten wat er nou eigenlijk gebeurd is iets wat ik verafschuw. De Symfony2 code
staat onder `vendor/symfony/symfony/src/Symfony`. Symfony2 bevat 3
verschillende typen klassen:


 - **Componenten** - Dit zijn losse componenten die je kunt gebruiken in alle
   applicaties, deze zijn niet gebouwd voor Symfony2 alleen. Je zult zien dat het
   meeste deel van Symfony2 bestaat uit deze componenten. Om alles te leren over
   deze componenten kun je kijken in
   "[The components](http://symfony.com/doc/current/components/)" serie.

 - **Bridges** - Vervolgens heb je de bridge klassen. Dit zijn klassen die een
   component of 3th party library implementeren in Symfony2. Zo heb je bijv. een
   TwigBridge die voor Twig ondersteuning in Symfony2 zorgt.

 - **Bundles** - Dan heb je nog de core bundles, met als belangrijkste de
   SymfonyFrameworkBundle. Deze zorgen dat de Bridges en Componenten gecombineerd
   worden tot 1 geweldig framework: Symfony2.

## Extra tips

Na 1.5 jaar werken met Symfony2 heb ik hier nog wat extra tips voor je:

 - Composer is de tool die je moet gebruiken met Symfony2. Leer meer van deze
   tool in "[Werken met Composer](http://wouterj.nl/php/werken-met-composer/509/)".

 - Gebruik bundles. Je kan zelf alles maken, maar waarom het wiel uitvinden als
   er al geweldige bundles voor gemaakt zijn? Zoek eens op
   [KnpBundles](http://knpbundles.com/) naar bundles, daar staan hele goede
   tussen.
   Enkele die ik bijna in elke applicatie gebruik zijn
   [KnpMenuBundle](http://knpbundles.com/KnpLabs/KnpMenuBundle),
   [FOSUserBundle](http://knpbundles.com/FriendsOfSymfony/FOSUserBundle) en
   [SonataAdminBundle](http://knpbundles.com/sonata-project/SonataAdminBundle).

   Enkele teams die vaak terugkomen en bekend staan om hun bundles zijn KnpLabs
   (Knp), Friend Of Symfony (FOS), Sonata Project (Sonata) en Johannes Schmitt
   (Jms).

## Veel succes!

Nu ben je helemaal klaar om te beginnen met het leren van Symfony2, doe het
rustig aan, doe het goed en je leerd de mooie kant van PHP kennen. Het is bijna
zeker dat je vragen zult krijgen. Deze kun je altijd op diverse plekken vragen:

 - De [Symfony2 User Group](https://groups.google.com/forum/?fromgroups=#!forum/symfony2)
 - Op [Stackoverflow](http://stackoverflow.com/questions/tagged/symfony2%0A(vergeet%20niet%20je%20vraag%20te%20taggen%20met%20*symfony2*)
 - Op [PHPhulp](http://phphulp.nl/)
 - En natuurlijk door een mailtje te sturen naar wouter{at}wouterj{dot}nl of
   door mij te contacteren via PHPhulp.
