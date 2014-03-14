# Übersicht

Unter <http://daia.gbv.de/> bietet die Verbundzentrale des GBV (VZG) für
ausgewählte Kataloge Document Availability Information APIs (DAIA) an.
Diese Dokument beschreibt die Konfiguration für diese Schnittstellen.

## Voraussetzungen

Grundsätzlich kann die DAIA-Spezifikation auf beliebige Weise benutzt werden,
um DAIA für einen Katalog zu implementieren. Im Idealfall unterstützt die eingesetzte
Katalogsoftware bereits standardmäßig DAIA. Für PICA-LBS-Kataloge wurde an der
VZG ein Wrapper entwickelt, der extern DAIA bereitstellt und intern mit dem LBS
und anderen Systemen kommuniziert. Dazu sind zunächst folgende Voraussetzungen
zu erfüllen:

* Die Bibliothek, für deren Katalog DAIA konfiguriert werden soll, muss im
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

### Wozu dient DAIA?

DAIA liefert eine Schnittstelle für Anwendungen, um Informationen über die (aktuelle) Verfügbarkeit von verschiedenen Diensten für spezifizierte Medien zu erhalten. Die Anfrage geschieht über eine eindeutige ID (etwa ppn) unter Definition der Einrichtung (über ISIL, s.o.) an das jeweilige LBS. Es findet eine Unterteilung in die Dienste Präsentation, Ausleihe, Fernleihe und Open Access (s.u.) statt. Zum Zweck der Automatisierung und der Kompatibilität mit mehreren Systemen sind die übermittelten Informationen so stark wie möglich standardisiert. Eine Übersicht über die Verarbeitung der Standardindikatoren folgt in [Teil 2.2]. Eine Einleitung in die Anwendung der DAIA-Schnittstelle findet sich im Wiki des GBV unter <http://www.gbv.de/wikis/cls/Verf%C3%BCgbarkeitsrecherche_mit_DAIA>.

[Teil 2.2]: <#Ausleihindikator>

### Welche Daten wertet der GBV-DAIA-Server aus?

Die aktuelle Verfügbarkeit von Exemplaren wird im Wesentlichen aus der
[PICA-Kategorie 701x (Pica3) bzw. 209A (PICA+)](http://www.gbv.de/vgm/info/mitglieder/02Verbund/01Erschliessung/02Richtlinien/01KatRicht/7100.pdf)
ermittelt. Es werden ausschließlich folgende Unterfelder ausgewertet:

* **`209A $a`** : Signatur
* **`209A $d`** : Ausleihindikator
* **`209A $f`** : Sonderstandort

Der Konvolutindikator (`209A $c`) und der Hinweis auf Mehrfachexemplare (`209A $e`)
wird noch nicht berücksichtigt.

Zusätzlich werden zur Bestimmung der aktuellen Verfügbarkeit und für einen Link
auf das Ausleihsystem für Bestellungen bzw. Vormerkungen die Kategorien `101@` und `201@`
mit folgenden Unterfeldern herangezogen:

* **`101@ $a`** : ILN, Interne Bibliotheks-ID, nur im Verbundkatalog relevant
* **`201@ $l`** : Link auf das Ausleihsystem
* **`201@ $b`** : aktueller Ausleihstatus (0:verfügbar, 1:bestellbar, 6: unbekannt weil Bandliste, alle anderen Werte: nicht verfügbar)
* **`201@ $n`** : Anzahl Vormerkungen auf dieses Exemplar - wenn nicht gesetzt, keine Vormerkungen

Die Pseudo-Kategorien `201@ $u` und `$v` werden *nicht* ausgewertet, da es sich
nicht um Datenfelder sondern um Textnachrichten handelt, die zudem von jeder
Bibliothek anders formuliert werden können. Eine Übertragung dieser Daten würde Probleme für die Automatisierung verursachen.

Bislang werden nur Monografien und unselbständige Werke (j-Sätze) ausgewertet,
d.h. bei Zeitschriften, Reihen etc. kann die
DAIA-Antwort ggf. falsch sein.

Bei elektronischen Publikationen (erkennbar daran, dass Unterfeld `002@$0` mit
"O" beginnt) werden zusätzlich die Kategorien `209R` ([PICA3: 7133]) und `009P` ([PICA3: 408x]) in den Unterfeldern `$a`,`$S` und `$4` ausgewertet, um ggf. direkte Hyperlinks auf elektronische Dokumente mitzuliefern und den
DAIA-Service "openaccess" zu setzen. Zur Zeit beschränkt sich die Auswahl auf die erste vorhandene URL, eine Überprüfung auf den Inhalt wird nicht vorgenommen.

[PICA3: 7133]: http://www.gbv.de/vgm/info/mitglieder/02Verbund/01Erschliessung/02Richtlinien/01KatRicht/7133.pdf
[PICA3: 408x]: http://www.gbv.de/vgm/info/mitglieder/02Verbund/01Erschliessung/02Richtlinien/01KatRicht/408x.pdf

Ausgewertete Felder:

* **`002@ $0`** : Bibliographische Gattung und Status (Position 1: O = Elektronische Ressource im Fernzugriff)
* **`009P`** : Elektronische Adresse und ergänzende Angaben zum Zugriff
	* `009P $a` : URL
	* `009P $S` : Indikator für Datentausch
	* `009P $4` : Codierte Lizenzinformationen bzw. Benutzungsbedingungen
* **`209R`** : Lokale Angaben zum Zugriff auf Online-Ressourcen (analog zu `009P`)


# Konfiguration

Zur Konfiguration der DAIA-Schnittstelle einer Bibliothek muss die Bibliothek
Informationen zur Belegung der Unterfelder `209A $d` (Ausleihindikator) und
`209A $f` (Sonderstandort) bereitstellen.

## Standort

Die Kategorie `209A $f` bestimmt den Standort eines Exemplars. Allgemeine Details zur Standortverwaltung befinden sich unter <http://www.gbv.de/wikis/cls/Standortverwaltung>. 

Um die Exemplarsätze mit Sonderstandorten (SST) zu verknüpfen, wird ein Mapping der Standorte in Form einer CSV-Datei benötigt. In dieser werden die Standortcodes mit Standortkürzeln und eventuellen Aufstellungsorten (z.B. Lehrbuchsammlung) verknüpft. Exemplarsätze ohne SST-Eintrag werden standardmäßig auf den Hauptstandort abgebildet.

Die CSV-Datei hat demnach drei Spalten:

**sst**
	:	Der SST-Eintrag wird als regulärer Ausdruck (Perl-Syntax) interpretiert. So können ähnliche Standorte (z.B. mit fortlaufender Nummer) kompakt definiert werden.

**department**
	:	Ein freies Standortkürzel beginnt mit einem '@', alternativ kann hier auch eine ISIL oder eine ISIL plus Standortkürzel angegeben werden, z.B. für Teilbibliotheken mit ISIL. Einträge beginnend mit "-" sind Pseudo-Exemplare, die später herausgefiltert werden.

**storage (optional)**
	:	Hier kann ein Aufstellungsstandort als Zeichenkette angegeben werden. Die Werte "$1" bis "$9" verweisen auf die jeweiligen regulären Ausdrücke im zugehörigen SST-Feld (siehe Bsp. 5).

<br>
**Beispiele:**

| sst | department | storage |
|-----|------------|---------|
| lehrb | @ | Lehrbuchsammlung |
| magalt | @ | Magazin |
| hb | @hand | |
| rot | DE-Luen4-1 | |
| sm([0-9]+) | @ | Seminarapparat $1 |
| hsb | - | |
| dgs magazin.* | DE-960-7@mag | |

<br><br>

## Ausleihindikator

Die Rückgaben für die einzelnen Dienste sind binär codiert (available/unavailable) und lassen außerdem eine Einschränkung (limitation) bzw. Zusatzinformation (expected) zu, die als Zeichenkette geliefert werden. Der Term "expected" wird bei bestellten Medien mit der erwarteten Verfügbarkeitszeit besetzt. Auf dieser Grundlage kann anschließend das LBS für den aktuellen Status angefragt werden.
Es wird zwischen vier verschiedenen Diensten unterschieden:

**presentation**
	: Der Zugriff von innerhalb der Einrichtung ist möglich.

**loan**
	:	Das Medium kann ausgeliehen werden.

**interloan**
	:	Das Medium ist zur Fernleihe zugelassen.

**openaccess**
	:	Falls ein elektronisches Medium vorliegt, wird der Status des Dienstes generiert und übergeben. (s. Punkt 1.2.2, "Welche Daten wertet der GBV-DAIA-Server aus?")

<br>

Die Standardkonfiguration für den Ausleihindikator entspricht den
GBV-Katalogisierungsrichtlinien und sieht folgendermaßen aus:

| Indikator | presentation | loan | interloan | openaccess |
| --- | --- | --- | --- |:---:|
| a | unavailable (+expected) | unavailable | unavailable | unavailable|
| b | available | available (+limitation) | available | - |
| c | available | available | unavailable | - |
| d | available | available (+limitation) | available | - |
| f | available | unavailable | available (+limitation) | - |
| g | unavailable | unavailable | unavailable | - |
| i | available | unavailable | unavailable | - |
| s | available | available (+limitation) | available (+limitation) | - |
| u | available | available | available | - |
| z | unavailable | unavailable | unavailable | - |

<br>
In der Standardkonfiguration lauten die Limitationen wie folgt:

* b: "kürzere Ausleihfrist"

* d: "mit Zustimmung"

* f: "nur Kopie"

* s: "mit Zustimmung", "nur Kopie"

<br>

Es besteht die Möglichkeit, für einzelne Einrichtungen alternative Konfigurationen der Indikatoren einzurichten. Die Einstellungen werden in der Datei *ausleihindikator.yaml* im Repository der Konfiguration unter <https://github.com/gbv/daia-config> vorgenommen. Es folgt ein Ausschnitt aus dieser Datei mit einigen Standardindikatoren:

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
~~~

<br>

# Weitere Informationen
<p>
GBV-Katalogisierungsrichtlinien für verwendete Kategorien:

* 7100/209A: <http://www.gbv.de/vgm/info/mitglieder/02Verbund/01Erschliessung/02Richtlinien/01KatRicht/7100.pdf>
* 7133/209R: <http://www.gbv.de/vgm/info/mitglieder/02Verbund/01Erschliessung/02Richtlinien/01KatRicht/7133.pdf>
* 408x/009P: <http://www.gbv.de/vgm/info/mitglieder/02Verbund/01Erschliessung/02Richtlinien/01KatRicht/408x.pdf>
</p>

<p>
Wiki der GBV-Standortverwaltung:\
<http://www.gbv.de/wikis/cls/Standortverwaltung>
</p>
<p>
Wiki zur Einführung in die DAIA-Schnittstelle:\
<http://www.gbv.de/wikis/cls/Verf%C3%BCgbarkeitsrecherche_mit_DAIA>
</p>

