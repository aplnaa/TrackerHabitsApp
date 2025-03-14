import SwiftUI

struct EnhancedCalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            // Месяц и год
            HStack {
                Text(viewModel.currentMonthYearString)
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.previousMonth()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {
                        viewModel.nextMonth()
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)
            
            // Дни недели
            HStack(spacing: 0) {
                ForEach(viewModel.weekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Переключатель недель
            HStack {
                Button(action: {
                    viewModel.previousWeek()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(viewModel.canGoToPreviousWeek ? .black : .gray)
                }
                .disabled(!viewModel.canGoToPreviousWeek)
                
                Spacer()
                
                Text("Неделя \(viewModel.currentWeekNumber)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {
                    viewModel.nextWeek()
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(viewModel.canGoToNextWeek ? .black : .gray)
                }
                .disabled(!viewModel.canGoToNextWeek)
            }
            .padding(.horizontal)
            
            // Дни недели
            HStack(spacing: 0) {
                ForEach(viewModel.currentWeekDays, id: \.id) { day in
                    Button(action: {
                        viewModel.selectDay(day)
                    }) {
                        VStack {
                            Text("\(day.day)")
                                .font(.system(size: 16))
                                .fontWeight(day.isToday ? .bold : .regular)
                                .foregroundColor(viewModel.isDaySelected(day) ? .white :
                                                day.isToday ? AppColors.primary :
                                                day.isInCurrentMonth ? .primary : .gray)
                                .frame(width: 36, height: 36)
                                .background(viewModel.isDaySelected(day) ? AppColors.primary :
                                          day.isToday ? AppColors.primary.opacity(0.2) :
                                          Color.clear)
                                .clipShape(Circle())
                            
                            // Индикатор наличия привычек
                            if day.hasHabits {
                                Circle()
                                    .fill(AppColors.secondary)
                                    .frame(width: 5, height: 5)
                                    .padding(.top, 2)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 5, height: 5)
                                    .padding(.top, 2)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}
