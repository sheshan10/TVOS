# Pitch script: Little Discoverers

Eight slides. Speaker notes are what to say. The editable deck is `Docs/LittleDiscoverers-Pitch.pptx`. Do not add statistics that are not in `Docs/References.md`.

## Slide 1. Little Discoverers

**On the slide**

Little Discoverers  
Look. Choose. Discover.

A single-player picture-recognition game for Apple TV.  
Children aged 4–7 look at a large picture and choose its name with the Siri Remote.

**Say**

This is a tvOS prototype for our Part B assignment. A child picks Animals, Fruits, or Vehicles, sees one picture, and presses the remote to choose from three names. It is meant to be played on the sofa, not on a phone.

## Slide 2. Problem, audience, and value

**On the slide**

Many early-learning games are built for touch screens.  
A family television is a different place: one remote, a shared screen, and a grown-up nearby.

Little Discoverers offers a short naming activity at TV distance, with a retry that does not take stars away.

**Say**

The audience is children aged 4–7 and the grown-up who sits with them. I am not claiming that television is better for learning. I am saying the interaction has to be designed for a remote. The value in this prototype is a calm five-picture session, not a score against other children.

## Slide 3. Gameplay and features

**On the slide**

- Three topics, five pictures each
- “What is this?” above the picture, with three large answers beside it
- Wrong answers can be tried again
- A star only when the first answer is correct
- Hear Question, a short fact after success, and a saved best score
- Works from pictures stored in the app

**Say**

Walk through one wrong answer and one first-try star. Say that leaving early does not save the session, and finishing saves it once. Mention narration only if you have heard it work.

## Slide 4. Why Apple TV

**On the slide**

- Siri Remote focus, not touch
- Menu asks before an unfinished quiz is thrown away
- Large type and pictures for a 10-foot screen
- The same point layout for HD and 4K, with safe margins
- Spoken prompts through the television

**Say**

Show focus moving from a wrong answer to the next choice, then to Next Picture. Show the leave confirmation and Keep Playing. That is the platform-specific behaviour, not a resized phone screen.

## Slide 5. Similar apps

**On the slide**

On Apple TV: PBS KIDS Video is a streaming and live-TV app.

Not listed as Apple TV apps in the pages I checked: PBS KIDS Games, Khan Academy Kids, and Sago Mini School. Those are touch learning apps.

Little Discoverers is a small remote naming quiz with offline pictures, spoken choices, and local progress. It does not replace those libraries.

**Say**

Read the compatibility line from the live App Store page if you can, because store text changes. Do not say a tablet app is absent from Apple TV unless you have looked at that page yourself.

## Slide 6. Possible revenue and go-to-market

**On the slide**

Hypothesis, not a result: keep Animals, Fruits, and Vehicles free. Later, sell extra topic packs as a one-time purchase.

First step: a supervised pilot with a few families, using this free prototype.  
No purchases are built. No price has been tested. No revenue is claimed.

**Say**

This is a guess about a future model. The prototype has no StoreKit code. I would not pick a price until caregivers had used the free topics.

## Slide 7. Prototype and validation

**On the slide**

Built: six screens, 15 local pictures, scoring, narration code, and progress on device.

Checked on the authoring PC: the question file, the image files, and that the Xcode project files exist.

Not checked yet: Xcode build, XCTest, the simulator, speech audio, VoiceOver, and a real Apple TV.

**Say**

Be exact. If you have since run the app, replace this slide with what you saw, including any failure. Do not say the tests passed unless you ran them.

## Slide 8. Next steps

**On the slide**

- Run the Mac checklist: simulator, remote, narration, relaunch, Reduce Motion, VoiceOver
- Add sharper 4K images, a layered app icon, and Top Shelf art before any store talk
- Pilot with families and decide whether paid topic packs are worth designing
- A fully nonvisual mode is future work, not a claim about this build

Possible impact, if a later pilot supports it: a few calm minutes of shared naming on the family TV. That impact is not measured here.

**Say**

Close on what you will do next, not on a promised mark or a promised learning gain.
