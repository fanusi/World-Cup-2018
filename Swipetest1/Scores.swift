//
//  Scores.swift
//  Swipetest1
//
//  Created by Stéphane Trouvé on 19/03/2021.
//

import Foundation

class Scores {
    
    var user: String
    var punten: Int
    var index: Int
    var ranking: Int = 0
    //var punten_last: String
    
    init(user: String, punten: Int, index: Int) {
        
        self.user = user
        self.punten = punten
        self.index = index
        
    }
    
}
