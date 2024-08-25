import XCTest
@testable import ImageFeed_IOS

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        viewController.loadViewIfNeeded()
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled, "Presenter's viewDidLoad should be called")
    }
    
    func testPresenterFetchPhotosNextPage() {
        // given
        let presenter = ImagesListViewPresenterSpy()
        
        // when
        presenter.fetchPhotosNextPage()
        
        // then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled, "Presenter should call fetchPhotosNextPage")
    }
    
    func testPresenterChangeLike() {
        // given
        let presenter = ImagesListViewPresenterSpy()
        let photoId = "123"
        let isLike = true
        
        // when
        presenter.changeLike(photoId: photoId, isLike: isLike) { _ in }
        
        // then
        XCTAssertTrue(presenter.changeLikeCalled, "Presenter should call changeLike")
        XCTAssertEqual(presenter.changeLikePhotoId, photoId, "Photo ID should be passed correctly")
        XCTAssertEqual(presenter.changeLikeIsLike, isLike, "Like status should be passed correctly")
    }
    
    func testViewControllerCallsUpdateTableViewAnimated() {
        // given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter(view: viewController)
        viewController.presenter = presenter
        
        // when
        viewController.updateTableViewAnimated()
        
        // then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled, "View should call updateTableViewAnimated")
    }
    
    func testPrepareForSegue() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        
        let segue = UIStoryboardSegue(identifier: "ShowSingleImage", source: viewController, destination: SingleImageViewController())
        let indexPath = IndexPath(row: 0, section: 0)
        
        let photo = Photo(id: "1", size: CGSize(width: 100, height: 100), createdAt: Date(), welcomeDescription: "Test Description", thumbImageURL: "thumbURL", largeImageURL: "largeURL", fullImageURL: "fullURL", isLiked: false)
        
        viewController.photos = [photo]
        
        // when
        viewController.prepare(for: segue, sender: indexPath)
        
        // then
        XCTAssertNotNil((segue.destination as! SingleImageViewController).fullImageURL, "Full image URL should be passed to the destination view controller")
    }
}
