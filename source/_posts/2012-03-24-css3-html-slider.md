---
layout: post
title: "Pure CSS3 en HTML slider"
thumbnail: css3-slider-thumb.jpg
categories:
- experiment
tags:
- bleeding edge
- css

---
Op 10 nov. 2011 zei
[Jeffrey Way op Google+](https://plus.google.com/117682024645575752797/posts/dRQApCxohW1):
*"So here's what I came up with for my simple CSS3-only slider. Not
practical yet - but as a proof of concept... http://jsfiddle.net/8TYm3/2/"*

Dit heeft mij aan het denken gezet om ook een CSS3 slider te maken, die een
mooie HTML heeft en makkelijk te bedienen is. In dit bericht wil ik graag
laten zien wat het resultaat is geworden en hoe je tot zoiets komt.

## CSS3 Animations

Allereerst kun je zoiets natuurlijk niet met CSS2 af. Je zult CSS3 technieken
moeten gebruiken, animations om exact te zijn. Dit betekend dat het momenteel
alleen zal werken in Chrome of FireFox.

Helaas, maar dit is natuurlijk ook alleen als test en oefening, het is
momenteel nog niet serieus te gebruiken.

## Het concept

Wat vaak het beste werkt als je met iets nieuws begint is je computer
afsluiten of je lap top dichtklappen en een kladblok, potlood en gum te
pakken. Vervolgens ga je al je ideeën opschreven en kijk je of ze wel mogelijk
zijn.

Deze techniek heb ik deze keer ook gebruikt, alleen vandaag heb ik nog wat
extra's erbij gepakt: Wat lijm en een schaar. Vervolgens heb ik hier wat
zitten knippen en plakken en ben zo tot het basis concept gekomen.

### Probleem 1: Hoe beweeg je de afbeeldingen?

Dit probleem lijkt, als je CSS3 animations doorhebt, in het begin makkelijk.
Maar dat is schijn. Want je kan moeilijk per afbeelding een animatie frame
maken. Laten we eerst eens kijken hoe we dit willen gebruiken als HTML code.
Wat zou de beste manier zijn om iets semantisch correct en makkelijk
handelbaar te krijgen?

Het eerste idee:

    <div id="slider">
        <img src="img/slide1.png" alt="some text">
        <img src="img/slide2.png" alt="some other text">
        <!-- ... -->
    </div>

Ziet er niet verkeerd uit, zo werken de meeste jQuery sliders ook. Alleen hoe
gaan we deze nou bewegen? We kunnen moeilijk de hele slider `div` gaan bewegen
en een ander element die alle slides omringt hebben we niet...  Laat ik hier
stoppen en bedenk eerst zelf een oplossen voordat je verder scrolled.

#### Oplossing

Als we nou eens de slides zien als een lijst van afbeeldingen (slides)? Dan
kunnen we de `ul` als overkoepelende element gebruiken en de li's daarmee
animeren. Ook qua semantisch opzicht is het te verdedigen en zeker niet fout.
De code wordt dus zoiets:

    <div id="slider">
    <ul>
        <li><img src="img/slide1.png" alt="some text"></li>
        <li><img src="img/slide2.png" alt="some other text"></li>
    </ul>
    </div>

### Probleem 2: Hoe verbergen we de andere afbeeldingen?

Je wilt per keer maar 1 afbeelding laten zien, dus de andere moet je zien te
verbergen. Nu heb ik ooit een jQuery scriptje gemaakt waarbij je een soort
spotlight effect creëerde. Als je met de muis over de afbeelding bewoog werd
alles donker behalve een cirkel met een diameter van ong. 10px rond je muis.
Daar moest ik hierbij als eerst aan denken. Ik gebruikte hiervoor destijds een
gigantisch grote (qua formaat) donkere afbeelding met in het midden een
doorzicht cirkeltje. Als we dit nu ook toepassen in dit voorbeeld? Helaas, is
dit niet praktisch (en dat is nou juist niet wat we willen). Want:

 1. Je moet het formaat van het doorzichtige gat telkens aanpassen als je het
    slider-formaat veranderd
 2. Je moet het niet doorzichtige gedeelte telkens aanpassen aan de kleur die
    je als achtergrond op de pagina wilt hebben.


Wat kan dan wel de oplossing zijn? Denk eerst zelf wat na en ga wat knippen en
plakken, zo kun je hier nog wat van leren, of bekijk meteen het filmpje waarin
ik (helaas zonder geluid) laat zien hoe je het kan oplossen:


Even kort beschreven de oplossing is dat we `#slider` `overflow: hidden;`
meegeven en de breedte en hoogte van de slides.  Hierdoor zie je telkens maar
1 afbeelding.

## Uitvoering

Tot zover het verkennen van de mogelijkheden en het uitwerken van het idee. Nu
moeten we de CSS gaan schrijven. Laten we weer bij het begin beginnen:

### Afbeeldingen in `ul` naast elkaar krijgen

Eerst moeten we de slides naast elkaar krijgen. Dit doen we heel simpel door
`float: left;` mee te geven aan `li`. NOTE: Gebruik **geen** `display: inline-block;`
hiervoor, dit is onjuist. Waarom dat zo is schrijf ik misschien nog wel een
bericht over.

### `#slider` opmaken

Vervolgens gaan we de `#slider` opmaken. De oplossing voor het 2e
probleem was dat we deze `overflow: hidden;` en de hoogte en
breedte van de afbeelding meegeven. Nou, laten we dat dan maar gaan doen:

    [css]
    #slider{
        width:610px;
        height:244px;
        overflow:hidden;
    }

### De animatie

En dan komt nu het moeilijkste onderdeel: De CSS3 animatie. Omdat dit voor
veel mensen die dit lezen nieuw zal zijn zal ik dit stap voor stap doen, zodat
je het kunt begrijpen.

Elke animatie heeft een animatie frame (keyframe genoemd). Dit is niet een
HTML frame, maar in CSS. Met dit keyframe geef je aan wat de animatie precies
is. Dus de keyframe bevat een gedetailleerde overzicht van de animatie. Als we
bijv. een animatie willen maken die de achtergrondkleur van rood naar blauw
veranderd doen we:

    [css]
    @keyframes changeBgColor {
        from { 
            background:red;
        }
        to {
            background:green;
        }
    }

Merk wel op dat het geen je hier ziet alleen de animatie zelf is. We moeten
deze animatie nog toevoegen aan een element. Dit doen we met `animation` en
omdat het nog in de test fase is moeten hier nog de prefixen (bijv. `-webkit-`
en `-moz-`) toegevoegd worden.  Als waardes verwacht `animation` als eerste de
naam van het keyframe, deze is *changeBgColor* in het voorbeeld hierboven. Als
2e waarde wordt de duration verwacht, of te wel de snelheid van de animatie.
Dit kan van alles zijn. Vervolgens kun je er andere opties bijzetten. Welke
opties en meer informatie kun je vinden op de 
[CSS Animations Module level 3](http://www.w3.org/TR/2009/WD-css3-animations-20090320/)
specificaties.

### Terug naar onze code

In ons geval willen we een animatie maken die de ul steeds de breedte van 1
slide opschuift en als hij bij het eind is weer terug gaat. Voordat we een
keyframe kunnen maken moeten we weten hoeveel slides we hebben  en hoe groot
deze slides zijn en als extra hoelang de slide duurt (het glijden van de
afbeeldingen). In mijn voorbeeld heb ik 4 slides van ong. 620px breed.

I.p.v. een keyframe te gebruiken met `from` en `to` kun je ze ook met
procenten gebruiken en zelfs combineren. In dit voorbeeld gebruiken we het
laatste. We gaan de ul doormiddel van `margin-left` bewegen, zodat de
afbeeldingen sliden. Om ervoor te zorgen dat alle slides even lang duren doen
we `100% / aantal slides - 0.5` om tot het antwoord te komen. In dit
geval wordt dat `100% / (4 -0.5)` en dan krijg je het geweldige antwoord van
28.57% met nog heel wat decimalen erachter. Vervolgens kunnen we dit gebruiken
voor de keyframes. We beginnen bij 0%, wat gelijk is aan from, en hierbij is
de `margin-left` ook 0. Vervolgens gaan we naar de eerste stap, 28%, waarbij
de `margin-left` de negatieve waarde van de breedte van onze slide heeft, in
dit geval dus `-620px`. De tweede stap is op 56% met de waarde van 2 slides
dus `-1240px`. En zo ga je door met 74% en 100% (to), waarbij deze beide een
waarde van `-1860px` hebben. De totale code wordt dus zoiets:

    [css]
    @keyframes slider
    {
        from     { margin-left:0;          }
        28%      { margin-left:-620px;     }
        56%      { margin-left:-1240px;    }
        74%, to  { margin-left:-1860px;    }
    }

Nu moeten we alleen de ul nog deze keyframe meegeven, een tijd en wat extra
opties, en we hebben onze slider af. De aanroep in `#slider ul` wordt:

    [css]
    animation: slider 10s linear infinite alternate;

Even een uitleg:

 - **slider**, dit is de keyframe die we gebruiken
 - **10s**, een slideshow van de eerste tot de laatste slide duurt 10 seconden
   (dit kun je aanpassen)
 - **linear**, er is niks van vertraging of effect in de slide
 - **infinite**, herhaal de animatie oneindig
 - **alternate**, voer de keyframe de eerste keer van from naar to uit en de
   2e keer van to naar from, zodat het mooi blijft doorlopen.

### Helaas, sliders zijn niet makkelijk

Het leek zo simpel en ik wou zo graag nu al het eind resultaat laten zien,
maar dit werkt nog niet. Dit komt door weer 2 problemen:

#### Prefixen

Zowel de animatie aanroepen en de prefixen in de `@keyframes` moeten worden
toegevoegd. Aangezien dit alleen in Chrome en FireFox werkt hoeven we maar 2
prefixen toe te voegen: `@-webkit-keyframes` en `@-moz-keyframes` en
`-webkit-animation` en `-moz-animation`. Hou de officiële properties, dus
zonder prefixen, er altijd ook gewoon in.

#### Ruimte voor de slide

Het zal nu in 1 keer van links tot rechts doorlopen. We hebben namelijk niet
aangegeven wat er tussen 0% en 28% zit en dus zal hij telkens tussen deze 2
waardes een stapje opschuiven. We moeten dus aangeven dat hij voor 28% nog
steeds op `0px` zet. Dus doen we dit:

    [css]
    @keyframes slider
    {
        from,27% { margin-left:0;          }
        28%, 55% { margin-left:-620px;     }
        56%, 73% { margin-left:-1240px;    }
        74%, to  { margin-left:-1860px;    }
    }

Hierbij kan CSS nog niks animaten en begin het pas met sliden bij 27% en dan
bij 28% stopt het weer tot 56% en zo gaat het door.

Weer een probleem, de slides duren nu veel te kort en we moeten dus de CSS
slide tijd verlengen. Ik stel voor dat we een slide tijd hebben van 6%. Dit
betekend dat er 3% vanaf gaat en 3% bij komt. We krijgen dus uiteindelijk
zoiets:

    [css]
    @keyframes slider
    {
        from, 24% { margin-left:0;         }
        31%, 53%  { margin-left:-620px;    }
        59%, 71%  { margin-left:-1240px;   }
        77%, to   { margin-left:-1860px;   }
    }

### Feestje?

Ja, eindelijk is het zo ver! Onze slider werkt en is
[hier](http://wouterj.nl/demos/css3-slider/) te aanschouwen met de juiste
prefixen en met nog een slide optie met alleen CSS3 en HTML.

Ik hoop dat je van deze tutorial hebt geleerd hoe je iets van een idee tot een
CSS en HTML code kunt omtoveren en dat je warm bent gemaakt dingen uit te
proberen met CSS3 en dan vooral het geweldige animations.

Mocht je net zo'n animatie hebben gemaakt als
[Anthony Calzadilla](http://www.optimum7.com/css3-man/)</a> of vind je dat je
iets geweldigs hebt gemaakt? Deel het met ons in de reacties!
