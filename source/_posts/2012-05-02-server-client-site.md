---
layout: post
title: "PHP server-side? JS client-side? En HTML en CSS dan?"
thumbnail: client-server-side-thumb.png
categories:
- article
tags:
- programming types

---
Tja, scripten is lastig. Maar het wordt nog lastiger als we het ook nog
eens gaan hebben over wat een scirpttaal precies doet en hoe het werkt. Maar
toch is het iets wat je echt door moet hebben wil je goed kunnen werken met
scripttalen. Helaas kom ik vaak tegen dat beginners dit niet door hebben
en met hun handen in hun haar naar een forum komen om te vragen of je iets
kunt doen in PHP wat PHP helemaal niet kan. Of precies andersom dat je in JS
iets wilt doen maar dat helemaal niet kan. Dat komt omdat er 1 heel groot
verschil zit in die talen.<br /> Om het voor eens en altijd duidelijk te maken
hier een artikel die het, hoop ik, goed uitlegt.

## Een scripttaal

Laten we eerst eens kijken wat nou een scripttaal is. Ik wil het niet te
moeilijk maken, want over dit onderwerp wordt nog
[heel](http://www.bautforum.com/showthread.php/93514-Scripting-vs-coding-vs-programming)
[veel](http://www.killersites.com/blog/2005/scripting-vs-programming-is-there-a-difference/)
[gediscussieerd](http://www.naelshawwa.com/scripting-coding-programming/).
Maar een scripttaal is een programmeertaal die in een programma werkt. Bijv.
PHP is een scripttaal. PHP heeft de PHP Engine (alle code achter PHP) nodig om
te kunnen werken, zodra je dit niet hebt kun je geen PHP draaien. Een taal als
JAVA (dus niet JavaScript!!!) draait uit zichzelf, in elk geval zo zeggen we
het. JavaScript (dus niet JAVA!!!) is weer een scripttaal, het heeft de JavaScript
Engine (ECMA) nodig om te draaien.

### ...en HTML en CSS dan?

Dan gaan we er nog een moeilijk begrip bij verzinnen. Een programmeertaal is
een taal die voorschrijft hoe een computer iets moet behandelen. HTML en CSS
schrijven helemaal geen handelingen voor, HTML en CSS zijn alleen maar voor
hoe het eruit ziet. Daarom zijn HTML en CSS mark-up talen.

### Even op een rijtje

 - **Programmeertaal** - Een taal die handelingen voorschrijft voor de
   computer (bijv. JAVA)
 - **Scripttaal** - Een programmeertaal die een programma (Engine) nodig heeft
   om te werken (bijv. PHP of JavaScript)
 - **Mark-uptaal** - Een taal die voorschrijft hoe iets eruit komt te zien.
   (bijv. HTML of CSS)

## Server-side vs Client-side

Oké, 1 verschil tussen soorten talen begrijpen we nu. Laten we naar nog een
verschil kijken tussen scripttalen: Server-side en Client-side. Je hebt het
vast al een keer voorbij horen komen, maar wat nou precies het verschil is?

### Wat gebeurd er als je een pagina oproept?

Een Server-side taal kan alleen op de server worden uitgevoerd. Als je een url
in je browser typt gaat het browser in de wereld opzoek naar een server waar
die domein opstaat. Hij zoekt deze server doormiddel van een HTTP Request uit
te sturen de wereld in. Een server ontvangt deze, denkt: *"Hé, die is voor mij"*
en gaat vervolgens de pagina afhandelen. Vervolgens stuurt de server een HTTP
Response terug naar de browser, die deze vervolgens omzet in wat voor ons een
normale webpagina is. Omgezet in een afbeelding is het:

![Een normale pagina opvraag van client naar server en weer terug](/img/2012/05/http-protocol.png)

#### En wat heeft dit er mee te maken?

Meer dan je denkt! We nemen even PHP als voorbeeld. PHP is een server-side
scripttaal. Dat betekend dat alle PHP code op de server worden uitgevoerd en
dat de code die gegenereerd wordt wordt meegezonden met de HTTP response. Dat
heeft een aantal consequenties:

 - PHP kan maar 1 keer per pagina aanroept worden uitgevoerd - Omdat een
   pagina (en dus de code) alleen langs de server komt bij het aanvragen kun
   je PHP alleen bij het genereren van een pagina gebruiken. Dus niet
   halverwege een pagina.
 - PHP is server afhankelijk - Doordat het op de server uit wordt gevoerd is
   het afhankelijk van die server. Staat er op die server PHP4.1 dan wordt de
   PHP uitgevoerd in PHP4.1, ookal heb jij op je computer PHP5.4.
 - PHP code kun je niet in de broncode terug zien, omdat de browser niet eens
   weet dat de pagina gemaakt is met PHP. Dat weet slechts alleen de server.

Om het weer duidelijk te maken nu hetzelfde plaatje, maar dan met de PHP
engine erin:

![Merk op dat alleen pagina's die PHP zijn door de PHP engine worden gehaald.](/img/2012/05/http-protocol-with-php.png)

### En nu de client-side

Client-side zegt het al, het wordt aan de kant van de client uitgevoerd.
Oftewel: in de browser. Dit zorgt ervoor dat we dingen kunnen aanpassen zonder
dat we de pagina hoeven te refreshen. En we kunnen een code net zo vaak
aanroepen als we zelf willen, in een JavaScript voorbeeld: Je kunt een click
event oneindig vaak aanroepen. Maar er kleven ook nadelen aan:

 - Het is afhankelijk van browsers - Doordat het in de browser wordt uitgevoerd zijn deze scripttalen afhankelijk van de engine in een browser. Dat kan door de browserwar nogal voor flinke problemen en irritaties zorgen.
 - Hoe meer scriptcode hoe trager de pagina laad en hoe trager de site werkt omdat de browser nu wel van de code af weet en nu alles in de gaten moet houden.
 - Het is te lezen in de broncode, je kan ten alle tijden de code lezen in de broncode. Persoonlijke gegevens als wachtwoorden kun je er dus niet in kwijt.
 - Het is door tools altijd aan te passen en dus mag je er nooit van uitgaan dat iets de waarde bevat/het ding doet die jij hebt voorgeschreven, controle is dus veel belangrijker.
 - Je kan niet communiceren met de server dus dingen uit een DataBase halen of een bestand van de server halen is niet mogelijk (tegenwoordig een beetje door AJAX en <a href="http://html5doctor.com/introducing-web-sql-databases/">Web databases</a> (web dus geen server db!))

## Wanneer kies ik welke taal?

Per onderdeel moet je je dus afvragen welke soort taal je gaat gebruiken. Vaak
is het zo dat je JavaScript alleen gebruikt ter verleuking van je website of
bijv. om pop-ups te tonen. PHP gebruik je voor het dynamisch maken van de
pagina en voor alle communicatie met de server.
