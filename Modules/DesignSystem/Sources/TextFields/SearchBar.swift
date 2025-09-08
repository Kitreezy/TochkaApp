//
//  SearchBar.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 14.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    let onFilterTap: () -> Void
    
    public init(
        text: Binding<String>,
        placeholder: String = "Поиск мест и активностей...",
        onFilterTap: @escaping () -> Void
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onFilterTap = onFilterTap
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
                .font(.system(size: 16))
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .foregroundColor(.textPrimary)
            
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
