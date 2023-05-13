//
//  Colors.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import SwiftUI

enum GeistColor {
    static let black = Color(hex: 0x000000)
    // GHO colors
    static let gray = Color(hex: 0x5D5C6C)
    static let purpleDark = Color(hex: 0x39375A)
    static let purpleGray = Color(hex: 0xBCB6CB)
    static let purpleLight = Color(hex: 0xC7BBE7)
    static let purpleLight2 = Color(hex: 0xDBD2EF)
}

enum GeistFontColor {
    static let border = GeistColor.purpleDark
    static let borderSecondary = GeistColor.purpleGray
    static let title = GeistColor.purpleDark
    static let secondaryTitle = GeistColor.gray
    static let text = GeistColor.purpleDark
}

// MARK: - Extensions

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }

    init(light: Color, dark: Color) {
      self.init(UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
}

extension UIColor {
  convenience init(light: UIColor, dark: UIColor) {
    self.init { traitCollection in
      switch traitCollection.userInterfaceStyle {
      case .light, .unspecified:
        return light
      case .dark:
        return dark
      @unknown default:
        return light
      }
    }
  }
}
