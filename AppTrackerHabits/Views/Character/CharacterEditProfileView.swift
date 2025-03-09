import SwiftUI
import SwiftData

struct CharacterEditProfileView: View {
    @Environment(\.modelContext) private var modelContext
    var character: Character
    @Binding var isPresented: Bool
    
    @State private var name: String
    @State private var selectedAvatar: String
    
    // Доступные аватары
    let avatars = ["avatar1", "avatar2", "avatar3", "avatar4", "avatar5"]
    
    init(character: Character, isPresented: Binding<Bool>) {
        self.character = character
        self._isPresented = isPresented
        self._name = State(initialValue: character.name)
        self._selectedAvatar = State(initialValue: character.avatarName)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            Text("Редактирование профиля")
                .font(.title2)
                .bold()
                .padding(.top)
            
            // Поле ввода имени
            VStack(alignment: .leading, spacing: 8) {
                Text("Имя персонажа")
                    .font(.headline)
                
                TextField("Введите имя", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            // Выбор аватара
            VStack(alignment: .leading, spacing: 12) {
                Text("Выберите аватар")
                    .font(.headline)
                
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
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(selectedAvatar == avatar ? AppColors.primary : Color.gray.opacity(0.3), lineWidth: 2)
                                )
                                .background(
                                    Circle()
                                        .fill(selectedAvatar == avatar ? AppColors.primary.opacity(0.3) : Color.clear)
                                        .frame(width: 64, height: 64)
                                )
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Кнопки
            HStack(spacing: 20) {
                Button("Отмена") {
                    isPresented = false
                }
                .foregroundColor(.gray)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                Button("Сохранить") {
                    saveChanges()
                    isPresented = false
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppColors.primary)
                .cornerRadius(15)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .padding()
        .background(AppColors.background)
    }
    
    private func saveChanges() {
        character.name = name
        character.avatarName = selectedAvatar
        
        do {
            try modelContext.save()
            print("Character updated successfully")
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

