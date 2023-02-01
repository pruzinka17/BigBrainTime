//
//  CategoriesProvider.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 01.02.2023.
//

import Foundation

final class CategoriesProvider {
    
    func provideCategories() -> [String] {
        
        let categories: [String] = [
            "science",
            "general knowledge",
            "music",
            "history",
            "geography",
            "food & drink",
            "film & TV"
        ]
        
        return categories
    }
}
