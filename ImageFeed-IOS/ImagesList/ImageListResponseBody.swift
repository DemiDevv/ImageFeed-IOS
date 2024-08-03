//import Foundation
//
//struct UrlsResult: Codable {
//    let raw: String
//    let full: String
//    let regular: String
//    let small: String
//    let thumb: String
//}
//
//struct PhotoResult: Codable {
//    let id: String
//    let createdAt: String
//    let updatedAt: String
//    let width: Int
//    let height: Int
//    let color: String
//    let blurHash: String
//    let likes: Int
//    let likedByUser: Bool
//    let description: String?
//    let urls: UrlsResult
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case width
//        case height
//        case color
//        case blurHash = "blur_hash"
//        case likes
//        case likedByUser = "liked_by_user"
//        case description
//        case urls
//    }
//}
//
//struct Photo {
//    let id: String
//    let size: CGSize
//    let createdAt: Date?
//    let welcomeDescription: String?
//    let thumbImageURL: String
//    let largeImageURL: String
//    let isLiked: Bool
//    
//    init(from photoResult: PhotoResult) {
//        self.id = photoResult.id
//        self.size = CGSize(width: photoResult.width, height: photoResult.height)
//        self.createdAt = ISO8601DateFormatter().date(from: photoResult.createdAt)
//        self.welcomeDescription = photoResult.description
//        self.thumbImageURL = photoResult.urls.thumb
//        self.largeImageURL = photoResult.urls.full
//        self.isLiked = photoResult.likedByUser
//    }
//}
//
