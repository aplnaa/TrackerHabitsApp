import SwiftUI
import Combine

// Модель даты календаря
struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let day: Int
    let isInCurrentMonth: Bool
    let isToday: Bool
    var hasHabits: Bool = false
    
    // Сравнение дат (только день, месяц, год)
    static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

// ViewModel для календаря
class CalendarViewModel: ObservableObject {
    @Published var currentDate: Date
    @Published var selectedDate: Date
    @Published var currentWeekDays: [CalendarDay] = []
    @Published var currentWeekNumber: Int = 1
    @Published var totalWeeks: Int = 0
    @Published var habitsByDate: [Date: [Habit]] = [:]
    
    // Callback для уведомления о смене даты
    var onDateSelected: (() -> Void)?
    
    let weekdaySymbols = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    let calendar = Calendar.current
    
    private var cancellables = Set<AnyCancellable>()
    
    var canGoToPreviousWeek: Bool {
        return currentWeekNumber > 1
    }
    
    var canGoToNextWeek: Bool {
        return currentWeekNumber < totalWeeks
    }
    
    var currentMonthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: currentDate).capitalized
    }
    
    init(currentDate: Date = Date(), habits: [Habit] = []) {
        let calendar = Calendar.current
        
        // Устанавливаем текущую дату и выбранную дату
        self.currentDate = calendar.startOfDay(for: currentDate)
        self.selectedDate = calendar.startOfDay(for: currentDate)
        
        // Устанавливаем первый день недели - понедельник
        var components = DateComponents()
        components.weekday = 2 // 2 = понедельник
        
        // Рассчитываем дни
        self.updateCalendar(habits: habits)
        
        // Отслеживаем изменения selectedDate
        self.$selectedDate
            .dropFirst() // Пропускаем начальное значение
            .sink { [weak self] _ in
                self?.onDateSelected?()
            }
            .store(in: &cancellables)
    }
    
    // Обновление календаря
    func updateCalendar(habits: [Habit]) {
        // Группируем привычки по датам
        updateHabitsByDate(habits)
        
        // Получаем первый день месяца
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = 1
        guard let firstDayOfMonth = calendar.date(from: components) else { return }
        
        // Рассчитываем общее количество дней в месяце
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let numDays = range.count
        
        // Находим первый день недели месяца (0 = воскресенье, 1 = понедельник, etc.)
        var firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        if firstWeekday == 0 { firstWeekday = 7 } // Воскресенье должно быть 7 в нашей логике
        firstWeekday -= 1 // Перевод с воскресенья (1) в понедельник (0)
        
        // Рассчитываем количество недель
        self.totalWeeks = (numDays + firstWeekday + 6) / 7
        
        // Обновляем текущую неделю
        updateCurrentWeek()
    }
    
    // Обновление группировки привычек по датам
    func updateHabitsByDate(_ habits: [Habit]) {
        habitsByDate = [:]
        for habit in habits {
            // Задаем минимальный срок выполнения в 14 дней
            let minDuration = 14
            
            for day in 0..<minDuration {
                // Получаем дату через 'day' дней от сегодня
                if let futureDate = Calendar.current.date(byAdding: .day, value: day, to: Date()) {
                    // Получаем день недели (0 = воскресенье, 1 = понедельник, ...)
                    let weekday = Calendar.current.component(.weekday, from: futureDate) - 1
                    // Преобразуем к индексу 0-6, где 0 - понедельник
                    let adjustedWeekday = weekday == 0 ? 6 : weekday - 1
                    
                    // Проверяем, запланирована ли привычка на этот день недели
                    if habit.scheduledDays.count > adjustedWeekday && habit.scheduledDays[adjustedWeekday] {
                        if habitsByDate[futureDate] == nil {
                            habitsByDate[futureDate] = []
                        }
                        habitsByDate[futureDate]?.append(habit)
                    }
                }
            }
        }
    }
    
    // Обновление текущей недели
    func updateCurrentWeek() {
        // Рассчитываем дни текущей недели
        var days: [CalendarDay] = []
        
        // Определяем первый день месяца
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = 1
        guard let firstDayOfMonth = calendar.date(from: components) else { return }
        
        // Находим начало текущей недели
        var weekStart: Date
        
        if currentWeekNumber == 1 {
            // Первая неделя - определяем смещение от первого дня месяца
            var weekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
            if weekday == 0 { weekday = 7 } // Воскресенье должно быть 7 в нашей логике
            weekday -= 1 // Перевод с воскресенья (1) в понедельник (0)
            
            weekStart = calendar.date(byAdding: .day, value: -weekday, to: firstDayOfMonth)!
        } else {
            // Другие недели - начало недели = первый день месяца + (номер недели - 1) * 7 - смещение первого дня
            var weekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
            if weekday == 0 { weekday = 7 } // Воскресенье должно быть 7 в нашей логике
            weekday -= 1 // Перевод с воскресенья (1) в понедельник (0)
            
            let daysToAdd = (currentWeekNumber - 1) * 7 - weekday
            weekStart = calendar.date(byAdding: .day, value: daysToAdd, to: firstDayOfMonth)!
        }
        
        // Создаем дни недели
        let today = calendar.startOfDay(for: Date())
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: i, to: weekStart)!
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let currentMonth = calendar.component(.month, from: currentDate)
            let isInCurrentMonth = month == currentMonth
            let isToday = CalendarDay.isSameDay(date, today)
            
            // Проверяем наличие привычек на этот день
            let hasHabits = habitsByDate.keys.contains { CalendarDay.isSameDay($0, date) }
            
            let calendarDay = CalendarDay(
                date: date,
                day: day,
                isInCurrentMonth: isInCurrentMonth,
                isToday: isToday,
                hasHabits: hasHabits
            )
            days.append(calendarDay)
        }
        
        currentWeekDays = days
    }
    
    // Выбор дня
    func selectDay(_ day: CalendarDay) {
        selectedDate = day.date
        // Коллбэк вызовется автоматически через наблюдатель
    }
    
    // Проверка выбранного дня
    func isDaySelected(_ day: CalendarDay) -> Bool {
        return CalendarDay.isSameDay(day.date, selectedDate)
    }
    
    // Переход к предыдущему месяцу
    func previousMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: -1, to: currentDate) else { return }
        currentDate = newDate
        currentWeekNumber = 1
        updateCalendar(habits: Array(habitsByDate.values.flatMap { $0 }))
        // Уведомляем об изменении даты
        onDateSelected?()
    }
    
    // Переход к следующему месяцу
    func nextMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: 1, to: currentDate) else { return }
        currentDate = newDate
        currentWeekNumber = 1
        updateCalendar(habits: Array(habitsByDate.values.flatMap { $0 }))
        // Уведомляем об изменении даты
        onDateSelected?()
    }
    
    // Переход к предыдущей неделе
    func previousWeek() {
        if currentWeekNumber > 1 {
            currentWeekNumber -= 1
            updateCurrentWeek()
            // Уведомляем об изменении даты
            onDateSelected?()
        }
    }
    
    // Переход к следующей неделе
    func nextWeek() {
        if currentWeekNumber < totalWeeks {
            currentWeekNumber += 1
            updateCurrentWeek()
            // Уведомляем об изменении даты
            onDateSelected?()
        }
    }
}
