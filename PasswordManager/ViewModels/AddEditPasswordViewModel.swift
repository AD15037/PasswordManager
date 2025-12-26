import Foundation
import SwiftData

@Observable
class AddEditPasswordViewModel {
    var accountName: String = ""
    var username: String = ""
    var passwordInput: String = ""
    var isEditing: Bool = false
    var editingItem: PasswordItem?
    
    var isValid: Bool {
        !accountName.isEmpty && !username.isEmpty && !passwordInput.isEmpty
    }
    
    var passwordStrength: Double {
        PasswordGenerator.shared.calculateStrength(password: passwordInput)
    }
    
    init(item: PasswordItem? = nil) {
        if let item = item {
            self.editingItem = item
            self.accountName = item.accountName
            self.username = item.username
            self.passwordInput = EncryptionService.shared.decrypt(item.encryptedPassword) ?? ""
            self.isEditing = true
        }
    }
    
    func save(context: ModelContext) {
        guard let encryptedPassword = EncryptionService.shared.encrypt(passwordInput) else { return }
        
        if let item = editingItem {
            item.accountName = accountName
            item.username = username
            item.encryptedPassword = encryptedPassword
            item.timestamp = Date()
        } else {
            let newItem = PasswordItem(
                accountName: accountName,
                username: username,
                encryptedPassword: encryptedPassword
            )
            context.insert(newItem)
        }
    }
}
