import SwiftUI

// Модели данных для SocialClub
struct Player: Identifiable {
    let id: Int
    let name: String
    let avatar: String
    let xp: Int
    let rank: Int
    let medal: String
}

struct FriendActivity: Identifiable {
    let id: Int
    let name: String
    let avatar: String
    let activity: String
    let xpGained: Int
    var trophy: Bool = false
}

struct Leader: Identifiable {
    let id: Int
    let name: String
    let avatar: String
    let xp: Int
    let position: Int
    let bonus: Int
}

// Расширение для скругления определенных углов
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

