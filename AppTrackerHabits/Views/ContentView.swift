import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var characters: [Character]
    
    var body: some View {
        if let character = characters.first {
            MainTabView(character: character)
        } else {
            VStack {
                Text("Персонаж не найден")
                    .font(.title)
                    .padding()
                
                Button("Создать персонажа") {
                    createExampleCharacter()
                }
                .buttonStyle(.borderedProminent)
                .tint(AppColors.primary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
            .onAppear {
                if characters.isEmpty {
                    createExampleCharacter()
                }
            }
        }
    }
    
    private func createExampleCharacter() {
        let stats = [
            Stat(name: "Сила воли", value: 0.7, icon: "💪🏻", percentage: 70),
            Stat(name: "Дисциплина", value: 0.6, icon: "⏱️", percentage: 60),
            Stat(name: "Мудрость", value: 0.8, icon: "📖", percentage: 80)
        ]
        
        let character = Character(
            name: "Burt",
            level: 12,
            experience: 3463,
            maxExperience: 5000,
            avatarName: "avatar1",
            stats: stats
        )
        
        modelContext.insert(character)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

