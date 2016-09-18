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
    associatedtype Input: Equatable, SignificanceComparable
    associatedtype Output
    
    static var updateCallbacksWithoutInputChange: Bool { get }
    
    var inputCache: Input? { get set }
    var outputCache: Result<(Output, Input)>? { get set }
    
    var callbackId: Int { get set }
    var callbacks: [Int : (Result<(Output, Input)>) -> Void] { get set }
    
    func fetchData(from input: Input)
    
    mutating func registerCallback(_ callback: @escaping (Result<(Output, Input)>) -> Void) -> Int
    mutating func unregisterCallback(with id: Int)
}

extension DataProvider
{
    // MARK: - Cache Management / Input Data
    mutating func updateInputData(_ inputData: Input)
    {
        if let inputCache = self.inputCache, let outputCache = self.outputCache, inputCache == inputData
        {
            // no changes to the input and the output is already cached => no fetch request necessary, just update callbacks if wanted
            if Self.updateCallbacksWithoutInputChange
            {
                self.notifyCallbacks(with: outputCache)
            }
        }
        else if let inputCache = self.inputCache , !(inputCache >> inputData)
        {
            // input has changed, but just marginally => doesn't require fetching data again, but DON'T update the cache!
            return
        }
        else
        {
            // significantly different new input data => save in cache and reset the output cache, then start the fetch request
            self.inputCache = inputData
            self.outputCache = nil
            
            self.fetchData(from: inputData)
        }
    }
    
    // MARK: - Callback Management
    mutating func registerCallback(_ callback: @escaping (Result<(Output, Input)>) -> Void) -> Int
    {
        self.callbackId += 1
        self.callbacks[self.callbackId] = callback
        return self.callbackId
    }
    
    mutating func unregisterCallback(with id: Int)
    {
        self.callbacks.removeValue(forKey: id)
    }
    
    func notifyCallbacks(with output: Result<(Output, Input)>)
    {
        self.callbacks.each { $1(output) }
    }
}
