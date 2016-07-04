//
//  Disaster.swift
//  Segmentio
//
//  Created by Dmitriy Demchenko
//  Copyright © 2016 Yalantis Mobile. All rights reserved.
//

struct Disaster {
    
    var cardName: String?
    var hints: [String]?
    
    init(cardName: String?, hints: [String]?) {
        self.cardName = cardName
        self.hints = hints
    }
    
}