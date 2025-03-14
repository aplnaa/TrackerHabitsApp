import SwiftUI

struct HabitsHeaderView: View {
    var body: some View {
        ZStack {
            HStack {
                ForEach(0..<8) { i in
                    Image(systemName: "list.bullet")
                        .font(.system(size: CGFloat(8 + i % 4)))
                        .rotationEffect(.degrees(Double(i * 45)))
                        .foregroundColor(.white.opacity(0.2))
                        .offset(x: CGFloat(i * 20 - 60), y: CGFloat(i % 2 == 0 ? 10 : -10))
                }
            }
            
            // Заголовок
            Text("Привычки")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
        }
    }
}
