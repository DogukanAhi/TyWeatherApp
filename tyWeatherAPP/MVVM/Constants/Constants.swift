import Foundation

enum Constants {
    static var favoriteCityNames: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: "favorites") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "favorites")
        }
    }
}
