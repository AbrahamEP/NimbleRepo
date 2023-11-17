//
//  ViewController.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 04/11/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - UI
    
    @IBOutlet var imageBackgroundView: UIImageView!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    var forgotButton: UIButton!
    
    var loadingView: LoadingView!
    
    //MARK: Variables
    private var apiService = APINimbleService()
    let keychainManager = KeychainManager()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupTextFields()
        self.setupViews()
        
        guard let _ = keychainManager.getToken() else {
            return
        }
        self.performSegue(withIdentifier: "toMainSegue", sender: nil)
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        self.loadingView = LoadingView()
        self.view.addSubview(loadingView)
        loadingView.center = self.view.center
        self.view.bringSubviewToFront(loadingView)
    }
    
    private func setupTextFields() {
        self.emailTextField.placeholder = "Email"
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.textContentType = .emailAddress
        
        self.passwordTextField.placeholder = "Password"
        self.passwordTextField.textContentType = .password
    }
    
    //MARK: - Helper
    private func successLoginFlow(with loginResponse: LoginResponse) {
        
        let token = loginResponse.attributes.accessToken
        
        guard let _ = keychainManager.getToken() else {
            // Save token
            guard keychainManager.saveToken(token) else {
                print("Error saving auth token: \(token)")
                return
            }
            
            self.performSegue(withIdentifier: "toMainSegue", sender: nil)
            return
        }
        // Token already saved
        self.performSegue(withIdentifier: "toMainSegue", sender: nil)
    }
    
    private func navigateToMain() {
        if let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewNavigationController") as? UINavigationController {
            present(mainViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions
    @IBAction func loginButtonAction(_ button: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            self.presentAlertController(text: "Please fill all the fields", title: "Missing info") {
                
            }
            return
        }
        print("email: \(email) and password \(password)")
        
        self.loadingView.startLoading()
        self.apiService.login(with: email, password: password) { [loadingView = self.loadingView, weak self] result in
            DispatchQueue.main.async {
                loadingView?.stopLoading()
                switch result {
                case .success(let loginResponse):
                    self?.successLoginFlow(with: loginResponse)
                case .failure(let error):
                    switch error {
                    case .apiError(let errorString):
                        self?.presentAlertController(text: "Error", title: "Error login", okAction: {
                            
                        })
                        print("Error: \(errorString)")
                    }
                }
            }
            
        }
    }
    
}

