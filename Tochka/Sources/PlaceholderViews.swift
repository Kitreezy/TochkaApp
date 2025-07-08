import SwiftUI

struct MapPlaceholderView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "map")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Карта будет здесь")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .navigationBarTitle("Карта")
        }
    }
}

struct ActivityListPlaceholderView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "list.bullet")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Список активностей")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .navigationBarTitle("Активности")
        }
    }
}

struct ProfilePlaceholderView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Профиль пользователя")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .navigationBarTitle("Профиль")
        }
    }
}
