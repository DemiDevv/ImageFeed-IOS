import Foundation

struct ProfileResult: Codable {
    let id: String
    let updatedAt: String
    let username: String
    let name: String
    let firstName: String
    let lastName: String
    let instagramUsername: String?
    let twitterUsername: String?
    let portfolioURL: String?
    let bio: String
    let location: String
    let totalLikes: Int
    let totalPhotos: Int
    let totalCollections: Int
    let followedByUser: Bool
    let followersCount: Int
    let followingCount: Int
    let downloads: Int
    let social: Social
    let profileImage: ProfileImage
    let badge: Badge
    let links: Links

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username
        case name
        case firstName = "first_name"
        case lastName = "last_name"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio
        case location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case followedByUser = "followed_by_user"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case downloads
        case social
        case profileImage = "profile_image"
        case badge
        case links
    }

    struct Social: Codable {
        let instagramUsername: String?
        let portfolioURL: String?
        let twitterUsername: String?

        enum CodingKeys: String, CodingKey {
            case instagramUsername = "instagram_username"
            case portfolioURL = "portfolio_url"
            case twitterUsername = "twitter_username"
        }
    }

    struct ProfileImage: Codable {
        let small: String
        let medium: String
        let large: String
    }

    struct Badge: Codable {
        let title: String
        let primary: Bool
        let slug: String
        let link: String
    }

    struct Links: Codable {
        let selfLink: String
        let html: String
        let photos: String
        let likes: String
        let portfolio: String

        enum CodingKeys: String, CodingKey {
            case selfLink = "self"
            case html
            case photos
            case likes
            case portfolio
        }
    }
}
enum ProfileServiceError: Error {
    case invalidRequest
    case invalidURL
    case noData
    case decodingError
}

final class ProfileService {
    
    static let shared = ProfileService()
    
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private let fetchQueue = DispatchQueue(label: "com.profileService.fetchQueue")
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String
        
        init(from profileResult: ProfileResult) {
            self.username = profileResult.username
            self.name = "\(profileResult.firstName) \(profileResult.lastName)"
            self.loginName = "@\(profileResult.username)"
            self.bio = profileResult.bio
        }
        
        func createURLRequest(for url: URL, with profile: Profile) -> URLRequest? {
            guard let bearerToken = OAuth2TokenStorage.shared.token else {
                return nil
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
            return request
        }
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        fetchQueue.async {
            guard self.lastToken != token else {
                completion(.failure(ProfileServiceError.invalidRequest))
                return
            }
            self.task?.cancel()
            self.lastToken = token
            
            guard let url = URL(string: "https://unsplash.com/me") else {
                completion(.failure(ProfileServiceError.invalidURL))
                self.lastToken = nil
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.task = nil
                    self.lastToken = nil
                    
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(ProfileServiceError.noData))
                        return
                    }
                    
                    do {
                        let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                        let profile = Profile(from: profileResult)
                        completion(.success(profile))
                    } catch {
                        completion(.failure(ProfileServiceError.decodingError))
                    }
                }
            }
            
            self.task = task
            task.resume()
        }
    }
}
