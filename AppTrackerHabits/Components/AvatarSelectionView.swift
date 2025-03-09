import SwiftUI

struct AvatarSelectionView: View {
    @Binding var selectedAvatar: String
    @Environment(\.dismiss) private var dismiss
    
    let avatars = ["avatar1", "avatar2", "avatar3", "avatar4", "avatar5"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            Text("Выберите аватар")
                .font(.title2)
                .bold()
                .padding(.top)
            
            // Поле ввода имени
            TextField("Burt", text: .constant("Burt"))
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal)
            
            // Сетка аватаров
            HStack(spacing: 15) {
                ForEach(avatars, id: \.self) { avatar in
                    Button(action: {
                        selectedAvatar = avatar
                    }) {
                        Image(avatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .background(selectedAvatar == avatar ? AppColors.primary.opacity(0.3) : Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(selectedAvatar == avatar ? AppColors.primary : Color.gray.opacity(0.3), lineWidth: 2)
                            )
                    }
                }
            }
            .padding()
            
            // Кнопки
            HStack(spacing: 20) {
                Button("Отмена") {
                    dismiss()
                }
                .foregroundColor(.gray)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(15)
                
                Button("Сохранить") {
                    dismiss()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppColors.primary)
                .cornerRadius(15)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(AppColors.background)
    }
}

struct AvatarSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarSelectionView(selectedAvatar: .constant("avatar1"))
    }
}

