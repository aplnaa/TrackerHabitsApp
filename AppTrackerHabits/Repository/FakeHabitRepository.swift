import Foundation

class FakeHabitRepository: HabitRepositoryProtocol {
    private var habits: [Habit] = [
        Habit(
            name: "Трекер воды",
            description: "выпить 5 стаканов воды",
            icon: "💧",
            category: "Здоровье",
            progress: 1.0,
            completed: true,
            lastCompletedDate: Date(),
            streak: 7,
            scheduledDays: [true, true, true, true, true, true, true] // Каждый день
        ),
        Habit(
            name: "Тренировка",
            description: "30 минутное кардио",
            icon: "🏃",
            category: "Здоровье",
            progress: 0.75,
            completed: false,
            lastCompletedDate: Date().addingTimeInterval(-86400),
            streak: 5,
            scheduledDays: [true, false, true, false, true, false, false] // Пн, Ср, Пт
        ),
        Habit(
            name: "Чтение",
            description: "прочитать 20 страниц",
            icon: "📚",
            category: "Развитие",
            progress: 1.0,
            completed: true,
            lastCompletedDate: Date().addingTimeInterval(-86400),
            streak: 14,
            scheduledDays: [true, true, true, true, true, false, false] // Будние дни
        ),
        Habit(
            name: "Медитация",
            description: "10 минут утром",
            icon: "🧘",
            category: "Здоровье",
            progress: 0.5,
            completed: false,
            lastCompletedDate: Date().addingTimeInterval(-86400*2),
            streak: 3,
            scheduledDays: [true, true, true, true, true, true, true] // Каждый день
        ),
        Habit(
            name: "Программирование",
            description: "1 час практики",
            icon: "💻",
            category: "Развитие",
            progress: 0.3,
            completed: false,
            lastCompletedDate: nil,
            streak: 0,
            scheduledDays: [true, true, true, true, true, false, false] // Будние дни
        ),
        Habit(
            name: "Планирование дня",
            description: "Составить план на день",
            icon: "📝",
            category: "Работа",
            progress: 0.0,
            completed: false,
            lastCompletedDate: nil,
            streak: 0,
            scheduledDays: [true, true, true, true, true, false, false] // Будние дни
        ),
        Habit(
            name: "Иностранный язык",
            description: "20 минут практики",
            icon: "🌍",
            category: "Развитие",
            progress: 0.0,
            completed: false,
            lastCompletedDate: nil,
            streak: 0,
            scheduledDays: [false, true, false, true, false, true, false] // Вт, Чт, Сб
        ),
        Habit(
            name: "Здоровый обед",
            description: "Приготовить здоровую пищу",
            icon: "🥗",
            category: "Здоровье",
            progress: 0.0,
            completed: false,
            lastCompletedDate: nil,
            streak: 0,
            scheduledDays: [true, true, true, true, true, false, false] // Будние дни
        )
    ]
    
    func getHabits() async throws -> [Habit] {
        // Имитация сетевой задержки
        try await Task.sleep(nanoseconds: 500_000_000)
        return habits
    }
    
    func updateHabit(_ habit: Habit) async throws {
        // Имитация сетевой задержки
        try await Task.sleep(nanoseconds: 300_000_000)
        
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
        } else {
            throw RepositoryError.habitNotFound
        }
    }
    
    func createHabit(_ habit: Habit) async throws {
        // Имитация сетевой задержки
        try await Task.sleep(nanoseconds: 300_000_000)
        habits.append(habit)
    }
    
    func deleteHabit(id: UUID) async throws {
        // Имитация сетевой задержки
        try await Task.sleep(nanoseconds: 300_000_000)
        
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits.remove(at: index)
        } else {
            throw RepositoryError.habitNotFound
        }
    }
    
    func updateHabitProgress(id: UUID, progress: Double) async throws {
        // Имитация сетевой задержки
        try await Task.sleep(nanoseconds: 200_000_000)
        
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits[index].progress = progress
            
            // Если прогресс 100%, отмечаем как выполненное
            if progress >= 1.0 {
                habits[index].completed = true
                habits[index].lastCompletedDate = Date()
                habits[index].streak += 1
            }
        } else {
            throw RepositoryError.habitNotFound
        }
    }
    
    func completeHabit(id: UUID) async throws {
        // Имитация сетевой задержки
        try await Task.sleep(nanoseconds: 200_000_000)
        
        if let index = habits.firstIndex(where: { $0.id == id }) {
            habits[index].progress = 1.0
            habits[index].completed = true
            habits[index].lastCompletedDate = Date()
            habits[index].streak += 1
        } else {
            throw RepositoryError.habitNotFound
        }
    }
}

