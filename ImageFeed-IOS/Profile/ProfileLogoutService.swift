import Foundation
import WebKit
import UIKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
  
    private init() { }

    func logout() {
        cleanCookies()
        clearUserData()
        switchToAuthViewController()
    }

    private func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
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

        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
        window.rootViewController = authViewController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {}, completion: nil)
    }
}
