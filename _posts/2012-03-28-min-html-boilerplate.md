---
layout: post
title: "Minimale HTML Boilerplate"
categories: article
tags: [bleeding edge, html]

---
Je kent het vast wel, het [HTML5 boilerplate](http://html5boilerplate.com/)
project opgezet door Paul Irish en een paar anderen. Het heeft een paar mooie
en handige technieken erin staan, maar echt een boilerplate is het niet.

Vandaag wil ik eens kijken hoe nou een echte minimale HTML boilerplate eruit
zou zien. Wat moet het minimaal hebben om in elk browser goed geparsed te
worden?

## Een 'oude' boilerplate

Van [HTML-site](http://html-site.nl/) heb ik een HTML4.01 boilerplate gehaald.
Laten we eens kijken wat we hier tegenwoordig allemaal van kunnen schrappen.

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
        "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <title>Hello World</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">
    <meta name="keywords" content="">
    <meta name="description" content="">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <script type="text/javascript" src="js/scripts.js"></script>
</head>
<body>
    <h1>Hello World</h1>
</body>
</html>
```

Omdat we deze hele tijd willen weten hoe een browser nou tegen deze code
aankijken gaan we de DOM bekijken. Als het browser een pagina binnen krijgt
leest hij van boven naar onder door het HTML bestand en maakt hij hiervan een
DOM. Dit is 1 groot schema waarin alle elementen staan en de verhouding tot
aan andere elementen (denk aan parents, children, siblings, enz.). Dit doen we
met [de live dom viewer](http://software.hixie.ch/utilities/js/live-dom-viewer/)
van Hixie. Ik werk hier met Chrome, maar de DOM is in bijna alle browser ong.
hetzelfde. Pas als je vreemde dingen gaat doen krijg je verschillen, deze
maand meer daarover, maar dat doen we nu niet.

## Doctype

Allereerst dat hele lange doctype. Als we dit in de parser stoppen krijgen we
dit terug `DOCTYPE: html`. Dat betekend dat het geen het browser onthoud van
dit hele lange doctype niet meer is dan de tag name (`DOCTYPE`, tagsnames
staan in de DOM altijd met hoofdletters) en welk soort doctype (`html`) het
is. De rest kunnen we dus allemaal weglaten! Als we dat doen en dus alleen
`<!DOCTYPE html>` erin stoppen zien we dat er niks veranderd in de
DOM, pas als we ook nog `html` weglaten gaat er iets mis.<br /> We kunnen
hieruit dus concluderen dat we alleen `<!DOCTYPE html>` nodig
hebben, i.p.v. die 2 lange regels aan urls.

## `HTML`, `HEAD` en `BODY` elementen

Als we nu alleen het doctype in de parser stoppen is je waarschijnlijk nog wat
opgevallen. Er worden in de DOM automatisch `HTML`, `HEAD` en `BODY` elementen
toegevoegd. Betekend dit dat we dit nu niet meer zelf hoeven te schrijven?

Laten we het eens testen. Als we nu eens een `H1` element onder het doctype
plaatsen, wordt deze dan automatisch toegevoegd in de DOM als kind van `BODY`?
Ja, dit werkt! En wat als we nou hiervoor een `TITLE` element toevoegen. Wordt
deze dan ook in de `BODY` geplaatst, of heeft het browser door dat het naar de
`HEAD` moet? Hé, het browser is slimmer dan we denken. Deze `TITLE` element
wordt namelijk toegevoegd aan de `HEAD`. Een laatste proef, een `SCRIPT`
element kan in beide elementen thuishoren. Wat kiest het browser? Daarom
plaatsen we onder de title een `SCRIPT` element. Hmm, het browser kiest er dus
voor om deze in de `HEAD` te plaatsen.

Al met al is dit een behoorlijk succes! We kunnen nu namelijk 6 regels
verwijderen!

## De charset

Dan komt de charset. In elk geval, dan hoort die te komen. IE verwacht de
charset binnen een x aantal tekens vanaf het doctype. Eerst de title plaatsen
en dan pas de charset kan dus niet. Daarom moet je altijd direct na `<head>`
(of direct na het doctype als je deze tags weghaalt zoals nu) de charset
definiëren. Kijk eens goed naar de charset:

```html
<meta http-equiv="content-type" content="text/html; charset=utf-8">
```

De content value is een soort attribuut in een attribuut ("...; charset=...").
Hier klopt iets niet zou je denken. Daarom plaatsen veel developers de quote
na `text/html;` en gebruiken ze charset als een eigen attribuut. Omdat browser
developers ook webdevelopers zijn begrijpen ze ook dat er een probleem heerst.
Vandaar dat ze al jaren toestaan dat je de charset als attribuut gebruikt. De
content value heeft dan geen waarde meer, want we weten wel dat het text/html
is, en de charset kan gewoon zonder name attribuut gebruikt worden. Van deze,
toch wel lange, regel code kunnen we dus simpel `<meta charset="utf-8">` maken.

## Andere meta tags

Op naar de volgende meta tags. Als eerst staat er de keywords meta tag. Deze
kunnen we meteen weggooien. Dan houden we nog de description over. Tja, ik
vind tegenwoordig, met rich snippets en microformat/-data, dat deze ook
overbodig is, maar het nut kan ik er nog wel van inzien. Daarom laten we die
staan.

## Link tag

De stylesheet is niet echt iets wat een minimale site nodig heeft, maar we
houden hem er toch in. Een echt minimale boilerplate in HTML5 bevat alleen het
doctype, de rest is namelijk overbodig. Maar we willen het toch een beetje op
een site laten lijken.

Er is wel een ding dat we kunnen verwijderen uit deze regel. Namelijk
`type="text/css"` de nieuwste parser zijn nu zo slim dat ze begrijpen dat
zodra je een stylesheet included het in het text/css formaat staat. Dit kun je
dus weglaten.

## De script tag

Een paar hoofdstukjes terug zag je dat de Chrome parser script tags
automatisch in de `HEAD` zet. Ik vind dit zelf nooit goed en ik ga altijd voor
script tags in de footer, op Modernizr na. Waarom?

Een browser leest een document van boven naar onder en van links naar rechts.
Hij leest de regel, deze wordt geparsed en de gebruiker kan deze regel zien.
Stel je plaatst de script tags in de head. Dan zal hij eerst helemaal moeten
wachten met het ophalen van de JS bestanden, dit kan wel eens lang duren, en
dan pas kan hij verder. Het kost dus, relatief, heel lang voordat de gebruiker
de pagina kan zien.

Als we de script tags vlak voor `</body>` plaatsen krijgt de gebruiker eerst
de pagina te zien en dan pas worden de files opgevraagd. De gebruiker kan dus
al sneller gebruik maken van de website en JS moet nooit zo belangrijk zijn
dat je dan niks met de site kan.

Kortom: We pakken deze script tag en plaatsen die aan het eind van onze
boilerplate, aangezien we de `<body>` tags verwijderd hebben. Tevens kunnen we
ook hier het type attribuut weglaten, omdat het browser deze zelf wel
doorheeft.

## De pagina content

Vervolgens komt er de pagina content. Deze kun je direct onder de link tag
zetten en dan ben je al klaar! Hier kun je niet heel veel van verwijderen.

Maar natuurlijk altijd wat. Zo kun je de quotes om attribuut waardes
verwijderen als er geen `< `, `>` of `&nbsp;` in wordt gebruikt. Je kunt het,
bij twijfel, altijd testen in de one-page-app 
[MothereffingUnquotedAttributes](http://mothereffingunquotedattributes.com).

Ook kun je sommige sluit tags weglaten, als `</li>`, `</tr>`, `</td>`,
`</body>`, `</html>`. Als je deze weglaat sluit het browser deze automatisch
op de plek waar jij hem verwacht.

## Het eindresultaat

Het eindresultaat van onze verkleining wordt dus:

```html
<!doctype html>
<meta charset=utf-8>
<title>Hello World</title>
<link rel=stylesheet href=css/style.css>

<h1>Hello World</h1>

<script src=js/scripts.js></script>
```

En hoe dit eruit ziet in de DOM van jouw browser kun je
[hier bekijken](http://software.hixie.ch/utilities/js/live-dom-viewer/?%3C!DOCTYPE%20HTML%3E%0A%3Cmeta%20charset%3Dutf-8%3E%0A%3Ctitle%3EHello%20World%3C%2Ftitle%3E%0A%3Clink%20rel%3Dstylesheet%20href%3Dcss%2Fstyle.css%3E%0A%3Ch1%3EHello%20world%3C%2Fh1%3E%0A%3Cscript%20src%3Djs%2Fscripts.js%3E%3C%2Fscript%3E).</head>

## Wacht eens, kan ik dit nu altijd gebruiken voor mijn nieuwe website?

Een simpel antwoord: Ja. Maar er zit wel een maar aan, want zoals een mooie engelse uitspraak zegt 

 > Just Because You Can, Does Not Mean You Should

Je kan het gebruiken, maar het ziet er bij sommige dingen niet heel mooi uit
en ik (en de uitvinder hiervan) staan niet garant dat oude IE versies dit ook
zo handelen en dat er niet ergens een probleem kan zijn.

Een mooi voorbeeld waarbij dit gebruikt is, en waarbij je dit ook kan
gebruiken is [de 404 error pagina van Google](http://www.google.com/404.html).
Dit is nou niet de belangrijkste pagina van je website, dus je hoeft er ook
niet heel veel moeite voor te doen, maar toch wil je wel dat het in elk
browser goed is. De ideale omstandigheid waarbij je het kan gebruiken!
