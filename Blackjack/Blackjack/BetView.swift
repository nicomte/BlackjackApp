//
//  BetView.swift
//  Blackjack
//
//  Created by HSLU-N0004891 on 18.11.2024.
//

import SwiftUI

struct BetView: View {
    @EnvironmentObject var gameSettings: GameSettings

    var body: some View {
        VStack(spacing: 40) {
            Text("Place Your Bet")
                .font(.title)
                .padding()

            Text("Bet: $\(gameSettings.bet)")
                .font(.largeTitle)
                .fontWeight(.bold)

            HStack(spacing: 20) {
                Button(action: {
                    if gameSettings.bet > 0 {
                        gameSettings.bet -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                }

                Button(action: {
                    gameSettings.bet += 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                }
            }

            Button(action: {
                gameSettings.isGameActive = true
            }) {
                NavigationLink(destination: GameLogicView()) {
                    Text("Start Game")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
