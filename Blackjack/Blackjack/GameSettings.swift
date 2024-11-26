//
//  GameSettings.swift
//  Blackjack
//
//  Created by Nico Graf on 14.11.2024.
//
import SwiftUI

class GameSettings: ObservableObject {
    @Published var selectedTable: Int
    @Published var balance: Int
    @Published var bet: Int
    @Published var isGameActive: Bool
    @Published var showResultScreen: Bool

    init(selectedTable: Int = 0, balance: Int = 10, bet: Int = 0, isGameActive: Bool = false, showResultScreen: Bool = false) {
        self.selectedTable = selectedTable
        self.balance = balance
        self.bet = bet
        self.isGameActive = isGameActive
        self.showResultScreen = showResultScreen
    }

    func resetGame() {
        isGameActive = false
        showResultScreen = false
        bet = 0
    }
}
