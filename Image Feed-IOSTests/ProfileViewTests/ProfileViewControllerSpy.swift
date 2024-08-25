import ImageFeed_IOS
import Foundation
@testable import ImageFeed_IOS

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed_IOS.ProfileViewPresenterProtocol?
    var setProfileDataCalled: Bool = false
    
    func profileViewCreated() {
    }
    
    func updateProfileDetails(profile: ImageFeed_IOS.Profile) {
        setProfileDataCalled = true
    }
    
    func updateAvatarImage(with url: URL) {
        
    }
}
