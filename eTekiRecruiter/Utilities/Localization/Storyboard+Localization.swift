

import UIKit

//Storyboard Localization Protocol
protocol StoryboardLocalizable {
    var localizedKey: String { get set }
}

//Localize UILabel's text through Stroryboard.
extension UILabel: StoryboardLocalizable {
    @IBInspectable
    var localizedKey: String {
        get { return "" }
        set(key) {
            text = key.localized
            accessibilityIdentifier = key
        }
    }
}

//Localize UIButton's title through Stroryboard.
extension UIButton: StoryboardLocalizable {
    @IBInspectable
    var localizedKey: String {
        get { return "" }
        set(key) {
            setTitle(key.localized, for: .normal)
            accessibilityIdentifier = key
        }
    }
}

//Localize UITextField's placeholder through Stroryboard.
extension UITextField: StoryboardLocalizable {
    @IBInspectable
    var localizedKey: String {
        get { return "" }
        set(key) {
            placeholder = key.localized
            accessibilityIdentifier = key
        }
    }
}

//Localize UIViewController's title through Stroryboard.
extension UIViewController: StoryboardLocalizable {
    @IBInspectable
    var localizedKey: String {
        get { return "" }
        set(key) {
            title = key.localized
        }
    }
}
