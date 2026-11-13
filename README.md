# Lone Wolf Action Chart

A digital Action Chart for the *Lone Wolf* gamebooks (Kai series, Books 1–5), made to look like the chart printed in the books. It runs in a browser as a single HTML page, and as an Android app.

## Features

- **Combat Skill** and **Endurance Points**, with crossed-out previous scores as you lose Endurance
- **Kai Disciplines**: all ten, with the 5 + 1-per-book limit; Weaponskill rolls its weapon from the book's table
- **Weapons** (2), **Backpack** (8 articles, Meals included), **Meals**, **Belt Pouch** (50 Gold Crowns), **Special Items List** with effects
- **Quiver & Arrows**: carry a Quiver and keep count of up to 6 Arrows
- **Notes**: a note for each book and section, with a list that jumps back to that section, plus general notes
- **Combat Record**: enter the enemy, the Combat Ratio is worked out with Mindblast, Weaponskill, no-weapon and Mindforce modifiers, and each round is resolved on the **Combat Results Table**, with undo and Evade
- **Combat Record History**: every finished fight (won, killed, evaded or broken off) with its book, section, enemy, rounds and Endurance lost
- **Random Number Table**: "close your eyes and point" picks a square, or tap one yourself
- **Day and Night** colours, switched with one button
- The chart is saved automatically on the device

## Files

| Path | What it is |
| --- | --- |
| `lone-wolf-action-chart.html` | The whole chart as one page (open it in a browser) |
| `LoneWolf-android/` | Android app: a WebView that shows the page from the app's assets, with the fonts bundled so it works offline |

## Android app

Download the APK from the [Releases](../../releases) page and open it on the phone (Android 8.0 or newer). Android asks to allow installs from that source. The APK is signed with a debug key, so Play Protect may warn about it.

To build it yourself on Windows (needs JDK 17, Android SDK platform 34 and Gradle 8.7; the script expects them in `%USERPROFILE%\.duelkockica-alati`, edit the paths at the top for your setup):

```powershell
powershell -ExecutionPolicy Bypass -File LoneWolf-android\build-apk.ps1
```

`prepare-chart.ps1` copies the page into the app's assets and, on the first run, downloads the fonts from Google Fonts.

## Notes

This is an unofficial fan-made tool. *Lone Wolf* and its rules, names and tables were created by Joe Dever; the gamebooks are freely available from [Project Aon](https://www.projectaon.org/). Check the Combat Results Table against your own book.

Fonts: IM Fell English, EB Garamond and Kalam, under the SIL Open Font License (via Google Fonts).
