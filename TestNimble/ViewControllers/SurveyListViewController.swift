//
//  SurveyListViewController.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 05/11/23.
//

import UIKit

class SurveyListViewController: UIViewController {
    
    private let apiService = APINimbleService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
