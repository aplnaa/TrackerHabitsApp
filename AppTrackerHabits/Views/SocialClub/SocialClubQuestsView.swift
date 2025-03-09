import SwiftUI

struct SocialClubQuestsView: View {
    @Binding var selectedTab: Int
    
    // Данные для квестов
    let activeQuests = [
        SocialQuests(id: 1, title: "Марафон здоровья", progress: "24/30", days: "дней", percentage: 0.8, medal: "GOLD", participants: ["avatar1", "avatar3", "avatar5", "avatar4", "avatar3"]),
        SocialQuests(id: 2, title: "Книжный клуб", progress: "10/20", days: "дней", percentage: 0.5, medal: "SILVER", participants: ["avatar1", "avatar2", "avatar3", "avatar4"])
    ]
    
    let inProgressQuests = [
        SocialQuests(id: 3, title: "Отказ от сладкого", progress: "9/30", days: "дней", percentage: 0.3, medal: "BRONZE", participants: ["avatar5", "avatar1", "avatar4"])
    ]
    
    let completedQuests = [
        SocialQuests(id: 4, title: "Йога-челлендж", progress: "14/14", days: "дней", percentage: nil, medal: "COMPLETED", participants: ["avatar2", "avatar3", "avatar5"]),
        SocialQuests(id: 5, title: "Медитация 7 дней", progress: "30/30", days: "дней", percentage: nil, medal: "COMPLETED", participants: ["avatar3", "avatar1"])
    ]
    
    var displayedQuests: [SocialQuests] {
        switch selectedTab {
        case 0: return activeQuests
        case 1: return inProgressQuests
        case 2: return completedQuests
        default: return []
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Вкладки квестов
            QuestTabPicker(selection: $selectedTab)
                .padding(.horizontal)
                .padding(.top, 10)
            
            VStack(spacing: 20) {
                Text("Командные квесты")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Список квестов
                ForEach(displayedQuests) { quest in
                    SocialQuestCards(quest: quest, isCompleted: selectedTab == 2)
                }
            }
        }
    }
}

struct QuestTabPicker: View {
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

struct SocialQuestCards: View {
    let quest: SocialQuests
    let isCompleted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(quest.title)
                        .font(.headline)
                    
                    if !isCompleted {
                        Text("Прогресс: \(quest.progress) \(quest.days)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColors.primary)
                        .font(.title)
                } else {
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
            }
            
            if !isCompleted {
                VStack(alignment: .trailing, spacing: 5) {
                    ProgressView(value: quest.percentage ?? 0.0)
                        .progressViewStyle(CustomProgressViewStyle(color: AppColors.primary))
                    
                    Text("\(Int((quest.percentage ?? 0.0) * 100))%")
                        .font(.caption)
                        .foregroundColor(AppColors.primary)
                }
            }
            
            HStack {
                ForEach(quest.participants, id: \ .self) { participant in
                    Image(participant)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .background(Circle().fill(AppColors.primary))
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


struct SocialQuests: Identifiable {
    let id: Int
    let title: String
    let progress: String
    let days: String
    let percentage: Double?
    let medal: String
    let participants: [String]
}

