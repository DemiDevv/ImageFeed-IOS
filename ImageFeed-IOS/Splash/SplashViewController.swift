import UIKit

final class SplashViewController: UIViewController {
    
    private let oAuthTokenStorage = OAuth2TokenStorage.shared
    private let oAuthService = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSplashScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oAuthTokenStorage.token != nil {
            switchToTabBarController()
        } else {
            self.showAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setUpSplashScreen() {
        let splashImageView = UIImageView()
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        splashImageView.image = UIImage(named: "lounch_screen_logo")
        splashImageView.backgroundColor = UIColor.ypBlackIOS
        view.addSubview(splashImageView)
        splashImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        splashImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    private func showAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            print("Failed to instantiate AuthViewController")
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        
        present(authViewController, animated: true, completion: nil)
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuthService.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token)
            case .failure:
                //TODO: LATER
                break
            }
        }
    }

    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                break
            }
        }
    }
}
