import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MapPlaceholderView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Карта")
                }
            
            ActivityListPlaceholderView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Активности")
                }
            
            ProfilePlaceholderView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Профиль")
                }
        }
    }
}
