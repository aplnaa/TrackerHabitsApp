import SwiftUI

struct StatisticsView: View {
    @State private var selectedPeriod = 0
    @State private var selectedMonth = "август"
    @State private var selectedYear = 2025
    
    // Данные для статистики
    let totalHabits = 73
    let completedHabits = 57
    let bestDay = "Вторник"
    let streak = 12
    
    // Данные для категорий
    let categories = [
        CategoryProgress(name: "Здоровье", icon: "💊", progress: 0.85),
        CategoryProgress(name: "Развитие", icon: "📚", progress: 0.65),
        CategoryProgress(name: "Работа", icon: "💼", progress: 0.75)
    ]
    
    // Данные для календаря
    let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    let daysInMonth = 31
    let daysActivity: [Double] = (1...31).map { _ in Double.random(in: 0...1) }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Image("statisticback")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 20)
                    .edgesIgnoringSafeArea(.top)
                
                VStack(spacing: 20) {
                    // Заголовок
                    StatisticHeaderView()
                    
                    // Переключатель периода
                    PeriodPicker(selection: $selectedPeriod)
                        .padding(.horizontal)
                }
                .frame(height: 160)
            }
        
        ScrollView {
                // Общий прогресс
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [AppColors.gradient1, AppColors.gradient2]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .cornerRadius(20)
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("ОБЩИЙ ПРОГРЕСС")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("Выполнено привычек: \(completedHabits)/\(totalHabits)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            
                            Text("Лучший день: \(bestDay)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            
                            Text("Серия: \(streak) дней")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Круговой прогресс
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 10)
                                .frame(width: 100, height: 100)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(completedHabits) / CGFloat(totalHabits))
                                .stroke(Color.white, lineWidth: 10)
                                .frame(width: 100, height: 100)
                                .rotationEffect(.degrees(-90))
                            
                            Text("\(Int((Double(completedHabits) / Double(totalHabits)) * 100))%")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 100, height: 100)
                    }
                    .padding()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Прогресс по категориям
                VStack(alignment: .leading, spacing: 15) {
                    Text("Прогресс по категориям")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(categories) { category in
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(AppColors.primary.opacity(0.3))
                                    .frame(width: 40, height: 40)
                                
                                Text(category.icon)
                                    .font(.system(size: 20))
                            }
                            
                            Text(category.name)
                                .font(.subheadline)
                                .padding(.leading, 5)
                            
                            Spacer()
                            
                            Text("\(Int(category.progress * 100))%")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        ProgressView(value: category.progress)
                            .progressViewStyle(CustomProgressViewStyle(color: AppColors.primary, height: 8))
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal)
                
                // Календарь активности
                VStack(alignment: .leading, spacing: 15) {
                    Text("Календарь активности за \(selectedMonth) \(selectedYear)")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if selectedPeriod == 0 {
                        // Неделя
                        WeekActivityView(daysActivity: Array(daysActivity.prefix(7)), weekdays: weekdays)
                    } else if selectedPeriod == 1 {
                        // Месяц
                        MonthActivityView(daysActivity: daysActivity, daysInMonth: daysInMonth, weekdays: weekdays)
                    } else {
                        // Год
                        YearActivityView()
                    }
                }
                .padding(.vertical)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal)
                            
                
                // Рекомендации
                VStack(alignment: .leading, spacing: 10) {
                    Text("Рекомендации")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text("Вы проявляете наибольшую активность по вторникам. Сделайте этот день ключевым для начала новых привычек")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
        }
        .scrollIndicators(.hidden)
        .background(AppColors.background)
        .edgesIgnoringSafeArea(.top)
    
    }
    
    func colorForActivity(_ activity: Double) -> Color {
        if activity < 0.3 {
            return AppColors.primary.opacity(0.3)
        } else if activity < 0.6 {
            return AppColors.primary.opacity(0.6)
        } else {
            return AppColors.primary
        }
    }
    
    func monthName(_ month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.monthSymbols[month - 1]
    }
}

struct StatisticHeaderView: View {
    var body: some View {
        ZStack {
            HStack {
                ForEach(0..<15) { i in
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: CGFloat(8 + i % 4)))
                        .rotationEffect(.degrees(Double(i * 45)))
                        .foregroundColor(.black.opacity(0.2))
                        .offset(x: CGFloat(i * 20 - 60), y: CGFloat(i % 2 == 0 ? 10 : -10))
                }
            }
            
            HStack {
                Spacer()

                Text("Ваша статистика")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, -10)

                Spacer()
                Button(action: {
                    // Действие экспорта
                }) {
                    Image(systemName: "arrow.down.doc")
                        .foregroundColor(.white)
                        .padding(1)
                    }
                }
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            .padding(.trailing)
        }
    }
}

struct PeriodPicker: View {
    @Binding var selection: Int
    private let periods = ["Неделя", "Месяц", "Год"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(periods.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring()) {
                        selection = index
                    }
                }) {
                    Text(periods[index])
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

struct CategoryProgress: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let progress: Double
}

// Представление активности за неделю
struct WeekActivityView: View {
    let daysActivity: [Double]
    let weekdays: [String]
    
    var body: some View {
        VStack(spacing: 10) {
            // Дни недели
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Дни недели с активностью
            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { day in
                    VStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colorForActivity(daysActivity[day]))
                            .frame(height: 40)
                        
                        Text("\(day + 1)")
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    func colorForActivity(_ activity: Double) -> Color {
        if activity < 0.3 {
            return AppColors.primary.opacity(0.3)
        } else if activity < 0.6 {
            return AppColors.primary.opacity(0.6)
        } else {
            return AppColors.primary
        }
    }
}

// Представление активности за месяц
struct MonthActivityView: View {
    let daysActivity: [Double]
    let daysInMonth: Int
    let weekdays: [String]
    
    var body: some View {
        VStack(spacing: 10) {
            // Дни недели
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Календарная сетка
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                ForEach(0..<daysInMonth, id: \.self) { day in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colorForActivity(daysActivity[day]))
                        .frame(height: 40)
                        .overlay(
                            Text("\(day + 1)")
                                .font(.caption)
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(.horizontal)
        }
    }
    
    func colorForActivity(_ activity: Double) -> Color {
        if activity < 0.3 {
            return AppColors.primary.opacity(0.3)
        } else if activity < 0.6 {
            return AppColors.primary.opacity(0.6)
        } else {
            return AppColors.primary
        }
    }
}

// Представление активности за год
struct YearActivityView: View {
    // Данные эффективности по месяцам (пример)
    let monthlyEfficiency: [Double] = [
        0.65, 0.72, 0.58, 0.81, 0.75, 0.90,
        0.85, 0.78, 0.65, 0.72, 0.80, 0.88
    ]
    
    let months = ["Янв", "Фев", "Мар", "Апр", "Май", "Июн",
                  "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]
    
    var body: some View {
        VStack(spacing: 15) {
            // График эффективности
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<12, id: \.self) { month in
                    VStack(spacing: 4) {
                        // Столбец графика
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colorForEfficiency(monthlyEfficiency[month]))
                            .frame(height: CGFloat(monthlyEfficiency[month] * 100))
                        
                        // Название месяца
                        Text(months[month])
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            .frame(height: 120)
            
            // Легенда
            HStack(spacing: 15) {
                HStack(spacing: 5) {
                    Circle()
                        .fill(AppColors.primary.opacity(0.3))
                        .frame(width: 10, height: 10)
                    
                    Text("Низкая")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 5) {
                    Circle()
                        .fill(AppColors.primary.opacity(0.6))
                        .frame(width: 10, height: 10)
                    
                    Text("Средняя")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 5) {
                    Circle()
                        .fill(AppColors.primary)
                        .frame(width: 10, height: 10)
                    
                    Text("Высокая")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
        }
    }
    
    func colorForEfficiency(_ efficiency: Double) -> Color {
        if efficiency < 0.3 {
            return AppColors.primary.opacity(0.3)
        } else if efficiency < 0.7 {
            return AppColors.primary.opacity(0.6)
        } else {
            return AppColors.primary
        }
    }
}
