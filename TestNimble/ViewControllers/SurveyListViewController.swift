//
//  SurveyListViewController.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 05/11/23.
//

import UIKit

class SurveyListViewController: UIViewController {
    //MARK: - UI
    var surveyPageView: SurveyPageView!
    var loadingView: LoadingView!
    
    //MARK: - Variables
    private let apiService = APINimbleService()
    private let keychainManager = KeychainManager()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        guard let _ = keychainManager.getToken() else {
            let okAction = {
                self.navigateToLogin()
            }
            self.presentAlertController(text: "An error ocurred with your credentials, please try again.", title: "Ups! Something is wrong", okAction: okAction)
            return
        }
        
        self.getSurveyList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK: - Helper methods
    private func getSurveyList() {
        self.loadingView.startLoading()
        self.apiService.getSurveyList { result, images  in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.loadingView.stopLoading()
                
                switch result {
                case .success(let surveyListResponse):
                    self.surveyPageView.isHidden = false
                    self.surveyPageView.viewModel = SurveyPageViewVM(surveys: surveyListResponse, images: images)
                    
                case .failure(let error):
                    switch error {
                    case .apiError(_ ):
                        
                        self.presentAlertController(text: "Error with the request", title: "Something went wrong") {
                            self.navigateToLogin()
                        } //END Alert controller
                    } //END Switch error statement
                } //END Switch result statement
            }
        }
    }
    
    //MARK: - Setup methods
    private func navigateToLogin() {
        if let mainViewController = storyboard?.instantiateViewController(withIdentifier: "LoginNavController") as? UINavigationController {
            _ = keychainManager.deleteToken()
            present(mainViewController, animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .lightGray
        self.setupSurveyPageView()
        self.setupLoadingView()
    }
    
    private func setupGradientLayerForBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = surveyPageView.backgroundImageView.frame
        
        let topColor = UIColor.green
        let bottomColor = UIColor.red
        
        gradientLayer.colors = [topColor, bottomColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.zPosition = 1
        
        surveyPageView.backgroundImageView.layer.addSublayer(gradientLayer)
    }
    
    
    private func setupSurveyPageView() {
        surveyPageView = SurveyPageView()
        surveyPageView.translatesAutoresizingMaskIntoConstraints = false
        surveyPageView.delegate = self
        surveyPageView.isHidden = true
        
        self.view.addSubview(surveyPageView)
        
        surveyPageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        surveyPageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        surveyPageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        surveyPageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func setupLoadingView() {
        self.loadingView = LoadingView()
        self.view.addSubview(loadingView)
        loadingView.center = self.view.center
        self.view.bringSubviewToFront(loadingView)
    }
    
}

extension SurveyListViewController: SurveyPageViewDelegate {
    func didPressProfileImageView(sender: UITapGestureRecognizer) {
        let okAction = {
            self.loadingView.startLoading()
            
            self.apiService.logout { result in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.loadingView.stopLoading()
                    self.navigateToLogin()
                }
            }
        }
        self.presentAlertController(text: "Do you want to exit the app?", title: "Logout", okAction: okAction, cancelAction: { })
    }
    
    func didSwipeToRightAction(sender: UISwipeGestureRecognizer) {
        print("Swiped to Right")
    }
    
    func didSwipeToLeftAction(sender: UISwipeGestureRecognizer) {
        print("Swiped to Left")
    }
    
    func didPressStartButton() {
        print("Start button tapped")
    }
}
