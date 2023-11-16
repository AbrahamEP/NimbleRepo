//
//  ViewController+PresentAlert.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 14/11/23.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlertController(text: String, title: String, okAction: @escaping (() -> Void), cancelAction: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        
        let okayAlertAction = UIAlertAction(title: "Okay", style: .default) { _ in
            okAction()
        }
        alertController.addAction(okayAlertAction)
        
        
        if let cancelClosure = cancelAction {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                cancelClosure()
            }
            alertController.addAction(cancelAction)
        }

        present(alertController, animated: true, completion: completion)
    }
}
