import SwiftUI
import SwiftData

struct PasswordDetailView: View {
    let item: PasswordItem
    @State private var isPasswordVisible: Bool = false
    @State private var showingEditSheet: Bool = false
    
    var decryptedPassword: String {
        EncryptionService.shared.decrypt(item.encryptedPassword) ?? "Error Decrypting"
    }
    
    var body: some View {
        List {
            Section {
                DetailRow(label: "Account", value: item.accountName, icon: "globe")
                DetailRow(label: "Username", value: item.username, icon: "person")
            }
            
            Section(header: Text("Password")) {
                HStack {
                    Image(systemName: "lock")
                        .foregroundStyle(.blue)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading) {
                        Text("Password")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        if isPasswordVisible {
                            Text(decryptedPassword)
                                .font(.body)
                                .monospaced()
                        } else {
                            Text("••••••••")
                                .font(.body)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                    
                    Divider()
                        .frame(height: 20)
                    
                    Button {
                        UIPasteboard.general.string = decryptedPassword
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(item.accountName)
        .toolbar {
            Button("Edit") {
                showingEditSheet = true
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditPasswordView(item: item)
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body)
            }
            Spacer()
            
            Button {
                UIPasteboard.general.string = value
            } label: {
                Image(systemName: "doc.on.doc")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let encrypted = EncryptionService.shared.encrypt("Secret123!") ?? ""
    let item = PasswordItem(accountName: "Example Account", username: "user@example.com", encryptedPassword: encrypted)
    
    return NavigationStack {
        PasswordDetailView(item: item)
    }
    .modelContainer(for: PasswordItem.self, inMemory: true)
}