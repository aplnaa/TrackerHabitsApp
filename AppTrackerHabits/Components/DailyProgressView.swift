import SwiftUI

struct DailyProgressView: View {
    let completedCount: Int
    let totalCount: Int
    let progressPercentage: Int
    let motivationalMessage: String
    
    var body: some View {
        HStack(spacing: 20) {
            // Круговой прогресс
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: totalCount > 0 ? CGFloat(completedCount) / CGFloat(totalCount) : 0)
                    .stroke(AppColors.primary, lineWidth: 10)
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                Text("\(progressPercentage)%")
                    .font(.system(size: 24, weight: .bold))
            }
            .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Дневной прогресс")
                    .font(.headline)
                
                Text("\(completedCount) из \(totalCount) привычек выполнено")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(motivationalMessage)
                    .font(.subheadline)
                    .foregroundColor(AppColors.primary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}
