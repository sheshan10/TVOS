# Viva and demonstration guide

Speak from what you have run. If a check in `Docs/Testing.md` is still “Not done”, say that plainly.

## Suggested live order

1. Home. Read the name and “Look. Choose. Discover.” Show the three sample pictures.
2. How to Play, briefly. Return Home with the button or Menu.
3. For Grown-ups before any quiz, so the marker sees empty or previous scores.
4. Let’s Explore, choose Animals, and answer one picture wrongly, then correctly. Point at the disabled button, the words “Good try!”, and the missing star.
5. Finish the five pictures, or skip to a second topic if time is short, and open Results. Explain first-try stars versus best score.
6. Play Again or choose Fruits. Then leave an unfinished quiz with Menu, choose Keep Playing, then leave for real and show that the finished count did not change.
7. Turn narration on, press Hear Question, and let the marker hear that the three choices are spoken.
8. Reset only if you are willing to clear the demo data, and only after the confirmation is visible.

Keep a finished session in the simulator before the viva so relaunch persistence is easy to show.

## Questions you should be able to answer

**Who is it for?** Children aged 4–7, with a grown-up nearby, sitting at TV distance.

**Why Apple TV rather than another phone game?** The Siri Remote is the only input. Focus, Menu, and large type are built for that. Name one app that is actually on Apple TV (PBS KIDS Video) and one that is a touch learning game and was not listed for Apple TV (Khan Academy Kids, PBS KIDS Games, or Sago Mini School).

**What is new about it?** The combination of a remote picture quiz, narration that does not give the answer, offline pictures, saved progress, and a retry that does not punish. Do not claim a study or a market size.

**When is a star awarded?** Only when the first attempted answer is correct. Show `QuizSession.select`.

**Can the child skip?** No. `advance()` returns blocked until the picture is solved, and Next Picture is disabled.

**Can the same session be saved twice?** No. `resultCommitted` is set only after `ProgressStore.save` succeeds. Play Again is a new session.

**Why UserDefaults?** The record is a few numbers, IDs, dates, and one Boolean on one device. Say that this is appropriate for this prototype and is not the advanced Part A design.

**What happens if the JSON is corrupt?** The loader returns a problem, Home shows it, and Let’s Explore stays off.

**What happens if saved progress is corrupt?** It is replaced with an empty record. The app continues.

**Where does speech stop?** Leaving the quiz, finishing, turning narration off, and moving to another screen. The question script is `NarrationScript.question`.

**Is it fully accessible?** No. The task is visual. VoiceOver labels and narration help, and they were not tested on hardware.

**What did you not test?** Read the “not executed” section of `Docs/Testing.md` after you have updated it with your own Mac results.

## What you still need to learn

- Walk through `select`, `advance`, and `commitIfNeeded` without reading every line for the first time in the room.
- Explain focus: initial focus, disabled answer, Next Picture, and Menu cancel.
- Explain one illustration choice, for example why the watermelon is a slice and why the boat sail has an outline.
- Rehearse the eight slides in under eight minutes, then leave time for the demo.
- Update `Docs/Testing.md` with the results you actually see. Do not leave the assistant’s “not run” notes if you have since run them, and do not change them to pass if you have not.

## If the demo breaks

- If signing fails, choose your personal team for the simulator run. Do not invent a team ID in the repository.
- If speech is silent, check the simulator volume and the narration toggle. Say that playback still needs confirmation.
- If focus is not where a UI test expects, show the behaviour you see and explain the intended rule.
- If a test fails, show the failure. A honest failure is safer than a claimed pass.
