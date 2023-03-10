//
//  CustomError.swift
//  WeatherApp
//
//  Created by Mina Atef on 10/03/2023.
//

import Foundation

class CustomError {
    static let faildtoPasrse = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "faild_to_parse"])
    static let noHttpResponse = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "no_http_response"])
    static let noURL = NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey: "no_url"])
    static let fileNotFound = NSError(domain: "", code: 3, userInfo: [NSLocalizedDescriptionKey: "file_not_Found"])
}
