---
layout: post
title: "5 oplossingen voor de vendors"
thumbnail: prefix-free-thumb.png
categories: article
tags: [tools, css]

---
CSS3 vind ik geweldig, maar die prefixen zijn natuurlijk totaal niet handig.
Er zijn veel tooltjes bedacht om deze te voorkomen, een paar wil ik vandaag met
jullie delen.

De tools die ik hier bespreek zijn:

 1. [Prefixr](#prefixr)
 2. [SASS + Compass](#compass)
 3. [-Prefix-free](#prefix-free)
 4. [CSS3 Please](#css3-please)
 5. [Waarom niet alleen `-webkit-`?](#webkit-in-moz)

## Prefixr {#prefixr}

![de prefixr tool](/img/prefix-free-prefixr.png)

De eerste die ik wil bespreken is [Prefixr](http://prefixr.com/). Prefixr is
een geweldig simpele tool met een uitgebreid API systeem waarbij je alle CSS3
properties automatisch kunt prefixen. Stel we hebben het volgende:

```css
#box {
    width:100px;
    height:100px;
    background:red;
    background:-webkit-linear-gradient(
        top,
        #000,
        #555
    );
    -moz-border-radius:5em;
    box-shadow:2px 3px 4px #2d2d2d;
}
```

Nu hebben we maar 1 prefix per CSS3 propertie en bij de laatste zelfs helemaal
geen één. Als we deze code in Prefixr stoppen en op Prefixize klikken krijgen
we daaruit deze code:

```css
#box {
    width: 100px;
    height: 100px;
    background: red;

    background: -webkit-linear-gradient( top, #000, #555 );
    background: -moz-linear-gradient( top, #000, #555 );
    background: -o-linear-gradient( top, #000, #555 );
    background: -ms-linear-gradient( top, #000, #555 );
    background: linear-gradient( top, #000, #555 );

    -webkit-border-radius: 5em;
    -moz-border-radius: 5em;
    border-radius: 5em;

    -webkit-box-shadow: 2px 3px 4px #2d2d2d;
    -moz-box-shadow: 2px 3px 4px #2d2d2d;
    box-shadow: 2px 3px 4px #2d2d2d;
}
```

Deze bevat alle mogelijke prefixen voor de properties, helaas wordt de oude
gradient syntax van webkit er niet in gestopt.

### API
Prefixr heeft een api systeem, waardoor je deze code als extensie of plugin op
je editor kan gebruiken. Een overzicht van al hun API's kun je op hun
[api pagina](http://www.prefixr.com/api/usage/) vinden.

Maar prefixr heeft nog veel andere features die het zo'n leuke tool maakt:

### Compressing
Als je een site online zet wil je die snel laten werken, een manier om te
krijgen is door alle onnodige whitespace weg te halen. Als je Compress My Code
aanzet wordt dit automatisch gedaan. De bovenstaande code wordt dan:

```css
#box{width:100px;height:100px;background:red;background:-webkit-linear-gradient( top, #000, #555 );background:-moz-linear-gradient( top, #000, #555 );background:-o-linear-gradient( top, #000, #555 );background:-ms-linear-gradient( top, #000, #555 );background:linear-gradient( top, #000, #555 );-webkit-border-radius:5em;-moz-border-radius:5em;border-radius:5em;-webkit-box-shadow:2px 3px 4px #2d2d2d;-moz-box-shadow:2px 3px 4px #2d2d2d;box-shadow:2px 3px 4px #2d2d2d;}
```

### Exclude
Als je juist van een code prefixes weg wilt halen kun je met exclude beslissen
welke prefixes er niet moeten worden toegepast.

### Variabelen
Prefixr begint zelfs steeds meer te lijken op een CSS precompessor (als SASS
of Stylus) en kan zelfs werken met variabelen: 

```css
@variables {
    main_color:red;  
}
#box {
    /* ... */
    background:var(main_color);  
}
#container {
    /* ... */
    border-color:var(main_color);
}
```

Wordt: 

```css
#box {
    /* ... */
    background: red;
}
#container {
    /* ... */
    border-color: red;
}
```

## SASS + Compass (en andere CSS precompressors) {#compass}

![SASS compass framework](/img/prefix-free-compass.png)

Een andere optie die ik zeer kan aanraden is het gebruik van een CSS
precompressor. Een precompressor voegt handige functies, syntaxes en andere
dingen toe aan CSS waardoor het CSS schrijven makkelijker en leuker wordt.
Precompressors zijn bijv. SASS, Stylus of LESS. De CSS die je schrijft gaat
door de compressor en die maakt er een normale CSS file van voor het
browser.

SASS en Stylus zijn de precompressors die ik vaak gebruik.
[SASS](http://sass-lang.com/)</a> is erg mooi en het heeft een geweldig
framework: [Compass](http://compass-style.org/). Deze bevat ook functies
waarmee je niet telkens alle prefixes hoeft te schrijven.

### Compass CSS3 module

Compass bevat heel wat mooie modules, maar de CSS3 module is degene waar we
vandaag naar kijken. Laten we eens zien hoe we een `box-shadow` in Compass
maken. Ik neem aan dat we SASS kennen en kunt omgaan met Compass, zo niet
dan raad ik je aan dit eerst te gaan leren.

Nu nemen we een kijkje in [de documentatie over
box-shadow](http://compass-style.org/reference/compass/css3/box_shadow/), we
zien hier dat we het bestand `compass/css3/box-shadow` moeten includen en dan
kunnen we de `box-shadow` mixin gebruiken. Deze werkt als volgt:

```css
@import "compass/css3/box-shadow";
#box {
    width:100px;
    height:100px;
    @include box-shadow(2px 3px 5px #2d2d2d);
}
```

Wordt:

```css
#box {
    width:100px;
    height:100px;
    -webkit-box-shadow:2px 3px 5px #2d2d2d;
    -moz-box-shadow:2px 3px 5px #2d2d2d;
    box-shadow:2px 3px 5px #2d2d2d;
}
```

## Prefix-free {#prefix-free}

![Prefix-free client side tool](/img/prefix-free-prefix-free.png)

Prefix-free is een andere oplossing die client-side werkt. In tegenstelling
tot de hierboven genoemde opties kan dit dus wel voor een tragere snelheid op
je website zorgen. Maar desondanks is het wel een tool die erg mooi gemaakt is
en goed werkt, daarom bespreek ik hem hier ook.

### Inladen in het script

Prefix-free is een JS API die, als de pagina geladen wordt, alle stylesheets
in de `link` elementen en alle `style` elementen aanpast zodat hij alle
prefixen erin zet. Je hoeft in je stylesheet dus alleen maar de officiële
versie (dus zonder prefixen) te gebruiken.

Allereerst moeten we de JS file downloaden. Dit doen we door naar de
[Homepagina van Prefix-free](http://leaverou.github.com/prefixfree/)
te gaan en dan op de download button te klikken. Dit bestand kun je vervolgens
opslaan in je webhost, of je kunt gewoon direct naar dit scriptfile linken. De
url voeg je dan toe doormiddel van een `script` element:

```html
<script src="https://raw.github.com/LeaVerou/prefixfree/master/prefixfree.min.js"></script>
```

Nu ben je al klaar en werkt het!

## CSS3 please {#css3-please}

![de CSS3 please website](/img/prefix-free-css3-please.png)

[CSS3 please](http://css3please.com/) vind ik zelf de minst mooie optie die ik
hier plaats. Het is een leuke one-page app voor als je kleine dingentjes snel
wil prefixen, maar in grote projecten is het veel te langzaam om elke CSS3
propertie eerst helemaal te maken in CSS3 please. **Maar CSS3 please
heeft ook een voordeel, en dat is dat het het niet alleen prefixen ervoor
plaatst, maar ook laat zien hoe je browser problemen kunt oplossen. Ook heeft
het her en der IE filters, zodat dingen ook werken in IE5.5+**

### Hoe werkt CSS3 please?
CSS3 please is een webpagina die eigenlijk helemaal vol zit met allemaal CSS3
stijlen. Je kunt van 1 propertie de waardes veranderen en dan veranderd het
automatisch ook bij de andere prefixen. Tevens is de box die links bovenin
staat een live voorbeeld van de code die je maakt.

Laten we eens beginnen met het maken van `border-radius`. We willen een radius
van `15px`. De bovenste code op de pagina is die voor een `border-radius`. De
standaard CSS3 please waarde is `12px` om dit te wijzigen klik je op deze
onderstreepte waarde en vul je jou waarde in. Als we nu eens iets heel groots
in vullen zien we dat de box ernaast meteen ook van radius veranderd. Als je
het goed vind kun je op `[to clipboard]` klikken en de code in je stylesheet
plakken. Maar we zien nog wat anders, CSS3 please voegt deze regel ook nog toe
aan de class:

```css
/* useful if you don't want a bg color from leaking outside the border: */
-moz-background-clip: padding; -webkit-background-clip: padding-box; background-clip: padding-box;
```

Hiermee zorgen we dat de bug dat de background geen radius krijgt opgelost is.

Maar wat als we nou bijv. geen border-radius op de box willen zien? Dan kunnen
we heel makkelijk op `[toggle rule off]` klikken dan wordt de code omvangen door
een comment en is die niet meer zichtbaar.

## Waarom niet alleen `-webkit-`? {#webkit-in-moz}

![webkit vendors ten opzichte van andere](/img/prefix-free-moz-webkit.png)

Waarom zullen we niet alleen de webkit prefix gebruiken? FireFox heeft ontdekt
bij [een onderzoek](https://bug708406.bugzilla.mozilla.org/attachment.cgi?id=579826)
dat de moz prefix vaak wordt vergeten en er alleen een webkit prefix bestaat.
Daarom hebben ze bedacht dat ze ook maar gaan werken met de webkit prefix.
Sinds begin 2012 accepteert FireFox dus ook de webkit prefixes.  De webkit
prefix bevat nu dus al 3 browsers: Chrome, Safari en FireFox. Omdat het dus al
3/5 van de grote browsers is denk ik dat Opera al heel snel overstapt naar de
webkit prefix en dan hou je alleen IE nog over. En tja, IE bevat sinds IE5.5
al bijna alle CSS3 properties in de vorm van hun geweldige filter systeem dus
dat is ook zo opgelost. Dit is zomaar een wild idee en ik zou het nog niet
doen, maar het geeft je misschien wat stof om over na te denken.

## En jij?
Er zullen vast nog wel meer dingen op de markt zijn. Dus daarbij mijn vraag,
wat gebruik jij en waarom?
