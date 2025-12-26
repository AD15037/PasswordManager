import Foundation
import CryptoKit

class EncryptionService {
    static let shared = EncryptionService()
    
    private let key: SymmetricKey
    
    private init() {
        let service = "com.passwordmanager.encryption"
        let account = "master_key"
        
        if let keyData = KeychainHelper.shared.read(service: service, account: account) {
            self.key = SymmetricKey(data: keyData)
        } else {
            let newKey = SymmetricKey(size: .bits256)
            self.key = newKey
            let keyData = newKey.withUnsafeBytes { Data($0) }
            KeychainHelper.shared.save(keyData, service: service, account: account)
        }
    }
    
    func encrypt(_ string: String) -> String? {
        guard let data = string.data(using: .utf8) else { return nil }
        
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined?.base64EncodedString()
        } catch {
            print("Encryption error: \(error)")
            return nil
        }
    }
    
    func decrypt(_ base64String: String) -> String? {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            print("Decryption error: \(error)")
            return nil
        }
    }
}
