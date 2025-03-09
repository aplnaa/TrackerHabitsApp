import Foundation
import SwiftData

@Model
final class Character: ObservableObject {
    var name: String
    var level: Int
    var experience: Int
    var maxExperience: Int
    var avatarName: String
    @Relationship var stats: [Stat]
    
    init(name: String, level: Int, experience: Int, maxExperience: Int, avatarName: String, stats: [Stat]) {
        self.name = name
        self.level = level
        self.experience = experience
        self.maxExperience = maxExperience
        self.avatarName = avatarName
        self.stats = stats
    }
}

@Model
final class Stat {
    var name: String
    var value: Double
    var icon: String
    var percentage: Int
    
    init(name: String, value: Double, icon: String, percentage: Int) {
        self.name = name
        self.value = value
        self.icon = icon
        self.percentage = percentage
    }
}
