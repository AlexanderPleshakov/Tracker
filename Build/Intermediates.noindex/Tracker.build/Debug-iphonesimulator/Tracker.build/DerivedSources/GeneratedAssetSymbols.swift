import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

    /// The "TBlue" asset catalog color resource.
    static let tBlue = ColorResource(name: "TBlue", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "AddButton" asset catalog image resource.
    static let addButton = ImageResource(name: "AddButton", bundle: resourceBundle)

    /// The "AddTracker" asset catalog image resource.
    static let addTracker = ImageResource(name: "AddTracker", bundle: resourceBundle)

    /// The "BlueImage" asset catalog image resource.
    static let blue = ImageResource(name: "BlueImage", bundle: resourceBundle)

    /// The "DoneTracker" asset catalog image resource.
    static let doneTracker = ImageResource(name: "DoneTracker", bundle: resourceBundle)

    /// The "Logo" asset catalog image resource.
    static let logo = ImageResource(name: "Logo", bundle: resourceBundle)

    /// The "Pin" asset catalog image resource.
    static let pin = ImageResource(name: "Pin", bundle: resourceBundle)

    /// The "RedImage" asset catalog image resource.
    static let red = ImageResource(name: "RedImage", bundle: resourceBundle)

    /// The "ResetTextField" asset catalog image resource.
    static let resetTextField = ImageResource(name: "ResetTextField", bundle: resourceBundle)

    /// The "SearchStub" asset catalog image resource.
    static let searchStub = ImageResource(name: "SearchStub", bundle: resourceBundle)

    /// The "StatisticStub" asset catalog image resource.
    static let statisticStub = ImageResource(name: "StatisticStub", bundle: resourceBundle)

    /// The "StubImage" asset catalog image resource.
    static let stub = ImageResource(name: "StubImage", bundle: resourceBundle)

    /// The "TCheckmark" asset catalog image resource.
    static let tCheckmark = ImageResource(name: "TCheckmark", bundle: resourceBundle)

    /// The "TabStatistic" asset catalog image resource.
    static let tabStatistic = ImageResource(name: "TabStatistic", bundle: resourceBundle)

    /// The "TabTracks" asset catalog image resource.
    static let tabTracks = ImageResource(name: "TabTracks", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "TBlue" asset catalog color.
    static var tBlue: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tBlue)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "TBlue" asset catalog color.
    static var tBlue: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .tBlue)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// The "TBlue" asset catalog color.
    static var tBlue: SwiftUI.Color { .init(.tBlue) }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "TBlue" asset catalog color.
    static var tBlue: SwiftUI.Color { .init(.tBlue) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "AddButton" asset catalog image.
    static var addButton: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .addButton)
#else
        .init()
#endif
    }

    /// The "AddTracker" asset catalog image.
    static var addTracker: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .addTracker)
#else
        .init()
#endif
    }

    /// The "BlueImage" asset catalog image.
    static var blue: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blue)
#else
        .init()
#endif
    }

    /// The "DoneTracker" asset catalog image.
    static var doneTracker: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .doneTracker)
#else
        .init()
#endif
    }

    /// The "Logo" asset catalog image.
    static var logo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo)
#else
        .init()
#endif
    }

    /// The "Pin" asset catalog image.
    static var pin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pin)
#else
        .init()
#endif
    }

    /// The "RedImage" asset catalog image.
    static var red: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .red)
#else
        .init()
#endif
    }

    /// The "ResetTextField" asset catalog image.
    static var resetTextField: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .resetTextField)
#else
        .init()
#endif
    }

    /// The "SearchStub" asset catalog image.
    static var searchStub: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .searchStub)
#else
        .init()
#endif
    }

    /// The "StatisticStub" asset catalog image.
    static var statisticStub: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .statisticStub)
#else
        .init()
#endif
    }

    /// The "StubImage" asset catalog image.
    static var stub: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .stub)
#else
        .init()
#endif
    }

    /// The "TCheckmark" asset catalog image.
    static var tCheckmark: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tCheckmark)
#else
        .init()
#endif
    }

    /// The "TabStatistic" asset catalog image.
    static var tabStatistic: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabStatistic)
#else
        .init()
#endif
    }

    /// The "TabTracks" asset catalog image.
    static var tabTracks: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabTracks)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "AddButton" asset catalog image.
    static var addButton: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .addButton)
#else
        .init()
#endif
    }

    /// The "AddTracker" asset catalog image.
    static var addTracker: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .addTracker)
#else
        .init()
#endif
    }

    /// The "BlueImage" asset catalog image.
    static var blue: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blue)
#else
        .init()
#endif
    }

    /// The "DoneTracker" asset catalog image.
    static var doneTracker: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .doneTracker)
#else
        .init()
#endif
    }

    /// The "Logo" asset catalog image.
    static var logo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo)
#else
        .init()
#endif
    }

    /// The "Pin" asset catalog image.
    static var pin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pin)
#else
        .init()
#endif
    }

    /// The "RedImage" asset catalog image.
    static var red: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .red)
#else
        .init()
#endif
    }

    /// The "ResetTextField" asset catalog image.
    static var resetTextField: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .resetTextField)
#else
        .init()
#endif
    }

    /// The "SearchStub" asset catalog image.
    static var searchStub: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .searchStub)
#else
        .init()
#endif
    }

    /// The "StatisticStub" asset catalog image.
    static var statisticStub: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .statisticStub)
#else
        .init()
#endif
    }

    /// The "StubImage" asset catalog image.
    static var stub: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .stub)
#else
        .init()
#endif
    }

    /// The "TCheckmark" asset catalog image.
    static var tCheckmark: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tCheckmark)
#else
        .init()
#endif
    }

    /// The "TabStatistic" asset catalog image.
    static var tabStatistic: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabStatistic)
#else
        .init()
#endif
    }

    /// The "TabTracks" asset catalog image.
    static var tabTracks: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabTracks)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ColorResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ImageResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Hashable {

    /// An asset catalog color resource name.
    fileprivate let name: String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Hashable {

    /// An asset catalog image resource name.
    fileprivate let name: String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif