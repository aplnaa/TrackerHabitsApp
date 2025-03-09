import SwiftUI

struct CharacterAchievementsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AchievementSection(title: "Начальные", achievements: [
                    AchievementData(title: "Первые шаги", description: "Создать 5 разных привычки", icon: "👣"),
                    AchievementData(title: "Знаток приложения", description: "Изучить все разделы приложения", icon: "🎓"),
                    AchievementData(title: "Душа компании", description: "Найти 5 друзей", icon: "🤝🏻"),
                ])
                
                AchievementSection(title: "Прогрессивные", achievements: [
                    AchievementData(title: "Ранняя пташка", description: "Выполнять утренние привычки 14 дней подряд", icon: "☀️")
                ])
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}

struct AchievementSection: View {
    let title: String
    let achievements: [AchievementData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .bold()
                .padding(.leading, 10)
            
            VStack(spacing: 10) {
                ForEach(achievements) { achievement in
                    AchievementRow(title: achievement.title, description: achievement.description, icon: achievement.icon)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.purple, lineWidth: 2))
                }
            }
            .padding(.horizontal)
        }
    }
}

struct AchievementRow: View {
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

struct AchievementData: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
}
