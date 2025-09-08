//
//  BottomSheetPosition.swift
//  MapFeature
//
//  Created by Artem Rodionov on 21.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import Foundation

public enum BottomSheetPosition: CaseIterable {
    case collapsed
    case partial
    case expanded
    
    var visibleHeight: CGFloat {
        switch self {
        case .collapsed: return 80    // Показываем только заголовок
        case .partial: return 220     // Показываем карточки мест
        case .expanded: return 500    // Показываем полный список
        }
    }

    static func nearest(to height: CGFloat) -> BottomSheetPosition {
        return allCases.min {
            abs($0.visibleHeight - height) < abs($1.visibleHeight - height)
        } ?? .partial
    }

    var isDraggable: Bool {
        return true // Все позиции поддерживают drag
    }
    
    var animationDuration: Double {
        switch self {
        case .collapsed: return 0.3
        case .partial: return 0.35
        case .expanded: return 0.4
        }
    }
}
