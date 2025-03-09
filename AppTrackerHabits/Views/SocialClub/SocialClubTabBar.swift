import SwiftUI

struct SocialClubTabBar: View {
    @Binding var selection: Int
    private let options = ["Друзья", "Команда", "Квесты"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring()) {
                        selection = index
                    }
                }) {
                    Text(options[index])
                        .font(.system(size: 16, weight: .medium))
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }
                .foregroundColor(selection == index ? .black : .gray)
                .background(selection == index ? Color.white: AppColors.background)
                .clipShape(Capsule())
            }
        }
        .padding(4)
        .background(AppColors.background)
        .clipShape(Capsule())
    }
}

