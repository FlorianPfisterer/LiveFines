//
//  Alertifiable.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

protocol Alertifiable
{
    var alertTuple: (String, String?) { get }
    var hasOkayAction: Bool { get }
    var style: UIAlertControllerStyle { get }
    var specialActions: [UIAlertAction] { get }
}

extension Alertifiable
{
    var alert: UIAlertController {
        let (title, message) = self.alertTuple
        let alert = UIAlertController(title: title, message: message, preferredStyle: self.style)
        
        if self.hasOkayAction { alert.addAction(.okay) }
        self.specialActions.each { alert.addAction($0) }
        
        return alert
    }
}

protocol AlertPresenter
{
    func present(error alertifiable: Alertifiable, completion: (() -> Void)?)
}