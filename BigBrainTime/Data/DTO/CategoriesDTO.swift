//
//  CategoriesDTO.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 03.02.2023.
//

import Foundation

struct CategoriesDTO: Codable {
    
    let artsAndLiterarature: [String]
    
    enum CodingsKeys: String, CodingKey {
        
        case artsAndLiterarature = "Arts & Literature"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingsKeys.self)
        
        self.artsAndLiterarature = try container.decode([String].self, forKey: CodingsKeys.artsAndLiterarature)
    }
}
