import SwiftUI
import SwiftData

struct PasswordListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [PasswordItem]
    @Binding var selectedItem: PasswordItem?
    
    init(filterString: String, selectedItem: Binding<PasswordItem?>) {
        self._selectedItem = selectedItem
        let sortDescriptors = [SortDescriptor(\PasswordItem.accountName)]
        
        if filterString.isEmpty {
            _items = Query(sort: sortDescriptors)
        } else {
            let predicate = #Predicate<PasswordItem> { item in
                item.accountName.localizedStandardContains(filterString) ||
                item.username.localizedStandardContains(filterString)
            }
            _items = Query(filter: predicate, sort: sortDescriptors)
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(items) { item in
                    PasswordRow(item: item)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
            }
            .padding(20)
        }
        .overlay {
            if items.isEmpty {
                ContentUnavailableView(
                    "No Passwords",
                    systemImage: "lock.shield",
                    description: Text("Add your first password by tapping the plus button.")
                )
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedItem: PasswordItem?
    PasswordListView(filterString: "", selectedItem: $selectedItem)
        .modelContainer(for: PasswordItem.self, inMemory: true)
}
