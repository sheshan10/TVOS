# Technical report: Little Discoverers

## Concept and audience

Little Discoverers is a single-player picture-recognition game for children aged 4–7, used together with a grown-up on an Apple TV. The child looks at one large picture and chooses its name from three answers with the Siri Remote. A session is five pictures from one topic. The tone is encouraging. There is no timer, no points taken away, and no ranking against other children.

The three topics are Animals (Cat, Dog, Elephant, Rabbit, Fish), Fruits (Apple, Banana, Orange, Grapes, Watermelon), and Vehicles (Car, Bus, Train, Boat, Airplane).

The proposed value is a short, sofa-distance activity that practices naming familiar things, allows a wrong try without punishment, reads the question aloud, and remembers a small amount of progress on that Apple TV. This is a course prototype, not a measured learning product.

## Similar apps

Mobile educational games and Apple TV apps are not the same catalogue.

PBS KIDS Video is on Apple TV. Its App Store page lists Apple TV, tvOS 15 or later, alongside iPhone, iPad, and Mac. It is a video and live-TV app. It does not ask a child to name a still picture from three choices.

PBS KIDS Games, Khan Academy Kids, and Sago Mini School are interactive learning apps whose US App Store compatibility sections list iPhone and iPad, not Apple TV. Khan Academy’s own device article describes Khan Academy Kids as a mobile-first touch experience and lists phones, tablets, Chromebooks, and Amazon tablets. It does not list Apple TV.

Little Discoverers does not claim to replace those products. The difference in this prototype is the combination of a TV-first remote quiz, local pictures, spoken questions that do not give away the answer, offline play, saved first-try progress, and retries that still let the child finish the picture.

## Screens

1. **Home** shows the name, the tagline “Look. Choose. Discover.”, three sample pictures, Let’s Explore, How to Play, and For Grown-ups. If the question bank is invalid, Let’s Explore is turned off and the error is shown.
2. **Topic selection** shows three illustrated cards, a short description, the saved best first-try score, and Back to Home.
3. **Quiz** shows the topic, picture number, progress, stars, the mystery picture, three answers, feedback, Hear Question, Next Picture, and Leave Adventure.
4. **Results** shows “Wonderful exploring!”, the stars earned this time, the best score, encouragement, Play Again, Choose a Topic, and Back to Home.
5. **For Grown-ups** shows best scores, finished-session counts, unique pictures explored, last completion dates, the narration toggle, a confirmed reset, and a short explanation of scoring and storage.
6. **How to Play** explains topic choice, remote movement, Select, retries, Next Picture, and first-try stars.

## Game rules

The rules live in `QuizSession`, not in the views.

- A session contains the five questions for the chosen topic. In normal play their order and the order of the three answers are shuffled. UI tests launch with `-UITesting`, which keeps the bundled order so remote presses are predictable.
- Next Picture does nothing until the current picture is solved. An unanswered picture cannot be skipped.
- The first selection that matches the correct answer awards one star. A wrong selection, then a correct one, solves the picture and awards no star.
- A disabled wrong answer cannot be selected again. The model also ignores a repeated or unknown choice, so a star cannot be added twice.
- After a correct answer, further selections on that picture are ignored.
- Moving to the next picture clears the wrong choices and the attempt count.
- After the fifth solved picture, the session is complete.
- The view model writes the result once. A later call does not write it again. Play Again starts a new session, which can be saved when that new session is finished.
- Leaving early stops speech and discards the unfinished session. Nothing is written.

Stars on screen are the session’s star count. Encouragement text is chosen from that same count. Views do not recalculate the score.

## Persistence

`ProgressStore` saves one `SavedProgress` value in `UserDefaults` under the key `littlediscoverers.progress.v1`, encoded as JSON. For each topic it stores the best first-try score, the number of finished sessions, the sorted unique picture IDs, and the last completion date. It also stores whether narration is on.

This is a suitable store for this Part B prototype because the record is small, local, and needed only on one Apple TV. It survives relaunch. Reset is one confirmed action and keeps the narration setting. If the stored data cannot be decoded, the app replaces it with an empty record and continues. Out-of-range scores read from storage are clamped.

This does not meet an advanced Part A persistence requirement. It is not a database, it does not sync, and it is not a user account.

The privacy manifest declares User Defaults for reason `CA92.1`: the app reads and writes information that stays inside the app.

UI tests use a separate defaults suite named `littlediscoverers.uitesting` and clear it at launch so a test run does not depend on an old score. Narration is also silenced for those launches so speech does not sit under the remote script. Normal launches use the standard defaults and speak when narration is on.

## Narration

`NarrationService` uses `AVSpeechSynthesizer` from AVFoundation. Apple’s speech synthesis documentation says speech is generated on device and is not sent to a server for processing. The service prefers the `voicePrompt` audio-session mode when `AVAudioSession` reports that the mode is available, because the utterances are short prompts. Otherwise it uses the default mode. The category is `playback`, so the prompt can be heard while the app is in front. If that configuration throws, it tries playback with the default mode and still attempts to speak.

Before a new utterance, any current speech is stopped. If stop is asynchronous, the next line is queued and spoken from the synthesizer’s cancel callback. Speech stops when the child leaves the quiz, when a session ends, when narration is turned off, and when another screen is opened.

Hear Question speaks “What is this?” and the three choices. It does not say which choice is correct and it does not read the fact. A wrong try speaks “Good try! Choose another answer.” A correct answer speaks “Well done!”, the name, and the fact. If narration is off, Hear Question shows that a grown-up can turn it on. It does not speak.

The availability banner for `AVSpeechSynthesizer` should be confirmed in Xcode’s documentation viewer on the Mac. Speech playback was not heard on this Windows machine.

## Remote interaction

The interface uses SwiftUI buttons, `@FocusState`, `defaultFocus`, and `focusSection`. A focused control gets a teal border, a colour change, and a small scale. Reduce Motion removes the scale and keeps the border and colour.

Initial focus is Let’s Explore, the Animals card, the first available answer, Play Again, the narration toggle, or Let’s Explore on How to Play. If the question bank is broken, focus moves to a control that still works.

After a wrong answer, that button is disabled and focus moves to an available answer. After a correct answer, focus moves to Next Picture. The next picture focuses its first answer. Focus changes are scheduled on the next main-queue turn so they land after SwiftUI enables the destination.

Menu uses `onExitCommand`. During an unfinished quiz it asks “Leave this adventure?” and explains that those stars will not be saved. Keep Playing is the cancel action. A short debounce reduces the chance that one Menu press both opens and closes the dialog. Cancel restores the focus that was active before the dialog. Confirming leave stops narration and returns to topic selection without saving.

Other screens use Menu as Back to Home. Home does not trap Menu, so the system can leave the app. The quiz can also be left with the Leave Adventure button, which uses the same confirmation.

The layout is intended for the 1920 by 1080 point canvas used by both HD and 4K Apple TVs. The quiz is one screen, without a scroll view. Pictures and type are large. Margins sit inside the safe area.

## Accessibility

Feedback uses words and symbols as well as colour: “Well done!” with a checkmark, and “Not this one” with a cross. Stars are also written as “2 of 5 first-try stars”. The mystery picture’s accessibility label is “Mystery picture”. It does not include the answer. VoiceOver announcements are posted for the feedback text.

This remains a visual game. Narration reads the question and the choices, but a child who cannot see the picture cannot learn from the picture. The app does not provide a fully nonvisual learning mode. VoiceOver, Reduce Motion, and Dynamic Type behaviour were not tested on Apple TV hardware or a simulator. Do not describe the prototype as fully accessible.

## Architecture

The project is a small MVVM-style app.

| Area | Types |
| --- | --- |
| Models | `TopicID`, `Question`, `QuestionBank`, `QuizSession`, `SavedProgress` |
| Services | `QuestionBankLoader`, `ProgressStore`, `NarrationScript`, `NarrationService` |
| View model | `AppViewModel` owns navigation, the session, saving, and when to speak |
| Views | The six screens, `RootView`, and shared TV controls |

`QuestionBankLoader` checks that there are exactly five questions for each of the three topics, IDs are unique, required fields are nonempty, each question has three distinct choices, the correct answer appears exactly once, and every image name is present in the asset set. At launch it also checks that `UIImage` can load each illustration from the app bundle. A failure is shown on Home and Topics. The quiz cannot start. The app does not crash.

## Content

Facts are short and meant to be accurate for this age: mammals and whiskers, gills, where fruit grows, wheels, tracks, floating, and wings. They are not a science curriculum. A marker should be able to ask you to justify any sentence.

Illustrations were generated as original flat pictures and stored locally. They were looked at on this machine for recognizability: each subject is a single centered object on a cream background, with thick outlines. The boat’s sail has a dark outline so it remains visible on cream.

## Performance and stability

The question file and fifteen JPEGs are in the app bundle. There is no runtime download. The illustration files checked on the authoring machine were 1024 by 1024 pixels and about 2.0 MB together. Decoding that set is a reasonable load for a prototype. It was not profiled.

Speech is one utterance at a time. Animations are short and skipped when Reduce Motion is on. There is no continuous animation. Unreadable progress and invalid content are handled without traps. No frame rate, memory, or launch-time number was measured.

## Challenges

- Apple TV focus does not always move by itself when a button becomes disabled, so the quiz sets the next focus explicitly.
- Menu and an alert can see the same press, so leaving uses a confirmation flag and a short debounce.
- tvOS layout is a 1920 by 1080 point screen for both HD and 4K. Sharpness on 4K still depends on image pixels. These pictures are 1024 pixels square, so a large picture on 4K can look slightly soft.
- Narration could not be heard here. Simulator voices also need to be checked on a Mac.
- Production layered icons and Top Shelf artwork are not in the asset catalog.

## Limitations and future work

Not included, on purpose: accounts, a server, purchases, ads, analytics, multiplayer, a timer, and extra topics. A possible later product could keep these three topics free and sell more topic packs once. That purchase flow is not built.

A later version could add 2x illustrations, a real App Icon and Top Shelf, a nonvisual mode that does not depend on the picture, and a pilot with families. None of those outcomes is demonstrated by this prototype.
