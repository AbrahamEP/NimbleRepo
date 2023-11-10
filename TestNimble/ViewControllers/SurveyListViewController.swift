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
    var pageControl: UIPageControl!
    
    //MARK: - Variables
    private let apiService = APINimbleService()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSurveyPageView()
        self.setupPageControl()
        
        let keychainManager = KeychainManager()
        
        guard let token = keychainManager.getToken() else {
            print("No token")
            return
        }
        print("Auth token: \(token)")
        
        self.apiService.getSurveyList { result in
            switch result {
            case .success(let surveyListResponse):
                print("Success \(surveyListResponse)")
                
            case .failure(let error):
                switch error {
                case .apiError(let message):
                    print("Error fetching SurveyList: \(message)")
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Setup methods
    
    private func setupGradientLayerForBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = surveyPageView.backgroundImageView.frame
        
        let topColor = UIColor.green
        let bottomColor = UIColor.red
        
        gradientLayer.colors = [topColor, bottomColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        surveyPageView.backgroundImageView.layer.addSublayer(gradientLayer)
    }
    
   
    private func setupSurveyPageView() {
        surveyPageView = SurveyPageView()
        surveyPageView.translatesAutoresizingMaskIntoConstraints = false
        surveyPageView.delegate = self
        
        self.view.addSubview(surveyPageView)
        
        surveyPageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        surveyPageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        surveyPageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        surveyPageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.backgroundColor = .gray.withAlphaComponent(0.5)
        self.view.addSubview(pageControl)
        
        pageControl.bottomAnchor.constraint(equalTo: surveyPageView.surveyTitleLabel.topAnchor, constant: -10).isActive = true
        pageControl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        
    }
    
    //MARK: - Actions
    

}

extension SurveyListViewController: SurveyPageViewDelegate {
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
