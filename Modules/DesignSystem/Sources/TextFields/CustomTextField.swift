import SwiftUI
import Core

public struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    
    public init(
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default
    ) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
}
