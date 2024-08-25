import ImageFeed_IOS
import Foundation
@testable import ImageFeed_IOS

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed_IOS.ProfileViewPresenterProtocol?
    var updateProfileDetailsCalled: Bool = false
    
    func profileViewCreated() {
    }
    
    func updateProfileDetails(profile: ImageFeed_IOS.Profile) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatarImage(with url: URL) {
        
    }
}
