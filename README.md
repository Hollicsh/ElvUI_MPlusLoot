# ElvUI M+ Loot

**ElvUI M+ Loot** is a lightweight ElvUI plugin that displays Mythic+ group loot in a clean, compact ElvUI-style window.

The addon is designed to provide a simple overview of loot drops during Mythic+ dungeons without adding unnecessary clutter to the user interface.

## Features

- Displays Mythic+ group loot in a dedicated ElvUI-style window
- Tracks loot messages from party members
- Clean and compact layout
- Designed to visually match ElvUI
- Supports English and German clients
- Optional KeystoneLoot wishlist detection
- Marks KeystoneLoot wishlist items in the loot window
- Adds a tooltip hint for KeystoneLoot wishlist items with tier labels such as Nice, Must or BiS
- Lightweight and easy to use

## Requirements

- World of Warcraft Retail
- ElvUI
- KeystoneLoot is optional and only used for read-only wishlist detection

## Installation

Download the latest release and extract the folder into your World of Warcraft AddOns directory:

`World of Warcraft/_retail_/Interface/AddOns/`

The final folder structure should look like this:

`World of Warcraft/_retail_/Interface/AddOns/ElvUI_MPlusLoot/`

## Usage

No additional setup is required after installation.

The plugin automatically detects loot from the final chest of a Mythic+ dungeon and displays the received items from group members in a clean ElvUI-style window.

If KeystoneLoot is installed and an item is found on the KeystoneLoot wishlist, the item is marked in the loot window. The item tooltip shows a KeystoneLoot wishlist hint with the detected tier label.

The KeystoneLoot integration is optional and read-only. No KeystoneLoot files or data are copied or modified.

The window shows:

- the received item
- the item level
- the upgrade track
- the player name
- a whisper button

The loot window can be opened manually with the following commands: `/mploot` or `/mplusloot`

Internal test commands such as `/mplootfake` and `/mplootitem` are disabled in the public release build.

## Project Status

This is an early public alpha release.

The addon is currently focused on basic Mythic+ loot tracking and a clean ElvUI-style presentation. More features may be added in future versions.

## Feedback and Bug Reports

Please report bugs, issues, or suggestions via GitHub Issues.

## Official Downloads

Please download ElvUI M+ Loot only from official sources:

- GitHub Releases
- CurseForge
- Wago
- WowUp

Unofficial uploads or modified versions are not supported.

## Disclaimer

ElvUI M+ Loot is an independent third-party plugin for ElvUI.

This project is not affiliated with, endorsed by, or maintained by the ElvUI development team.

ElvUI is required for this addon to function, but ElvUI itself is not included in this project.

KeystoneLoot is optionally supported for wishlist detection. This project is not affiliated with, endorsed by, or maintained by the KeystoneLoot developers.

The KeystoneLoot integration is read-only. No KeystoneLoot files or data are copied, modified, or distributed.
