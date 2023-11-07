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
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupTextFields()
        self.setupViews()
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
        
        self.passwordTextField.placeholder = "Password"
    }
    
    //MARK: - Actions
    @IBAction func loginButtonAction(_ button: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Must do all fields")
            return
        }
        print("email: \(email) and password \(password)")
        
        self.loadingView.startLoading()
        self.apiService.login(with: email, password: password) { [loadingView = self.loadingView] result in
            DispatchQueue.main.async {
                loadingView?.stopLoading()
                switch result {
                case .success(let loginResponse):
                    print("Success: \(loginResponse)")
                    self.performSegue(withIdentifier: "toMainSegue", sender: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
}

