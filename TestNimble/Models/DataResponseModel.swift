//
//  DataResponseModel.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 05/11/23.
//

import Foundation

struct DataResponseModel<T: Codable>: Codable {
    var data: T
}
