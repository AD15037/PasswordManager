import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var searchText = ""
    @State private var showAddSheet = false
    @State private var selectedItem: PasswordItem?
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                VStack(spacing: 12) {
                    HStack {
                        Text("Password Manager")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(AppColors.textMain)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Divider()
                        .background(AppColors.cardBorder)
                }
                .background(Color.white)
                
                PasswordListView(filterString: searchText, selectedItem: $selectedItem)
            }
            
            // Floating Add Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showAddSheet = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(AppColors.highlightBlue)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddEditPasswordView()
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $selectedItem) { item in
            PasswordDetailView(item: item)
                .presentationDetents([.height(450)])
                .presentationDragIndicator(.visible)
        }
    }
}

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
    ContentView()
        .modelContainer(for: PasswordItem.self, inMemory: true)
}
