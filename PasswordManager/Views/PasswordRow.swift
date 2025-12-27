import SwiftUI

struct PasswordRow: View {
    let item: PasswordItem
    
    var body: some View {
        HStack {
            Text(item.accountName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.textMain)
            
            Text("*******")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.textSecondary)
                .padding(.leading, 8)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(AppColors.textSecondary)
                .font(.system(size: 14, weight: .bold))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .background(Color.white)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    PasswordRow(item: PasswordItem(accountName: "Google", username: "user@gmail.com", encryptedPassword: "password"))
        .padding()
}
