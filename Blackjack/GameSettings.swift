//
//  GameSettings.swift
//  Blackjack
//
//  Created by Nico Graf on 14.11.2024.
//
import SwiftUI

class GameSettings: ObservableObject {
    @AppStorage("selectedTable") var selectedTable: Int = 0
    @AppStorage("balance") var balance: Int = 10
    @AppStorage("isGameActive") var isGameActive: Bool = false
    @AppStorage("gameOvers") var gameOvers: Int = 0
    @Published var showResultScreen: Bool = false
    @Published var bet: Int = 0

    func resetGame() {
        isGameActive = false
        showResultScreen = false
        bet = 0
    }
    
    func restartGame() {
            balance = 100
            bet = 0
            gameOvers += 1
        }
}
