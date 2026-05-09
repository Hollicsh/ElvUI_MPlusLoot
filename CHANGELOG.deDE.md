# Änderungsprotokoll

Alle wichtigen Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

---

## 0.1.1-alpha

### Neu

- Optionale KeystoneLoot-Wunschlisten-Erkennung hinzugefügt.
- Gegenstände auf der KeystoneLoot-Wunschliste werden jetzt im Lootfenster markiert.
- Tooltip-Hinweis für KeystoneLoot-Wunschitems inklusive Tier-Anzeige wie Nett, Wichtig oder BiS ergänzt.

### Geändert

- Item-Relevanzlogik in ein eigenes Core-Modul ausgelagert, um spätere Erweiterungen vorzubereiten.
- Interne Test-Slashcommands für die öffentliche Release-Version deaktiviert.

### Hinweise

- Die KeystoneLoot-Integration ist optional und nur lesend.
- Es werden keine KeystoneLoot-Dateien oder Daten kopiert oder verändert.

---

## 0.1.0-alpha

### Hinzugefügt

- Erste öffentliche Alpha-Version
- Grundlegende Mythic+ Gruppenloot-Erfassung hinzugefügt
- Loot-Fenster im ElvUI-Stil hinzugefügt
- Unterstützung für englische und deutsche Clients hinzugefügt
- Slash-Befehl `/mploot` hinzugefügt
- Addon-Icon-Unterstützung hinzugefügt
- Unterstützung für gespeicherte Einstellungen hinzugefügt

### Geändert

- Öffentliche Debug-Ausgaben für Release-Versionen deaktiviert

### Korrigiert

- IconTexture-Eintrag in der TOC-Datei wieder ergänzt
- Formatierung des Slash-Befehls in der README korrigiert

### Bekannte Einschränkungen

- Dies ist eine frühe Alpha-Version
- Erweiterte Loot-Filter können später ergänzt werden
- Eine eigene Mount-Drop-Erkennung kann später ergänzt werden
- Weitere Einstellungsmöglichkeiten können in zukünftigen Versionen ergänzt werden
