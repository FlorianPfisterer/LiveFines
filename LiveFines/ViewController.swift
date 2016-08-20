//
//  ViewController.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 17.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let result = Database.realm()
        switch result
        {
        case .success(let realm):
            let provider = LiveFinesProvider(requestHandler: AlamofireRequestHandler(), realm: realm)
            provider.startReceivingUpdates(self)
            
            print(Array(realm.objects(Node.self)))
            
        default:
            return
        }
    }
}

extension ViewController: LiveFinesUpdateReceiver
{
    func update(node node: Node)
    {
        Log.info("Receiving \(node)")
    }
}