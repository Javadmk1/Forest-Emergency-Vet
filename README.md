# Forest Emergency Vet / پزشک فوری جنگل

Godot 4 bilingual (Persian/English) mobile game starter.

## Included
- Portrait 540x960 logical viewport
- Main menu with language toggle
- Local JSON save manager with backup
- Coin economy manager
- Level selection screen
- Seven independent level data files (level 1 has a starter treatment sequence)

## Run
1. Install Godot 4.3 or newer.
2. Import this folder by selecting project.godot.
3. Press F6/F5 to run.

## Current status
This is an initial code scaffold, not the finished game and not a verified APK. Individual illustrated assets, full treatment interactions, accessibility checks, Android export preset and signing configuration are still pending.


## First playable flow
- Main menu -> Forest Map -> Level 1 -> choose tweezers -> remove thorn -> wash three times -> apply bandage -> earn 20 coins and unlock level 2.
- Treatment flow is currently a UI prototype using emoji placeholders. Replace these with original illustrated art and add touch-drag interactions in the next art/gameplay milestone.


## Expanded content
- Level content drafts now cover levels 8–15.
- These eight additions are content/data drafts, not yet playable scenes. The gameplay controller must be generalized before they can be called playable.

## Advertising
See docs/ADVERTISING.md. An AdsManager scaffold is registered, but no native ad SDK is installed or serving ads yet. The game targets ages 6–10, so use a currently Families self-certified SDK version, child age treatment, G-rated creatives, and parent-gated optional rewarded ads only. Do not add multiple unverified ad SDKs.
