---
layout: post
title: "OO: de niet bestane objecten"
description: ""
category: php
tags: [oo]
type: article
---
De vorige 2 lessen hebben we gekeken naar de fysieke objecten, objecten
waarbij we ons wat voor kunnen stellen. Vandaag gaan we ons denkvermogen op de
proef stellen om ook bij niet fysieke objecten een beeld te krijgen.
<!--more-->

### Een project heeft taken

Het is allemaal leuk en aardig dat we nu heel wat fysieke objectjes in onze
applicatie hebben, maar die mogen natuurlijk niet de hele tijd een beetje
lanterfanten. Er moeten nog dingen gebeuren in ons project!

Denk alleen al aan onze user management systeem. We moeten mensen inloggen,
uitloggen, informatie tonen van de gebruiker, gebruikers toevoegen, bewerken,
gebruikers ophalen uit de database, kijken of iemand de juiste rechten heeft,
ect.

Nouja, dan kunnen we die toch gewoon toevoegen aan onze User klasse? We geven
hem gewoon `findUserById(id:int)`, `isGranted(action:string)`, `change(...)`,
ect. methods mee? Dat kan, maar in OO hebben we 1 heeele belangrijke regel:
**Elke klasse en method mag maar 1 verantwoordelijkheid hebben, zodra het er
meer zijn moet je ze opsplitsen.**
De verantwoordelijkheden zijn de taken die ik opnoemde. Deze krijgen dus
allemaal een eigen method en de meeste ook nog een eigen klasse. Laten we elke
klasse eens gaan uitdenken.

#### 1 verantwoordelijkheid per klasse? Waar is dat voor nodig?

Een OO applicatie wordt gekenmerkt door het feit dat hij extreem flexibel is.
Als je iets 1 keer gemaakt hebt hoef je het nooit meer te maken, je kunt hem
dan telkens opnieuw gebruikt. Omdat dat doel te 

### Database

Oke, deze lag voor de hand. We gaan een Database object maken (of maken
gebruik van een standaard PHP database klasse zoals [`PDO`](http://php.net/pdo) of
[`MySQLi`](http://php.net/mysqli)). Omdat we het in deze tutorial simpel gaan
houden gebruiken we de 
