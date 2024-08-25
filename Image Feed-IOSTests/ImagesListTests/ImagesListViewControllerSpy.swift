import UIKit
@testable import ImageFeed_IOS

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
    var updateTableViewAnimatedCalled = false
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
}
