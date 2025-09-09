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
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
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
                        .foregroundColor(.white)
                        .font(.footnote)
                        .bold()
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                // VPN UI
                if !showSettings && !showAbout {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(isConnected ? Color.green : Color.red)
                                .frame(width: 150, height: 150)
                                .shadow(radius: 10)
                                .animation(.easeInOut, value: isConnected)
                            
                            Image(systemName: isConnected ? "lock.open.fill" : "lock.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.white)
                        }
                        Text(isConnected ? t["vpnConnected"]! : t["vpnDisconnected"]!)
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                isConnected.toggle()
                            }
                        }) {
                            Text(isConnected ? t["disconnect"]! : t["connect"]!)
                                .foregroundColor(.white)
                                .bold()
                                .padding()
                                .frame(width: 220)
                                .background(isConnected ? Color.red : Color.blue)
                                .cornerRadius(30)
                        }
                    }
                }
                Spacer()
            }
            
            // Dim background
            if showSettings || showAbout {
                Color.black.opacity(0.35)
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
                        SettingsRow(title: t["settings"]!, iconName: "gearshape")
                            .onTapGesture { withAnimation { activeMenu = .language } }
                        SettingsRow(title: t["feedback"]!, iconName: "pencil")
                            .onTapGesture { withAnimation { activeMenu = .feedback } }
                        Link(destination: URL(string: "https://t.me/+iNVtHj3_3tZiZWEy")!) {
                            SettingsRow(title: t["telegram"]!, iconName: "paperplane")
                        }
                        SettingsRow(title: t["about"]!, iconName: "info.circle")
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
                .background(Color.white)
                .cornerRadius(16)
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
                .background(Color.white)
                .cornerRadius(16)
                .frame(maxWidth: 300)
            }
        }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    var title: String
    var iconName: String
    var body: some View {
        HStack {
            Text(title).foregroundColor(.black)
            Spacer()
            Image(systemName: iconName).foregroundColor(.blue)
        }
        .padding()
        .background(Color(white: 0.95))
        .cornerRadius(10)
    }
}

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
            Text(title).font(.headline)
            Picker("", selection: $tempSelection) {
                ForEach(languages, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 140)
            
            HStack {
                Button(cancelText) { tempSelection = chosenLanguage; onCancel() }
                    .foregroundColor(.blue)
                Spacer()
                Button(okText) { chosenLanguage = tempSelection; onOK() }
                    .foregroundColor(.blue)
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
        VStack {
            TextField(emailPlaceholder, text: $email)
                .padding().background(Color(white: 0.95)).cornerRadius(8)
            ZStack(alignment: .topLeading) {
                if opinion.isEmpty {
                    Text(opinionPlaceholder).foregroundColor(.gray).padding(10)
                }
                TextEditor(text: $opinion).frame(height: 100)
            }
            .background(Color(white: 0.95)).cornerRadius(8)
            HStack {
                Button(cancelText) { onCancel() }
                    .foregroundColor(.white)
                    .padding().background(Color.gray).cornerRadius(10)
                Button(sendText) { onSubmit(email, opinion) }
                    .foregroundColor(.white)
                    .padding().background(Color.blue).cornerRadius(10)
            }
        }
    }
}

// MARK: - Enum
enum SettingsMenu { case language, feedback }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View { HomeView() }
}
