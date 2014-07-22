---
layout: post
title: "Controle over je project"
thumbnail: controle-over-je-project-thumb.jpg
categories:
- article
tags:
- tools
- git

---
Als je de basis van een taal kent en verder komt en je eigen projecten gaat
schrijven, zoals een inlog systeem of een forum dan kom je vanzelf vaak wel
problemen tegen. Hoe kun je snel bijhouden wanneer iets misging?

Je wou eerst iets op manier A doen, maar nu kom je er toch achter dat manier B
eigenlijk veel beter werkt. Je moet dan alle bestanden opzoeken waarin je iets
voor manier A hebt veranderd en daar moet je alle codes van manier A
verwijderen. Vervolgens kun je bijna weer opnieuw beginnen met manier B. Dat
moet simpeler kunnen toch?

## Back-ups maken

![Back-ups maken - Handig of niet?](/img/2012/04/git-backup.png)

Een oplossing voor het probleem hierboven is om backups te maken. Telkens als
je iets belangrijks klaar hebt kopieer je de map en ga je weer verder.
Hierdoor hoef je alleen de vorige map weer terug te zetten en je kunt verder
met manier B.

Dit ziet er goed uit, maar toch is er iets wat nog niet helemaal lekker loopt.
Je hebt dan op gegeven moment heel wat mappen op je server staan, kost
geheugen en het wordt er niet overzichtelijker op. Ook kost het wel heel veel
tijd om de map te kopiëren als de map langzamerhand groot begint te worden.
Nee, dit moet handiger kunnen...

## Subversion

![controle over je versies](/img/2012/04/git-svn.png)
Ja, dan komt er een systeem om de hoek kijken: [Apache Subversion](http://subversion.apache.org/).
Hiermee kun je na elke verandering een nieuwe 'versie' aanmaken. Als je weer
terug wilt kun je zo weer een paar versies terug en ben je klaar.

Subversion slaat het op op internet en daarmee is het ook geen geheugen
verlies voor je browser. Als je met meerdere mensen werkt kunnen die mensen
ook bij deze repro (zoals dat heet) op het internet en dus kun je er met
meerdere mensen tegelijk aan werken.

Maar wacht eens, alles wordt online opgeslagen. Ik kan er dus niet lokaal mee
werken. En de versies worden alleen op internet opgeslagen, dus als persoon X
wat veranderd dan moet mijn script meteen mee veranderen.
Hmmm, het moet nog steeds beter kunnen...

## GIT

Ik wil je niet meer in spanning houden: Hier houdt het voor vandaag op, GIT is
het eindstation waar we de komende tijd mee gaan werken.

GIT is een Distributed Version Control System. Het globale basis idee achter
GIT en SVN (subversion) zijn gelijk. Dat is namelijk door middel van versies
zorgen dat je zo heen en weer kunt. Alleen GIT is veel uitgebreider en de
totale gedachte gang achter GIT is beter.

Zo werkt GIT lokaal en heeft elke developer in een project de totale repro op
zijn computer. Per dag kan hij dit naar de server pushen en dan kan de andere
developer het de volgende ochtend weer op zijn computer stoppen. Het voordeel
hiervan is dat je zelf lokaal naar andere versies kunt en dat je veel
makkelijker kan samenwerken.

In SVN heb je 2 area's: De werk area (de bestanden die jij ziet) en de Data
area (waar de repro is opgeslagen). In GIT heb je nog een extra area: De
Staging area. Hiermee krijg je de vrijheid zelf te bepalen van welke
gewijzigde bestanden je een nieuwe versie wilt maken en welke gewijzigde
bestanden je nog even lokaal wilt houden.

## De serie

Dit was het eerste artikel in de serie. Vanuit deze basis gaan we verder
werken. We gaan beginnen met GIT en ik zal je proberen veel uit te leggen over
GIT en version control systems. Hierdoor wordt jij na een paar lessen ook
liefhebber van GIT en wil je ook niet meer zonder.
