import SwiftUI

struct CharacterView: View {
    @State private var selectedTab = 0
    var character: Character

    var body: some View {
        VStack(spacing: 0) {
            // Хедер персонажа
            CharacterHeaderView(character: character)
            
            // Вкладки (Характеристики, Способности, Достижения)
            CustomSegmentedPicker(selection: $selectedTab)
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 5)

            // Контент под вкладками
            TabView(selection: $selectedTab) {
                CharacterStatsView(stats: character.stats)
                    .tag(0)
                CharacterAbilitiesView()
                    .tag(1)
                CharacterAchievementsView()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer()
        }
        .background(AppColors.background)
        .edgesIgnoringSafeArea(.top)
    }
}

struct CustomSegmentedPicker: View {
    @Binding var selection: Int
    private let options = ["Характеристика", "Способности", "Достижения"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring()) {
                        selection = index
                    }
                }) {
                    Text(options[index])
                        .font(.system(size: 15, weight: .medium))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .foregroundColor(selection == index ? .white : .black)
                .background(selection == index ? AppColors.secondary : Color.clear)
                .clipShape(Capsule())
            }
        }
        .padding(4)
        .background(Color.white)
        .clipShape(Capsule())
    }
}
