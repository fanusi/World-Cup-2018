//
//  EuroJSON.swift
//  Swipetest1
//
//  Created by Stéphane Trouvé on 15/02/2021.
//

import Foundation

struct fixture: Codable {
    var venue: String
    var round: String
    var fixture_id: Int
    var status: String
    var awayTeam: AT
    var homeTeam: HT
    var score: FT
    var goalsAwayTeam: Int
    var goalsHomeTeam: Int
    
    enum CodingKeys: String, CodingKey {
           case venue
           case round
           case fixture_id
           case status
           case awayTeam
           case homeTeam
           case goalsAwayTeam
           case goalsHomeTeam
           case score
       }
       
       // The Initializer function from Decodable
       init(from decoder: Decoder) throws {
           // 1 - Container
           let values = try decoder.container(keyedBy: CodingKeys.self)
           
           // 2 - Normal Decoding
           fixture_id = try values.decode(Int.self, forKey: .fixture_id)
           awayTeam = try values.decode(AT.self, forKey: .awayTeam)
           homeTeam = try values.decode(HT.self, forKey: .homeTeam)
           score =  try values.decode(FT.self, forKey: .score)
           status =  try values.decode(String.self, forKey: .status)
           
           // 3 - Conditional Decoding
           if var goalsAwayTeam =  try values.decodeIfPresent(Int.self, forKey: .goalsAwayTeam) {
               self.goalsAwayTeam = goalsAwayTeam
           } else {
               self.goalsAwayTeam = -999
           }
        
           if var goalsHomeTeam =  try values.decodeIfPresent(Int.self, forKey: .goalsHomeTeam) {
               self.goalsHomeTeam = goalsHomeTeam
           } else {
               self.goalsHomeTeam = -999
           }
        
           if var round =  try values.decodeIfPresent(String.self, forKey: .round) {
               self.round = round
           } else {
               self.round = "NA"
           }
        
            if var venue =  try values.decodeIfPresent(String.self, forKey: .venue) {
                self.venue = venue
            } else {
                self.venue = "NA"
            }
        
        
       }
}

struct fixtures: Codable {
    var fixtures: [fixture]
}

struct api1: Codable {
    var api: fixtures
}

struct AT: Codable {
    var team_name: String
}

struct HT: Codable {
    var team_name: String
}

struct FT: Codable {
    var fulltime: String
    
    enum CodingKeys: String, CodingKey {
           case fulltime
       }
    
    init(from decoder: Decoder) throws {
        // 1 - Container
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        
        // 3 - Conditional Decoding
        if var fulltime =  try values.decodeIfPresent(String.self, forKey: .fulltime) {
            self.fulltime = fulltime
        } else {
            self.fulltime = "-"
        }
        
    }
    
}
