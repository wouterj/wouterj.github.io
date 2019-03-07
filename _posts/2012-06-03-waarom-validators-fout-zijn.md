---
layout: post
title: "Waarom ik geen voorstander van validators ben"
thumbnail: validators-bad-thumb.png
categories: opinion
tags: [validators, w3c, html]

---
Een validator wordt door veel webscripters gezien als een heilige tool. Heb je
geen fouten dan draait je website overal goed en heb je wel fouten dan is je
website code eigenlijk al meteen slecht.

Nu ben ik 3 jaar geleden, toen ik begon, ook zo opgevoed. Elke website die ik
in elkaar zette haalde ik door de validator en ik deed er alles aan om die
*kuch* mooie buttons op mijn website te mogen zetten. Helaas is de validator
alles behalve heilig en kun je die na een half jaar beter op een zijspoortje
zetten, op weg naar Tokio.

## Semantiek is het belangrijkst

HTML gaat om het semantisch weergeven van een woordje of een stuk tekst.
Helaas zal de validator alleen maar kijken of onze mark-up voldoet aan de
regels, gesteld door een één of andere DTD file. Of de pagina semantisch
correct is boeit hem niks. Deze pagina bijv. zou worden goed gerekend:

```html
<!doctype html>
<html>
<head>
    <title>Hello World</title>
    <meta charset=utf-8>
</head>
<body>
    <div>Sitetitel</div>
    <div>Artikeltitel</div>
    <div>Lorem ipsum geblaat</div>
    <div>Nog een alinea</div>
    <div>Footer info</div>
</body>
</html>
```

Even voor de duidelijkheid, dit is natuurlijk totaal verkeerd. Titels horen
in heading elementen (`<h1> t/m <h6>`), een alinea hoor in een paragraph
element (`<p>`) en een footer in een footer element (`<footer>`).

Maar dit alles merkt de validator niet op. De enige waarschuwing die ik
hierbij krijg is dat hij in de HTML5 validator gaat en die nog volledig in
beta is...

## Trias Politica: De wetgevende macht !== Rechterlijke macht

W3C is de partij die de regels voorschrijft, in hun hele lange, maar o zo
leervolle, specificaties. De browsers volgen deze regels dan op, plus wat
eigen inbreng.

W3C moet vervolgens niet gaan controleren doormiddel van validators of de code
correct is volgens het geen wat browsers zouden moeten doen. Het zou veel
beter zijn als een browser zelf een validator inbouwt die je kan aanroepen. De
browser weet immers hoe hij met het HTML document omgaat en weet daarom ook
wat er fout is.

## Niet up to date

De validators zijn totaal niet up to date. Tegenwoordig leven we bijna in het
HTML5 tijdperk. De HTML5 specificaties en de HTML5 DTD zijn al lang klaar
(sinds mei 2011). Het is nu slechts alleen wachten tot alle browsers dit
hebben geïmplementeerd. De W3C validator is DTD based dat betekend dat ze
gewoon de HTML5 DTD file kunnen laden en ze hebben een goede (voorzover een
validator goed is) HTML5 validator. Waarom wachten ze er dan nog zo lang mee
en hebben ze alleen maar 'beta' HTML5 validators?

Deze traagheid van W3C zorgt voor veel zorgen, vooral bij beginners. Neem nou
<a href="http://www.html-site.nl/forum/1_28231_0.html">deze persoon</a>, 415
fouten(!). Je schrikt je rot als je dat ziet. Maar als je eens bij die fouten
kijkt hou je maar 5 echte fouten over. Die andere 410 fouten zijn omdat de
validator niet tegen prefixes kan. Waarom bouwen ze niet in dat deze worden
genegeerd, zoals het in elk browser gedaan wordt? De browsers pakken alleen de
prefixen die zij gebruiken en die andere negeren ze gewoon.

Ook de officiële syntax van bijv. `linear-gradient` kan een validator niet.
Waarom? Waarom moet er zo moeilijk gedaan worden?

## Zeer onduidelijke foutmeldingen

De validators doen geen moeite om ook maar een ietwat goede foutmelding te
geven. Als je een sluit tag ergens bovenin vergeet krijg je onderin een
foutmelding dat er iets niet goed is afgesloten. Met een beetje meer moeite
kan je achterhalen wat er verkeerd is afgesloten. Waarom meldt je dat niet?

Of neem nou deze voorbeeld code:

```html
<!doctype html>
<h1>Sitenaam</h1>
```

Laten we de error stap voor stap nagaan:

 > Line 2, Column 4: Element head is missing a required instance of child element title.

Als eerste, waarom krijg ik deze error pas bij het openen van een h1 element?
Waarom niet vlak voor het eerste body element om te melden dat ik iets mis in
de head?

Ten tweede, 'element head' hmm. Waar is mijn head element? Ben ik niet gewoon
mijn hele head element vergeten? Is dat niet de fout?

 > Content model for element head:
 > If the document is an iframe srcdoc document or if title information is
 > available from a higher-level protocol: Zero or more elements of metadata
 > content.<br>
 > Otherwise: One or more elements of metadata content, of which exactly one
 > is a title element.

Hier begrijp ik dus bar weinig van, een beginner al helemaal niks. Het wil
zo'n beetje zeggen dat een title element verplicht is (2e zin) behalve als het
een iFrame srcdoc document (joost mag weten wat dat is) of als de title
information in een higher-level protocol (??) staat.

Ik ga er maar vanuit dat dit geen iFrame srcdoc document is en dat er geen
higher-level protocol bestaat. Dus dan zal ik wel verplicht een title element
in een één of andere head element moeten plaatsen...

## Mooie richtlijn, maar heilig...nee

Validators zijn een mooie richtlijn om te gebruiken voor je code. Maar laat je
niet belemmeren door de validator. Als jij een mooie pagina die goed in elkaar
zit en die mooi modern is met nieuwe technieken dan moet je dat niet gaan
verwijderen omdat de validator het niet leuk vind. Laat die validator lekker
denken wat hij wil denken, maar ga zelf gewoon lekker door met waar je goed in
bent.

### Beginners

Voor beginners is het, mochten ze de errors doorkrijgen, een goed punt om te
zien waar grenzen liggen. Maar als je op gegeven moment ver genoeg ben in HTML
dat je zelf weet wat wel en niet zou mogen dan moet je die dingen niet
gebruiken.

### Denk goed na

Ik zal altijd blijven verkondigen dat je bij al je code die je schrijft een
gedachte erachter moet hebben. Heb je dat niet dan moet je de code verwijderen
en opnieuw beginnen. Zo werkt het ook met HTML. Schrijf HTML met een gedachte
probeer HTML op een zo semantisch correcte methode te schrijven. Je zult zien
dat de rest (browser support) vanzelf komt. Meer over semantiek kun je in
[deze tutorial](http://www.phphulp.nl/php/tutorial/html-ajax-css-javascript/html-en-semantiek/785/)
(van Jeroen vd en mij) lezen.
