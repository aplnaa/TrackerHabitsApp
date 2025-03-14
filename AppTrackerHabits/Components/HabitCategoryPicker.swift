import SwiftUI

struct HabitCategoryPicker: View {
    @Binding var selection: Int
    let categories: [String]
    let onSelectCategory: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(categories.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring()) {
                        selection = index
                        onSelectCategory(index)
                    }
                }) {
                    Text(categories[index])
                        .font(.system(size: 16, weight: .medium))
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(selection == index ? .primary : .gray)
                }
                .background(selection == index ? AppColors.background : Color.white.opacity(0.7))
                .clipShape(Capsule())
            }
        }
        .padding(4)
        .background(Color.white)
        .clipShape(Capsule())
    }
}
