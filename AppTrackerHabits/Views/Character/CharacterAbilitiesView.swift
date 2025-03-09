import SwiftUI

struct CharacterAbilitiesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AbilitySection(title: "Базовые", abilities: [
                    AbilityData(title: "Утренняя продуктивность", description: "Повышает эффективность привычек, выполненных до 10AM", icon: "☀️"),
                    AbilityData(title: "Вечерняя концентрация", description: "Увеличивает опыт за привычки после 6PM", icon: "🌙")
                ])
                
                AbilitySection(title: "Продвинутые", abilities: [
                    AbilityData(title: "Сила единомышленников", description: "Усиливает эффект от выполнения командных квестов", icon: "🧠"),
                    AbilityData(title: "Цепная реакция", description: "Увеличивает опыт при выполнении нескольких привычек подряд", icon: "⛓")
                ])
                
                AbilitySection(title: "Уникальные", abilities: [
                    AbilityData(title: "Класс \"Мыслитель\"", description: "Способности, связанные с интеллектуальными привычками", icon: "💡"),
                    AbilityData(title: "Класс \"Творец\"", description: "Способности для креативных и творческих привычек", icon: "💡")
                ])
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}

struct AbilitySection: View {
    let title: String
    let abilities: [AbilityData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .bold()
                .padding(.leading, 10)
            
            VStack(spacing: 10) {
                ForEach(abilities) { ability in
                    AbilityRow(title: ability.title, description: ability.description, icon: ability.icon)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.purple, lineWidth: 2))
                }
            }
            .padding(.horizontal)
        }
    }
}

struct AbilityRow: View {
    var title: String
    var description: String
    var icon: String

    var body: some View {
        HStack(spacing: 15) {
            // Иконка в круге
            ZStack {
                Circle()
                    .fill(AppColors.primary)
                    .frame(width: 50, height: 50)
                
                Text(icon)
                    .font(.system(size: 24))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct AbilityData: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
}
