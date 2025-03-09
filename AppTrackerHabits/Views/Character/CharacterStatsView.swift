import SwiftUI

struct CharacterStatsView: View {
    var stats: [Stat]

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(stats, id: \.name) { stat in
                    StatRow(stat: stat)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}

struct StatRow: View {
    var stat: Stat
    
    var body: some View {
        HStack(spacing: 5) {
            // Иконка в круге
            ZStack {
                Circle()
                    .fill(AppColors.primary)
                    .frame(width: 50, height: 50)
                
                Text(stat.icon)
                    .font(.system(size: 24))
            }
            Spacer()
                .frame(width: 10)
            
            Text(stat.name)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 100, alignment: .leading)
                .lineLimit(1)
            
            Spacer()
            
            // Прогресс-бар с процентами
            HStack(spacing: 5) {
                ZStack(alignment: .leading) {
                    // Серый фон для непрогрессивной части
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.barstat)
                        .frame(height: 8)
                    
                    // Активная часть прогресса
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.primary)
                        .frame(width: UIScreen.main.bounds.width * 0.2 * CGFloat(stat.value), height: 8)
                }
                .frame(width: UIScreen.main.bounds.width * 0.2)
                
                Text("\(stat.percentage)%")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(width: 35, alignment: .trailing)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
