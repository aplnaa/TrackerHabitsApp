import SwiftUI

struct QuestsTabView: View {
    @Binding var selectedTab: Int
    
    // Данные для квестов
    let quests = [
        SocialQuest(id: 1, title: "Марафон здоровья", progress: "24/30", days: "дней", percentage: 0.8, medal: "GOLD", participants: ["🤖", "🐼", "🦁", "🐶", "🐱"]),
        SocialQuest(id: 2, title: "Книжный клуб", progress: "10/20", days: "дней", percentage: 0.5, medal: "SILVER", participants: ["🤖", "🐼", "🦁", "🐶"]),
        SocialQuest(id: 3, title: "Отказ от сладкого", progress: "9/30", days: "дней", percentage: 0.3, medal: "BRONZE", participants: ["🤖", "🦁", "🐼"])
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Вкладки квестов
            SocialQuestTabPicker(selection: $selectedTab)
                .padding(.horizontal)
                .padding(.top, 10)
            
            VStack(spacing: 20) {
                Text("Командные квесты")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Список квестов
                ForEach(quests) { quest in
                    SocialQuestCard(quest: quest)
                }
            }
        }
    }
}

struct SocialQuestTabPicker: View {
    @Binding var selection: Int
    private let options = ["Активные", "В процессе", "Завершенные"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring()) {
                        selection = index
                    }
                }) {
                    Text(options[index])
                        .font(.system(size: 14, weight: .medium))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
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

struct SocialQuestCard: View {
    let quest: SocialQuest
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(quest.title)
                        .font(.headline)
                    
                    Text("Прогресс: \(quest.progress) \(quest.days)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(quest.medal)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        quest.medal == "GOLD" ? Color(hex: "fbc371") :
                            quest.medal == "SILVER" ? Color.gray.opacity(0.3) :
                            Color(hex: "c58e6b")
                    )
                    .foregroundColor(quest.medal == "GOLD" ? .black : .white)
                    .cornerRadius(10)
            }
            
            // Прогресс-бар
            VStack(alignment: .trailing, spacing: 5) {
                ProgressView(value: quest.percentage)
                    .progressViewStyle(CustomProgressViewStyle(color:
                        quest.medal == "GOLD" ? Color(hex: "fbc371") :
                        quest.medal == "SILVER" ? Color.gray :
                        Color(hex: "c58e6b")
                    ))
                
                Text("\(Int(quest.percentage * 100))%")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Участники
            HStack {
                ForEach(quest.participants, id: \.self) { participant in
                    Text(participant)
                        .font(.system(size: 20))
                        .frame(width: 35, height: 35)
                        .background(AppColors.accent.opacity(0.3))
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .padding(.horizontal)
    }
}

struct SocialQuest: Identifiable {
    let id: Int
    let title: String
    let progress: String
    let days: String
    let percentage: Double
    let medal: String
    let participants: [String]
}

