//
//  Network.swift
//  WeatherApp
//
//  Created by Mina Atef on 08/03/2023.
//

import Foundation
import Alamofire
protocol Network: AnyObject {
    func request<T: Codable>(url: String, type: T.Type, parameters: [String: String], headers: HTTPHeaders?, method: HTTPMethod, encoding: URLEncoding) async -> Result<T, Error>
}
class AFNetwork: Network {
    func request<T: Codable>(url: String, type: T.Type, parameters: [String: String], headers: HTTPHeaders?, method: HTTPMethod, encoding: URLEncoding = .queryString)  async -> Result<T, Error> {
        guard let url = URL(string: url) else {
            return .failure(NSError(domain: "", code: 0, userInfo: [:]))
        }
        let data = await withCheckedContinuation { continuation in
            AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
                continuation.resume(returning: response.data)
            }
        }
        guard let data = data else {
            return .failure(NSError(domain: "", code: 0, userInfo: [:]))
        }
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(NSError(domain: "", code: 0, userInfo: [:]))
        }
    }
    
}
