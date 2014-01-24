# Übersicht

Unter <http://daia.gbv.de/> bietet die Verbundzentrale des GBV (VZG) für
ausgewählte Kataloge Document Availability Information APIs (DAIA) an.
Diese Dokument beschreibt die Konfiguration für diese Schnittstellen.

## Voraussetzungen

Grundsätzlich kann die DAIA-Spezifikation auf beliebige Weise umgesetzt werden,
um DAIA für einen Katalog umzusetzen. Im Idealfall unterstützt die eingesetzte
Katalogsoftware bereits standardmäßig DAIA. Für PICA-LBS-Kataloge wurde an der
VZG ein Wrapper entwickelt, der extern DAIA bereitstellt und intern mit dem LBS
und anderen Systemen kommuniziert. Dazu sind zunächst folgende Voraussetzungen
zu erfüllen:

* Die Bibliothek für deren Katalog DAIA konfiguriert werden soll muss im
  [GBV-Standortverzeichnis] eingerichtet sein. Dies beinhaltet insbesondere
  einen ISIL zur Identifizierung der Bibliothek (bspw. `DE-Luen4` für die UB
  Lüneburg). Zur Überprüfung kann die entsprechende URI aufgerufen werden,
  bspw. <http://uri.gbv.de/organization/isil/DE-Luen4>.

* Die Katalogdatenbank muss in der unAPI-Schnittstelle <http://unapi.gbv.de/>
  eingerichtet sein. Bestandteil dieser Einrichtung ist ein Datenbankkürzel,
  dass in der Regel aus dem ISIL abgeleitet ist (z.B. `opac-de-luen4` für die
  UB Lüneburg). Zur Überprüfung kann die entsprechende Datenbank-URI aufgerufen 
  werden, bspw. <http://uri.gbv.de/database/opac-de-luen4>.

[GBV-Standortverzeichnis]: http://www.gbv.de/wikis/cls/Konfiguration_der_GBV-Standortverwaltung

## Grundlagen

... *TODO: Was ist und kann DAIA und was nicht?* ...

Die aktuelle Verfügbarkeit von Exemplaren wird im Wesentlichen aus der
[PICA-Kategorie 701x (Pica3) bzw. 209A (PICA+)](http://www.gbv.de/vgm/info/mitglieder/02Verbund/01Erschliessung/02Richtlinien/01KatRicht/7100.pdf)
ermittelt. Es werden ausschließlich folgende Unterfelder ausgewertet:

* **`209A $a`** : Signatur
* **`209A $d`** : Ausleihindikator
* **`209A $f`** : Sonderstandort

Der Konvolutindikator (`209A $c`) und der Hinweis auf Mehrfachexemplare (`209A $e`)
wird noch nicht berücksichtigt.

Zusätzlich wird zur Bestimmung der aktuellen Verfügbarkeit und für einen Link
auf das Ausleihsystem für Bestellungen bzw. Vormerkungen die Kategorie `201@`
mit folgenden Unterfeldern herangezogen:

* **`201@ $l`** : Link auf das Ausleihsystem
* **`201@ $b`** : aktueller Ausleihstatus (0:verfügbar, 1:bestellbar, 6: unbekannt weil Bandliste, alle anderen Werte: nicht verfügbar)
* **`201@ $n`** : Anzahl Vormerkungen auf dieses Exemplar - wenn nicht gesetzt, keine Vormerkungen

Die Pseudo-Kategorien `201@ $u` und `$v` werden *nicht* ausgewertet, da es sich
nicht um Datenfelder sondern um Textnachrichten handelt, die zudem von jeder
Bibliothek anders formuliert werden können. Diese Lösung hätte deshalb die
gleichen Probleme wie Screenscraping.

Bislang werden nur Monografien und unselbständige Werke (j-Sätze) ausgewertet,
d.h. bei elektronischen Publikationen, Zeitschriften, Reihen etc. kann die
DAIA-Antwort ggf. falsch sein.

# Konfiguration

Zur Konfiguration der DAIA-Schnittstelle einer Bibliothek, muss die Bibliothek
Informationen zur Belegung der Unterfelder `209A $d` (Ausleihindikator) und
`209A $f` (Sonderstandort) bereitstellen.

## Standort

Die Kategorie `209A $f` bestimmt den Standort eines Exemplars. 

Weitere Details siehe unter
<http://www.gbv.de/wikis/cls/Standortverwaltung>

## Ausleihindikator

Die Standardkonfiguration für den Ausleihindikator entspricht den
GBV-Katalogisierungsrichtlinien und sieht folgendermaßen aus:

~~~
    # Standardwert, falls kein Indikator angegeben
    default: u

    # ausleihbar/Fernleihe
    u:
        presentation:
            is: available
        loan:
            is: available
        interloan:
            is: available

    # verkürzt ausleihbar / Fernleihe
    b:
        presentation:
            is: available
        loan:
            is: available
            limitation: "kürzere Ausleihfrist"
        interloan:
            is: available

    # mit Zustimmung ausleihbar / Fernleihe
    d:
        presentation:
            is: available
        loan:
            is: available
            limitation: "mit Zustimmung"
        interloan:
            is: available

    # mit Zustimmung ausleihbar / Fernleihe nur Kopie
    s:
        presentation:
            is: available
        loan:
            is: available
            limitation: "mit Zustimmung"
        interloan:
            is: available
            limitation: "nur Kopie"
    # ausleihbar / keine Fernleihe
    c:
        presentation:
            is: available
        loan:
            is: available
        interloan:
            is: unavailable

    # Lesesaalausleihe / keine Fernleihe
    i:
        presentation:
            is: available
        loan:
            is: unavailable
        interloan:
            is: unavailable

    # für Ausleihe gesperrt / keine Fernleihe
    g:
        presentation:
            is: available
        loan:
            is: unavailable
        interloan:
            is: unavailable

    # Lesesaalausleihe / nur Kopie in die Fernleihe
    f:
        presentation:
            is: available
        loan:
            is: unavailable
        interloan:
            is: available
            limitation: "nur Kopie"

    # bestellt
    a:
        presentation:
            is: unavailable
            expected: unknown
        loan:
            is: unavailable
        interloan:
            is: unavailable
        openaccess:
            is: unavailable

    # bestellt, Verlust, keine Angabe, unbekanter Indikator
    "":
        presentation:
            is: unavailable
        loan:
            is: unavailable
        interloan:
~~~

# Weitere Informationen

* GBV-Katalogisierungsrichtlinie für Kategorie 7100/209A\
  <http://www.gbv.de/vgm/info/mitglieder/02Verbund/01Erschliessung/02Richtlinien/01KatRicht/7100.pdf>

...

Mit dem zusätzlichen URL-Parameter `debug` werden internen PICA+ Feldinhalte
angezeigt werden, aus denen die DAIA-Antwort konstruiert wird:

* `002@ $0` : Materialart
* `209A $f` : Sonderstandort
* `209A 1$d` : Ausleihindikator
* `201@ $b` : Aktueller Ausleihstatus (0=verfügbar, 1=verfügbar, muss ggf. bestellt werden)
* `ILN` : Interne Bibliotheks-ID, nur im Verbundkatalog relevant

