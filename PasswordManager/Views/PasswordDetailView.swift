import SwiftUI
import SwiftData

struct PasswordDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    let item: PasswordItem
    
    @State private var isPasswordVisible: Bool = false
    @State private var showingEditSheet: Bool = false
    
    var decryptedPassword: String {
        EncryptionService.shared.decrypt(item.encryptedPassword) ?? "********"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Account Details")
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(AppColors.highlightBlue)
                .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Account Type")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                Text(item.accountName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.textMain)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Username/ Email")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                Text(item.username)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.textMain)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Password")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                HStack {
                    Text(isPasswordVisible ? decryptedPassword : "********")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColors.textMain)
                    
                    Spacer()
                    
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(AppColors.textMain)
                            .frame(width: 14, height: 13)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 18) {
                Button(action: {
                    showingEditSheet = true
                }) {
                    Text("Edit")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(AppColors.buttonDark)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1)
                }
                
                Button(action: {
                    modelContext.delete(item)
                    dismiss()
                }) {
                    Text("Delete")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(AppColors.deleteRed)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1)
                }
            }
        }
        .padding(30)
        .background(Color(hex: "F9F9F9"))
        .sheet(isPresented: $showingEditSheet) {
            AddEditPasswordView(item: item)
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    let context = try! ModelContainer(for: PasswordItem.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)).mainContext
    let item = PasswordItem(accountName: "Facebook", username: "Amitshah165@maill.com", encryptedPassword: "")
    return PasswordDetailView(item: item)
}
