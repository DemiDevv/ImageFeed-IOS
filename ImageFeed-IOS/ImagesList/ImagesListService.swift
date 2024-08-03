//import UIKit
//
//class ImagesListService {
//    
//    private let urlSession = URLSession.shared
//    private var task: URLSessionTask?
//    private var lastLoadedPage: (number: Int, total: Int)?
//    private var isLoading = false
//    
//    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
//    
//    private(set) var photos: [Photo] = [] {
//        didSet {
//            NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
//        }
//    }
//    
//    func fetchPhotosNextPage() {
//        guard !isLoading else { return }
//        
//        isLoading = true
//        
//        let nextPage = (lastLoadedPage?.number ?? 0) + 1
//        
//        guard let request = makePhotosRequest(page: nextPage) else {
//            isLoading = false
//            return
//        }
//        
//        task = urlSession.dataTask(with: request) { [weak self] data, response, error in
//            defer {
//                self?.isLoading = false
//            }
//            
//            if let error = error {
//                print("Error fetching photos: \(error)")
//                return
//            }
//            
//            guard let data = data else { return }
//            
//            do {
//                let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
//                DispatchQueue.main.async {
//                    self?.photos += photoResults.map { Photo(from: $0) }
//                    self?.lastLoadedPage = (number: nextPage, total: photoResults.count)
//                }
//            } catch {
//                print("Error decoding photos: \(error)")
//            }
//        }
//        
//        task?.resume()
//    }
//
//    
//    private func makePhotosRequest(page: Int) -> URLRequest? {
//        guard var components = URLComponents(string: "https://api.unsplash.com/photos") else {
//            assertionFailure("Failed to create URL components")
//            return nil
//        }
//        
//        components.queryItems = [
//            URLQueryItem(name: "page", value: "\(page)"),
//            URLQueryItem(name: "client_id", value: "YOUR_ACCESS_KEY")
//        ]
//        
//        guard let url = components.url else {
//            assertionFailure("Failed to create URL from components")
//            return nil
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        return request
//    }
//
//
//}
