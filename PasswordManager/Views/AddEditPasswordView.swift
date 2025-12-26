import SwiftUI
import SwiftData

struct AddEditPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var viewModel: AddEditPasswordViewModel
    @State private var isPasswordVisible: Bool = false
    
    init(item: PasswordItem? = nil) {
        _viewModel = State(initialValue: AddEditPasswordViewModel(item: item))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Field: Account Name
            VStack(alignment: .leading, spacing: 8) {
                CustomTextField(placeholder: "Account Name", text: $viewModel.accountName)
            }
            
            // Field: Username / Email
            VStack(alignment: .leading, spacing: 8) {
                CustomTextField(placeholder: "Username/ Email", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            }
            
            // Field: Password
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $viewModel.passwordInput)
                    } else {
                        SecureField("Password", text: $viewModel.passwordInput)
                    }
                    
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(Color.white)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(hex: "CBCBCB"), lineWidth: 0.6)
                )
            }
            
            Spacer()
            
            // Action Button
            Button(action: {
                viewModel.save(context: modelContext)
                dismiss()
            }) {
                Text(viewModel.isEditing ? "Update Account" : "Add New Account")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(AppColors.buttonDark)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1)
            }
            .disabled(!viewModel.isValid)
            .opacity(viewModel.isValid ? 1.0 : 0.5)
        }
        .padding(30)
        .background(Color(hex: "F9F9F9"))
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(Color.white)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(hex: "CBCBCB"), lineWidth: 0.6)
            )
            .font(.system(size: 13, weight: .medium))
    }
}

#Preview {
    AddEditPasswordView()
        .modelContainer(for: PasswordItem.self, inMemory: true)
}