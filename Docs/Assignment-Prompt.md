# Assignment prompt

This is the brief used to create Little Discoverers on 10 October 2026. It is saved here so the request is part of the project, not only in a chat window.

---

You are an experienced Apple tvOS developer. Create a brand-new, standalone native tvOS application called “Little Discoverers” for SE4041 Mobile Application Design and Development Assignment 02, Part B.

Start from scratch in the currently opened empty folder. There is no existing project to modify. This must be a separate Apple TV application, independent of my Part A iOS app. Implement the complete project directly, not just suggestions, sample code, or a project outline.

Use Swift and SwiftUI, targeting tvOS 17 or later. Create an ordinary Xcode project with a shared scheme. Avoid third-party dependencies unless essential. Do not create a website, iOS replacement, backend, login, advertising, analytics, or multiplayer features.

APP CONCEPT

Little Discoverers is a single-player picture-recognition game for children aged 4–7. The child chooses a topic, looks at a large picture, and selects its correct name from three answers using the Apple TV remote.

Include three topics with five pictures each:

Animals: Cat, Dog, Elephant, Rabbit, Fish.
Fruits: Apple, Banana, Orange, Grapes, Watermelon.
Vehicles: Car, Bus, Train, Boat, Airplane.

Create 15 original, recognizable, child-friendly illustrations in a consistent flat style. Include them as local assets in Assets.xcassets. Do not use emoji as the final illustrations or download images at runtime. If image-generation tools are unavailable, create the illustrations programmatically.

GAMEPLAY

Each session contains five pictures from the selected topic in randomized order.

Display “What is this?” above the picture and provide three large answer buttons.

When the answer is correct, show “Well done!”, a checkmark, and a short educational fact. Enable Next Picture.

When the answer is wrong, show “Good try! Choose another answer.” Disable that wrong choice and allow another attempt.

Award one star only when the first attempted answer is correct. Retrying still completes the picture but does not earn its first-try star.

Prevent repeated selections from awarding duplicate stars. Prevent unanswered questions from being skipped. Save each completed session only once.

After five solved pictures, show the final stars, encouraging feedback, Play Again, Choose a Topic, and Back to Home.

Do not add a timer, negative scores, or competitive rankings.

SCREENS

Create six complete screens:

1. Home: app name, “Look. Choose. Discover.” tagline, sample illustrations, Let’s Explore, How to Play, and For Grown-ups.

2. Topic Selection: Animals, Fruits, and Vehicles illustrated cards, short descriptions, saved best scores, and Back to Home.

3. Quiz: topic name, picture number, progress, current stars, large mystery picture, three answers, feedback, Hear Question, Next Picture, and Leave Adventure. Ask for confirmation before leaving an unfinished session.

4. Results: “Wonderful exploring!”, earned stars, final first-try score, best score, encouragement, Play Again, Choose a Topic, and Back to Home.

5. For Grown-ups: best scores, completed session counts, unique pictures explored, last completion dates, narration toggle, confirmed progress reset, and a simple explanation of scoring and local storage.

6. How to Play: simple instructions for topic selection, remote movement, Select, retries, Next Picture, and first-try stars. Include Let’s Explore and Back to Home.

APPLE TV REMOTE INTERACTION

Make the entire app usable with the Siri Remote.

Use native SwiftUI controls, @FocusState, and focus sections where appropriate. Clearly highlight focused controls with a border, colour change, and subtle scaling.

Ensure every control is reachable and focus never becomes trapped.

Give each screen sensible initial focus. After a wrong answer is disabled, move focus to an available answer. After a correct answer, move focus to Next Picture. When the next question appears, focus its first available answer.

Handle Back/Menu consistently. During an unfinished quiz, request confirmation before leaving. Canceling a dialog should restore sensible focus. Leaving the quiz must stop narration and discard unfinished session progress.

Do not depend on touchscreen interaction, mouse hover, or keyboard input.

DESIGN AND ACCESSIBILITY

Use a cream background, dark readable text, teal highlights, rounded cards, and consistent flat illustrations.

Make text and controls readable from a sofa. Use large pictures, comfortable spacing, and safe TV margins. Support 1080p and 4K layouts without clipping or overlapping content. Avoid unnecessary scrolling in the quiz.

Use subtle focus, feedback, and results animations. Respect Reduce Motion. Avoid flashing or continuous distracting animations.

Communicate feedback through text and symbols as well as colour. Provide useful VoiceOver labels, but do not reveal the correct answer through the mystery picture’s accessibility label.

Document that this visual recognition game does not yet provide a fully nonvisual learning mode. Do not claim complete accessibility without testing.

NARRATION

Use AVSpeechSynthesizer to read the question and answer choices without revealing the correct answer.

Speak friendly retry feedback. After success, speak the correct answer and educational fact.

Provide Hear Question and a saved narration preference. Stop previous speech before starting a new utterance. Stop speech when leaving the quiz or disabling narration.

Use appropriate tvOS audio handling and verify API availability against Apple documentation. Verify actual speech playback when Mac or device access is available.

CONTENT VALIDATION

Store the question bank in a bundled JSON file.

Each question must have a unique ID, topic, image asset name, correct answer, three distinct choices, and one short, accurate educational fact.

Validate that there are exactly five questions per topic, IDs are unique, required fields are nonempty, the correct answer appears exactly once, and every image asset exists.

If content loading or validation fails, show a useful error and prevent starting a broken quiz. Do not crash.

ARCHITECTURE

Use a clear, understandable MVVM-style structure:

Models for topics, questions, progress, and quiz state.
Services for content loading, persistence, and narration.
A view model for session lifecycle and navigation.
Views for the six screens and reusable TV controls.
Resources for JSON and pictures.
Separate unit and UI tests.
Documentation in a Docs folder.

Keep scoring, attempts, question advancement, and completion in the model. Views must not independently calculate scores. Avoid unnecessary abstractions and complexity.

PERSISTENCE

Use UserDefaults with Codable, or an equally suitable lightweight local approach, for small progress records.

Save each topic’s best first-try score, completed session count, unique explored picture IDs, and last completion date. Also save narration preference.

Save completed sessions once. Do not save unfinished sessions. Preserve progress after relaunch. Reset only after confirmation. Handle unreadable stored data safely.

Explain why this approach is suitable for this Part B prototype. Do not claim it meets Part A’s advanced persistence requirement.

TESTING

Create meaningful unit tests covering first-try scoring, wrong-then-correct answers, repeated and invalid choices, preventing unanswered-question skipping, clearing attempts between questions, five-question completion, duplicate-result prevention, persistence, best-score preservation, unique explored IDs, reset, incomplete sessions, and malformed content or missing assets.

Create tvOS UI tests using remote input for Home → Topics → Quiz navigation, initial focus, wrong-answer focus transitions, correct-answer focus transitions, exit confirmation and cancellation, and completion/replay where practical.

Provide a manual checklist for all screens, topics, remote navigation, narration, persistence, dialogs, 1080p/4K layouts, Reduce Motion, VoiceOver, offline use, and repeated replays.

Clearly distinguish checks actually executed from tests provided but not executed and future user/device/performance checks. Never invent passing results.

ENVIRONMENT AND VERIFICATION

Check which tools are available.

If macOS and Xcode are available, build for an available Apple TV simulator, run tests, fix project errors and warnings, inspect every screen, and record actual results.

If Xcode is unavailable, create the complete native project and run available structural/content checks. Do not claim Swift compilation, XCTest, simulator, or hardware testing passed. Give exact Mac instructions for remaining verification.

Do not replace the native app with a browser simulation.

ASSIGNMENT REQUIREMENTS

Support the Part B requirements with implementation and documentation:

A clear concept and target audience.
Similar-app research using verifiable primary sources.
A functional tvOS prototype.
Meaningful platform-specific interactions.
Appropriate architecture and coding standards.
Stability and performance considerations.
A stakeholder/investor pitch.
Live demonstration and viva preparation.
Separate GitHub repository instructions.
README build/run instructions.
Original-work references.
AI-assistance disclosure.

Distinguish mobile educational games from apps actually available on Apple TV.

Describe innovation honestly as the combination of TV-first picture learning, narration, offline access, saved progress, and friendly retries. Do not invent market statistics, user studies, learning outcomes, performance measurements, revenue results, or guaranteed marks.

RUBRIC MAPPING

Create a table mapping evidence to the Part B rubric:

Concept Innovation: 25 marks.
Prototype Functionality: 25 marks.
User Experience: 15 marks.
Technical Proficiency: 15 marks.
Pitch Presentation: 20 marks.

For each criterion, identify implemented evidence, supporting files, verification status, and remaining limitations. Do not apply Part A requirements to this project.

PITCH PRESENTATION

Prepare eight slides:

1. App name, tagline, and concept.
2. Problem, audience, and proposed value.
3. Gameplay and features.
4. Why Apple TV and platform-specific interactions.
5. Similar apps and differentiation.
6. Proposed revenue model and go-to-market strategy.
7. Prototype demonstration and actual validation status.
8. Next steps, pilot plan, and potential impact.

Create an editable presentation if suitable tools are available; otherwise provide complete slide content in Markdown.

A possible future revenue model is free starter content with one-time paid topic packs. Present this as a hypothesis. Do not implement purchases in this prototype.

DOCUMENTATION

Create README.md, Docs/Technical-Report.md, Docs/Rubric-Mapping.md, Docs/Testing.md, Docs/References.md, Docs/Viva-Guide.md, Docs/AI-Assistance.md, and the eight-slide pitch.

Explain purpose, audience, similar apps, design choices, architecture, scoring, persistence, narration, accessibility, challenges, testing status, performance considerations, limitations, and future improvements.

Save this full prompt and record your assistance. Explain how I should retain later Cursor prompts and responses. Identify what I still need to understand, adapt, and test myself.

GITHUB

Include an appropriate .gitignore and exact instructions for creating a separate Git repository, making meaningful commits, and pushing to my own GitHub repository.

Do not publish or create an online repository without my instruction. Do not include credentials or tokens.

XCODE PROJECT

Create an ordinary Xcode project with a native tvOS app target, correct source/resource membership, unit-test target, tvOS UI-test target, shared scheme, appropriate Info.plist configuration, deployment target, and bundle identifier.

Do not hard-code a development team or credentials. Do not require a project-generation tool just to open the application.

Document these Mac steps: install compatible Xcode and tvOS runtime, open the .xcodeproj, select the app scheme and Apple TV simulator, run with Command+R, and test with Command+U.

If production app icons or Top Shelf artwork remain incomplete, state that clearly. Do not claim App Store readiness.

FINISHING RULES

Create the complete project directly in this empty folder. Keep the single-player scope. Do not leave placeholder screens or TODOs in core gameplay. Include every asset and question. Verify what the environment permits, fix discovered issues, and keep documentation consistent with the final implementation.

Finish with a concise summary of what you created, checks actually executed, remaining Mac/Apple TV testing, exact run instructions, and remaining actions before assignment submission.
