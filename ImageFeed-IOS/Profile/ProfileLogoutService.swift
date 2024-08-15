import Foundation
import WebKit
import UIKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
  
    private init() { }

    func logout() {
        OAuth2TokenStorage.shared.token = nil
        cleanCookies()
        clearUserData()
        switchToAuthViewController()
    }

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

    private func clearUserData() {
        ProfileService.shared.clearProfileData()
        ProfileImageService.shared.clearProfileImage()
        ImagesListService.shared.clearImagesList()
    }

    private func switchToAuthViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {}, completion: nil)
    }
}
