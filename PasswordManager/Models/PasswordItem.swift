import Foundation
import SwiftData

@Model
final class PasswordItem {
    var id: UUID
    var accountName: String
    var username: String
    var encryptedPassword: String
    var timestamp: Date
    
    init(accountName: String, username: String, encryptedPassword: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.accountName = accountName
        self.username = username
        self.encryptedPassword = encryptedPassword
        self.timestamp = timestamp
    }
}
