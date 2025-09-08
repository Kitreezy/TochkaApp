//
//  DragHandle.swift
//  MapFeature
//
//  Created by Artem Rodionov on 23.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct DragHandle: View {
    let onDragChanged: (CGFloat) -> Void
    let onDragEnded: (CGFloat) -> Void
    
    @GestureState private var dragOffset: CGFloat = 0
    
    public init(
        onDragChanged: @escaping (CGFloat) -> Void,
        onDragEnded: @escaping (CGFloat) -> Void
    ) {
        self.onDragChanged = onDragChanged
        self.onDragEnded = onDragEnded
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.clear)
                .frame(height: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.textSecondary.opacity(0.4))
                        .frame(width: 36, height: 5)
                )
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.height
                            onDragChanged(value.translation.height)
                        }
                        .onEnded { value in
                            onDragEnded(value.translation.height)
                        }
                )
        }
    }
}
