import SwiftUI

struct FSTextFieldStyle: TextFieldStyle {
  /// Whether the user is focused on this `TextField`.
  var isEditing: Bool

  func _body(configuration: TextField<_Label>) -> some View {
    configuration
      .textFieldStyle(PlainTextFieldStyle())
      .multilineTextAlignment(.leading)
    
      .font(.custom("ElMessiri-Bold", size: 20))
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .background(Color.accentColor)
  }

  var border: some View {
    RoundedRectangle(cornerRadius: 16)
      .strokeBorder(
        LinearGradient(
          gradient: .init(
            colors: [
                Color.borderColor,
                Color.borderColor
            ]
          ),
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        ),
        lineWidth: isEditing ? 4 : 2
      )
  }
}
