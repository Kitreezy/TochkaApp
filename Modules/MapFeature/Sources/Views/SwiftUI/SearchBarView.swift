//
//  SearchBarView.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core
import DesignSystem

public struct MapSearchBarView: View {
    @Binding var searchText: String
    let onFilterTap: () -> Void
    
    public init(
        searchText: Binding<String>,
        onFilterTap: @escaping () -> Void
    ) {
        self._searchText = searchText
        self.onFilterTap = onFilterTap
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            // Иконка поиска
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
                .font(.system(size: 16))
            
            // Поле ввода
            TextField("Поиск мест и активностей...", text: $searchText)
                .font(.system(size: 16))
                .foregroundColor(.textPrimary)
            
            // Кнопка фильтра
            Button(action: onFilterTap) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.primaryBlue)
                    .font(.system(size: 16))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 12)
        )
        .shadow(color: .shadowColor, radius: 8, x: 0, y: 4)
    }
}
