import SwiftUI

struct CharacterHeaderView: View {
    var character: Character
    @State private var showEditProfile = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Фоновое изображение из ресурсов проекта
            Image("characterBack")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
            
            // Контент
            HStack(alignment: .center) {
                // Информация о персонаже (слева)
                VStack(alignment: .leading, spacing: 5) {
                    Text("С возвращением, \(character.name)!")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Уровень: \(character.level)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("\(character.experience)/\(character.maxExperience)XP")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            .frame(maxWidth: .infinity, alignment: .leading)
            
         
            // Аватар (справа)
            ZStack {
                Image(character.avatarName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 165, height: 165)
                    .clipShape(Circle())
            }
            .padding(.top, 50)
            .padding(.trailing, 32)
            
            // Кнопка редактирования
            Button(action: {
                showEditProfile = true
            }) {
                Image(systemName: "pencil")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Circle().fill(AppColors.secondary))
            }
            .padding(.trailing, 20)
            .padding(.top, 170)
        }
        .sheet(isPresented: $showEditProfile) {
            CharacterEditProfileView(character: character, isPresented: $showEditProfile)
        }
    }
}

