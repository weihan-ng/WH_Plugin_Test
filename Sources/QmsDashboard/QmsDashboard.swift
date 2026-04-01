//
//  QmsDashboard.swift
//  ios_native_qms_test
//
//  Created by Wei Han Ng on 30/03/2026.
//

import UIKit
import QmsPluginFramework

public final class QmsDashboardManager {

    // MARK: - Props (mirror RN)
    private let clientID: String
    private let clientCode: String
    private let userToken: String

    private var isOrigin: Bool = true
    private var payload: [String: Any]?

    private var themeColor: String?
    private var accentColor: String?
    private var headerThemeColor: String?

    private var onClose: (() -> Void)?
    private var onLogout: (() -> Void)?
    private var onAnalyticsScreen: ((String) -> Void)?

    private var observers: [NSObjectProtocol] = []

    // MARK: - Init (required props)
    public init(
        clientID: String,
        clientCode: String,
        userToken: String
    ) {
        self.clientID = clientID
        self.clientCode = clientCode
        self.userToken = userToken
    }

    // MARK: - Chainable config (like RN props)

    public func setIsOrigin(_ value: Bool) -> Self {
        self.isOrigin = value
        return self
    }

    public func setPayload(_ value: [String: Any]?) -> Self {
        self.payload = value
        return self
    }

    public func setThemeColor(_ value: String?) -> Self {
        self.themeColor = value
        return self
    }

    public func setAccentColor(_ value: String?) -> Self {
        self.accentColor = value
        return self
    }

    public func setHeaderThemeColor(_ value: String?) -> Self {
        self.headerThemeColor = value
        return self
    }

    public func onClose(_ handler: @escaping () -> Void) -> Self {
        self.onClose = handler
        return self
    }

    public func onLogout(_ handler: @escaping () -> Void) -> Self {
        self.onLogout = handler
        return self
    }

    public func onAnalyticsScreen(_ handler: @escaping (String) -> Void) -> Self {
        self.onAnalyticsScreen = handler
        return self
    }

    // MARK: - Present (this replaces RN render)

    public func present(from vc: UIViewController) {
        let dashboardVC = QmsPluginUI.makeViewController()
        
        // ✅ Pass required props
        dashboardVC.setValue(clientID, forKey: "ClientID")
        dashboardVC.setValue(clientCode, forKey: "ClientCode")
        dashboardVC.setValue(userToken, forKey: "user_token")
        dashboardVC.setValue(isOrigin, forKey: "isOrigin")
        
        if let payload = payload {
            dashboardVC.setValue(payload, forKey: "payload")
        }
        
        // 🎨 Theme
        if let themeColor = themeColor {
            UserDefaults.standard.set(themeColor, forKey: "QmsThemePrimaryColor")
        }
        if let accentColor = accentColor {
            UserDefaults.standard.set(accentColor, forKey: "QmsThemeAccentColor")
        }
        if let headerThemeColor = headerThemeColor {
            UserDefaults.standard.set(headerThemeColor, forKey: "QmsThemeHeaderColor")
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("QmsThemeDidChangeNotification"),
            object: nil
        )
        
        // 🔔 Events
        setupObservers()
        
        // 🧹 Cleanup on dismiss
        dashboardVC.presentationController?.delegate = PresentationDelegate {
            self.cleanup()
        }
        
        // ✅ Wrap in UINavigationController for guaranteed full screen
        let nav = UINavigationController(rootViewController: dashboardVC)
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .fullScreen
        
        vc.present(nav, animated: true)
    }

    // MARK: - Private

    private func setupObservers() {
        if let onClose = onClose {
            observers.append(
                NotificationCenter.default.addObserver(
                    forName: NSNotification.Name("QmsDashboardDidCloseNotification"),
                    object: nil,
                    queue: .main
                ) { _ in onClose() }
            )
        }

        if let onLogout = onLogout {
            observers.append(
                NotificationCenter.default.addObserver(
                    forName: NSNotification.Name("QmsLogoutNotification"),
                    object: nil,
                    queue: .main
                ) { _ in onLogout() }
            )
        }

        if let onAnalyticsScreen = onAnalyticsScreen {
            observers.append(
                NotificationCenter.default.addObserver(
                    forName: NSNotification.Name("QmsAnalyticsScreenNotification"),
                    object: nil,
                    queue: .main
                ) { notification in
                    if let screen = notification.userInfo?["screenName"] as? String {
                        onAnalyticsScreen(screen)
                    }
                }
            )
        }
    }

    private func cleanup() {
        observers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
        observers.removeAll()
    }
}
