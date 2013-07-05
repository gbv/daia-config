# Konfiguration für daia.gbv.de

Die Konfiguration des zentralen DAIA-Servers der VZG (http://daia.gbv.de/) wird
zentral in diesem git-Repository verwaltet. Die jeweils aktuelle Version steht
öffentlich auf GitHub unter <https://github.com/gbv/daia-config> und wird vom
DAIA-Server von dort aktualisiert.

## Übersicht der Konfigurationsdateien

Derzeit gibt es folgende Konfigurationsdateien:

`sstmap`
  : Mapping von Standortcodes Sonderstandorten (sst) auf Standort-URIs. Für jede 
    Bibliothek kann eine eigene CSV-Datei angelegt werden, deren
    Dateiname der ISIL entspricht (z.B. `DE-84.csv`).

`ilnelnmap.csv`
  : Mapping von ELN und ILN auf ISIL, Bibliotheksnamen und Ausleihcodes 
    (Export aus dem CBS).

`ausleihindikator.yaml`
  : Mapping von Ausleihcodes auf DAIA-Services

`materialcodes.yaml`
  : Mapping von PICA-Datensatzarten (Kategorie 002@) auf Materialcodes 
    (aka "Material-ADIs")

## Einbindung in den DAIA-Server

Der Quellcode des DAIA-Servers befindet sich in einem [eigenen, nicht
öffentlichen Repository](https://github.com/gbv/daia.gbv.de.git).

Auf dem Server wird das Repository daia-config üblicherweise unter `/etc/daia/`
ausgecheckt. Durch setzen der Umgebungsvariable `DAIA_CONF` kann auch ein
anderes Verzeichnis als Konfigurationsverzeichnis ausgewählt werden.

## Weitere Datenquellen

Nicht alle Aspekte des DAIA-Server lassen sich über die Konfigurationsdateien
anpassen. Zusätzlich kommen folgende Datenquellen zum Einsatz:

* Die Inhalte aus GBV-Katalogen, abgerufen via **unAPI** und **SRU**.

* Informationen *über* Kataloge, Bibliotheken und Bibliotheksstandorte,
  abgerufen als Linked Open Data von <http://uri.gbv.de/database> bzw.
  <http://uri.gbv.de/organization>.

Um beispielsweise einen neuen Standort einzurichten, muss ggf. zunächst
eine Standort-URI unter <http://uri.gbv.de/organization> eingerichtet
werden um anschließend im DAIA-Server darauf verweisen zu können.

