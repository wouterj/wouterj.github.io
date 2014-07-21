---
layout: post
title: "Random in PHP"
categories:
- article
tags:
- php
- reading the source

---
Een computer is logisch, hoe kan zo'n logisch apparaat nou random getallen
maken? Vandaag nemen we een kijk in de PHP source om te kijken hoe het in PHP
gedaan wordt.

## De PHP source

De PHP source is geschreven in C en je kunt een hele makkelijk navigeerbare
weergave van de source op http://lxr.php.net/ vinden. Hier kun je zoeken naar
functies en makkelijk naar de source van functies navigeren.

Er is 1 basis conceptje die ik moet vertellen, de rest zal je gaanderweg wel
gaan begrijpen. Dit concept is defines in C. De C taal wordt eerst gecompiled
en vervolgens wordt die compiled code omgezet in uitvoerbare code. Tijdens het
compilen kun je wat dingen doe die PHP niet kan. Bijv. het gebruik van
defines. Defines zijn woorden die worden omgezet in de waarde die je er aan
meegeeft. Laten we beginnen met een simpele constante:

    #define M_PI 3.14159265358979323846

Wanneer we nu in onze code `M_PI` gebruiken wordt dit vervangen door dit
getal:

    long omtrek = M_PI * 4;

Hier staat na het compilen eigenlijk:

    long omtrek = 3.14159265358979323846 * 4;

Naast het invullen van getallen of strings kun je ook macro's definiëren.
Bijvoorbeeld deze macro:

    #define INCREMENT(x) x++

Nu zal `INCREMENT(5)` worden omgezet in `6`.

## Random getallen

De andere basis kennis is het doorhebben hoe je random getallen maakt. Random
getallen zijn eigenlijk een sequence, je begint met een getal en stopt die in
een formule. Uit deze formule komt een getal, dit getal is het random getal en
die wordt opgeslagen in een variabele (dezelfde variabele als het begin
getal). Dit getal wordt dan weer gebruikt om met dezelfde functie weer een
getal te genereren, die ook weer wordt opgeslagen en als je de functie nog een
keer aanroept komt er weer een ander getal uit.

Je zal wel begrijpen dat je dan een hele rij van allemaal nieuwe random
getallen krijgt. Wanneer je met hetzelfde getal begint zal er altijd dezelfde
rij uitkomen. Dit eerste getal noemen we een *seed*. De seed wordt random
gecreeërd, bijvoorbeeld door de tijd en datum te gebruiken. Op deze manier heb
je dus nooit dezelfde random reeks getallen.

## De `rand` functie

Nu je de basiskennis hebt gaan we kijken in de PHP source code. De meeste
functies worden aangemaakt door `PHP_FUNCTION(rand)`. Als we opzoek willen
naar de `rand` functie zoeken we op `"PHP_FUNCTION rand"` (vergeet de quotes
niet). In de [resultaten][1] krijgen we dan 2 bestanden: `php_math.h` en
`rand.c`. De `*.h` bestanden zijn header bestanden, die vertellen wat er
allemaal in de `*.c` bestanden staat. De `*.c` bestanden bevatten de echte
code. We klikken dus op die link en navigeren naar [regel 290][2]:

    PHP_FUNCTION(rand)
    {
        long min;
        long max;
        long number;
        int  argc = ZEND_NUM_ARGS();
    
        if (argc != 0 && zend_parse_parameters(argc TSRMLS_CC, "ll", &min, &max) == FAILURE)
            return;
    
        number = php_rand(TSRMLS_C);
        if (argc == 2) {
            RAND_RANGE(number, min, max, PHP_RAND_MAX);
        }
    
        RETURN_LONG(number);
    }

En dat is de functie!

### Parsen van argumenten

Als eerst zien we dat er 4 variabelen gedeclareerd worden:

    long min;
    long max;
    long number;
    int  argc = ZEND_NUM_ARGS();

De eerste 3 variabelen zijn of argumenten of variabele die we verder in de
functie gaan gebruiken. De 4e variabele, `argc`, is het aantal argumenten.
Zend is de engine achter PHP en we kunnen wel raden wat `ZEND_NUM_ARGS()`
doet, we gaan dus niet naar die source code kijken.

Dan krijgen we een check voor de argumenten:

    if (argc != 0 && zend_parse_parameters(argc TSRMLS_CC, "ll", &min, &max) == FAILURE)
        return;

De check `argc != 0` betekend dat we pas argumenten gaan checken als er
argumenten zijn, dit komt omdat de `rand` functie ook zonder argumenten
aangeroepen kan worden. Zodra er wel argumenten zijn moeten er meteen 2 zijn.
Met `zend_parse_parameters` parsen we de argumenten. We zien `"ll"`, dit
betekend dat beide argumenten `long` (een soort float) zijn. Daarachter zien
we `&min` en `&max`, dit betekend dat de waarde van de argumenten worden mee
gegeven aan de variabelen `min` en `max` (die we hiervoor al gedeclareerd
hadden).

### Het maken van de seed

Dan gaan we de seed maken:

    number = php_rand(TSRMLS_C);

In deze regel roepen we de functie `php_rand` (een interne functie die niet in
PHP bestaat) aan. Die geven we ook weer een waarde mee, die is voor nu even
niet interessant.

Wat wel interessant is hoe PHP die random seed maakt. Dus klikken we op de
functie `php_rand` om die source te bekijken:

    PHPAPI long php_rand(TSRMLS_D)
    {
        long ret;
    
        if (!BG(rand_is_seeded)) {
            php_srand(GENERATE_SEED() TSRMLS_CC);
        }
    
    #ifdef ZTS
        ret = php_rand_r(&BG(rand_seed));
    #else
    # if defined(HAVE_RANDOM)
        ret = random();
    # elif defined(HAVE_LRAND48)
        ret = lrand48();
    # else
        ret = rand();
    # endif
    #endif
    
        return ret;
    }

Wat we hier heel in het kort zien is dat de functie, afhankelijk van bepaalde
instellingen, de C functies `rand`, `lrand48` of `random` gebruikt.

### Het maken van het random getal

    if (argc == 2) {
        RAND_RANGE(number, min, max, PHP_RAND_MAX);
    }

Zodra er 2 argumenten zijn gegeven wordt de `RAND_RANGE` define functie
gebruikt om het random nummer tussen 2 waardes te maken. Zodra je dus geen
argumenten geeft, krijg je gewoon de seed terug.

Nu zijn we natuurlijk benieuwd wat voor algoritme PHP gebruikt voor het maken
van het random getal, dus klikken we erop en gaan we naar een
[`php_rand.h`][3] bestand:

    #define RAND_RANGE(__n, __min, __max, __tmax) \
        (__n) = (__min) + (long) ((double) ( (double) (__max) - (__min) + 1.0) * ((__n) / ((__tmax) + 1.0)))

En dat is de magische formule achter PHP's `rand` functie! Er wordt mooi
gespeelt met wat afronden (de `(long)`'s en `(double)`'s in de code), de min
en max (`__min` en `__max`) worden een paar keer gebruikt en ook onze seed
(`__n`) wordt gebruikt. Vervolgens zien we ook `(__n) = ...`, waardoor onze
seed dus weer vernieuwd wordt door het gegenereerde random getal.

### Het returnen van het getal

Het enige dat ons nog rest is het returnen van de gemaakt `long`:

    RETURN_LONG(number);

Achter deze simpele regel zit weer heel wat zend gedoe, maar daar bemoeien we
ons vandaag niet mee.

## Dus...

Je hoofd duizeld nu van de C code, maar je hebt wel begrepen hoe je kan kijken
hoe PHP functies werken. Ook heb je geleerd dat een goede random functie 4
factoren heeft: Niet voorspelbaar; geen herhalend patroon; alle getallen
moeten ongeveer gelijk voorkomen; dezelfde seed zorgt voor dezelfde rij random
getallen.

 [1]: http://lxr.php.net/search?q=%22PHP_FUNCTION+rand%22&defs=&refs=&path=&hist=&project=PHP_5_4
 [2]: http://lxr.php.net/xref/PHP_5_4/ext/standard/rand.c#290
 [3]: http://lxr.php.net/xref/PHP_5_4/ext/standard/php_rand.h#43
