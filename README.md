# Behind The Reefs

An underwater narrative puzzle game for iOS. Players receive a mysterious letter from an ancestor, then dive beneath the ocean to sort scattered sea creatures back into their rightful order, uncovering five hidden keys that unlock a long-lost treasure chest.

---

## Gameplay

The game consists of **five puzzle rounds**. In each round, six colorful sea creatures are scattered across two holding pools on either side of the screen. The player's goal is to **drag and drop** all six creatures into the correct column order based on the round's sorting rule:

| Round | Rule |
|-------|------|
| 1 | Sort by Height |
| 2 | Sort by Number of Legs / Fins |
| 3 | Sort by Eye Direction |
| 4 | Sort by Number of Lines / Pattern |
| 5 | Sort by Number of Dots |

When all six slots are filled, the answer is checked automatically. A correct arrangement rewards the player with a **unique key**. After collecting all five keys, a cinematic chest-opening sequence plays, followed by the ending screen.

A friendly **starfish character** lives in the corner of the puzzle screen and offers hints when the player seems stuck or has the correct creatures in reversed order.

---

## App Flow

```
Main Menu
  ├── New Game → Letter (intro cutscene) → Tutorial → Puzzle
  ├── Continue → Puzzle (resumes from last completed pattern)
  └── Credits

Puzzle
  └── [Pattern solved] → Key Result
        ├── Continue → Puzzle (next pattern)
        ├── Home → Main Menu
        └── [All 5 patterns solved] → Chest Opening → End Screen
```

Players can also open the **Collection View** at any time during the puzzle to review which keys they've already collected.

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| UI | SwiftUI |
| Game Engine | SpriteKit |
| Persistence | SwiftData |
| Audio | AVFoundation |
| Haptics | UIKit / CoreHaptics |
| Architecture | MVVM + custom `NavigationRouter` (`@Observable`) |
| Language | Swift 5 |
| Platform | iOS (landscape) |

---

## Project Structure

```
Behind-The-Reefs/
├── BehindTheReefsApp.swift       # App entry point, SwiftData model container
├── AppRouter.swift               # NavigationRouter + AppRoute enum
│
├── Models/
│   ├── GameProgress.swift        # SwiftData model — tracks completed patterns & keys
│   ├── GameKey.swift             # SwiftData model — one record per key (locked / unlocked)
│   ├── PuzzlePattern.swift       # PuzzleItem enum, SortCategory, all 5 correct orders
│   └── Bubble.swift              # Value type for animated background bubbles
│
├── ViewModels/
│   ├── PuzzleViewModel.swift     # Bridges PuzzleScene events to SwiftUI state
│   ├── CollectionViewModel.swift # Key unlock status for CollectionView
│   └── ResultViewModel.swift
│
├── Views/
│   ├── MainMenuView.swift        # Title screen with animated bubbles and BGM
│   ├── LetterView.swift          # Intro cutscene — animated letter reveal
│   ├── KeyResultView.swift       # Key reward overlay after each solved pattern
│   ├── CollectionView.swift      # Treasure chest showing collected keys
│   ├── ChestOpeningView.swift    # Cinematic all-keys-unlock animation
│   ├── EndView.swift             # Congratulations / ending screen
│   ├── CreditsView.swift         # Team credits overlay
│   └── Components/
│       ├── AudioManager.swift    # Singleton BGM manager
│       └── NewGameAlertView.swift
│
├── Game/
│   ├── Scenes/
│   │   ├── PuzzleScene.swift     # Main SpriteKit scene — drag-and-drop, slots, hints
│   │   ├── TutorialScene.swift   # Simplified scene used in the tutorial
│   │   └── LoadingScene.swift
│   ├── Nodes/
│   │   ├── SeaCreatureNode.swift # PieceNode — draggable creature sprite with idle animation
│   │   └── SlotNode.swift        # Column slot node with highlight on hover
│   └── Views/
│       ├── PuzzleGameView.swift  # SwiftUI wrapper around PuzzleScene
│       ├── TutorialView.swift    # 4-step interactive tutorial
│       └── LoadingGameView.swift
│
├── Services/
│   └── HapticService.swift       # Tap, impact, notification, and prolonged haptics
│
└── Resources/
    ├── Assets/                   # Image assets (backgrounds, creatures, keys, UI)
    ├── Audio/
    │   ├── BGM/                  # mainMenuSound, magicSolo, endingSound, bubbleAudio
    │   └── SFX/                  # buttonSound, chestopen, keyAlertSound, etc.
    └── Fonts/                    # Chewy-Regular, Sniglet-Regular, Sniglet-ExtraBold
```

---

## Key Design Decisions

**Drag-and-drop with automatic slot-swap** — Dropping a creature onto an occupied slot displaces the existing creature back to the nearest pool, keeping the interaction fluid without requiring an explicit "swap" gesture.

**Reverse-order detection** — If the player arranges creatures in the exact reverse of a correct answer, the starfish character surfaces with a specific hint ("The waves don't always flow in one direction…") rather than a generic "something feels off" message.

**Pre-placed pieces on resume** — When a player continues a saved game, the puzzle scene pre-populates the slots with the last completed pattern's arrangement as a visual reference before the next pattern begins.

**Progressive key reward** — Each key has a unique art asset and a silhouette state. The `GameKey` SwiftData model stores the unlock timestamp, and `CollectionView` shows locked keys as black silhouettes that become full-colour once earned and tappable for a detail view.

---

## Credits

| Role | Name |
|------|------|
| Project Manager | Ivana Grasielda |
| Programmer | Bryan Samuel |
| Programmer | Ivone Liwang |
| Programmer | Hana Azizah Nurhadi |
| Art & Design | Angely Georgina J. |
| Mentor | Amelia Alexandra |

© 2026 Behind the Reefs. All rights reserved.
