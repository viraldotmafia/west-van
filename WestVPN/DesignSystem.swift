//
//  DesignSystem.swift
//  WestVPN
//
//  Centralized tokens and primitives inspired by shadcn/ui patterns.
//

import SwiftUI

// MARK: - Color Tokens
enum DSColor {
    static let gray100 = Color(hex: "#F5F5F5")
    static let gray200 = Color(hex: "#E6E6E6")
    static let gray300 = Color(hex: "#D9D9D9")
    static let gray400 = Color(hex: "#B3B3B3")
    static let gray500 = Color(hex: "#757575")
    static let gray600 = Color(hex: "#444444")
    static let gray700 = Color(hex: "#383838")
    static let gray800 = Color(hex: "#2C2C2C")
    static let gray900 = Color(hex: "#1E1E1E")
    static let gray1000 = Color(hex: "#111111")

    // Semantic
    static let background = gray1000
    static let surface = gray900
    static let surfaceElevated = gray800
    static let border = gray700
    static let textPrimary = gray100
    static let textSecondary = gray400
    static let accent = gray300
    static let critical = Color(hex: "#D9D9D9").opacity(0.12) // subtle critical bg
}

// MARK: - Spacing & Radii
enum DSSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

enum DSRadii {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let full: CGFloat = 999
}

// MARK: - Typography
enum DSTypography {
    static let title = Font.system(size: 28, weight: .bold, design: .rounded)
    static let headline = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 16, weight: .regular, design: .rounded)
    static let footnote = Font.system(size: 13, weight: .medium, design: .rounded)
}

// MARK: - Utilities
extension Color {
    init(hex: String) {
        let r, g, b, a: CGFloat
        var hexColor = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexColor.hasPrefix("#") { hexColor.removeFirst() }

        var hexNumber: UInt64 = 0
        Scanner(string: hexColor).scanHexInt64(&hexNumber)

        switch hexColor.count {
        case 6:
            r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000FF) / 255
            a = 1.0
        case 8:
            r = CGFloat((hexNumber & 0xFF000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000FF) / 255
        default:
            r = 1; g = 1; b = 1; a = 1
        }

        self = Color(red: r, green: g, blue: b, opacity: a)
    }
}

// MARK: - Components (shadcn-inspired)
struct DSButtonStyle: ButtonStyle {
    enum Kind { case primary, secondary, danger }
    var kind: Kind = .primary
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DSTypography.body.weight(.semibold))
            .foregroundColor(DSColor.textPrimary)
            .padding(.vertical, DSSpacing.sm)
            .padding(.horizontal, DSSpacing.lg)
            .frame(maxWidth: .infinity)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadii.md)
                    .stroke(DSColor.border, lineWidth: 1)
            )
            .cornerRadius(DSRadii.md)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }

    private func backgroundColor(isPressed: Bool) -> Color {
        switch kind {
        case .primary:
            return isPressed ? DSColor.surface : DSColor.surfaceElevated
        case .secondary:
            return isPressed ? DSColor.background : DSColor.surface
        case .danger:
            return isPressed ? DSColor.gray800 : DSColor.gray900
        }
    }
}

struct DSCard<Content: View>: View {
    var padding: CGFloat = DSSpacing.lg
    var content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            content()
        }
        .padding(padding)
        .background(DSColor.surface)
        .overlay(
            RoundedRectangle(cornerRadius: DSRadii.lg)
                .stroke(DSColor.border, lineWidth: 1)
        )
        .cornerRadius(DSRadii.lg)
        .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 8)
    }
}

struct DSRow: View {
    var title: String
    var iconName: String?
    var trailing: AnyView? = nil
    var body: some View {
        HStack(spacing: DSSpacing.sm) {
            if let iconName { Image(systemName: iconName).foregroundColor(DSColor.textSecondary) }
            Text(title).font(DSTypography.body).foregroundColor(DSColor.textPrimary)
            Spacer()
            if let trailing { trailing }
        }
        .padding(DSSpacing.md)
        .background(DSColor.surfaceElevated)
        .overlay(
            RoundedRectangle(cornerRadius: DSRadii.md)
                .stroke(DSColor.border, lineWidth: 1)
        )
        .cornerRadius(DSRadii.md)
    }
}

struct DSBadge: View {
    var text: String
    var tone: Tone = .neutral
    enum Tone { case neutral, success, warning, danger }
    var body: some View {
        Text(text)
            .font(DSTypography.footnote)
            .foregroundColor(DSColor.textPrimary)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(background)
            .cornerRadius(DSRadii.sm)
            .overlay(
                RoundedRectangle(cornerRadius: DSRadii.sm)
                    .stroke(DSColor.border, lineWidth: 1)
            )
    }
    private var background: Color {
        switch tone {
        case .neutral: return DSColor.surface
        case .success: return DSColor.gray800
        case .warning: return DSColor.gray800
        case .danger: return DSColor.gray800
        }
    }
}

// MARK: - VPN Status Indicator
struct VPNStatusIndicator: View {
    var isConnected: Bool
    var body: some View {
        ZStack {
            Circle()
                .fill(isConnected ? DSColor.gray700 : DSColor.gray900)
                .frame(width: 160, height: 160)
                .overlay(
                    Circle().stroke(DSColor.border, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 10)
            Image(systemName: isConnected ? "lock.open.fill" : "lock.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .foregroundColor(DSColor.textPrimary)
        }
    }
}


