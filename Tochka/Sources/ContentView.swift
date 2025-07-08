import SwiftUI


public struct ContentView: View {
    @StateObject private var appCoordinator = AppCoordinator()
    
    public var body: some View {
        Group {
            if appCoordinator.isAuthenticated {
                MainTabView()
                    .environmentObject(appCoordinator)
            } else {
                WelcomeView()
                    .environmentObject(appCoordinator)
            }
        }
        .onAppear {
            appCoordinator.checkAuthenticationStatus()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
