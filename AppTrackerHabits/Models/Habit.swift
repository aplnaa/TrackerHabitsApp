import Foundation

struct Habit: Identifiable {
    let id: UUID
    var name: String
    var description: String
    var icon: String
    var category: String
    var progress: Double
    var completed: Bool
    var lastCompletedDate: Date?
    var streak: Int
    var scheduledDays: [Bool] // [Пн, Вт, Ср, Чт, Пт, Сб, Вс]
    var reminderTime: Date?
    var dailyGoal: String?
    var notificationsEnabled: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        icon: String,
        category: String,
        progress: Double = 0.0,
        completed: Bool = false,
        lastCompletedDate: Date? = nil,
        streak: Int = 0,
        scheduledDays: [Bool] = [true, true, true, true, true, false, false],
        reminderTime: Date? = nil,
        dailyGoal: String? = nil,
        notificationsEnabled: Bool = true
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.category = category
        self.progress = progress
        self.completed = completed
        self.lastCompletedDate = lastCompletedDate
        self.streak = streak
        self.scheduledDays = scheduledDays
        self.reminderTime = reminderTime
        self.dailyGoal = dailyGoal
        self.notificationsEnabled = notificationsEnabled
    }
}
