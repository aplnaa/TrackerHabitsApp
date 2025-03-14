import SwiftUI

struct EmptyStateView: View {
    let message: String
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 70))
                .foregroundColor(AppColors.primary.opacity(0.7))
            
            Text(message)
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: buttonAction) {
                Text("Создать привычку")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.primary)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
