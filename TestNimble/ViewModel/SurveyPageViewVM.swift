//
//  SurveyPageViewVM.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 09/11/23.
//

import Foundation
import UIKit

class SurveyPageViewVM {
    // MARK: - Init
    init(surveys: [SurveyListResponse], images: [UIImage]) {
        self.surveys = surveys
        guard images.isEmpty else {
            self.images = images
            return
        }
        var tmpImages: [UIImage] = []
        for _ in 0..<surveys.count{
            tmpImages.append(backgroundImages.randomElement()!)
        }
        self.images = tmpImages
    }
    
    init() {
        self.surveys = []
        self.images = []
    }
    
    //MARK: - Private vars
    private var surveys: [SurveyListResponse]
    private let backgroundImages: [UIImage] = [
        UIImage(named: "SurveyBackground")!,
        UIImage(named: "SurveyBackground2")!,
        UIImage(named: "SurveyBackground3")!
    ]
    private var images: [UIImage]
    
    //MARK: - Public vars
    var currentIndex: Int = 0
    
    var count: Int {
        surveys.count
    }
    
    var currentImage: UIImage? {
        guard currentIndex < images.count else {
            return nil
        }
        return images[currentIndex]
    }
    
    var currentItem: SurveyListResponse? {
        guard currentIndex < surveys.count else {
            return nil
        }
        return surveys[currentIndex]
    }
    
    //MARK: - Methods
    func nextItem() {
        currentIndex += 1
        if currentIndex >= surveys.count {
            currentIndex = 0
        }
    }
    
    func previousItem() {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = surveys.count - 1
        }
    }
    
}

//MARK: - Extension - formatted info
extension SurveyPageViewVM {
    var mediumFormattedDate: String {
        guard let currentItem = currentItem else {
            return "No info"
        }
        let dateFormatterUtility = DateFormatterUtility.shared
        guard let date = dateFormatterUtility.date(from: currentItem.attributes.createdAt, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") else {
            
            return "No format"
        }
        let dateString = dateFormatterUtility.string(from: date, format: "MMMM d")
        
        return dateString
    }
    
    var shortFormattedDate: String {
        guard let currentItem = currentItem else {
            return "No info"
        }
        let dateFormatterUtility = DateFormatterUtility.shared
        guard let date = dateFormatterUtility.date(from: currentItem.attributes.createdAt, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") else {
            
            return "No format"
        }
        let dateString = dateFormatterUtility.string(from: date, format: "EEEE")
        return dateString
    }
}
