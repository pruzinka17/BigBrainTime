//
//  CategoriesDTO.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 03.02.2023.
//

import Foundation

struct CategoriesDTO: Codable {
    
    let artsAndLiterarature: [String]
    let filmAndTv: [String]
    let foodAndDrink: [String]
    let generalKnowledge: [String]
    let geography: [String]
    let history: [String]
    let music: [String]
    let science: [String]
    let societyAndCulture: [String]
    let sportAndLeisure: [String]
    
    enum CodingsKeys: String, CodingKey, CaseIterable {
        
        case artsAndLiterarature = "Arts & Literature"
        case filmTv = "Film & TV"
        case foodAndDrink = "Food & Drink"
        case generalKnowledge = "General Knowledge"
        case geography = "Geography"
        case history = "History"
        case music = "Music"
        case science = "Science"
        case societyAndCulture = "Society & Culture"
        case sportAndLeisure = "Sport & Leisure"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingsKeys.self)
        
        self.artsAndLiterarature = try container.decode([String].self, forKey: CodingsKeys.artsAndLiterarature)
        self.filmAndTv = try container.decode([String].self, forKey: CodingsKeys.filmTv)
        self.foodAndDrink = try container.decode([String].self, forKey: CodingsKeys.foodAndDrink)
        self.generalKnowledge = try container.decode([String].self, forKey: CodingsKeys.generalKnowledge)
        self.geography = try container.decode([String].self, forKey: CodingsKeys.geography)
        self.history = try container.decode([String].self, forKey: CodingsKeys.history)
        self.music = try container.decode([String].self, forKey: CodingsKeys.music)
        self.science = try container.decode([String].self, forKey: CodingsKeys.science)
        self.societyAndCulture = try container.decode([String].self, forKey: CodingsKeys.societyAndCulture)
        self.sportAndLeisure = try container.decode([String].self, forKey: CodingsKeys.sportAndLeisure)
    }
}
