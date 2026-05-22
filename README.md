# Docky Widgets

The marketplace manifest for [Docky](https://getdocky.com)'s Widget Store.

This repository is a **manifest only**. It does **not** host widget binaries. Each entry in `widgets.json` points at an HTTPS URL where the author actually distributes the `.dockywidget` bundle (GitHub Releases, an S3 bucket, the author's own site, wherever).

Docky reads this manifest (proxied through `https://getdocky.com/api/widgets`) and renders the entries in the Widget Store.

## Building a widget

A Docky widget is a regular macOS loadable bundle (`Bundle` target in Xcode) with the wrapper extension `dockywidget`. Its principal class implements the `DockyWidgetPlugin` protocol.

1. Create a new macOS **Bundle** target. Set `Wrapper Extension` to `dockywidget`.
2. Drop [`DockyWidgetPlugin.swift`](./DockyWidgetPlugin.swift) into the target's Compile Sources.
3. Add a Swift file with your principal class. Conform to `DockyWidgetPlugin` and use `@objc(YourClass)` so Docky can resolve it at load time.
4. Set `INFOPLIST_KEY_NSPrincipalClass` to your class's Objective-C name (e.g. `YourClass`) and sign the bundle with a valid Developer ID certificate.

Minimum implementation:

```swift
import AppKit
import SwiftUI

@objc(HelloWidget)
public final class HelloWidget: NSObject, DockyWidgetPlugin {
    public override init() { super.init() }

    public var identifier: String { "com.example.HelloWidget" }
    public var displayName: String { "Hello" }
    public var systemImageName: String { "sparkles" }
    public var author: String { "Your Name" }
    public var version: String { "1.0.0" }

    public var defaultSpanValue: Int { 2 }
    public var supportedSpanValues: [Int] { [1, 2, 3] }
    public var expansionWidthTiles: Int { 3 }
    public var expansionHeightTiles: Int { 3 }
    public var isExpandable: Bool { true }
    public var includesInPalette: Bool { true }
    public var includesInSmartStack: Bool { true }

    public func makeView(
        cornerRadius: CGFloat,
        renderedSpanValue: Int,
        isWithinStack: Bool,
        isExpanded: Bool,
        isExpandedPreviewOpen: Bool
    ) -> NSView {
        NSHostingView(rootView: Text("Hello from my widget").padding())
    }
}
```

## Submitting your widget

Open a pull request that adds one entry to `widgets.json`.

| Field             | Required | Description                                                                                                  |
|-------------------|----------|--------------------------------------------------------------------------------------------------------------|
| `identifier`      | yes      | Reverse-DNS identifier that matches what your plugin returns from `DockyWidgetPlugin.identifier`.            |
| `title`           | yes      | Display name shown in the marketplace.                                                                       |
| `author`          | yes      | Your name or organization.                                                                                   |
| `version`         | yes      | Semantic version, matches what your plugin returns from `DockyWidgetPlugin.version`.                         |
| `downloadURL`     | yes      | HTTPS URL where you host the `.dockywidget` package (or a `.zip` containing one). Arbitrary; your choice.    |
| `sha256`          | no       | Hex SHA-256 of the file at `downloadURL`. When present, Docky verifies the download matches before install.  |
| `previewURL`      | no       | HTTPS URL of a square preview image (PNG / JPG, 512x512 recommended). Also hosted by you.                    |
| `description`     | no       | One-line summary shown under the title.                                                                      |
| `systemImageName` | no       | SF Symbol name for the placeholder shown before the preview image loads.                                     |

### Recommending `sha256`

Although optional, the `sha256` field is strongly recommended. It pins the manifest entry to a specific build of your bundle, so a compromise of the download host can't silently swap in a malicious payload. Generate it with:

```bash
shasum -a 256 MyWidget.dockywidget.zip
```

### Reviewing PRs

Submissions are reviewed for:

- The download URL serves a `.dockywidget` (or zip containing one) that Docky can install.
- `identifier`, `author`, and `version` match what the bundle reports at runtime.
- If `sha256` is provided, the file at `downloadURL` matches it.
- No malicious or misleading behavior.

Approved PRs merge and the manifest goes live immediately.
