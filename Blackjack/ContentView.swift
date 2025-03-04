//
//  ContentView.swift
//  Blackjack
//
//  Created by HSLU-N0004891 on 13.11.2024.
//
 
import SwiftUI
 
struct ContentView: View {
    @StateObject private var gameSettings = GameSettings()
    var body: some View {
     TableSelectionView()
            .environmentObject(gameSettings)
    }
}
 
#Preview {
    ContentView()
}
