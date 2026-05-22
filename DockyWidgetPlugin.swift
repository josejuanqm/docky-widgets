//
//  DockyWidgetPlugin.swift
//
//  The contract a Docky widget bundle must implement. Drop this file
//  into your Xcode bundle target and have your principal class conform
//  to `DockyWidgetPlugin`. The `@objc(DockyWidgetPlugin)` attribute is
//  required so Docky's Objective-C runtime can resolve the protocol
//  across module boundaries.
//

import AppKit
import Foundation
import SwiftUI

@objc(DockyWidgetPlugin) public protocol DockyWidgetPlugin: AnyObject {
    @objc init()

    /// Reverse-DNS identifier. Must match the `identifier` field in
    /// the marketplace manifest entry, and must remain stable across
    /// releases so persisted dock placements keep their slot.
    var identifier: String { get }

    /// Display name shown in the dock editor.
    var displayName: String { get }

    /// SF Symbol name shown in the editor palette before the widget
    /// renders for the first time.
    var systemImageName: String { get }

    /// Default tile span when the user drops the widget into the dock.
    /// Use 1, 2, 3, or 4.
    var defaultSpanValue: Int { get }

    /// Tile spans the widget supports. Subset of `[1, 2, 3, 4]`.
    var supportedSpanValues: [Int] { get }

    /// Width (in tiles) the expansion preview opens to.
    var expansionWidthTiles: Int { get }

    /// Height (in tiles) the expansion preview opens to.
    var expansionHeightTiles: Int { get }

    /// Whether hovering grows the widget to its expanded size.
    var isExpandable: Bool { get }

    /// Whether the widget appears in the editor palette.
    var includesInPalette: Bool { get }

    /// Whether the widget can be added to a Smart Stack.
    var includesInSmartStack: Bool { get }

    /// Author shown in the Widget Store row. Optional; defaults to "Unknown".
    @objc optional var author: String { get }

    /// Marketing version string shown in the Widget Store row (e.g. "1.2.0").
    /// Optional; defaults to "1.0".
    @objc optional var version: String { get }

    /// Build and return the widget's rendered view. Most widgets wrap a
    /// SwiftUI view in `NSHostingView`, but any `NSView` works.
    ///
    /// - Parameters:
    ///   - cornerRadius: Corner radius of the tile, in points.
    ///   - renderedSpanValue: Current rendered span (1...4).
    ///   - isWithinStack: True when the widget is rendered as part of a Smart Stack.
    ///   - isExpanded: True when the user is hovering and the expansion preview is open.
    ///   - isExpandedPreviewOpen: True when the expanded floating preview window is showing.
    func makeView(
        cornerRadius: CGFloat,
        renderedSpanValue: Int,
        isWithinStack: Bool,
        isExpanded: Bool,
        isExpandedPreviewOpen: Bool
    ) -> NSView
}
