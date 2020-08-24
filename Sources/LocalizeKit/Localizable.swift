//
// Copyright (c) 2017 Mario Negro Martín
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit
import LocalizeKitC

// MARK: Localizable
public protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    public func localizedWith(_ arguments: CVarArg...) -> String {
        return String(format: self.localized, locale: Locale.current, arguments: arguments)
    }

    public func pluralLocalizedWith(_ number: Int) -> String {
        if let result = pluralform(Locale.current.languageCode, Int32(number)) {
            let key = "\(self)##{\(String(cString: result))}"
            let translated = key.localizedWith(number)
            if key != translated {
                return translated
            } else {
                return self.localized
            }
        } else {
            return self.localized
        }
    }

    public func pluralLocalizedWith(_ number: Float) -> String {
        if let result = pluralformf(Locale.current.languageCode, number) {
            let key = "\(self)##{\(String(cString: result))}"
            let translated = key.localizedWith(number)
            if key != translated {
                return translated
            } else {
                return self.localized
            }
        } else {
            return self.localized
        }
    }

    public func pluralLocalizedAttributedForLabel(_ label: UILabel, with number: Int) -> NSAttributedString? {
        if let result = pluralform(Locale.current.languageCode, Int32(number)) {
            let key = "\(self)##{\(String(cString: result))}"
            return key.localizedAttributedForLabel(label, with: number)
        } else {
            return nil
        }
    }

    public func pluralLocalizedAttributedForLabel(_ label: UILabel, with number: Float) -> NSAttributedString? {
        if let result = pluralformf(Locale.current.languageCode, number) {
            let key = "\(self)##{\(String(cString: result))}"
            return key.localizedAttributedForLabel(label, with: number)
        } else {
            return nil
        }
    }

    public func localizedAttributedForLabel(_ label: UILabel, with arguments: CVarArg...) -> NSAttributedString? {
        return try? NSMutableAttributedString(data: (String(format: self.localized, locale: Locale.current, arguments: arguments)).data(using: .utf8)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).with(font: label.font, color: label.textColor)
    }

    public func localizedAttributedForLabel(_ label: UILabel) -> NSAttributedString? {
        return try? NSMutableAttributedString(data: (self.localized).data(using: .utf8)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).with(font: label.font, color: label.textColor)
    }

}

// MARK: XIBLocalizable
public protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get {
            return nil
        }
        set(key) {
            text = key?.localized
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get {
            return nil
        }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }

    @IBInspectable public var xibLocKeyDisabled: String? {
        get {
            return nil
        }
        set(key) {
            setTitle(key?.localized, for: .disabled)
        }
    }
}

extension UINavigationItem: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get {
            return nil
        }
        set(key) {
            title = key?.localized
        }
    }
}

extension UIBarItem: XIBLocalizable { // Localizes UIBarButtonItem and UITabBarItem
    @IBInspectable public var xibLocKey: String? {
        get {
            return nil
        }
        set(key) {
            title = key?.localized
        }
    }
}

// MARK: Special protocol to localize multiple texts in the same control
public protocol XIBMultiLocalizable {
    var xibLocKeys: String? { get set }
}

extension UISegmentedControl: XIBMultiLocalizable {
    @IBInspectable public var xibLocKeys: String? {
        get {
            return nil
        }
        set(keys) {
            guard let keys = keys?.components(separatedBy: ","), !keys.isEmpty else {
                return
            }
            for (index, title) in keys.enumerated() {
                setTitle(title.localized, forSegmentAt: index)
            }
        }
    }
}

// MARK: Special protocol to localizaze UITextField's placeholder
public protocol UITextFieldXIBLocalizable {
    var xibPlaceholderLocKey: String? { get set }
}

extension UITextField: UITextFieldXIBLocalizable {
    @IBInspectable public var xibPlaceholderLocKey: String? {
        get {
            return nil
        }
        set(key) {
            placeholder = key?.localized
        }
    }
}

extension UITextView: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get {
            return nil
        }
        set(key) {
            text = key?.localized
        }
    }
}

extension NSMutableAttributedString {

    func with(font: UIFont, color: UIColor) -> NSMutableAttributedString {
        enumerateAttributes(in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired) { (attributes, range, stop) in
            for attribute in attributes {
                if let originalColor = attribute.value as? UIColor {
                    let blackColor = UIColor.black.cgColor
                    let convertedColor = originalColor.cgColor.converted(to: blackColor.colorSpace!, intent: .absoluteColorimetric, options: nil)

                    if convertedColor == blackColor {
                        addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
                    } else {
                        addAttribute(NSAttributedString.Key.foregroundColor, value: originalColor, range: range)
                    }

                }
                if let originalFont = attribute.value as? UIFont, let newFont = applyTraitsFromFont(originalFont, to: font) {
                    addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
                }
            }
        }

        return self
    }

    func applyTraitsFromFont(_ originalFont: UIFont, to newFont: UIFont) -> UIFont? {
        let originalTrait = originalFont.fontDescriptor.symbolicTraits

        if originalTrait.contains(.traitBold) {
            var traits = newFont.fontDescriptor.symbolicTraits
            traits.insert(.traitBold)

            if let fontDescriptor = newFont.fontDescriptor.withSymbolicTraits(traits) {
                return UIFont.init(descriptor: fontDescriptor, size: 0)
            }
        }

        return newFont
    }
}
