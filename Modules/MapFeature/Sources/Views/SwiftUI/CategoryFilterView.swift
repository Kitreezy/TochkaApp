//
//  CategoryFilterView.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct CategoryFilterView: View {
    @Binding var selectedCategory: PlaceCategory
    let onCategoryChanged: (PlaceCategory) -> Void
    
    public init(
        selectedCategory: Binding<PlaceCategory>,
        onCategoryChanged: @escaping (PlaceCategory) -> Void
    ) {
        self._selectedCategory = selectedCategory
        self.onCategoryChanged = onCategoryChanged
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(PlaceCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                        onCategoryChanged(category)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4) // Добавили вертикальный padding
        }
        .frame(height: 48) // Увеличили высоту
        .background(Color.clear)
    }
}

// MARK: - CategoryButton (исправленная версия)
struct CategoryButton: View {
    let category: PlaceCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if category != .all {
                    Text(category.emoji)
                        .font(.system(size: 13))
                }
                
                Text(category.displayName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(isSelected ? .white : .textSecondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? Color.primaryBlue : Color.white.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                isSelected ? Color.clear : Color.gray.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(
                color: isSelected ? Color.primaryBlue.opacity(0.3) : .shadowColor,
                radius: isSelected ? 4 : 2,
                x: 0,
                y: 1
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
