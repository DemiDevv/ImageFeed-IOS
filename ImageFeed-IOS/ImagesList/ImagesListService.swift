import UIKit

struct Photo {
    internal init(id: String, size: CGSize, createdAt: Date? = nil, welcomeDescription: String? = nil, thumbImageURL: String, largeImageURL: String, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
    
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = ISO8601DateFormatter().date(from: photoResult.createdAt)
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
    }
    
    
}

final class ImagesListService {
    static var shared = ImagesListService()
    
    private init() {}
    
    private let urlSession = URLSession.shared
    private(set) var photos: [Photo] = [] {
        didSet {
            NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
        }
    }
    private var lastLoadedPage: (number: Int, total: Int)?
    private var isLoading: Bool = false
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        let nextPage = (lastLoadedPage?.number ?? 0) + 1
        
        guard let request = makePhotosRequest(page: nextPage) else {
            isLoading = false
            return
        }
        
        task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            defer {
                self?.task = nil
            }
            
            if let error = error {
                print("Error fetching photos: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            self?.photos = Array(0..<10).map{_ in Photo(id: "", size: .zero, thumbImageURL: "", largeImageURL: "", isLiked: true)}
            do {
                let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                DispatchQueue.main.async {
                    self?.photos += photoResults.map { Photo(from: $0) }
                    self?.lastLoadedPage = (number: nextPage, total: photoResults.count)
                }
            } catch {
                print("Error decoding photos: \(error)")
            }
        }
        
        task?.resume()
    }
    
    private func makePhotosRequest(page: Int = 1, perPage: Int = 10, orderBy: String = "latest") -> URLRequest? {
        guard let baseURL = URL(string: "https://api.unsplash.com") else {
            assertionFailure("Failed to create base URL")
            return nil
        }
        
        guard let url = URL(string: "/photos", relativeTo: baseURL) else {
            return nil
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "order_by", value: orderBy)
        ]
        
        guard let finalURL = components?.url else {
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(OAuth2TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
