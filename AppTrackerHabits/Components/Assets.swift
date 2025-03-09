import SwiftUI

// Цвета приложения
struct AppColors {
    static let background = Color(hex: "f0ecfa")
    static let primary = Color(hex: "7b5bca")
    static let chosen = Color(hex: "BB5CD2")
    static let secondary = Color(hex: "be68d7")
    static let accent = Color(hex: "ad84e6")
    static let gradient1 = Color(hex: "7b5bca")
    static let gradient2 = Color(hex: "634ac1")
    static let barstat = Color(hex: "DCD4F0")
    static let activepie = Color(hex: "CDA2DA")
    static let unactivepie = Color(hex: "A0D1A2")
    
}

// Расширение для создания цвета из HEX
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Стили для прогресс-баров
struct CustomProgressViewStyle: ProgressViewStyle {
    var color: Color = AppColors.primary
    var height: Double = 8
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColors.barstat)
                .frame(height: 8)
            
            RoundedRectangle(cornerRadius: 8)
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 150, height: height)
                .foregroundColor(color)
        }
    }
}

