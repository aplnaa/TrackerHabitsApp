import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var showCreateHabit: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<6) { index in
                if index == 2 {
                    // Кнопка добавления привычки
                    Button(action: {
                        showCreateHabit = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                } else {
                    // Обычные вкладки
                    Button(action: {
                        selectedTab = index
                    }) {
                        Image(systemName: getIcon(for: index))
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == index ? AppColors.primary : .gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selectedTab == index ? AppColors.primary.opacity(0.2) : Color.clear)
                    .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    func getIcon(for index: Int) -> String {
        switch index {
        case 0: return "person.fill"
        case 1: return "list.bullet"
        case 3: return "bubble.left.fill"
        case 4: return "chart.bar.fill"
        case 5: return "gamecontroller.fill"
        default: return "questionmark"
        }
    }
}
