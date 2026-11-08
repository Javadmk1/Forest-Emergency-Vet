# Forest Emergency Vet / پزشک فوری جنگل

A bilingual Persian/English portrait mobile game prototype built with Godot 4.3.

## Visual milestone
- Original illustrated forest-clinic scene artwork, including a woodland clinic, veterinarian, fawn, fox and rabbit.
- Custom rabbit patient illustration used in the treatment scene.
- Illustrated clinic interior background for the treatment screen.
- Additional fox, fawn and hedgehog character portraits; level cards display matching portraits when the level data identifies those animals.
- Warm wooden-style buttons and panels, forest-green overlays, readable bilingual controls.
- Forest-themed level map and treatment screen.
- No external image downloads or runtime network dependency.

## Current playable flow
1. Main menu -> Forest Map.
2. Level 1 -> choose tweezers -> remove thorn -> wash three times -> apply bandage.
3. Finish the treatment, earn 20 coins and unlock level 2.

## Important scope notes
- Level 1 is the only implemented treatment flow. Levels 2–15 are content drafts and are not yet playable.
- Animal album now lists rescued and upcoming animals; the clinic shop supports three coin-purchased decor unlocks; settings can switch language; the parent area explains the child-friendly build and disabled ads. These are lightweight functional menus, not a fully furnished clinic/decor placement system.
- The illustrated assets are original lightweight SVG artwork designed to keep the Android build small. They are static illustrations, not production character animations or separate high-resolution sprite sheets. Several animal portraits are ready for future missions, but those missions are not playable yet.
- The project has not yet been verified on a physical Android device. A successful CI export only confirms that the build pipeline produced an APK.
- Ads remain disabled. This is a child-focused game prototype; do not enable ad SDKs without a suitable family-safe design and required compliance review.

## Run locally
1. Install Godot 4.3 or newer.
2. Import this folder by selecting `project.godot`.
3. Press F6/F5 to run.

## Android build
The GitHub Actions workflow in `.github/workflows/android-build.yml` exports a debug APK on pushes to `main`.
