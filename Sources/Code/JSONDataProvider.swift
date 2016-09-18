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

class JSONDataProvider<Input, Output>: DataProvider
    where Output: JSONDataType, Input: Equatable, Input: SignificanceComparable
{
    static var updateCallbacksWithoutInputChange: Bool { return false }
    
    // MARK: - Protocol Variables
    var callbackId: Int = 0
    var callbacks: [Int : (Result<(Output, Input)>) -> ()]
    
    var inputCache: Input?
    var outputCache: Result<(Output, Input)>?
    
    // MARK: - Private Properties
    fileprivate let apiInformation: APIAccessInformation<Input>
    fileprivate let requestHandler: URLRequestHandler
    
    // MARK: - Init
    init(apiInformation: APIAccessInformation<Input>, requestHandler: URLRequestHandler)
    {
        self.apiInformation = apiInformation
        self.requestHandler = requestHandler
        self.callbacks = [:]
    }
}

extension JSONDataProvider
{
    // MARK: - Fetch Data
    func fetchData(from input: Input)
    {
        let method = self.apiInformation.requestMethod
        let url = self.apiInformation.baseURL
        let parameters = self.apiInformation.apiParameters(for: input)

        self.requestHandler.request(url, method: method, parameters: parameters as [String : AnyObject]?, completion: { response in
            let result = response.result
            guard let value = result.value, let output = Output(json: JSON(value)), result.error == nil else
            {
                var output: Result<(Output, Input)>
                if let error = result.error
                {
                    output = .error(.local(error))
                    Log.info("\(error) with response: \(response.debugDescription)")
                }
                else
                {
                    output = .error(.other("Couldn't complete request \(response.request ?? nil) with response: \(response.debugDescription)"))
                }

                self.notifyCallbacks(with: output)
                return
            }

            self.notifyCallbacks(with: .success((output, input)))
        })
    }
}
