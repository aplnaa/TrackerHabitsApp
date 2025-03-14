import SwiftUI

// HabitRow.swift - Компонент отображения одной привычки
struct HabitRow: View {
    let habit: Habit
    let onProgressIncrement: () -> Void
    let onComplete: () -> Void
    let onDelete: () -> Void
    @State private var showDeleteConfirmation = false
    
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
                
                if habit.streak > 0 {
                    Text("Серия: \(habit.streak) дн.")
                        .font(.caption)
                        .foregroundColor(AppColors.primary)
                }
            }
            .padding(.leading, 8)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                HStack {
                    Text("\(Int(habit.progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // Кнопка инкремента прогресса (если не выполнено)
                    if !habit.completed {
                        Button(action: onProgressIncrement) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(AppColors.primary)
                        }
                    }
                }
                
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
            
            // Кнопки действий
            HStack(spacing: 12) {
                // Галочка для выполненных или кнопка завершения
                if habit.completed {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .padding(5)
                        .background(AppColors.primary)
                        .clipShape(Circle())
                } else {
                    Button(action: onComplete) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(AppColors.primary)
                            .font(.system(size: 24))
                    }
                }
                
                // Кнопка удаления
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.system(size: 16))
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .padding(.horizontal)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Удалить привычку?"),
                message: Text("Вы уверены, что хотите удалить привычку \"\(habit.name)\"?"),
                primaryButton: .destructive(Text("Удалить")) {
                    onDelete()
                },
                secondaryButton: .cancel(Text("Отмена"))
            )
        }
    }
}
