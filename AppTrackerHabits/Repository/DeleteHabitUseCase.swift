import SwiftUI

class DeleteHabitUseCase {
    private let repository: HabitRepositoryProtocol
    
    init(repository: HabitRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: UUID) async throws {
        try await repository.deleteHabit(id: id)
    }
}
