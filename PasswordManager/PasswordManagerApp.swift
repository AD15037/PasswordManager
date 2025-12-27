import SwiftUI
import SwiftData

@main
struct PasswordManagerApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: PasswordItem.self)
    }
}
