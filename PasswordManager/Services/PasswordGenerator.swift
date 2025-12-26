import Foundation

class PasswordGenerator {
    static let shared = PasswordGenerator()
    
    enum Option {
        case uppercase, lowercase, numbers, special
    }
    
    func generate(length: Int = 12, options: Set<Option> = [.uppercase, .lowercase, .numbers, .special]) -> String {
        var charset = ""
        if options.contains(.lowercase) { charset += "abcdefghijklmnopqrstuvwxyz" }
        if options.contains(.uppercase) { charset += "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
        if options.contains(.numbers) { charset += "0123456789" }
        if options.contains(.special) { charset += "!@#$%^&*()_+-=[]{}|;:,.<>?" }
        
        if charset.isEmpty { return "" }
        
        return String((0..<length).map { _ in
            charset.randomElement()!
        })
    }
    
    func calculateStrength(password: String) -> Double {
        var score = 0.0
        if password.isEmpty { return 0.0 }
        
        if password.count >= 8 { score += 0.25 }
        if password.count >= 12 { score += 0.25 }
        if password.rangeOfCharacter(from: .uppercaseLetters) != nil { score += 0.1 }
        if password.rangeOfCharacter(from: .lowercaseLetters) != nil { score += 0.1 }
        if password.rangeOfCharacter(from: .decimalDigits) != nil { score += 0.15 }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?")) != nil { score += 0.15 }
        
        return min(score, 1.0)
    }
}
