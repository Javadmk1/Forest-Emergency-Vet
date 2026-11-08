# Advertising integration policy

## Current state
The project contains an advertising manager scaffold only. No native advertising SDK is bundled, initialized, or serving ads yet. This is deliberate: the game is designed for ages 6–10 and must not ship with an unverified SDK or ad configuration.

## Recommended provider
Start with one primary provider: Google Mobile Ads (AdMob) through a maintained Godot 4 plugin. Do not bundle several unrelated ad SDKs directly. If mediation is considered later, every mediated SDK and every served creative must satisfy the current Google Play Families requirements.

Useful references:
- Google Play Families policy: https://support.google.com/googleplay/android-developer/answer/9893335
- Families self-certified SDK program and current certified-version list: https://support.google.com/googleplay/android-developer/answer/9900633
- AdMob child/family compliance: https://support.google.com/admob/answer/6223431
- Google age-treatment settings: https://support.google.com/admob/answer/6219315
- Godot AdMob plugin documentation: https://godot-sdk-integrations.github.io/godot-admob/

## Required release safeguards
1. Verify the exact AdMob SDK/plugin version against the current Families self-certified list before release.
2. Apply child age treatment (CHILD) to requests for this child-directed game and use a G maximum ad content rating. Verify the exact plugin API for the selected version.
3. Do not enable personalized ads, interest-based ads, remarketing, or ad identifier collection for child users.
4. No banner, interstitial, app-open, or unsolicited ads in the child gameplay flow.
5. Rewarded ads, if approved for the final release, must be optional, clearly described, parent-enabled behind the parental gate, and reward only after the SDK's verified earned-reward callback.
6. Do not reward a click. Never make an ad necessary to complete a level or obtain core progress.
7. Maintain a privacy policy and accurate Play Console Data Safety disclosures for all SDK data practices.

## Configuration still required
- A registered AdMob app ID and rewarded-ad unit ID from the publisher.
- A maintained Godot 4 plugin release compatible with the project's Godot version.
- Android export template and plugin setup.
- A real-device test using Google's test ad units before any production IDs are used.

Never commit publisher secrets or production IDs to a public repository. Use test IDs during development.
