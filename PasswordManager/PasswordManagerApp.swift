import SwiftUI
import SwiftData

@main
struct PasswordManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: PasswordItem.self)
    }
}