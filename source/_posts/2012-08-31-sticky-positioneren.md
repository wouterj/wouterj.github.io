---
layout: post
title: "CSS bleeding edge: Sticky Positioneren"
category: article
tags:
- bleeding edge
- css

---
Vandaag bespreek ik een echte bleeding edge: Er is nog geen specificatie voor
en het is gister beland in de alpha channel van Chrome.

## Chrome Canary of Webkit Nightly

Om deze blogpost live te kunnen uittesten en om de demo te kunnen bekijken heb
je Chrome Canary nodig. Dit is een versie van Chrome die je naast je stable of
dev. versie kunt draaien. Het is het alpha kanaal met elke dag de nieuwste
updates.

Ga naar [deze pagina](https://tools.google.com/dlpage/chromesxs/) om Chrome
Canary te downloaden.

Je kan ook [webkit nightly](http://nightly.webkit.org/) downloaden.

## Het probleem: In-flow en fixed

Elk element is standard in-flow: Het gaat mee met de flow van de pagina. Maar
aan de hand van positionering kun je een element uit de flow halen en er wat
leuks mee doen. Met bijv. absoluut positioneren kun je een element een vaste
plek geven, aan de hand van de eerste relative parent, wat vaak het body
element is.

Fixed positioneren kennen we al een tijdje. Hiermee geef je een element een
vaste positie op het scherm en die positie die blijft als je scrolld. Hij zal
dus nooit veranderen, zie ook [deze demo](http://wouterj.nl/demos/position-sticky/fixed.html).

Maar nu hebben we het probleem dat we soms in-flow en fixed willen combineren.
We willen het element gewoon een plek geven in de content, maar zodra hij
dreigt te verwijderen moet hij fixed zijn. Een voorbeeld kun je op
[Google Nieuws](https://news.google.com/) zien. Het menu aan de linkerkant
staat eerst leuk in de flow, maar zodra hij dreigt te verdwijnen wordt hij
fixed.

## De oude oplossing: JavaScript scroll events

Om dit voor elkaar te krijgen gebruikte men JavaScript, om precies te zijn het
scroll event. Deze wordt per pixel dat je naar beneden gaat aangeroepen.
Doormiddel van een simpele if kun je dan kijken of de pagina al zover naar
beneden is dat het element gaat verdwijnen. Dan maak je zo'n element fixed.

### Niet ideaal

Het grote nadeel is dat je hiermee per pixel dat je scroll een javascript
functie laat uitvoeren. Dit maakt het scrollen wat schokkerig en geeft je niet
de scroll ervaring die je hoort te hebben. Je moet zoveel mogelijk van scroll
events afblijven.

## De nieuwe oplossing: CSS sticky

Simon Fraser had dit probleem ook en dacht: Kan CSS me niet helpen? Dus hij
[vroeg een feature aan bij webkit](https://bugs.webkit.org/show_bug.cgi?id=95146).
Tevens vroeg
[iemand aan w3c](http://lists.w3.org/Archives/Public/www-style/2012Jun/0627.html)
of die er een specificatie voor konden maken, zodat andere browsers het ook
konden implementeren. Maar zoiets kost tijd, en de specificatie is er nu nog
niet (ook niet een editors draft).

Het Webkit team is gelukkig wel snel en
[het is zojuist beland in de webkit alpha versie](http://trac.webkit.org/changeset/126774).

### Laten we wat gaan testen

Het is heel simpel om te gebruiken. Je definieert eerst dat het `position:
sticky;` is, merk op dat dit momenteel nog prefixed is. Tevens moet je
definiëren wanneer hij moet vastplakken. In dit geval zeggen we dat als hij
niet meer `10px` vanaf de bovenkant van de pagina is hij fixed moet
worden.

    [css]
    #element {
        position: -webkit-sticky;
        position: -moz-sticky;
        position: -ms -sticky;
        position: -o -sticky;
        position: sticky;
        top: 10px;
    }

En we zijn klaar!

Nu hoor ik je denken, waarom al die prefixen als het alleen in webkit werkt? Je
wilt natuurlijk dat als een browser het support, met prefix of niet, hij meteen
werk. Daarom denk je alvast vooruit en zorg je dat de prefixen er al staan.
Mijn verwachting is dat Mozilla snel gaat komen met hun sticky, aangezien
webkit en Mozilla elkaar vaak wel snel volgen en soms zelf dingen samen doen.
MicroSoft en Opera zullen wel wachten op de specificaties. Maar nogmaals: dat
zijn mijn verwachtingen.

## Een demo

Om het te demonstreren heb ik
[een simpele demo](http://wouterj.nl/demos/position-sticky/sticky.html)
gemaakt, let wel op of je in een browser zit dat het ondersteund!
