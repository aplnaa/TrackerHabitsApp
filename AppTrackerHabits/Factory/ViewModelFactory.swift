import SwiftUI

class ViewModelFactory {
    // Синглтон для доступа к фабрике
    static let shared = ViewModelFactory()
    
    private init() {}
    
    // Метод для создания HabitsViewModel
    func makeHabitsViewModel() -> HabitsViewModel {
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
    }
}
