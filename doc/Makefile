TITLE 	= Konfiguration der GBV-DAIA-Server
AUTHOR  = Jakob Voß (VZG)
NAME    = daia-config
VERSION = 0.1

LANGUAGE=ngerman
include vzgspec/Makefile

wiki: $(NAME).wiki

$(NAME).wiki: $(NAME).md
	@$(PANDOC) $< -t mediawiki | sed 's/^{|/{| class="wikitable"/' > $@

