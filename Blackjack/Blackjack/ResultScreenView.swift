//
//  ResultScreenView.swift
//  Blackjack
//
//  Created by HSLU-N0004891 on 13.11.2024.
//

import SwiftUI
 
struct ResultScreenView: View {
    var playerScore: Int
    var dealerScore: Int
    var resultMessage: String
    var newBalance: Int
    var onPlayAgain: () -> Void

    var body: some View {
        VStack {
            Text("Game Over!")
                .font(.largeTitle)
                .padding()

            Text(resultMessage)
                .font(.title)
                .foregroundColor(.green)
                .padding()

            Text("Player Score: \(playerScore)")
            Text("Dealer Score: \(dealerScore)")
                .padding()

            Text("New Balance: \(newBalance)$")
                .font(.headline)
                .padding()

            Button("Play Again") {
                onPlayAgain()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
