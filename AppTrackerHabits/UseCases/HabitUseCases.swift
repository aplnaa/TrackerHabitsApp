import Foundation

class GetHabitsUseCase {
    private let repository: HabitRepositoryProtocol
    
    init(repository: HabitRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Habit] {
        return try await repository.getHabits()
    }
}

class UpdateHabitProgressUseCase {
    private let repository: HabitRepositoryProtocol
    
    init(repository: HabitRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(habitId: UUID, progress: Double) async throws {
        try await repository.updateHabitProgress(id: habitId, progress: progress)
    }
}

class CompleteHabitUseCase {
    private let repository: HabitRepositoryProtocol
    
    init(repository: HabitRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(habitId: UUID) async throws {
        try await repository.completeHabit(id: habitId)
    }
}

class CreateHabitUseCase {
    private let repository: HabitRepositoryProtocol
    
    init(repository: HabitRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(habit: Habit) async throws {
        try await repository.createHabit(habit)
    }
}
