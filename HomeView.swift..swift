//
//  HomeView.swift
//  WestVPN
//
//  Created by Is'hoq Abduvoxidov on 09/09/25.
//

import SwiftUI
import SwiftUI

struct HomeView: View {
    @State private var isConnected = false
    @State private var isConnecting = false
    @State private var showSettings = false
    @State private var activeMenu: SettingsMenu? = nil
    @State private var showAbout = false
    
    // Persistent language setting
    @AppStorage("chosenLanguage") private var chosenLanguage: String = "Русский"
    
    // Localized strings
    private var localized: [String: [String: String]] = [
        "Русский": [
            "banner": "Ваше соединение не защищено!",
            "connect": "Подключить",
            "disconnect": "Отключить",
            "vpnConnected": "VPN Подключен",
            "vpnDisconnected": "VPN Отключен",
            "settings": "Настройки",
            "feedback": "Оставить Отзыв",
            "telegram": "Перейти в Telegram канал",
            "about": "О Нас",
            "aboutText": "For all students who wants scroll social media without any interruptions 🫶",
            "language": "Язык",
            "cancel": "Отменить",
            "ok": "OK",
            "send": "Отправить",
            "emailPlaceholder": "электронная почта",
            "opinionPlaceholder": "Расскажите нам, что вы думаете об этом приложении, что мы должны улучшить? Спасибо!"
        ],
        "English": [
            "banner": "Your connection is not secure!",
            "connect": "Connect",
            "disconnect": "Disconnect",
            "vpnConnected": "VPN Connected",
            "vpnDisconnected": "VPN Disconnected",
            "settings": "Settings",
            "feedback": "Leave Feedback",
            "telegram": "Join Telegram Channel",
            "about": "About",
            "aboutText": "For all students who wants scroll social media without any interruptions 🫶",
            "language": "Language",
            "cancel": "Cancel",
            "ok": "OK",
            "send": "Send",
            "emailPlaceholder": "Email",
            "opinionPlaceholder": "Tell us what you think about this app, what we should improve? Thank you!"
        ],
        "Türkçe": [
            "banner": "Bağlantınız güvenli değil!",
            "connect": "Bağlan",
            "disconnect": "Bağlantıyı Kes",
            "vpnConnected": "VPN Bağlandı",
            "vpnDisconnected": "VPN Bağlı Değil",
            "settings": "Ayarlar",
            "feedback": "Geri Bildirim",
            "telegram": "Telegram Kanalına Katıl",
            "about": "Hakkımızda",
            "aboutText": "Kesintisiz sosyal medya gezintisi isteyen tüm öğrenciler için 🫶",
            "language": "Dil",
            "cancel": "İptal",
            "ok": "Tamam",
            "send": "Gönder",
            "emailPlaceholder": "E-posta",
            "opinionPlaceholder": "Bu uygulama hakkında ne düşündüğünüzü, neyi geliştirmemiz gerektiğini bize söyleyin! Teşekkürler!"
        ]
    ]
    
    private var t: [String: String] {
        localized[chosenLanguage] ?? localized["Русский"]!
    }
    
    var body: some View {
        ZStack {
            DSColor.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Settings button
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showSettings.toggle()
                            activeMenu = nil
                            showAbout = false
                        }
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 12)
                    .opacity(showSettings ? 0.4 : 1.0)
                    Spacer()
                }
                .padding(.top, 10)
                
                // Banner centered
                if !showSettings && !showAbout {
                    Text(t["banner"]!)
                        .foregroundColor(DSColor.textPrimary)
                        .font(DSTypography.footnote)
                        .padding(8)
                        .background(DSColor.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: DSRadii.sm)
                                .stroke(DSColor.border, lineWidth: 1)
                        )
                        .cornerRadius(DSRadii.sm)
                }
                
                Spacer()
                
                // VPN UI
                if !showSettings && !showAbout {
                    VStack(spacing: 16) {
                        VPNStatusIndicator(isConnected: isConnected)
                            .animation(.easeInOut, value: isConnected)
                        Text(isConnected ? t["vpnConnected"]! : (isConnecting ? "Connecting..." : t["vpnDisconnected"]!))
                            .font(DSTypography.headline)
                            .foregroundColor(DSColor.textPrimary)
                        Button(action: {
                            guard !isConnecting else { return }
                            if isConnected {
                                withAnimation(.spring()) { isConnected = false }
                            } else {
                                isConnecting = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    withAnimation(.spring()) {
                                        isConnected = true
                                        isConnecting = false
                                    }
                                }
                            }
                        }) {
                            Text(isConnected ? t["disconnect"]! : (isConnecting ? "Connecting..." : t["connect"]!))
                        }
                        .buttonStyle(DSButtonStyle(kind: isConnected ? .secondary : .primary))
                        .disabled(isConnecting)
                    }
                }
                Spacer()
            }
            
            // Dim background
            if showSettings || showAbout {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showSettings = false
                            activeMenu = nil
                            showAbout = false
                        }
                    }
            }
            
            // Settings card
            if showSettings {
                VStack(spacing: 16) {
                    if activeMenu == nil {
                        DSRow(title: t["settings"]!, iconName: "gearshape")
                            .onTapGesture { withAnimation { activeMenu = .language } }
                        DSRow(title: t["feedback"]!, iconName: "pencil")
                            .onTapGesture { withAnimation { activeMenu = .feedback } }
                        Link(destination: URL(string: "https://t.me/+iNVtHj3_3tZiZWEy")!) {
                            DSRow(title: t["telegram"]!, iconName: "paperplane")
                        }
                        DSRow(title: t["about"]!, iconName: "info.circle")
                            .onTapGesture {
                                withAnimation {
                                    showSettings = false
                                    showAbout = true
                                }
                            }
                    } else if activeMenu == .language {
                        LanguageMenu(
                            chosenLanguage: $chosenLanguage,
                            onCancel: { withAnimation { activeMenu = nil } },
                            onOK: { withAnimation { activeMenu = nil; showSettings = false } },
                            title: t["language"]!,
                            cancelText: t["cancel"]!,
                            okText: t["ok"]!
                        )
                    } else if activeMenu == .feedback {
                        FeedbackMenu(
                            emailPlaceholder: t["emailPlaceholder"]!,
                            opinionPlaceholder: t["opinionPlaceholder"]!,
                            cancelText: t["cancel"]!,
                            sendText: t["send"]!,
                            onCancel: { withAnimation { activeMenu = nil } },
                            onSubmit: { _, _ in withAnimation { activeMenu = nil; showSettings = false } }
                        )
                    }
                }
                .padding()
                .background(DSColor.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadii.lg)
                        .stroke(DSColor.border, lineWidth: 1)
                )
                .cornerRadius(DSRadii.lg)
                .frame(maxWidth: 360)
            }
            
            // About popup
            if showAbout {
                VStack(spacing: 16) {
                    Text(t["aboutText"]!)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding()
                    Button(t["ok"]!) {
                        withAnimation { showAbout = false }
                    }
                    .foregroundColor(.blue)
                }
                .padding()
                .background(DSColor.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadii.lg)
                        .stroke(DSColor.border, lineWidth: 1)
                )
                .cornerRadius(DSRadii.lg)
                .frame(maxWidth: 300)
            }
        }
    }
}

// MARK: - Replaced SettingsRow with DSRow

// MARK: - Language menu
struct LanguageMenu: View {
    @Binding var chosenLanguage: String
    @State private var tempSelection: String
    var onCancel: () -> Void
    var onOK: () -> Void
    var title: String
    var cancelText: String
    var okText: String
    
    private let languages = ["English", "Русский", "Türkçe"]
    
    init(chosenLanguage: Binding<String>, onCancel: @escaping () -> Void, onOK: @escaping () -> Void, title: String, cancelText: String, okText: String) {
        self._chosenLanguage = chosenLanguage
        self._tempSelection = State(initialValue: chosenLanguage.wrappedValue)
        self.onCancel = onCancel
        self.onOK = onOK
        self.title = title
        self.cancelText = cancelText
        self.okText = okText
    }
    
    var body: some View {
        VStack {
            Text(title).font(DSTypography.headline).foregroundColor(DSColor.textPrimary)
            Picker("", selection: $tempSelection) {
                ForEach(languages, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 140)
            
            HStack {
                Button(cancelText) { tempSelection = chosenLanguage; onCancel() }
                    .buttonStyle(DSButtonStyle(kind: .secondary))
                Spacer()
                Button(okText) { chosenLanguage = tempSelection; onOK() }
                    .buttonStyle(DSButtonStyle(kind: .primary))
            }
        }
    }
}

// MARK: - Feedback menu
struct FeedbackMenu: View {
    @State private var email = ""
    @State private var opinion = ""
    var emailPlaceholder: String
    var opinionPlaceholder: String
    var cancelText: String
    var sendText: String
    var onCancel: () -> Void
    var onSubmit: (String, String) -> Void
    
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            TextField(emailPlaceholder, text: $email)
                .font(DSTypography.body)
                .foregroundColor(DSColor.textPrimary)
                .padding(DSSpacing.sm)
                .background(DSColor.surfaceElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadii.md).stroke(DSColor.border, lineWidth: 1)
                )
                .cornerRadius(DSRadii.md)
            ZStack(alignment: .topLeading) {
                if opinion.isEmpty {
                    Text(opinionPlaceholder)
                        .foregroundColor(DSColor.textPrimary)
                        .padding(10)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $opinion)
                    .frame(height: 100)
                    .foregroundColor(DSColor.textPrimary)
                    .background(Color.clear)
            }
            .padding(4)
            .background(DSColor.surfaceElevated)
            .overlay(
                RoundedRectangle(cornerRadius: DSRadii.md).stroke(DSColor.border, lineWidth: 1)
            )
            .cornerRadius(DSRadii.md)
            HStack {
                Button(cancelText) { onCancel() }
                    .buttonStyle(DSButtonStyle(kind: .secondary))
                Button(sendText) { onSubmit(email, opinion) }
                    .buttonStyle(DSButtonStyle(kind: .primary))
            }
        }
    }
}

// MARK: - Enum
enum SettingsMenu { case language, feedback }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View { HomeView() }
}
