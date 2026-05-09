# Changelog

All notable changes to this project will be documented in this file.

---

## 0.1.2-alpha

### Added

- Added README screenshots.

### Changed

- Improved compatibility with WIM and modern Retail item link color codes.

### Fixed

- Fixed Shift-click item link insertion from the loot window.

---

## 0.1.1-alpha

### Added

- Added optional KeystoneLoot wishlist detection.
- Items found on the KeystoneLoot wishlist are now marked in the loot window.
- Clarified that ElvUI M+ Loot does not add an extra KeystoneLoot tooltip line.

### Changed

- Moved item relevance detection into a dedicated core module for future expansion.
- Disabled internal test slash commands for the public release build.

### Notes

- KeystoneLoot integration is optional and read-only.
- No KeystoneLoot files or data are copied or modified.

---

## 0.1.0-alpha

### Added

- Initial public alpha release
- Added basic Mythic+ group loot tracking
- Added ElvUI-style loot window
- Added support for English and German clients
- Added slash command `/mploot`
- Added addon icon support
- Added saved settings support

### Changed

- Disabled public debug output for release builds

### Fixed

- Restored addon icon texture entry in the TOC file
- Corrected slash command formatting in the README

### Known Limitations

- This is an early alpha version
- Advanced loot filtering may be added later
- Dedicated mount drop handling may be added later
- Additional configuration options may be added in future versions
