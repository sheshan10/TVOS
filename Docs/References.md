# References

Pages were read while this prototype was written, in October 2026. Store pages change. Open them again before the viva and quote the compatibility lines you see that day.

## Apple TV and mobile learning apps

PBS KIDS Video. Apple App Store. Lists iPhone, iPad, Mac, and Apple TV. The compatibility section read for this report said Apple TV requires tvOS 15.0 or later. The description is streaming and live video, not a three-choice picture quiz.

https://apps.apple.com/us/app/pbs-kids-video/id435138734

PBS KIDS Games. Apple App Store. The compatibility section read for this report listed iPhone (iOS 15.6 or later) and iPad (iPadOS 15.6 or later). Apple TV was not in that list.

https://apps.apple.com/us/app/pbs-kids-games/id1050773989

Khan Academy Kids. Apple App Store. The listings inspected listed iPhone, iPad, and iPod touch. They did not list Apple TV. The minimum iOS version differed between storefronts, so use the storefront you cite.

https://apps.apple.com/us/app/khan-academy-kids/id1378467217

Khan Academy. “Does Khan Academy Kids work with my device?” Support article. Describes a mobile-first touch app for iPhone, iPad, Android, Chromebook, and Amazon tablets. Apple TV is not in the supported-device list on that page.

https://khankids.zendesk.com/hc/en-us/articles/360007054791-Does-Khan-Academy-Kids-work-with-my-device

Sago Mini School (Kids 2–5). Apple App Store. The US listing inspected listed iPhone, iPad, and iPod touch, requiring iOS 15.0 or iPadOS 15.0 or later. Apple TV was not listed.

https://apps.apple.com/us/app/sago-mini-school-kids-2-5/id1483068197

## Apple platform documentation

Speech synthesis. Apple Developer Documentation. Describes `AVSpeechUtterance` and `AVSpeechSynthesizer`, and states that speech generation occurs on device and is not sent to a server for processing.

https://developer.apple.com/documentation/avfoundation/speech-synthesis

AVSpeechSynthesizer. Apple Developer Documentation. Confirm the tvOS availability banner in Xcode on the Mac. A documentation mirror listed tvOS among the supported platforms but did not print a clean minimum version, so that version is not claimed here.

https://developer.apple.com/documentation/avfaudio/avspeechsynthesizer

AVAudioSession. Apple Developer Documentation. Used to set a playback category so spoken prompts can be heard.

https://developer.apple.com/documentation/avfaudio/avaudiosession

availableModes. Apple Developer Documentation. The app checks this before choosing `voicePrompt`.

https://developer.apple.com/documentation/avfaudio/avaudiosession/availablemodes

onExitCommand(perform:). SwiftUI. Used so Menu on an unfinished quiz asks before leaving.

https://developer.apple.com/documentation/swiftui/view/onexitcommand(perform:)

focusSection(). SwiftUI. Used to group answer buttons and the quiz actions.

https://developer.apple.com/documentation/swiftui/view/focussection()

XCUIRemote. XCTest. The UI tests call `XCUIRemote.shared.press` for Select, direction, and Menu.

https://developer.apple.com/documentation/xctest/xcuiremote

Designing for tvOS. Human Interface Guidelines. Focus, safe areas, and the 10-foot layout informed the type size, focus border, and margins.

https://developer.apple.com/design/human-interface-guidelines/designing-for-tvos

Describing use of required reason API. Apple. User Defaults reason `CA92.1` matches app-only storage of progress and the narration setting.

https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api

App Programming Guide for tvOS. Apple’s archived guide. Shows how to conditionalize tvOS code. It is archived, so current HIG and API pages take priority if they disagree.

https://developer.apple.com/library/archive/documentation/General/Conceptual/AppleTV_PG/

## Original material in this prototype

The question sentences, screen copy, and Swift code were written for this assignment. The fifteen pictures were generated for this project and saved in the asset catalog. They were not taken from the App Store apps above. Fact sentences should still be checked by you before you present them as your own knowledge.
