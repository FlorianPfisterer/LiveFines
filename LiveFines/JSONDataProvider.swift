//
//  JSONDataProvider.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import SwiftyJSON

protocol JSONDataType
{
    init?(json: JSON)
}

class JSONDataProvider<Input, Output, APIInformation where APIInformation: APIAccessInformation, APIInformation.InputDataType == Input, Input: Equatable, Input: SignificanceComparable, Output: JSONDataType>: DataProvider
{
    typealias InputDataType = Input
    typealias OutputDataType = Output
    
    static var updateCallbacksWithoutInputChange: Bool { return false }
    
    // MARK: - Protocol Variables
    var callbackId = 0
    var callbacks: [Int : ((Result<Output>) -> Void)]
    
    var inputCache: Input?
    var outputCache: Result<Output>?
    
    // MARK: - Private Properties
    private var apiInformation: APIInformation.Type
    private var requestHandler: URLRequestHandler
    
    // MARK: - Init
    init(_ apiInformation: APIInformation.Type, requestHandler: URLRequestHandler)
    {
        self.apiInformation = apiInformation
        self.requestHandler = requestHandler
        self.callbacks = [:]
    }
}
extension JSONDataProvider
{
    // MARK: - Fetch Data
    func fetchData(fromInput input: InputDataType)
    {
        let method = self.apiInformation.requestMethod
        let url = self.apiInformation.baseURL
        let parameters = self.apiInformation.apiParameters(forInputData: input)
        
        self.requestHandler.request(method, url, parameters: parameters) { response in
            let result = response.result
            guard let value = result.value,
                let output = OutputDataType(json: JSON(value))
                where result.error == nil else
            {
                // TODO specify Error
                self.notifyCallbacks(withOutput: .error(.other("\(result.error!.localizedDescription); Response: \(response.debugDescription)")))
                return
            }
            
            self.notifyCallbacks(withOutput: .success(output))
        }
    }
}
