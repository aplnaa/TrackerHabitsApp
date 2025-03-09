import SwiftUI

struct SocialClubView: View {
    @State private var selectedTab = 0
    @State private var showSearchFriend = false
    @State private var showCreateTeam = false
    @State private var searchText = ""
    @State private var newTeamName = ""
    @State private var selectedQuestTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Image("socialback")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 80)
                    .edgesIgnoringSafeArea(.top)
                
                VStack(spacing: 20) {
                    // Заголовок
                    SocialClubHeaderView()
                    
                    // Сегментированный переключатель
                    SocialClubTabBar(selection: $selectedTab)
                        .padding(.horizontal, 20)
                }
            }
            .frame(height: 80)
            
            // Контент в зависимости
            TabView(selection: $selectedTab) {
                // Вкладка Друзья
                ScrollView {
                    SocialClubFriendsView(showSearchFriend: $showSearchFriend)
                        .padding(.bottom, 100)
                }
                .tag(0)
                
                // Вкладка Команда
                ScrollView {
                    SocialClubTeamView(showCreateTeam: $showCreateTeam)
                        .padding(.bottom, 100)
                }
                .tag(1)
                
                // Вкладка Квесты
                ScrollView {
                    SocialClubQuestsView(selectedTab: $selectedQuestTab)
                        .padding(.bottom, 100)
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .padding(.top, 60)
        }
        .background(AppColors.background)
        .overlay(
            // Всплывающие окна
            ZStack {
                // Поиск друзей
                if showSearchFriend {
                    SearchFriendOverlay(
                        showSearchFriend: $showSearchFriend,
                        searchText: $searchText
                    )
                }
                
                // Создание команды
                if showCreateTeam {
                    CreateTeamOverlay(
                        showCreateTeam: $showCreateTeam,
                        newTeamName: $newTeamName
                    )
                }
            }
        )
        .animation(.spring(), value: showSearchFriend)
        .animation(.spring(), value: showCreateTeam)
    }
        
}

struct SocialClubHeaderView: View {
    var body: some View {
        ZStack {
            HStack {
                ForEach(0..<8) { i in
                    Image(systemName: "bubble.left.fill")
                        .font(.system(size: CGFloat(8 + i % 4)))
                        .rotationEffect(.degrees(Double(i * 45)))
                        .foregroundColor(.black.opacity(0.2))
                        .offset(x: CGFloat(i * 20 - 60), y: CGFloat(i % 2 == 0 ? 10 : -10))
                }
            }
            
            // Заголовок
            Text("Социальный клуб")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 40)
        }
    }
    
}

struct SearchFriendOverlay: View {
    @Binding var showSearchFriend: Bool
    @Binding var searchText: String
    
    var body: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
                showSearchFriend = false
            }
        
        VStack(spacing: 15) {
            HStack {
                ZStack(alignment: .trailing) {
                    TextField("Введите имя друга", text: $searchText)
                        .padding(10)
                        .background(Color(hex: "e8def8"))
                        .cornerRadius(20)
                    
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(5)
                    }
                    .padding(.trailing, 10)
                }
                
                Button("Искать") {
                    showSearchFriend = false
                }
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(AppColors.primary)
                .cornerRadius(20)
            }
            .padding()
            .background(AppColors.background)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .padding(.horizontal, 20)
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(1)
    }
}

struct CreateTeamOverlay: View {
    @Binding var showCreateTeam: Bool
    @Binding var newTeamName: String
    
    var body: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
                showCreateTeam = false
            }
        
        VStack(spacing: 15) {
            HStack {
                ZStack(alignment: .trailing) {
                    TextField("Введите название команды", text: $newTeamName)
                        .padding(10)
                        .background(Color(hex: "e8def8"))
                        .cornerRadius(20)
                    
                    Button(action: {
                        newTeamName = ""
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(5)
                    }
                    .padding(.trailing, 10)
                }
                
                Button("Создать") {
                    showCreateTeam = false
                }
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(AppColors.primary)
                .cornerRadius(20)
            }
            .padding()
            .background(AppColors.background)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .padding(.horizontal, 20)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .zIndex(1)
    }
}
