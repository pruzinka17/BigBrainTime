//
//  ContentView.swift
//  BigBrainTime
//
//  Created by Miroslav Bořek on 25.01.2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        let networkClient = NetworkService()
        let gameService = GameService(
            networkClient: networkClient
        )
        
        MainMenuView(
            gameService: gameService
        )
    }
}
