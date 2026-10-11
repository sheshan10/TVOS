# Testing

## Environment

Checked on the authoring PC on 10 October 2026:

| Tool | Result |
| --- | --- |
| Windows | Available |
| Git | Available (`git.exe`) |
| Python 3.12 | Available |
| python-pptx 1.0.2 | Available and used to write the PowerPoint |
| Xcode / `xcodebuild` | Not installed |
| Swift compiler | Not installed |
| Apple TV simulator | Not available |
| Physical Apple TV | Not used |

Because Xcode is absent, no Swift file was compiled, no XCTest run, no simulator screenshot was taken, and no speech was heard.

## Checks that were executed

A Python check read `LittleDiscoverers/Resources/questions.json` and `LittleDiscoverers/Assets.xcassets`.

| Check | Result |
| --- | --- |
| Question count | 15 |
| Unique IDs | Yes |
| Questions per topic | Animals 5, Fruits 5, Vehicles 5 |
| Empty fields, choice shape, correct answer once, image name exists as an imageset | No errors reported |
| Illustration files | 15 JPEG imagesets |
| Illustration size | Each image 1024 by 1024 pixels |
| Illustration bytes | About 2.0 MB in total, from the individual file sizes printed during the copy |
| Source files named by the Xcode project | All present |
| Shared scheme | `LittleDiscoverers.xcodeproj/xcshareddata/xcschemes/LittleDiscoverers.xcscheme` exists |
| Illustrations viewed | All 15 were opened. Each is one centered subject on cream, in a flat outlined style, with no text in the picture. The boat sail has a dark outline. |

These checks do not prove that the Xcode project builds.

## Tests written but not executed

Unit tests in `LittleDiscoverersTests`:

| Test | What it covers |
| --- | --- |
| `testFirstTryAwardsOneStar` | One star, and a second selection does not add another |
| `testWrongThenCorrectAwardsNoStar` | Retry solves the picture with zero stars |
| `testRepeatedWrongChoiceIsIgnored` | The same wrong choice does not count twice |
| `testInvalidChoiceIsIgnored` | A choice that is not on the card is ignored and does not skip |
| `testUnansweredQuestionCannotBeSkipped` | Advance is blocked |
| `testAdvanceClearsAttempts` | The next picture starts with a clear attempt |
| `testFiveQuestionCompletionCountsOnlyFirstTries` | Five pictures, three first-try stars, no further changes after completion |
| `testEncouragementFollowsStarCount` | Encouragement uses the star count |
| `testRoundTripAndNarrationPreference` | Save and load, including narration off |
| `testBestScoreIsPreservedWhenLaterScoreIsLower` | Best score stays high, count and date update |
| `testHigherScoreUpdatesBestAndUniqueIDsStayUnique` | Best score rises, explored IDs are a set |
| `testResetClearsProgressAndKeepsNarration` | Reset |
| `testUnreadableDataDoesNotCrashAndBecomesEmpty` | Corrupt `UserDefaults` data |
| `testOutOfRangeStoredScoreIsClamped` | Impossible stored numbers |
| `testValidBankPasses` | A well-formed bank |
| `testBundledBankAndAssetNamesMatch` | The real JSON against the asset-name list |
| `testBundledIllustrationsExistInTheAppBundle` | `UIImage` can see every asset when the app host is running |
| `testMalformedJSONIsReported` | Unreadable JSON |
| `testDuplicateIDsAndWrongTopicCountsFail` | Duplicate IDs |
| `testMissingAssetEmptyFactAndWrongChoiceShapeFail` | Missing picture, empty fact, bad choices, wrong counts |
| `testCorrectAnswerMustAppearOnce` | Correct answer missing or repeated |
| `testUnansweredQuestionDoesNotAdvanceOrSave` | View model will not skip or save |
| `testLeavingAnUnfinishedSessionDiscardsIt` | Leave does not write progress |
| `testCompletedSessionSavesOnceAndASecondAdventureSavesAgain` | One write per finished session, best score kept, a new session can save |
| `testNarrationQuestionDoesNotCallOutTheCorrectChoice` | Question script lists choices and omits the fact |
| `testBrokenContentPreventsQuizStart` | Invalid content blocks the quiz |

UI tests in `LittleDiscoverersUITests/NavigationUITests.swift` use `XCUIRemote` and `-UITesting`:

| Test | What it covers |
| --- | --- |
| `testHomeTopicsAndQuizStartWithExpectedFocus` | Home, Topics, Quiz, initial focus, Next Picture disabled |
| `testWrongAnswerDisablesChoiceAndMovesFocus` | Wrong answer, disabled choice, focus moves, no star |
| `testFirstCorrectAnswerMovesFocusToNextPicture` | First-try correct, focus on Next Picture, one star |
| `testLeaveConfirmationCanBeCancelled` | Menu confirmation, cancel, quiz remains |
| `testFinishQuizThenPlayAgainAndSeeSavedScore` | Five first-try answers, results, then the grown-up score |

`-UITesting` keeps question and choice order fixed and turns narration off so the remote script is stable. The first Animals choices are Dog, Cat, Rabbit. Down, then Select, is the first-try correct path.

These UI tests were not run. They may need timing changes after the first simulator run. Do not record them as passed until Command+U says so.

## Manual checklist

Do this on a Mac with an Apple TV simulator. Tick only what you personally see. Use both an HD-style simulator and a 4K simulator if both runtimes are installed. Repeat a session at least twice to check replay.

| Check | Status |
| --- | --- |
| Home title, tagline, three samples, and three buttons | Not done |
| Let’s Explore opens Topics | Not done |
| How to Play explains remote, retry, Next Picture, and stars, then returns Home | Not done |
| For Grown-ups opens from Home and returns Home | Not done |
| Animals, Fruits, and Vehicles each show five pictures | Not done |
| Best score on a topic card matches For Grown-ups | Not done |
| Quiz shows “What is this?”, three answers, and picture progress | Not done |
| Wrong answer shows “Good try!”, disables that button, and moves focus | Not done |
| Correct answer shows “Well done!”, a checkmark, and the fact | Not done |
| Next Picture stays off until the picture is solved | Not done |
| A star appears only on a first-try correct answer | Not done |
| Retry then correct adds no star | Not done |
| Five pictures reach results | Not done |
| Play Again starts the same topic at picture 1 | Not done |
| Choose a Topic and Back to Home work from results | Not done |
| Menu on an unfinished quiz asks, and Keep Playing stays in the quiz | Not done |
| Leave discards the unfinished score | Not done |
| A finished score is still there after quitting the simulator and launching again | Not done |
| A second full session increments the finished count once | Not done |
| Reset asks first, then clears scores and keeps the narration choice | Not done |
| Hear Question speaks the question and all three choices, not the fact | Not done |
| Success speech includes the name and the fact | Not done |
| Turning narration off stops speech and silences the next question | Not done |
| No screen clips at the edges on the simulator | Not done |
| Quiz does not need scrolling | Not done |
| Reduce Motion still shows focus clearly and skips the star stagger | Not done |
| VoiceOver names controls and does not speak the mystery picture’s answer | Not done |
| Airplane mode or no network still plays a full topic | Not done |
| Play the same topic several times without a crash or a double-counted session | Not done |

## Future checks

These were not done and are not claimed:

- A run on Apple TV hardware
- A VoiceOver user session
- A child or caregiver pilot
- Instruments for memory, launch time, or dropped frames
- App Store validation, icon parallax, and Top Shelf screenshots
- Hearing every voice that `en-US` may resolve to on a simulator
