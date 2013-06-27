# Konfiguration des DAIA-Servers der VZG

Dieses git-Repository enthält die zentrale Konfiguration des DAIA-Server der
VZG unter http://daia.gbv.de/. Die jeweils aktuelle Version der Konfiguration
wird zentral auf GitHub verwaltet:

* SSH: `git@github.com:gbv/daia-config.git`
* HTTPS: <https://github.com/gbv/daia-config.git>

Der Quellcode des DAIA-Servers befindet sich in einem eigenen, [nicht
öffentlichen Repository](https://github.com/gbv/daia.gbv.de).

Auf dem DAIA-Server wird dieses Repository üblicherweise unter `/etc/daia/`
ausgecheckt. Durch setzen der Umgebungsvariable `DAIA_CONF` kann auch ein
anderes Verzeichnis als Konfigurationsverzeichnis ausgewählt werden.

## Datenquellen

Grundsätzlich liefert der DAIA-Server Ergebnisse basierend auf folgenden
Datenquellen:

* Die in diesem Repository verwalteten 
  [Konfigurationsdateien](#Konfigurationsdateien)

* Inhalte aus PICA-Katalogen (per [unAPI](http://www.gbv.de/wikis/cls/unAPI)
  und [SRU](http://www.gbv.de/wikis/cls/SRU).

* SRU, unAPI Basis-URLs

* Namen und Homepage-URLs von Organisationen und Standorten
  (als Linked Open Data via <http://uri.gbv.de/organization/>).

* Zuordnung von Organisationen zu Datenbanken, Datenbankkürzeln,
  PICA-Katalog-URLs und SRU-Basis-URLs (via
  (als Linked Open Data via <http://uri.gbv.de/database/>).

## Konfigurationsdateien

Die Konfiguration beinhaltet folgenden Dateien:

* **`sstmap`**:
  Mapping von Sonderstandorten (sst) auf Standort-URIs. Für jede 
  Bibliothek kann eine eigene CSV-Datei angelegt werden, deren
  Dateiname der ISIL entspricht (z.B. `DE-84.csv`).

* **`ilnelnmap.csv`**: 
  Mapping von ELN und ILN auf ISIL, Bibliotheksnamen und Ausleihcodes 
  (Export aus dem CBS).

* **`ausleihindikator.yaml`**: 
  Mapping von Ausleihcodes auf DAIA-Services.

* **`materialcodes.yaml`**:
  Mapping von 002@ auf Materialcode (Material-ADI)

*Eine genauere Beschreibung der Konfigurationsdateien folgt noch!*

## Vor- und Nachteile der Verwaltung in einem eigenen Repository

Die Verwaltung der Konfiguration in einem Repository hat folgende Vorteile:

* Der Server-Code muss seltener geändert werden, so dass weniger Updates
  notwendig sind.
* Änderungen an der Konfiguration sind besser nachvollziehbar und können 
  bei Bedarf rückgängig gemacht werden.
* Der gesamte DAIA-Server mitsamt der jeweils aktuellen Konfiguration
  lässt sich jederzeit auf einem anderen Rechner klonen (z.B. zum
  Testen und Entwickeln oder zur Ausfallsicherheit).
* Dank Post-Receive Hook im zentralen Konfigurations-Repository auf GitHub
  lässt sich die Konfiguration des DAIA-Servers von aktualisieren, ohne
  dass sich jemand auf dem  DAIA-Server einloggen müsste.

Die Verwaltung der Konfiguration in einem Repository hat folgende Nachteile:

* Direkte Änderungen ("nur mal schnell...") auf dem Produktivsystem sind nicht
  möglich bzw. führen zu inkonsistenten Konfigurationen, die ggf. mühsam per 
  Hand aufgelöst werden müssen.
* Stattdessen müssen Änderungen an der Konfiguration erst commited und an das
  zentrale Repository gepusht werden.
* Es kann u.U. einige Minuten dauern bis Änderungen im Produktivsystem aktiv 
  sind.

## Änderungen an der Konfiguration

Für Änderungen an der Konfiguration wird folgendes Vorgehen empfohlen:

1. Installation des DAIA-Servers auf einer Testmaschine 
   (in der Regel reicht dazu der lokale Rechner).

2. Abgleich der Konfiguration auf der Testmaschine mit dem zentralen 
   Konfigurations-Repository

       $ git pull origin master

3. Änderung der Konfiguration und Test auf Korrektheit

4. Commiten der Änderungen

5. Push an das zentrale Konfigurations-Repository

6. Ggf. zusätzlicher Test am Produktivsystem

