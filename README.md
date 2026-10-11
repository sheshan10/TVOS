# Little Discoverers

Little Discoverers is a native Apple TV picture-recognition game for children aged 4–7. A child picks a topic, looks at a large picture, and chooses its name with the Siri Remote. The prototype is the tvOS submission for SE4041 Mobile Application Design and Development, Assignment 02, Part B. It is a separate app from any Part A iOS project.

## What is included

- A SwiftUI tvOS app targeting tvOS 17 or later
- Three topics with five pictures each: Animals, Fruits, and Vehicles
- Fifteen original flat illustrations in `Assets.xcassets`
- A bundled question bank, `LittleDiscoverers/Resources/questions.json`
- First-try stars, friendly retries, narration, and local progress
- Unit tests and tvOS UI tests
- Report, rubric map, testing notes, references, viva guide, and an eight-slide pitch

There is no account, network play, advertising, or purchase flow.

## Open and run on a Mac

This project was created on Windows. Xcode and the Swift compiler were not available there, so the app has not been compiled or run yet.

1. Install Xcode from the Mac App Store. Use a version that includes the tvOS 17 SDK or newer. Xcode 15 or later is the practical minimum. A current Xcode release is preferable.
2. Open Xcode once and install the Apple TV simulator runtime if it is not already installed. In Xcode: Settings, Platforms, then the tvOS platform.
3. Copy this folder to the Mac.
4. Open `LittleDiscoverers.xcodeproj`. Do not look for a separate generator or a web version.
5. Select the shared scheme **LittleDiscoverers**.
6. Select an Apple TV simulator, for example Apple TV 4K (3rd generation) or an Apple TV HD simulator.
7. Press Command+R to build and run.
8. Press Command+U to run the unit tests and the tvOS UI tests.

The project does not set a development team. Simulator builds are configured with code signing not required. If Xcode still asks for a team, sign in with an Apple ID under Settings, Accounts, then choose that personal team in Signing & Capabilities. Do not put a team ID, certificate, or token into the project file before you understand what you are committing.

## Remote demo path

1. On Home, the focus starts on **Let's Explore**. Press the clickpad.
2. On Topics, focus starts on **Animals**. Press the clickpad.
3. On the quiz, move with the ring or swipe. Press the clickpad to answer.
4. After a correct answer, focus moves to **Next Picture**.
5. Menu during an unfinished quiz asks before leaving. An unfinished adventure is not saved.
6. After five pictures, the results screen shows first-try stars, **Play Again**, **Choose a Topic**, and **Back to Home**.

## Documentation

| Document | Purpose |
| --- | --- |
| `Docs/Technical-Report.md` | Concept, design, architecture, and limitations |
| `Docs/Rubric-Mapping.md` | Part B rubric evidence |
| `Docs/Testing.md` | What was checked, what was only written, and the manual checklist |
| `Docs/References.md` | Primary sources |
| `Docs/Viva-Guide.md` | Demonstration and questions to prepare |
| `Docs/AI-Assistance.md` | What the assistant did and what you still need to do |
| `Docs/Pitch.md` | Slide script |
| `Docs/LittleDiscoverers-Pitch.pptx` | Editable PowerPoint |
| `Docs/Assignment-Prompt.md` | The brief used to create this prototype |

## Separate GitHub repository

Do this yourself when you want the project online. Nothing in this folder has been pushed.

On a Mac, in Terminal:

```bash
cd /path/to/TV
git init
git add .
git status
git commit -m "Add the Little Discoverers tvOS prototype."
```

Create an empty repository on GitHub named something like `LittleDiscoverers`. Do not add a generated README, license, or `.gitignore` there, because this folder already has them. Then:

```bash
git remote add origin https://github.com/YOUR_USERNAME/LittleDiscoverers.git
git branch -M main
git push -u origin main
```

Use your own username. Do not put a personal access token in a file. If Git asks you to sign in, use GitHub CLI or the macOS credential helper.

A clearer history, if you have not committed yet, is to commit in this order:

1. `Add the tvOS project, question bank, and illustrations.`
2. `Add quiz scoring, progress storage, and narration.`
3. `Add the six SwiftUI screens and remote focus.`
4. `Add unit and UI tests.`
5. `Add the Part B report, pitch, and test notes.`

If everything is already in one working tree, one honest first commit is acceptable. Later changes should be separate commits with messages that say why the change was made.

## App icons and Top Shelf

Layered Apple TV app icons and Top Shelf images are not included. The simulator can still run the prototype. This is not an App Store submission.

## Illustrations

The pictures are local JPEG images, 1024 by 1024 pixels, in a shared flat style. They are not downloaded at runtime and they are not emoji. On a 4K Apple TV they may look slightly soft because separate 2x images were not made.
