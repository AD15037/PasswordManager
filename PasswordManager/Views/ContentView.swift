import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var searchText = ""
    @State private var showAddSheet = false
    
    var body: some View {
        NavigationStack {
            PasswordListView(filterString: searchText)
                .navigationTitle("Passwords")
                .searchable(text: $searchText, prompt: "Search accounts")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: { showAddSheet = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showAddSheet) {
                    AddEditPasswordView()
                }
        }
    }
}

struct PasswordListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [PasswordItem]
    
    init(filterString: String) {
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
        List {
            ForEach(items) { item in
                NavigationLink(destination: PasswordDetailView(item: item)) {
                    HStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Text(item.accountName.prefix(1).uppercased())
                                    .font(.headline)
                                    .foregroundStyle(.blue)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(item.accountName)
                                .font(.headline)
                            Text(item.username)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete(perform: deleteItems)
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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: PasswordItem.self, inMemory: true)
}