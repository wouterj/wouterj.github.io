---
layout: post
title: "CSS voor objecten"
thumbnail: css-objecten-thumb.png
categories:
- article
tags:
- object oriented
- css

---
Dat je kunt programmeren in objecten is waarschijnlijk al bekent. Maar dat je
ook CSS in objecten kunt gebruiken is nog vrij nieuw. Tijd om dat eens te
ontdekken!

## De concepten

### Onderhoud

Onderhoud, dat is een hele belangrijke factor in de scriptwereld. Sommige
mensen kiezen voor een korte ontwikkeltijd, met als nadeel dat je langer doet
over het onderhoud. Andere mensen kiezen voor een lange ontwikkeltijd,
waardoor je later sneller dingen kunt aanpassen. Die laatste methode is naar
mijn mening de beste, en daar probeer ik mijn lezers van te overtuigen.

### Hergebruik

CSS code kun je op sommige momenten heel makkelijk hergebruiken. Als ik
eenmaal een hele mooie button heb gemaakt kan ik die in al mijn toekomstige
projecten gebruiken. Eigenlijk zou dat zo moeten bij heel veel CSS dingen,
vind je niet? Stel je nou voor dat je later heel snel een webpagina kan maken,
doordat je alleen wat CSS scriptjes bij elkaar hoeft te voegen?

### Overerving

Nog zo'n typisch concept in zowel CSS als OO. De C in CSS staat voor
Cascading, overerving. Waarom zullen we daar dan geen gebruik van maken?

Het probleem is dat het vanuit je CSS file niet duidelijk is waarvan je dingen
overerft. Je moet in de HTML code kijken naar de klassen, het element en zijn
parents.

## Werk NIET met elementen en IDs

De oplossing is om niet te werken met element selectoren of IDs. Stel je nou
voor dat je een `<header>` element stijlt, zodat hij er goed uitziet als
pagina header. Een maandje later kom je er achter dat je deze header tag ook
wilt gebruiken voor de header van een artikel. Ai, daar heb je een probleem.
Die krijgt nu ook al die stijlen van de pagina header mee.

Het kan ook andersom. Je maakt een footer en die stijl je met het id
`#footer`. Alles ziet er mooi uit en nu wil je ook dezelfde stijlen gebruiken
voor de footer in een post. Ga je nu alle CSS code kopieren?

### Werk WEL met classes

De oplossing is het gebruik van classes. Hiermee limiteer je jezelf niet tot
bepaalde elementen, of het maar 1 keer mogen voorkomen in een pagina. Als ik
de stijlen voor een button wil gebruiken in mijn header dan moet ik vrij
genoeg zijn om dat te mogen doen.

#### Quasi-qualified selectors

om ons niet te limiteren op bepaalde elementen, maar om toch aan te geven bij
welk element deze klasse hoort kun je
[quasi-qualified selectors](http://csswizardry.com/2012/07/quasi-qualified-css-selectors/)
gebruiken. Stel we hebben dit:

```css
article.featured{
    /* ... */
}
```

Nu kunnen we de `.featured` class alleen op een `<article>` element gebruiken.
Maar misschien wil ik later wel helemaal geen pagina op de homepagina, maar
wil ik bijv. een `<section>` of `<img>` element deze class meegeven.

Om toch aan te geven dat hij bij een `article` element hoort, maar om hem niet
te limiteren op dit element, plaatsen we de selector in een comment:

```css
/*article*/.featured{
    /* ... */
}
```

Voor CSS is dit nu gewoon een `.featured` class, maar voor de lezer wordt dit
gezien als een `.featured` class op een `article` element: Het is
quasi-qualified.

## De BEM techniek

Het basis concept van objecten in CSS wordt
[BEM](http://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/)
genoemd. Dit staat voor <b>B</b>lock, <b>E</b>lement, <b>M</b>odifier.

Ik ga een voorbeeld laten zien van deze techniek doormiddel van deze HTML
code:

```html
<article>
    <header>
        <h1>Hello World</h1>
        <img src="img/thumbs/hello-world.png">
    </header>
    <article>
        <!-- ... -->
    </article>
    <footer>
        <p>Geplaatst in <a href="...">Nieuws</a></p>

        <nav>
            <ul>
                <li><a href="...">Tweet</a></li>
                <li><a href="...">like</a></li>
                <li><a href="...">+1</a></li>
            </ul>
        </nav>
</article>
```

Een Block is het hoofdobject, in ons geval is dit een post. We geven onze
article element dus een `post` class mee:

```html
<article class=post>
    <!-- ... -->
</article>
```

Een Block heeft children. In ons geval heeft hij een header, body en footer.
Dit zijn de Elementen. De conventie voor een element class naam is
`block__element` (2 underscores). In ons geval wordt het bijvoorbeeld
`post__header`:

```html
<article class=post>
    <header class=post__header>
        <!-- ... -->
    </header>
    <article class=post__body>
        <!-- ... -->
    </article>
    <footer class=post__footer>
        <!-- ... -->
    </footer>
</article>
```

Deze Elementen hebben ook weer children. Dit zijn ook allemaal Elementen van
de post, we hebben een `post__title`, `post__tumbnail`, ect.:

```html
<article class=post>
    <header class=post__header>
        <h1 class=post__title>Hello World</h1>
        <img class=post__thumbnail src="img/thumbs/hello-world.png">
    </header>
    <article class=post__body>
        <!-- ... -->
    </article>
    <footer class=post__footer>
        <p class=post__meta>Geplaatst in <a href="...">Nieuws</a></p>

        <nav class=post__social>
            <ul>
                <li><a href="...">Tweet</a></li>
                <li><a href="...">like</a></li>
                <li><a href="...">+1</a></li>
            </ul>
        </nav>
    </footer>
</article>
```

Dan hebben we als laatst nog een Modifier. Dit betekend dat het een Block is,
die net wat anders is als de vorige block. Als je bijv. op de hompagina van
deze website kijkt zie je dat het nieuwste bericht groter is. Het is een
uitbereiding van de overige nieuwsblokjes. Dit wordt gedaan doormiddel van een
modifier.

Zodra je aan een element een Modifier meegeeft geef je ook altijd de Block
mee. Want, zoals ik in het begin al verkondigde, we moeten gebruiken maken van
de Cascade.

Een Modifier gebruikt als conventie `block--modifier`. In ons geval wordt dit
waarschijnlijk `post--latest`:

```html
<article class="post  post--latest">
    <!-- ... -->
</article>

<article class=post>
    <!-- ... -->
</article>
```

    [note]
    Een opmerkzame lezer zal zien dat ik 2 spaties tussen de classnamen heb
    geplaatst. Hierdoor kun je snel zien wat de classnamen zijn, met 1 spatie
    staan ze te dicht op elkaar om het snel te kunnen zien.

## Harry Roberts en Inuit.css

Voordat ik stop met schrijven wil ik jullie kennis laten maken met
[Harry Roberts](http://csswizardry.com/) en zijn framework
[Inuit.css](http://inuitcss.com/).

Harry Roberts is een van de actieve front-end developers die strijden voor het
gebruik van BEM. Hij heeft 2 jaar gewerkt aan grote websites en heeft daardoor
een hele interessante kijk op CSS. Het loont zeker de moeite om zijn artikelen
te lezen.

Daarnaast heeft hij Inuit.CSS gemaakt. Een framework die werkt via het BEM
principe en zijn meeste andere ideeën. Deze blog is ook gemaakt via Inuit.CSS
en de code hiervan kun je
[bekijken](https://github.com/WouterJ/wouterj.github.com).
