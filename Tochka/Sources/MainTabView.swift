//
//  MainTabView.swift
//  Tochka
//
//  Created by Artem Rodionov on 08.07.2025.
//

import SwiftUI
import MapFeature

struct MainTabView: View {
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Карта")
                }

            ActivityListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Активности")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Профиль")
                }
        }
        .accentColor(.primaryBlue)
    }
}
