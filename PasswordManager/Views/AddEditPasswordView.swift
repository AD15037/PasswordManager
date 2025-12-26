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
        NavigationStack {
            Form {
                Section(header: Text("Account Details")) {
                    TextField("Account Name (e.g. Google)", text: $viewModel.accountName)
                    TextField("Username / Email", text: $viewModel.username)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
                
                Section(header: Text("Password")) {
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $viewModel.passwordInput)
                        } else {
                            SecureField("Password", text: $viewModel.passwordInput)
                        }
                        
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if !viewModel.passwordInput.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Strength: \(Int(viewModel.passwordStrength * 100))%")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .frame(width: geometry.size.width, height: 4)
                                        .opacity(0.3)
                                        .foregroundStyle(.gray)
                                    
                                    Rectangle()
                                        .frame(width: geometry.size.width * viewModel.passwordStrength, height: 4)
                                        .foregroundStyle(colorForStrength(viewModel.passwordStrength))
                                }
                            }
                            .frame(height: 4)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                        }
                        .padding(.vertical, 4)
                    }
                    
                    Button("Generate Strong Password") {
                        viewModel.passwordInput = PasswordGenerator.shared.generate()
                        isPasswordVisible = true
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Password" : "Add Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save(context: modelContext)
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
    
    private func colorForStrength(_ strength: Double) -> Color {
        if strength < 0.3 { return .red }
        if strength < 0.6 { return .orange }
        if strength < 0.8 { return .yellow }
        return .green
    }
}

#Preview {
    AddEditPasswordView()
        .modelContainer(for: PasswordItem.self, inMemory: true)
}
