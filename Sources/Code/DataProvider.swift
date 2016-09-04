//
//  DataProvider.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 17.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

protocol DataProvider
{
    associatedtype InputDataType: Equatable, SignificanceComparable
    associatedtype OutputDataType
    
    static var updateCallbacksWithoutInputChange: Bool { get }
    
    var inputCache: InputDataType? { get set }
    var outputCache: Result<(OutputDataType, InputDataType)>? { get set }
    
    var callbackId: Int { get set }
    var callbacks: [Int : (Result<(OutputDataType, InputDataType)>) -> Void] { get set }
    
    func fetchData(fromInput input: InputDataType)
    
    mutating func registerCallback(callback: (Result<(OutputDataType, InputDataType)>) -> Void) -> Int
    mutating func unregisterCallback(withId id: Int)
}

extension DataProvider
{
    // MARK: - Cache Management / Input Data
    mutating func updateInputData(inputData: InputDataType)
    {
        if let inputCache = self.inputCache, let outputCache = self.outputCache where inputCache == inputData
        {
            // no changes to the input and the output is already cached => no fetch request necessary, just update callbacks if wanted
            if Self.updateCallbacksWithoutInputChange
            {
                self.notifyCallbacks(withOutput: outputCache)
            }
        }
        else if let inputCache = self.inputCache where !(inputCache >> inputData)
        {
            // input has changed, but just marginally => doesn't require fetching data again, but DON'T update the cache!
            return
        }
        else
        {
            // significantly different new input data => save in cache and reset the output cache, then start the fetch request
            self.inputCache = inputData
            self.outputCache = nil
            
            self.fetchData(fromInput: inputData)
        }
    }
    
    // MARK: - Callback Management
    mutating func registerCallback(callback: (Result<(OutputDataType, InputDataType)>) -> Void) -> Int
    {
        self.callbackId += 1
        self.callbacks[self.callbackId] = callback
        return self.callbackId
    }
    
    mutating func unregisterCallback(withId id: Int)
    {
        self.callbacks.removeValueForKey(id)
    }
    
    func notifyCallbacks(withOutput output: Result<(OutputDataType, InputDataType)>)
    {
        self.callbacks.each { $1(output) }
    }
}