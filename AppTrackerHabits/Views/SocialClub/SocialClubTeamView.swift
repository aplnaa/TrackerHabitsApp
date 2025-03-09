import SwiftUI

struct SocialClubTeamView: View {
    @Binding var showCreateTeam: Bool
    

    let teamStats = [
        TeamStat(name: "Активность", value: 0.85, color1: AppColors.unactivepie, color2: AppColors.activepie, percentage: 85),
        TeamStat(name: "Завершено", value: 0.38, color1: AppColors.unactivepie, color2: AppColors.activepie, percentage: 38),
        TeamStat(name: "Уровень", value: 0.78, color1: AppColors.unactivepie, color2: AppColors.activepie, percentage: 78)
    ]
    
    // Данные для лидеров
    let leaders = [
        Leader(id: 1, name: "Ann Huff", avatar: "avatar4", xp: 5270, position: 1, bonus: 25),
        Leader(id: 2, name: "John King", avatar: "avatar2", xp: 3879, position: 2, bonus: 20),
        Leader(id: 3, name: "Lina Klark", avatar: "avatar5", xp: 2984, position: 3, bonus: 15),
        Leader(id: 4, name: "Mark Odern", avatar: "avatar3", xp: 2300, position: 4, bonus: 10),
        Leader(id: 5, name: "Harmony Lumon", avatar: "avatar1", xp: 1908, position: 5, bonus: 8)
    ]
    
    var body: some View {
        VStack(spacing: 25) {
                // Статистика команды
            VStack(alignment: .leading, spacing: 15) {
                Text("Статистика команды")
                    .font(.headline)
                    .padding(.horizontal)
                    
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 50) {
                        ForEach(teamStats) { stat in
                            VStack {
                                PieChartView(progress: stat.value, color1: stat.color1, color2: stat.color2)
                                    .frame(width: 70, height: 70)

                                Text("\(stat.percentage)%")
                                    .font(.system(size: 14, weight: .bold))
                            
                                Text(stat.name)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5)
            .padding(.horizontal)
            
            // Лидеры
            VStack(alignment: .leading, spacing: 15) {
                Text("Лидеры")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(leaders) { leader in
                    HStack {
                        Text("\(leader.position)")
                            .font(.headline)
                            .frame(width: 30)
                        
                        Image(leader.avatar)
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
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(leader.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("\(leader.xp) xp")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("+\(leader.bonus)xp")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.primary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5)
                }
                .padding(.horizontal)
            }
            
            // Кнопка создания новой команды
            Button(action: {
                showCreateTeam = true
            }) {
                Text("Создать новую команду")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.primary)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5)
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}

struct TeamStat: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
    let color1: Color
    let color2: Color
    let percentage: Int
}

extension Stat {
    var color: Color {
        Color.purple
    }
}

struct PieChartView: View {
    var progress: Double
    var color1: Color
    var color2: Color

    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                // Оставшаяся часть
                Path { path in
                    path.move(to: center)
                    path.addArc(center: center, radius: radius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 270), clockwise: false)
                }
                .fill(color1) // Добавляем фоновый цвет
                
                // Заполненная часть
                Path { path in
                    path.move(to: center)
                    path.addArc(center: center, radius: radius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: -90 + (360 * progress)), clockwise: false)
                }
                .fill(color2)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}


