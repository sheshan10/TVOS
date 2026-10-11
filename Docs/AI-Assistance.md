# AI assistance disclosure

## What was assisted

A coding assistant in Cursor created this tvOS prototype from the assignment brief in `Docs/Assignment-Prompt.md`. The folder was empty. There was no existing Xcode project to modify.

The assistant:

- Designed the six-screen flow, the scoring rules, and the MVVM-style split
- Wrote the SwiftUI app, the question JSON, the unit tests, and the tvOS UI tests
- Generated the fifteen illustrations and copied them into `Assets.xcassets`
- Wrote the report, rubric map, testing notes, references, viva guide, pitch script, and PowerPoint
- Checked the question bank, asset files, and project paths with Python on Windows
- Looked up App Store and Apple documentation pages used in `Docs/References.md`

The assistant did not have Xcode, a Swift compiler, or an Apple TV simulator. It did not compile the app, run XCTest, hear speech, or operate the Siri Remote.

## What you must still understand, adapt, and test

You are the person who will demonstrate and defend this work. Before submission:

- Read `QuizSession`, `AppViewModel`, `QuestionBankLoader`, and `ProgressStore` until you can explain them aloud.
- Build and run the app on a Mac with the steps in `README.md`.
- Run Command+U. Fix failures yourself or with a later prompt that you keep. Record the real result in `Docs/Testing.md`.
- Play every topic with the simulator remote. Complete the manual checklist.
- Listen to Hear Question, a wrong try, and a correct answer. Confirm the correct choice is not announced early.
- Turn on VoiceOver and Reduce Motion and write what you observe. Do not claim those checks if you skip them.
- Check every fact sentence. Change any sentence you cannot explain.
- Rehearse the pitch in your own words. The revenue idea is a hypothesis. Do not add numbers you have not sourced.
- If you change gameplay, update the tests and the report so they match the code.

## How to keep later prompts

This file and `Docs/Assignment-Prompt.md` are the record of the brief and this round of assistance. Cursor chat history can disappear or stay tied to one machine, so do not treat the chat as your only copy.

For every later session:

1. Copy the prompt you send into `Docs/Prompt-Log.md`, with the date and one line about what you asked to change.
2. After the assistant replies, add a short note of what you accepted, what you rejected, and what you still need to test.
3. If the course asks for transcripts, export or copy the chat into your submission notes as well.
4. Commit the log with the code change it describes, in your own Git repository. Do not commit tokens or Apple certificates.

`Docs/Prompt-Log.md` starts with this session so you have a place to continue.
