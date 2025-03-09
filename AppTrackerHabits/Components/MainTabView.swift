import SwiftUI

struct MainTabView: View {
    var character: Character
    @State private var selectedTab = 0
    @State private var showCreateHabit = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                CharacterView(character: character)
                    .tag(0)
                
                HabitsView()
                    .tag(1)
                
                // Пустой вид для кнопки добавления
                Color.clear
                    .tag(2)
                
                SocialClubView()
                    .tag(3)
                
                StatisticsView()
                    .tag(4)
                
                GameView()
                    .tag(5)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            CustomTabBar(selectedTab: $selectedTab, showCreateHabit: $showCreateHabit)
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showCreateHabit) {
            CreateHabitView(isPresented: $showCreateHabit)
                .background(AppColors.background)
        }
    }
}

