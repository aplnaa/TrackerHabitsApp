import SwiftUI

import SwiftUI

struct MainTabView: View {
    var character: Character
    @State private var selectedTab = 0
    @State private var showCreateHabit = false
    @StateObject private var habitsViewModel = ViewModelFactory.shared.makeHabitsViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                CharacterView(character: character)
                    .tag(0)
                
                // Используем обновленный HabitsView с ViewModel
                HabitsView(viewModel: habitsViewModel)
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
            CreateHabitView(
                isPresented: $showCreateHabit,
                onHabitCreated: { habit in
                    Task {
                        await habitsViewModel.createHabit(habit: habit)
                    }
                }
            )
            .background(AppColors.background)
        }
    }
}

