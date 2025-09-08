//
//  CheckboxView.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 17.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI

struct CheckboxView: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: { isChecked.toggle() }) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(isChecked ? Color.primaryBlue : Color.white)
                    .frame(width: 20, height: 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(
                                isChecked ? Color.primaryBlue : Color.gray.opacity(0.5),
                                lineWidth: 2
                            )
                    )
                
                if isChecked {
                    Text("✓")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
    }
}
