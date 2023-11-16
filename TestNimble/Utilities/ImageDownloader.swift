//
//  ImageDownloader.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 10/11/23.
//

import Foundation
import UIKit

class ImageDownloader {
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                // Handle error, e.g., call completion with nil
                print("Error downloading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
