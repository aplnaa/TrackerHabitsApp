import Foundation
import SwiftUI
import Combine

class HabitsViewModel: ObservableObject {
    // UseCases
    private let getHabitsUseCase: GetHabitsUseCase
    private let updateHabitProgressUseCase: UpdateHabitProgressUseCase
    private let completeHabitUseCase: CompleteHabitUseCase
    private let createHabitUseCase: CreateHabitUseCase
    private let deleteHabitUseCase: DeleteHabitUseCase
    
    // Published state
    @Published var habits: [Habit] = []
    @Published var filteredHabits: [Habit] = []
    @Published var selectedCategory: Int = 0
    @Published var state: ViewState = .loading
    @Published var error: String? = nil
    @Published var completedCount: Int = 0
    @Published var totalCount: Int = 0
    @Published var progressPercentage: Int = 0
    
    // Календарь
    @Published var calendarViewModel: CalendarViewModel
    
    // Категории привычек
    let categories = ["Здоровье", "Развитие", "Работа"]
    
    init(
        getHabitsUseCase: GetHabitsUseCase,
        updateHabitProgressUseCase: UpdateHabitProgressUseCase,
        completeHabitUseCase: CompleteHabitUseCase,
        createHabitUseCase: CreateHabitUseCase,
        deleteHabitUseCase: DeleteHabitUseCase
    ) {
        self.getHabitsUseCase = getHabitsUseCase
        self.updateHabitProgressUseCase = updateHabitProgressUseCase
        self.completeHabitUseCase = completeHabitUseCase
        self.createHabitUseCase = createHabitUseCase
        self.deleteHabitUseCase = deleteHabitUseCase
        
        // Инициализируем календарь
        self.calendarViewModel = CalendarViewModel(currentDate: Date(), habits: [])
        
        // Устанавливаем обратный вызов для обновления привычек при изменении даты
        self.calendarViewModel.onDateSelected = { [weak self] in
            self?.updateFilteredHabits()
        }
        
        // Загружаем привычки при инициализации
        Task {
            await loadHabits()
        }
    }
    
    // Возможные состояния UI
    enum ViewState {
        case loading
        case loaded
        case error
        case empty
    }
    
    // Метод для загрузки привычек
    @MainActor
    func loadHabits() async {
        state = .loading
        error = nil
        
        do {
            habits = try await getHabitsUseCase.execute()
            
            // Обновляем календарь с актуальными привычками
            calendarViewModel.updateCalendar(habits: habits)
            
            // Обновляем отфильтрованные привычки
            updateFilteredHabits()
            
            if habits.isEmpty {
                state = .empty
            } else {
                state = .loaded
            }
        } catch {
            self.error = error.localizedDescription
            state = .error
        }
    }
    
    // Метод для обновления прогресса привычки
    @MainActor
    func updateProgress(habitId: UUID, progress: Double) async {
        do {
            try await updateHabitProgressUseCase.execute(habitId: habitId, progress: progress)
            await loadHabits() // Перезагружаем привычки
        } catch {
            self.error = error.localizedDescription
            state = .error
        }
    }
    
    // Метод для завершения привычки
    @MainActor
    func completeHabit(habitId: UUID) async {
        do {
            try await completeHabitUseCase.execute(habitId: habitId)
            await loadHabits() // Перезагружаем привычки
        } catch {
            self.error = error.localizedDescription
            state = .error
        }
    }
    
    // Метод для создания новой привычки
    @MainActor
    func createHabit(habit: Habit) async {
        do {
            try await createHabitUseCase.execute(habit: habit)
            await loadHabits() // Перезагружаем привычки
        } catch {
            self.error = error.localizedDescription
            state = .error
        }
    }
    
    // Метод для удаления привычки
    @MainActor
    func deleteHabit(habitId: UUID) async {
        do {
            try await deleteHabitUseCase.execute(id: habitId)
            await loadHabits() // Перезагружаем привычки
        } catch {
            self.error = error.localizedDescription
            state = .error
        }
    }
    
    // Метод для изменения выбранной категории
    func selectCategory(index: Int) {
        selectedCategory = index
        updateFilteredHabits()
    }
    
    // Метод для обновления списка отфильтрованных привычек
    func updateFilteredHabits() {
        // Сначала фильтруем по дате
        let habitsForDate = getHabitsForSelectedDate()
        
        // Затем по категории
        if selectedCategory < categories.count {
            filteredHabits = habitsForDate.filter { $0.category == categories[selectedCategory] }
        } else {
            filteredHabits = habitsForDate
        }
        
        updateCompletionStats()
    }
    
    // Получение привычек для выбранной даты
    private func getHabitsForSelectedDate() -> [Habit] {
        let selectedDate = calendarViewModel.selectedDate
        let weekday = Calendar.current.component(.weekday, from: selectedDate) - 1
        let adjustedWeekday = weekday == 0 ? 6 : weekday - 1 // Преобразуем к индексу 0-6, где 0 - понедельник
        
        // Фильтруем привычки, которые запланированы на этот день недели
        return habits.filter { habit in
            return habit.scheduledDays.indices.contains(adjustedWeekday) && habit.scheduledDays[adjustedWeekday]
        }
    }
    
    // Обработчик изменения выбранной даты в календаре
    @MainActor
    func onSelectedDateChanged() {
        // Обновим отображаемые привычки
        updateFilteredHabits()
    }
    
    // Метод для обновления статистики выполнения
    private func updateCompletionStats() {
        totalCount = filteredHabits.count
        completedCount = filteredHabits.filter { $0.completed }.count
        
        if totalCount > 0 {
            progressPercentage = Int((Double(completedCount) / Double(totalCount)) * 100)
        } else {
            progressPercentage = 0
        }
    }
    
    // Метод для определения мотивирующего сообщения
    func getMotivationalMessage() -> String {
        if progressPercentage >= 80 {
            return "Превосходный результат!"
        } else if progressPercentage >= 50 {
            return "Отличное начало, продолжай!"
        } else if progressPercentage > 0 {
            return "Хорошая работа, нужно продолжать!"
        } else {
            return "Начни свой день с полезной привычки!"
        }
    }
    
    // Метод для увеличения прогресса привычки
    func incrementProgress(habit: Habit) {
        Task {
            let newProgress = min(1.0, habit.progress + 0.25)
            await updateProgress(habitId: habit.id, progress: newProgress)
        }
    }
}
