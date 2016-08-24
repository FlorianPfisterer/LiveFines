//
//  PunishmentView.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 24.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

@IBDesignable
class PunishmentView: UIView
{
    // MARK: - Init
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.sharedInitialization()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.sharedInitialization()
    }
    
    private func sharedInitialization()
    {
        self.backgroundColor = .clearColor()
    }
}
