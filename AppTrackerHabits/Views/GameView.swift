import SwiftUI

struct GameView: View {
    @State private var selectedTab = 0
    
    // Данные для квестов
    let quests = [
        GameQuest(id: 1, title: "Утренний ритуал", description: "выполняйте утренние привычки 7 дней подряд", progress: "5/7", progressValue: 0.71, days: "дней", difficulty: "легкий", xpReward: 100, trophyReward: 1, isActive: true),
        GameQuest(id: 2, title: "Командный марафон", description: "Командой преодолейте суммарно 100 000 шагов за неделю", progress: "68 000/100 000", progressValue: 0.68, days: "шагов", difficulty: "средний", xpReward: 100, trophyReward: 1, isActive: true),
        GameQuest(id: 3, title: "Цифровой детокс", description: "не используйте смартфон за час до сна в течение 10 дней", progress: "0/10", progressValue: 0.0, days: "дней", difficulty: "сложный", xpReward: 100, trophyReward: 1, isActive: false),
        GameQuest(id: 4, title: "Спортивный вызов", description: "тренируйтесь 5 раз в неделю", progress: "3/5", progressValue: 0.6, days: "тренировок", difficulty: "средний", xpReward: 80, trophyReward: 1, isActive: true),
        GameQuest(id: 5, title: "Книжный марафон", description: "читайте по 30 минут каждый день", progress: "12/14", progressValue: 0.85, days: "дней", difficulty: "легкий", xpReward: 70, trophyReward: 1, isActive: true),
        GameQuest(id: 6, title: "Здоровое питание", description: "не употребляйте фастфуд 21 день", progress: "7/21", progressValue: 0.33, days: "дней", difficulty: "сложный", xpReward: 120, trophyReward: 2, isActive: false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top){
                Image("quests")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .edgesIgnoringSafeArea(.top)
                
                VStack(spacing: 15) {
                    // Заголовок
                    GameHeaderView()
                    // Переключатель типов квестов
                    GameQuestTabPicker(selection: $selectedTab)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                }
            }
            .background(.ultraThinMaterial)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Список квестов
                    ForEach(filteredQuests) { quest in
                        QuestCardView(quest: quest)
                    }
                    
                    // Подсказка
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Подсказка")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Text("Командные квесты дают двойные бонусы вашему персонажу")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .frame(minWidth: 370)
                    }
                    .padding(.vertical)
                    
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.bottom, 40)
                }
                .padding(.vertical)
            }
            .scrollIndicators(.hidden)
            .padding(.top, 20)
        }
        .background(AppColors.background)
        .edgesIgnoringSafeArea(.top)
    }
    
    // Фильтрация квестов в зависимости от выбранной вкладки
    var filteredQuests: [GameQuest] {
        switch selectedTab {
        case 0:
            return quests.filter { $0.isActive }
        case 1:
            return quests.filter { !$0.isActive }
        case 2:
            return []
        default:
            return quests
        }
    }
}

struct GameHeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                HStack {
                    ForEach(0..<8) { i in
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: CGFloat(8 + i % 4)))
                            .rotationEffect(.degrees(Double(i * 45)))
                            .foregroundColor(.white.opacity(0.2))
                            .offset(x: CGFloat(i * 20 - 60), y: CGFloat(i % 2 == 0 ? 10 : -10))
                    }
                }
                
                HStack {
                    Text("Квесты")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        HStack(spacing: 5) {
                            Text("3")
                                .font(.headline)
                            
                            Image(systemName: "trophy.fill")
                                .foregroundColor(Color(hex: "fbc371"))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.white)
                        .cornerRadius(10)
                        
                        HStack(spacing: 5) {
                            Text("96")
                                .font(.headline)
                            
                            Text("XP")
                                .font(.headline)
                        }
                        .padding(.horizontal, 10) // Добавляем horizontal padding
                        .padding(.vertical, 5)
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }
            }
            
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}


struct GameQuestTabPicker: View {
    @Binding var selection: Int
    private let options = ["Активные", "Доступные", "Завершенные"]
    
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
                        .foregroundColor(selection == index ? .primary : .gray)
                }
                .background(selection == index ? AppColors.background : Color.white)
                .clipShape(Capsule())
            }
        }
        .padding(4)
        .background(Color.white)
        .clipShape(Capsule())
    }
}

struct QuestCardView: View {
    let quest: GameQuest
    @State private var showAcceptButtons = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Заголовок квеста
            Text(quest.title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppColors.secondary)
                .cornerRadius(15, corners: [.topLeft, .topRight])
            
            // Описание квеста и дни выполнения
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(quest.description)
                        .font(.subheadline)
                    
                    Text("Прогресс: \(quest.progress) \(quest.days)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Прогресс-бар
                    ProgressView(value: quest.progressValue)
                        .progressViewStyle(CustomProgressViewStyle(color: AppColors.primary))
                    
                    HStack {
                        // Сложность
                        HStack {
                            ForEach(0..<difficultyStars(quest.difficulty), id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(hex: "fbc371"))
                                    .font(.system(size: 14))
                            }
                            
                            Text(quest.difficulty)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .frame(minWidth: 80)
                                .lineLimit(1)
                                .background(difficultyColor(quest.difficulty))
                                .cornerRadius(10)
                        }
                        
                        // Награды
                        HStack(spacing: 5) {
                            Text("+\(quest.xpReward) XP")
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color(hex: "fbc371"))
                                .frame(minWidth: 80)
                                .lineLimit(1)
                                .cornerRadius(50)
                                
                            
                            Text("+\(quest.trophyReward) 🏆")
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color(hex: "fbc371"))
                                .cornerRadius(10)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(minHeight: 150)
                
                Spacer()
                
                // Дни выполнения 
                ZStack {
                    Circle()
                        .fill(Color(hex: "a0d1a2"))
                        .frame(width: 50, height: 50)
                    
                    VStack(spacing: 2) {
                        if quest.title == "Утренний ритуал" {
                            Text("2")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("дня")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        } else if quest.title == "Командный марафон" {
                            Text("3")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("дня")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        } else {
                            Text("10")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("дней")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // Кнопки принять/отклонить для неактивных квестов
            if !quest.isActive && showAcceptButtons {
                HStack {
                    Button(action: {
                        // Принять квест
                    }) {
                        Text("принять")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(AppColors.primary)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Отклонить квест
                    }) {
                        Text("отклонить")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .padding(.horizontal)
        .onAppear {
            if !quest.isActive {
                showAcceptButtons = true
            }
        }
    }
    
    func difficultyStars(_ difficulty: String) -> Int {
        switch difficulty {
        case "легкий":
            return 1
        case "средний":
            return 2
        case "сложный":
            return 3
        default:
            return 1
        }
    }
    
    func difficultyColor(_ difficulty: String) -> Color {
        switch difficulty {
        case "легкий":
            return Color(hex: "a0d1a2")
        case "средний":
            return Color(hex: "fbc371")
        case "сложный":
            return Color(hex: "e57373")
        default:
            return Color.gray
        }
    }
}

struct GameQuest: Identifiable {
    let id: Int
    let title: String
    let description: String
    let progress: String
    let progressValue: Double
    let days: String
    let difficulty: String
    let xpReward: Int
    let trophyReward: Int
    let isActive: Bool
}

