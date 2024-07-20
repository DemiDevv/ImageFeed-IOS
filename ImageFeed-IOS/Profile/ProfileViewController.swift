import UIKit

final class ProfileViewController: UIViewController {
    private let imageViewProfile = UIImageView()
    private let exitButton = UIButton.systemButton(
        with: UIImage(systemName: "ipad.and.arrow.forward")!,
        target: ProfileViewController.self,
        action: #selector(Self.didTapButton)
    )
    private let fioLabel = UILabel()
    private let userNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileViewCreated()
        fetchProfileData()
    }
    
    func profileViewCreated() {
        imageViewProfile.image = UIImage(named: "PhotoImage")
        imageViewProfile.tintColor = .red
        imageViewProfile.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewProfile)
        imageViewProfile.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageViewProfile.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageViewProfile.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageViewProfile.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        
        
        exitButton.setImage(UIImage(named: "ExitImage"), for: .normal)
        exitButton.tintColor = .ypRedIOS
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: imageViewProfile.centerYAnchor).isActive = true
        
        fioLabel.text = "Екатерина Новикова"
        fioLabel.textColor = .ypWhiteIOS
        fioLabel.font = .systemFont(ofSize: 23, weight: .bold)
        fioLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fioLabel)
        fioLabel.topAnchor.constraint(equalTo: imageViewProfile.bottomAnchor, constant: 8).isActive = true
        fioLabel.leadingAnchor.constraint(equalTo: imageViewProfile.leadingAnchor).isActive = true
        
        userNameLabel.text = "@ekaterina_nov"
        userNameLabel.textColor = .ypGrayIOS
        userNameLabel.font = .systemFont(ofSize: 13)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: fioLabel.bottomAnchor, constant: 8).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: imageViewProfile.leadingAnchor).isActive = true
        
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhiteIOS
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: imageViewProfile.leadingAnchor).isActive = true
    }
    
    private func fetchProfileData() {
        guard let token = OAuth2TokenStorage.shared.token else {
            print("Error: No token available")
            return
        }
        
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.fioLabel.text = profile.name
                    self?.userNameLabel.text = profile.loginName
                    self?.descriptionLabel.text = profile.bio
                }
            case .failure(let error):
                print("Failed to fetch profile: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func didTapButton() {
        
    }
}

