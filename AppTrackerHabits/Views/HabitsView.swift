import SwiftUI

struct HabitsView: View {
    @StateObject var viewModel: HabitsViewModel
    @State private var showCreateHabit = false
    
    init(viewModel: HabitsViewModel = {
        let repository = FakeHabitRepository()
        let getHabitsUseCase = GetHabitsUseCase(repository: repository)
        let updateHabitProgressUseCase = UpdateHabitProgressUseCase(repository: repository)
        let completeHabitUseCase = CompleteHabitUseCase(repository: repository)
        let createHabitUseCase = CreateHabitUseCase(repository: repository)
        let deleteHabitUseCase = DeleteHabitUseCase(repository: repository)
        
        return HabitsViewModel(
            getHabitsUseCase: getHabitsUseCase,
            updateHabitProgressUseCase: updateHabitProgressUseCase,
            completeHabitUseCase: completeHabitUseCase,
            createHabitUseCase: createHabitUseCase,
            deleteHabitUseCase: deleteHabitUseCase
        )
    }()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top){
                Image("habits")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 320, height: 280)
                    .edgesIgnoringSafeArea(.top)
                
                VStack(spacing: 20) {
                    // Заголовок
                    HabitsHeaderView()
                    
                    // Улучшенный календарь
                    EnhancedCalendarView(viewModel: viewModel.calendarViewModel)
                        .padding(.horizontal)
                    
                    // Категории
                    HabitCategoryPicker(
                        selection: $viewModel.selectedCategory,
                        categories: viewModel.categories,
                        onSelectCategory: { index in
                            viewModel.selectCategory(index: index)
                        }
                    )
                    .padding(.horizontal)
                }
            }
            .background(.ultraThinMaterial)
            
            switch viewModel.state {
            case .loading:
                LoadingView()
            case .error:
                ErrorView(errorMessage: viewModel.error ?? "Произошла ошибка", retryAction: {
                    Task {
                        await viewModel.loadHabits()
                    }
                })
            case .empty:
                EmptyStateView(
                    message: "У вас пока нет привычек",
                    buttonAction: { showCreateHabit = true }
                )
            case .loaded:
                ScrollView {
                    VStack(spacing: 20) {
                        // Дневной прогресс
                        DailyProgressView(
                            completedCount: viewModel.completedCount,
                            totalCount: viewModel.totalCount,
                            progressPercentage: viewModel.progressPercentage,
                            motivationalMessage: viewModel.getMotivationalMessage()
                        )
                        .padding(.horizontal)
                        
                        // Привычки на сегодня
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Привычки на сегодня")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if viewModel.filteredHabits.isEmpty {
                                Text("На этот день нет запланированных привычек")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 20)
                            } else {
                                // Фильтруем привычки по выбранной категории
                                ForEach(viewModel.filteredHabits) { habit in
                                    HabitRow(
                                        habit: habit,
                                        onProgressIncrement: {
                                            viewModel.incrementProgress(habit: habit)
                                        },
                                        onComplete: {
                                            Task {
                                                await viewModel.completeHabit(habitId: habit.id)
                                            }
                                        },
                                        onDelete: {
                                            Task {
                                                await viewModel.deleteHabit(habitId: habit.id)
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.bottom, 100)
                    }
                    .padding(.vertical)
                }
                .scrollIndicators(.hidden)
                .refreshable {
                    await viewModel.loadHabits()
                }
            }
        }
        .background(AppColors.background)
        .onAppear {
            Task {
                await viewModel.loadHabits()
            }
        }
        .sheet(isPresented: $showCreateHabit) {
            CreateHabitView(isPresented: $showCreateHabit, onHabitCreated: { habit in
                Task {
                    await viewModel.createHabit(habit: habit)
                }
            })
        }
    }
}
