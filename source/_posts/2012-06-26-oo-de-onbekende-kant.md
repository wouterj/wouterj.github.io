---
layout: post
title: "OO: De onbekende kant"
thumbnail: oo-onbekende-kant-thumb.png
category: oo
tags:
- scripting
type: article
---
OO, elke beginner weet het wel: Denken in objecten en dat omzetten in een
script. Maar OO is veel en veel meer, laat me even kennis maken met de, voor
velen, onbekende kant van OO.

## Even een klein sprongetje

Voor ik verder kan moet ik dan nu toch dat kleine sprongetje maken van objecten
naar een script. Daarvoor moet ik even 3 universele begrippen uitleggen, verder
gaan we nog niet.

### Object = class

Een object, wat in de vorige tutorial is uitgelegd, heet in een scripttaal een
class (klasse in het Nederlands). Een object is dus een klasse, maar niet elke
klasse is een object. Dat betekend dat we ook klassen kunnen hebben die geen
object voorstellen in de werkelijkheid.

### Eigenschap = property

Een eigenschap, zoals een blauwe kleur, is in een klasse een property. Dit is
te vergelijken met een variabele.

Ook een property hoeft niet per se een eigenschap te zijn, maar kan ook een
virtueel iets zijn dat het scripten makkelijk maakt.

### Gedragsverandering = method

Een gedragsverandering, zoals het veranderen van een kleur, wordt gedaan door
een method, dit is te vergelijken met een functie.

Een method hoeft niet per se een gedragsverandering te zijn, maar kan ook
gebruikt worden als bijv. een getter (waarmee je de waarde van een eigenschap
ophaalt).

## Een blogsysteempje

We gaan een blogsysteempje maken en houden het heel simpel: We zorgen dat
iemand een bericht kan plaatsen.

Allereerst moeten we dan eens de objecten bekijken, mocht je dit nog niet
begrijpen lees dan
[Eens goed nadenken in objecten](http://wouterj.nl/php/eens-goed-nadenken-in-objecten/354/).

### Welke fysieke objecten zijn er?

Nou, wat was de zin die we net hadden: *"We zorgen dat iemand een bericht
kan plaatsen."* Wat voor objecten zijn er in deze zin? Ik denk
*bericht* en *iemand*. Die iemand is dan de Author en dat bericht is
een BlogPost.

### Welke eigenschappen hebben die objecten?

Een Author heeft een naam, een biografie en een foto van zichzelf.

Een BlogPost heeft een titel, content en een slug (het geen in de url staat).

### Welke methods horen er dan bij?

En welke methods hebben die objecten dan? Nou, je zal als eerst natuurlijk
methods moeten hebben om die eigenschappen op te vragen, de zogeheten getters,
en ook kunnen sommige eigenschappen opnieuw ingesteld worden, de setters.

Een Author heeft setName, setBiography, setPicture setters en getName,
getBiography, getPicture getters.

Een BlogPost heeft setTitle, setContent en setSlug en getTitle, getContent en
getSlug.

## De `HEEFT-EEN` relatie

Ik heb jullie net iets achtergehouden, maar ik hoop dat je dat zelf ook wel
door had. Want wat heeft een BlogPost nou nog meer? Een Author toch?!

En die Author, is dat niet dat andere object die we net gemaakt hadden?

Huh, zul je denken, kan ik dan een object aan een ander object meegeven? Ja,
dat kan. Dan komen we bij 1 van de 3 meest gebruikte relaties in OO: De
`HEEFT-EEN` releatie. Deze relatie kun je gewoon heel makkelijk opzeggen: Een
BlogPost `HEEFT-EEN` Author. En klopt dat? Ja.

We hebben in het BlogPost object dus een eigenschap author (met zijn getter
en setter) en die bevat de waarde van het Author object. Als we later in de
code de naam van de Author willen krijgen dan moeten we eerst de author van die
BlogPost krijgen, dat doen we met de getAuthor van de BlogPost. Vervolgens
hebben we de author en kunnen we de getName method van die Author object
gebruiken om de naam te krijgen.

## Klein blogsysteempje wordt groter

Je concept is een groot succes en je krijgt dozijnen aan bezoekers per uur. Een
paar daar van posten berichten, andere beginnen spam te posten en je site wordt
langzaam 1 grote hoop reclame. Het is tijd voor verandering, anders is je site
straks 1 grote ramp.

Nu is een goed OO script flexibel en horen dit soort dingen snel en makkelijk
toegevoegd te kunnen worden. Tijd om onze goede OO kennis op de proef te
stellen. 

## Admins toevoegen

Zonder admins die berichten goedkeuren blijft er alleen maar spam komen. Dus we
moeten een nieuw soort User toevoegen, iemand met meer rechten dan een
Author.

Nou denk je, we maken gewoon weer een nieuw object aan: Admin. Die geven we
weer de eigenschappen naam, biografie en foto mee, met hun setters en getters.
Tevens voegen we wat methods toe als allowPost en disallowPost. En klaar zijn
we.

Maar is dit wel zo flexibel als ik net beweerde dat OO is? Stel we besluiten
dat de naam altijd moet beginnen met een hoofdletter. Dan zullen we de method
setName van de Author en van de Admin moeten wijzigen. Dat kost ons dus 2x
zoveel werk als dat het hoort.

Hoe moeten we het dan doen? Nou, dan gaan we programmeren naar een superobject.
Klinkt heel moeilijk, is heel makkelijk. We kijken welke dingen de Author en de
Admin gemeen hebben: alle eigenschappen + hun getters. Het enige verschil is
eigenlijk dat de Admin wat extra methods heeft.

Deze overeenkomsten halen we uit de bestaande objecten en plaatsen we in een
totaal nieuw object: User. Vervolgens gaan we overerving gebruiken: we geven
aan dat de Admin een soort User is, waardoor hij automatisch de methods en
eigenschappen van User krijgt en dat doen we ook met de Author.

## De `IS-EEN` relatie

En daar hebben we al weer een nieuwe relatie gekregen: De `IS-EEN` relatie. Ook
deze kunnen we makkelijk opzeggen: De Author `IS-EEN` User. En dat klopt, ook
als we de Admin hiervoor invullen.

Een IS-EEN relatie is altijd handig. Je moet altijd proberen IS-EEN relaties te
krijgen, te programmeren naar een superobject, zoals ik net al zei.

### Waarom moet dat?

Omdat je dan heel makkelijk kunt controleren. We willen dat de Author van de
BlogPost wel een object is met bepaalde methods. Stel dat we nou alleen
controleren of die eigenschap een Author object is dan kan de Admin geen
berichten plaatsen? Als we nou controleren op het overkoepelende object, het
superobject, dan kan ook de Admin berichten plaatsen.

Ook kunnen we nu bepalen dat de Author en de Admin op zijn minst een aantal
eigenschappen en methods heeft, dat is wel handig als je die ergens in een
method van de BlogPost gaat gebruiken.

## UML

Als laatste wil ik weer even doorgaan met UML. In de vorige tutorial van deze
serie hebben we geleerd hoe we een object met hun methods en eigenschappen in
UML tekenen, laten we dan nu de pas geleerde relaties gaan gebruiken in UML:

### `HEEFT-EEN` relatie

Een HEEFT-EEN relatie wordt in UML aangeduid met een doorgetrokken streep met
aan het eind een open pijl:

![Een HEEFT-EEN relatie in UML](/img/2012/06/oo2-uml-has-a.png)

### `IS-EEN` relatie

Een IS-EEN relatie wordt in UML aangeduid met een gestreepte streep met aan het
eind een gesloten pijl die niet is ingekleurd:

![Een IS-EEN relatie in UML](/img/2012/06/oo2-uml-is-a.png)

Merk op dat bij een IS-EEN relatie de subklassen (de kinderen) alle methoden
overerven, deze worden dus ook weer in de nieuwe class geplaats.

## Alweer het einde

En dit is al weer het einde van deze les. Ik hoop dat je nu weer even vooruit
kunt. De volgende les gaan we nog 1 relatie leren en gaan we kijken naar
Interfaces en Abstracte Objecten, een apart soort superobject.
