import SwiftUI

struct SocialClubFriendsView: View {
    @Binding var showSearchFriend: Bool
    
    // Данные для топ игроков
    let topPlayers = [
        Player(id: 1, name: "John King", avatar: "avatar2", xp: 3879, rank: 2, medal: "GOLD"),
        Player(id: 2, name: "Ann Huff", avatar: "avatar4", xp: 5270, rank: 1, medal: "GOLD"),
        Player(id: 3, name: "Lina Klark", avatar: "avatar5", xp: 2984, rank: 3, medal: "GOLD")
    ]
    
    // Данные для активности друзей
    let friendsActivity = [
        FriendActivity(id: 1, name: "Harmony Lumon", avatar: "avatar1", activity: "закончил \"Утренняя медитация\"", xpGained: 25),
        FriendActivity(id: 2, name: "Mark Odern", avatar: "avatar3", activity: "выполнял привычку 14 дней", xpGained: 0, trophy: true)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Поиск друзей
            SearchFriendButton(showSearchFriend: $showSearchFriend)
            
            // Топ игроков
            TopPlayersView(players: topPlayers)
            
            // Активность друзей
            FriendsActivityView(activities: friendsActivity)
            
            // Общая цель команды
            TeamGoalView()
        }
    }
}

// Кнопка поиска друзей
struct SearchFriendButton: View {
    @Binding var showSearchFriend: Bool
    
    var body: some View {
        Button(action: {
            showSearchFriend = true
        }) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                Text("Поиск друзей")
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.05), radius: 5)
        }
        .padding(.horizontal)
    }
}

// Секция топ игроков
struct TopPlayersView: View {
    let players: [Player]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Топ игроков")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 10)
            
            // Аватары
            HStack(spacing: 30) {
                ForEach(players.sorted(by: { $0.rank < $1.rank })) { player in
                    PlayerAvatarView(player: player)
                }
            }
            .padding(.bottom, 10)
            
            // Подиумы
            PodiumsView(players: players)
        }
        .padding(.vertical)
        .frame(width: 360, height: 190)
        .background(Color.white)
        .cornerRadius(15)
    }
}

// Аватар игрока
struct PlayerAvatarView: View {
    let player: Player
    
    var body: some View {
        VStack {
            Image(player.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .background(
                    Circle()
                        .fill(AppColors.primary)
                        .frame(width: 64, height: 64)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 5)
            
            Text(player.name.split(separator: " ").first ?? "")
                .font(.caption)
        }
    }
}

// Подиумы для топ игроков
struct PodiumsView: View {
    let players: [Player]
    
    var body: some View {
        HStack(spacing: -25) {
            ForEach(players.sorted(by: { $0.rank < $1.rank })) { player in
                VStack(spacing: 0) {
                    PodiumShape()
                        .fill(getPodiumColor(for: player.rank))
                        .frame(width: 115, height: 60)
                        .shadow(radius: 5)
                        .overlay(
                            VStack(spacing: 2) {
                                Text("\(player.xp)xp")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 2)
                                    .background(Color.white.opacity(0.3))
                                    .cornerRadius(15)
                                
                                Text("\(player.rank)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 10), alignment: .top
                        )
                }
                .zIndex(player.rank == 2 ? 1 : 0)
            }
        }

    }
    
    func getPodiumColor(for rank: Int) -> Color {
        switch rank {
        case 1: return Color(hex: "be68d7")
        case 2: return Color(hex: "fbc371")
        case 3: return Color(hex: "a0d1a2")
        default: return Color.gray
        }
    }
}

struct PodiumShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let peakHeight = height * 2
        
        path.move(to: CGPoint(x: 0, y: height))
        path.addQuadCurve(to: CGPoint(x: width, y: height), control: CGPoint(x: width / 2, y: height - peakHeight))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}


// Представление для одного подиума
struct PodiumView: View {
    let position: Int
    
    var body: some View {
        PodiumShape()
            .fill(
                position == 1 ? Color(hex: "be68d7") :
                    position == 2 ? Color(hex: "fbc371") :
                    Color(hex: "a0d1a2")
            )
            .frame(width: 120, height: position == 1 ? 100 : position == 2 ? 80 : 60)
            .offset(y: -40)
    }
}


// Секция активности друзей
struct FriendsActivityView: View {
    let activities: [FriendActivity]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Активность друзей")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(activities) { activity in
                ActivityRow(activity: activity)
            }
            .padding(.horizontal)
        }
    }
}

// Строка активности друга
struct ActivityRow: View {
    let activity: FriendActivity
    
    var body: some View {
        HStack {
            Image(activity.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .background(Circle().fill(AppColors.accent.opacity(0.3)))
                .shadow(color: Color.black.opacity(0.1), radius: 5)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(activity.activity)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if activity.trophy {
                HStack(spacing: 2) {
                    Text("+")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.primary)
                    Image(systemName: "trophy.fill")
                        .foregroundColor(Color(hex: "fbc371"))
                }
            } else if activity.xpGained > 0 {
                Text("+\(activity.xpGained)xp")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

// Секция общей цели команды
struct TeamGoalView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Общая цель команды")
                    .font(.headline)
                    .padding(.horizontal)
                
                Text("30 дней здоровых привычек")
                    .font(.subheadline)
                    .padding(.horizontal)
                
                HStack {
                    ProgressView(value: 0.3)
                        .progressViewStyle(CustomProgressViewStyle(color: AppColors.primary))
                    
                    Text("30%")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .padding(.horizontal)
    }
}
