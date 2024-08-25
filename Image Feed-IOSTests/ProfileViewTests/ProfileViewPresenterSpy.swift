import Foundation
@testable import ImageFeed_IOS

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {

    
    var view: ImageFeed_IOS.ProfileViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    var updateAvatarCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    

    
    func updateProfileDetailsIfNeeded() {
    
    }
    
    func didTapLogoutButton() {
        
    }
}
