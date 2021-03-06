//
//  LFError.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 17.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import RealmSwift

enum LFError: Swift.Error
{
    case realm(RealmSwift.Error)
    
    case user(Alertifiable)
    case local(Swift.Error)
    
    case other(String)
}

extension LFError
{
    var description: String {
        switch self
        {
        case .realm(let error):
            return String(describing: error)
            
        case .user(let alertifiable):
            let (title, message) = alertifiable.alertTuple
            return message == nil ? title : "\(title) - \(message!)"
            
        case .local(let error):
            return String(describing: error)
            
        case .other(let string):
            return string
        }
    }
}
