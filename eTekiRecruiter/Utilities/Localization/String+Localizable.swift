
import Foundation

//Localization Protocol
protocol Localizable {
    var localized: String { get }
}

//Localization Helper
extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
