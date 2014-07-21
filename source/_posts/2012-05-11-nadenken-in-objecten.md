---
layout: post
title: "OO: Eens goed nadenken in objecten"
thumbnail: oop-nadenken-thumb.png
category: article
tags:
- scripting
- object oriented

---
OOP is vooral het denken in objecten. Ja, daar beginnen heel veel OOP
tutorials mee. Maar wat nou precies dat denken in objecten is dat wordt vaak
heel vaag uitgelegd. En hoe je dat moet doen is vaak al helemaal niet
uitgelegd. Tijd om daar eens verandering in te brengen. In deze tutorial raken
we geen 1 stukje code aan. Dat betekend dat het uit kan lopen op een saaie
theorie les, maar dat probeer ik te voorkomen. Het betekend ook dat iedereen,
in welke taal je ook script, deze tutorial kan volgen en dus is dit voor
iedereen geschikt.

## Object Georiënteerd

Laten we eerst eens dit moeilijke begrip uitpluizen. Dat georiënteerd begrijp
je waarschijnlijk wel. Maar wat bedoelen we nou met programmeren naar een
Object? Wat de van dale over een object zegt:

 > obj<u>e</u>ct het; o -en voorwerp (1, 2)

En wat is dan een voorwerp?

 > voorwerp het; o -en 1 iets dat men waarneemt, aanvat, bewerkt, liefheeft,
 > haat enz. 2 (taalk) naam van dat zinsdeel dat een persoon, zaak enz. noemt
 > die naast het onderwerp bij het gebeuren betrokken is (...)

Een voorwerp is dus gewoon alles wat je kan vastpakken, aanraken, zien, enz.
Dit lijkt waarschijnlijk erg logisch, maar deze basis kennis komt straks nog
goed van pas!

## Nadenken in objecten

Tja en dat straks van de vorige paragraaf kun je wel weglaten. We beginnen nu
meteen al met dat begrip. Een object is dus alles wat je kan aanraken zien
enz. Laat ik het eens op mijn bureau houden:

 - laptop
 - pen
 - kladblok
 - papier
 - boek

En zo kunnen we nog even doorgaan. Merk op dat een kladblok uit papieren
bestaat en dat kladblok en papier dus op sommige momenten aan elkaar gekoppeld
zijn, maar papier kan ook alleen voorkomen.

En nu gaan we het wat meer naar programmeren betrekken. Wat zien we hier op
mijn website nou voor objecten?

 - artikel
 - website
 - header
 - logo
 - Reactie

En zo kunnen we ook weer door gaan. Leuk is dat we hier veel child relaties
vinden. Een header is een child van de website, het logo weer een child van de
header (maar misschien ook van de footer).

Maar in de wereld van programmeren hebben we helaas ook objecten die je niet
kan zien maar die er wel zijn. Denk bijv. aan een user (dat ben ik, maar jij
bijv. ook).

### Objecten hebben eigenschappen

Objecten hebben eigenschappen dat is 1 van de regels die er zijn in moeder
natuur. Zonder eigenschappen kunnen we een object niet zien, voelen, enz. en
is het dus geen object. We noemen eens wat eigenschappen op van mijn bureau:

 - laptop is van Toshiba en draait op Windows Vista
 - Papier is wit en is 210 mm bij 297 mm
 - Kladblok bevat 100 paginas, gekoppeld door een ringband
 - Een pen heeft een blauwe kleur vulling en is 15 cm lang

Maar ook onze objecten in het web hebben eigenschappen:

 - Een artikel heeft een titel, auteur, tekst, thumbnail en publish datum
 - Een website bevat een header, content en footer ook heeft het een titel
 - Een header bevat een menu, sitenaam, slogan, slider
 - Een logo heeft een afbeelding als eigenschap
 - Een user heeft een naam, wachtwoord, geboortedatum, biografie

Merk op dat sommige eigenschappen op het web ook weer een object zijn. Bijv.
de auteur is een User.

Nu hebben we dus uit deze ene webpagina al een hele boel objecten gehaald en
bij die objecten zo een hele lijst eigenschappen opgenoemd. Probeer nu eens
zelf nog wat objecten uit deze pagina te halen, met hun eigenschappen. Zo leer
je kijken naar een project in objecten.

### Eigenschappen veranderen

Nu kunnen die eigenschappen veranderen. Op mijn laptop kan ik Windows 8
installeren, dan veranderd dus die eigenschap. Ook kan ik het papier
doormidden scheuren en ga zo maar verder.

In het web is dit ook zo. De naam van deze site kan veranderen, er kunnen menu
items bij komen en afgaan. Ik kan de tekst van dit bericht veranderen. En zo
kun je ook verder gaan.

## Flexibel denken

Maar we zijn er nog niet. Naast het denken in objecten is flexibel denken ook
heel belangrijk. Je moet straks je script zo hebben gescript dat je alles met
minimale wijzigingen kunt aanpassen. Bijv. je hebt een aantal users opgeslagen
in een database. Je heb een User object waarmee je een user uit de database
haalt en wanneer je hem uit de database haalt vul je met de gegevens van de
database de eigenschappen in.

Klinkt allemaal geweldig OO vind je niet? Toch is het niet OO. Het is goed als
je hetzelfde dacht, want meer had je nog niet uitgelegd, maar niet goed OO.
Wat als we nu dit project op een host zetten zonder database (erg dom, maar
stel je voor). Dan zullen we het hele user object moeten aanpassen zodat het
met een XML file(oid) kan werken. En dit moeten we straks met grotere
projecten niet alleen voor de User doen, maar ook voor de artikelen, sitenaam,
enz. Kortom: niet echt flexibel. Om een script flexibel te maken moeten we ons
houden aan één van de basisregels van OO:

**Een object mag slechts 1 functionaliteit hebben, wanneer er meer zijn behoort
het in 2 aparte objecten gesplitst te worden**

In ons geval doet het User object 2 dingen: Het haalt zorgt voor de connectie
tussen DB en script en het zorgt voor het vasthouden van eigenschappen. Dat is
er dus 1 teveel. De oplossing is het opdelen in 2 objecten. Nu gaan we het
moeilijk krijgen we moeten nu voor het beste resultaat een object aanmaken dat
niet echt bestaat. Het kost nu dus waarschijnlijk dus wat fantasie.

We houden ons User object deze gaat alleen dienen voor het vasthouden van
gegevens zodat we 1 vaste plek hebben om onze gegevens in te stoppen en 1
vaste plek om gegevens van de User op te halen.

Nu maken we nog een object die we UserMapper noemen (waarom we dit zo noemen
krijg je in latere tutorials te horen). Deze UserMapper object zorgt voor de
connectie tussen ons ophaalpunt en het User object.

Waarom zo moeilijk doen? Nou eigenlijk zorg je nu dat je het jezelf heel
makkelijk maakt. Stel je voor dat je de switch van database naar XML file
moeten maken. Dan hoeven we maar 1 bestand (het UserMapper bestand) aan te
passen en de rest blijft gewoon werken. Ideaal toch?

## Gedachte uittekenen

We kunnen wel uren per project gaan nadenken, maar daar schieten we niks mee
op als we het niet kunnen uittekenen. Voor het uittekenen van onze ideeën
gebruiken we in OOP de UML (Undefined Modeling Language) diagrammen. Een
voorbeeld van ons bovenstaande idee over het User en het UserMapper object:

![Wees gerust, zo moeilijk is het niet wat hier staat.](/img/2012/05/oop-nadenken-uml-usermapper.png)

We zien hier 2 blokken elk blok stelt 1 object voor. We hebben dus een
UserMapper object en een User object. Vervolgens heeft elk blok een naam
(dikgedrukt bovenin). Dit is de naam van elk object. Dan komen de
eigenschappen. Bij de UserMapper zijn dit `db` en `table` en bij de User zijn
het `name`, `password` en `id`. Het geen er achter de dubbele punt staat is
welk type ze moeten zijn, maar daar ga ik verder niet op in.

Vervolgens zien we nog iets wat we nog niet zijn tegengekomen. Die namen die
eronder staan gevolgt door een () met soms iets erin en soms niet. Dit zijn
functies waarmee we eigenschappen van een object kunnen veranderen/opgevragen.
Bijv. getName in het User object zorgt ervoor dat we de naam kunnen opvragen.
Soms staan er wat dingen tussen () dit zijn parameters die we gebruiken. Bijv.
bij setPass dan hebben we een parameter pass die we gaan opslaan in de
password eigenschap.

## Laten we stoppen
Waarschijnlijk slaan je hersens nu op hol. Zoveel heb je hier nu gelezen en
daar moet je toch nog eens goed over nadenken. Ook ik hou het nu niet lang
meer vol. Ik kan nu niet meer verder praten over OOP zonder code te plaatsen.
Dat gaan we de volgende les ook doen.

Veel succes met het vaker lezen van dit artikel en denk eraan. Als je iets nog
niet snapt is het niet erg het gaat erom dat je nu de basis van het nadenken
door hebt.
