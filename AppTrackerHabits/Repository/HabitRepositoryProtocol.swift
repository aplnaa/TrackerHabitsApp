import Foundation
import SwiftUI
protocol HabitRepositoryProtocol {
    func getHabits() async throws -> [Habit]
    func updateHabit(_ habit: Habit) async throws
    func createHabit(_ habit: Habit) async throws
    func deleteHabit(id: UUID) async throws
    func updateHabitProgress(id: UUID, progress: Double) async throws
    func completeHabit(id: UUID) async throws
}
