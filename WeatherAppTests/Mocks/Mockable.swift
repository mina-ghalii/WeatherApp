//
//  Mockable.swift
//  WeatherAppTests
//
//  Created by Mina Atef on 10/03/2023.
//

import Foundation
import Foundation
@testable import WeatherApp
class Mockable {
    func getResourcesMock<T: Codable>(fileName: String, model: T.Type) -> Result<T, Error> {
        if let url = Bundle.init(for: type(of: self)).url(forResource: fileName, withExtension: "json") {
            let decoder = JSONDecoder()
            do {
                let jsonData = try Data(contentsOf: url)
                let resources = try decoder.decode(T.self, from: jsonData )
                return .success(resources)
            } catch {
                return .failure(CustomError.faildtoPasrse)
            }
        } else {
            return .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: CustomError.fileNotFound]))
        }
    }
}
