//
//  CurrencyAPI.swift
//  CurrencyConversion
//
//  Created by ArakiTaku on 2021/01/18.
//

import Foundation
import Alamofire

class CurrencyAPI: CurrencyAPIProtocol {
    func getConversionRates(onSuccess: @escaping (ConversionRateDTO) -> Void, onError: @escaping (Error) -> Void) {
        AF.request("http://api.currencylayer.com/live?access_key=<your access key>").response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    if let dto = try? JSONDecoder().decode(ConversionRateDTO.self, from: data) {
                        onSuccess(dto)
                    }
                }
            case .failure(let error):
                onError(error)
            }
        }
    }
}
