# Zentrale Konfiguration des DAIA-Server daia.gbv.de

Dieses git-Repository enthält die zentrale Konfiguration des DAIA-Server der
VZG (http://daia.gbv.de/). Die jeweils aktuelle Version wird zentral auf GitHub
verwaltet:

* SSH: <git@github.com:gbv/daia-config.git> 
* HTTPS: <https://github.com/gbv/daia-config.git>

Der Quellcode des DAIA-Servers befindet sich in einem eigenen Repository:

* SSH: <git@github.com:gbv/daia.gbv.de.git>
* HTTPS: <https://github.com/gbv/daia.gbv.de.git>

Auf dem Server wird dieses Repository üblicherweise unter `/etc/daia/`
ausgecheckt. Durch setzen der Umgebungsvariable `DAIA_CONF` kann auch ein
anderes Verzeichnis als Konfigurationsverzeichnis ausgewählt werden.

## Übersicht der Konfigurationsdateien

Derzeit gibt es folgende Konfigurationsdateien:

* **`sstmap/`**: 
  Mapping von Sonderstandorten (sst) auf Standort-URIs. Für jede 
  Bibliothek kann eine eigene CSV-Datei angelegt werden, deren
  Dateiname der ISIL entspricht (z.B. `DE-84.csv`).

* **`ilnelnmap.csv`**: 
  Mapping von ELN und ILN auf ISIL, Bibliotheksnamen und Ausleihcodes 
  (Export aus dem CBS).

* **`ausleihindikator.yaml`**: 
  Mapping von Ausleihcodes auf DAIA-Services.

* **`materialcodes.yaml'**:
  Mapping von 002@ auf Materialcode (Material-ADI)

*Eine genauere Beschreibung der Konfigurationsdateien folgt noch!*

## Weitere Datenquellen

Nicht alle Aspekte des DAIA-Server lassen sich über die Konfigurationsdateien
anpassen. Zusätzlich kommen folgende Datenquellen zum Einsatz:

* Die Inhalte aus GBV-Katalogen, abgerufen via **unAPI** und **SRU**.
* Informationen *über* Kataloge, Bibliotheken und Bibliotheksstandorte,
  abgerufen als Linked Open Data von <http://uri.gbv.de/database> bzw.
  <http://uri.gbv.de/organization>.

Um Beispielsweise einen neuen Standort einzurichten, muss ggf. zunächst
eine Standort-URI unter <http://uri.gbv.de/organization> eingerichtet
werden um anschließend im DAIA-Server darauf verweisen zu können.

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

## Was tun wenn's brennt?

...*Anleitung zur Fehlerbehebung falls DAIA-Server kaputtkonfiguriert folgt*...

