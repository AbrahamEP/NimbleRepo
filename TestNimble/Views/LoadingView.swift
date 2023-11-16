//
//  LoadingView.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 05/11/23.
//

import UIKit

import UIKit

class LoadingView: UIView {
    private let activityIndicator: UIActivityIndicatorView

    override init(frame: CGRect) {
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            // Fallback on earlier versions
            activityIndicator = UIActivityIndicatorView()
        }
        super.init(frame: frame)
        
        self.setupUI()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        activityIndicator.color = .blue
        
        addSubview(activityIndicator)
        activityIndicator.center = center
        activityIndicator.isHidden = true
    }

    func startLoading() {
        isHidden = false
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        isHidden = true
        activityIndicator.stopAnimating()
    }
}

