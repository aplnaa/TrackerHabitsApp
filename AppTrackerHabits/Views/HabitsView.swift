import SwiftUI

struct HabitsView: View {
    @State private var selectedCategory = 0
    @State private var selectedDay = 1
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    // Данные для привычек
    let habits = [
        Habit(id: 1, name: "Трекер воды", description: "выпить 5 стаканов воды", icon: "💧", category: "Здоровье", progress: 1.0, completed: true),
        Habit(id: 2, name: "Тренировка", description: "30 минутное кардио", icon: "🏃", category: "Здоровье", progress: 1.0, completed: true),
        Habit(id: 3, name: "Чтение", description: "прочитать 20 страниц", icon: "📚", category: "Развитие", progress: 1.0, completed: true),
        Habit(id: 4, name: "Медитация", description: "10 минут утром", icon: "🧘", category: "Здоровье", progress: 0.5, completed: false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top){
                Image("habits")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 320,height: 280)
                    .edgesIgnoringSafeArea(.top)
                
                VStack(spacing: 20) {
                    // Заголовок
                    HabitsHeaderView()
                    // Календарь
                    CalendarView(selectedMonth: $selectedMonth, selectedYear: $selectedYear)
                        .padding(.horizontal)
                    
                    // Категории
                    HabitCategoryPicker(selection: $selectedCategory)
                        .padding(.horizontal)
                }
            }
            .background(.ultraThinMaterial)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Дневной прогресс
                    DailyProgressView(habits: habits)
                        .padding(.horizontal)
                    
                    // Привычки на сегодня
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Привычки на сегодня")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Фильтруем привычки по выбранной категории
                        ForEach(filteredHabits) { habit in
                            HabitRow(habit: habit)
                        }
                    }
                    .padding(.bottom, 100)
                }
                .padding(.vertical)
            }
            .scrollIndicators(.hidden)
        }
        .background(AppColors.background)
        
           
    }
    
    // Фильтрация привычек по выбранной категории
    var filteredHabits: [Habit] {
        let categories = ["Здоровье", "Развитие", "Работа"]
        if selectedCategory < categories.count {
            return habits.filter { $0.category == categories[selectedCategory] }
        }
        return habits
    }
}

struct HabitsHeaderView: View {
    var body: some View {
        ZStack {
            HStack {
                ForEach(0..<8) { i in
                    Image(systemName: "list.bullet")
                        .font(.system(size: CGFloat(8 + i % 4)))
                        .rotationEffect(.degrees(Double(i * 45)))
                        .foregroundColor(.white.opacity(0.2))
                        .offset(x: CGFloat(i * 20 - 60), y: CGFloat(i % 2 == 0 ? 10 : -10))
                }
            }
            
            // Заголовок
            Text("Привычки")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
        }
    }
}

struct CalendarView: View {
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    var body: some View {
        VStack(spacing: 10) {
            // Месяц и год
            HStack {
                Text(monthName(selectedMonth) + ", " + String(selectedYear) + "г")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    if selectedMonth > 1 {
                        selectedMonth -= 1
                    } else {
                        selectedMonth = 12
                        selectedYear -= 1
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                
                Button(action: {
                    if selectedMonth < 12 {
                        selectedMonth += 1
                    } else {
                        selectedMonth = 1
                        selectedYear += 1
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            
            // Дни недели
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Числа
            HStack(spacing: 0) {
                ForEach(1..<8) { day in
                    Text("\(day)")
                        .font(.body)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(day == 1 ? AppColors.background : Color.clear)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    func monthName(_ month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.monthSymbols[month - 1]
    }
}

struct HabitCategoryPicker: View {
    @Binding var selection: Int
    private let categories = ["Здоровье", "Развитие", "Работа"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(categories.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring()) {
                        selection = index
                    }
                }) {
                    Text(categories[index])
                        .font(.system(size: 16, weight: .medium))
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(selection == index ? .primary : .gray)
                }
                .background(selection == index ? AppColors.background : Color.white.opacity(0.7))
                .clipShape(Capsule())
            }
        }
        .padding(4)
        .background(Color.white)
        .clipShape(Capsule())
    }
}

struct DailyProgressView: View {
    let habits: [Habit]
    
    var completedCount: Int {
        habits.filter { $0.completed }.count
    }
    
    var progressPercentage: Int {
        Int((Double(completedCount) / Double(habits.count)) * 100)
    }
    
    var body: some View {
        HStack(spacing: 20) {
            // Круговой прогресс
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: CGFloat(completedCount) / CGFloat(habits.count))
                    .stroke(AppColors.primary, lineWidth: 10)
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                Text("\(progressPercentage)%")
                    .font(.system(size: 24, weight: .bold))
            }
            .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Дневной прогресс")
                    .font(.headline)
                
                Text("\(completedCount) из \(habits.count) привычек выполнено")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Превосходное начало, Burt!")
                    .font(.subheadline)
                    .foregroundColor(AppColors.primary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}

struct HabitRow: View {
    let habit: Habit
    
    var body: some View {
        HStack {
            // Иконка
            ZStack {
                Circle()
                    .fill(AppColors.secondary.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Text(habit.icon)
                    .font(.system(size: 24))
            }
            
            // Название и описание
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name)
                    .font(.headline)
                
                Text(habit.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 2){
                
                Text("\(Int(habit.progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 5)
                
                // Прогресс-бар
                ZStack(alignment: .leading) {
                    // Серый фон для непрогрессивной части
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.barstat)
                        .frame(height: 8)
                    
                    // Активная часть прогресса
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.primary)
                        .frame(width: UIScreen.main.bounds.width * 0.2 * CGFloat(habit.progress), height: 8)
                }
                .frame(width: UIScreen.main.bounds.width * 0.2)
            }
            // Галочка для выполненных
            if habit.completed {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .padding(5)
                    .background(AppColors.primary)
                    .clipShape(Circle())
                    .padding(.leading, 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .padding(.horizontal)
    }
}

struct Habit: Identifiable {
    let id: Int
    let name: String
    let description: String
    let icon: String
    let category: String
    let progress: Double
    let completed: Bool
    
}

