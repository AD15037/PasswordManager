import SwiftUI
import SwiftData

struct HomeView: View {
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

#Preview {
    HomeView()
        .modelContainer(for: PasswordItem.self, inMemory: true)
}
