import SwiftUI

struct CreateHabitView: View {
    @Binding var isPresented: Bool
    var onHabitCreated: (Habit) -> Void
    
    @State private var habitName = "Утренняя пробежка"
    @State private var selectedCategory = 0
    @State private var selectedDays: [Bool] = [true, true, true, true, true, false, false]
    @State private var reminderTime = Date()
    @State private var dailyGoal = ""
    @State private var notificationsEnabled = true
    @State private var selectedIcon = "🏃"
    @State private var showTimePicker = false
    
    private let categories = ["Здоровье", "Развитие", "Работа"]
    private let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    private let icons = ["🏃", "💧", "📚", "🧘", "💻", "📝", "🎯", "🎸", "🧠", "🍎"]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Заголовок
                    ZStack(alignment: .topTrailing) {
                        Image("createhabits")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 100)
                        
                            .overlay(
                                Text("Создать новую привычку")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.leading, 10)
                                    .padding(.top, 20)
                            )
                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(8)
                        }
                        .padding(.trailing, 20)
                    }
                    
                    // Выбор иконки
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Иконка")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(icons, id: \.self) { icon in
                                    Button(action: {
                                        selectedIcon = icon
                                    }) {
                                        Text(icon)
                                            .font(.system(size: 24))
                                            .frame(width: 50, height: 50)
                                            .background(selectedIcon == icon ? AppColors.chosen : Color.white)
                                            .foregroundColor(selectedIcon == icon ? .white : .black)
                                            .clipShape(Circle())
                                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    
                    // Форма создания привычки
                    VStack(alignment: .leading, spacing: 20) {
                        // Название
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Название")
                                .font(.headline)
                            
                            TextField("Утренняя пробежка", text: $habitName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                        
                        // Категория
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Категория")
                                .font(.headline)
                            
                            HStack(spacing: 10) {
                                ForEach(categories.indices, id: \.self) { index in
                                    Button(action: {
                                        selectedCategory = index
                                    }) {
                                        Text(categories[index])
                                            .font(.system(size: 16))
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 20)
                                            .foregroundColor(selectedCategory == index ? .white : .black)
                                            .background(selectedCategory == index ? AppColors.chosen : Color.white)
                                            .cornerRadius(20)
                                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Частота выполнения
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Частота выполнения")
                                .font(.headline)
                            
                            HStack(spacing: 10) {
                                ForEach(weekdays.indices, id: \.self) { index in
                                    Button(action: {
                                        selectedDays[index].toggle()
                                    }) {
                                        Text(weekdays[index])
                                            .font(.system(size: 16))
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(selectedDays[index] ? .white : .black)
                                            .background(selectedDays[index] ? AppColors.chosen : Color.white)
                                            .clipShape(Circle())
                                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Время напоминания
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Время напоминания")
                                .font(.headline)
                            
                            Button(action: {
                                showTimePicker.toggle()
                            }) {
                                HStack {
                                    Text(timeFormatter.string(from: reminderTime))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppColors.chosen)
                                        .rotationEffect(showTimePicker ? .degrees(180) : .degrees(0))
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                            
                            if showTimePicker {
                                DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Дневная цель
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Дневная цель")
                                .font(.headline)
                            
                            TextField("-", text: $dailyGoal)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                        
                        // Уведомление
                        HStack {
                            Text("Уведомление")
                                .font(.headline)
                            
                            Spacer()
                            
                            Toggle("", isOn: $notificationsEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: AppColors.chosen))
                        }
                        .padding(.horizontal)
                        
                        // Кнопка создания
                        Button(action: {
                            createHabit()
                            isPresented = false
                        }) {
                            Text("Создать")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.chosen)
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .background(AppColors.background)
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }
    
    private func createHabit() {
        // Создание новой привычки из данных формы
        let newHabit = Habit(
            name: habitName,
            description: dailyGoal.isEmpty ? "Новая привычка" : dailyGoal,
            icon: selectedIcon,
            category: categories[selectedCategory],
            progress: 0.0,
            completed: false,
            scheduledDays: selectedDays,
            reminderTime: reminderTime,
            dailyGoal: dailyGoal,
            notificationsEnabled: notificationsEnabled
        )
        
        // Вызываем коллбэк для создания привычки
        onHabitCreated(newHabit)
    }
}
