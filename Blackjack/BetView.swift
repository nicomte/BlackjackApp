//
//  BetView.swift
//  Blackjack
//
//  Created by HSLU-N0004891 on 18.11.2024.
//
import SwiftUI

struct BetView: View {
    @EnvironmentObject var gameSettings: GameSettings
    @Environment(\.dismiss) var dismiss // For navigating back

    var body: some View {
        Image("BetBackground")
            .resizable()
            .ignoresSafeArea()
            .overlay(
        ZStack {
            VStack(spacing: 40) {
                Text("Place Your Bet")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)

                // Display the current bet value
                Text("Bet: $\(gameSettings.bet)")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)

                // Bet adjustment buttons
                HStack(spacing: 20) {
                    Button(action: {
                        if gameSettings.selectedTable == 1 || gameSettings.selectedTable == 3 {
                            if gameSettings.bet > 0 {
                                gameSettings.bet -= 1
                            }
                        } else if gameSettings.selectedTable == 2 || gameSettings.selectedTable == 4 {
                            if gameSettings.bet >= 10 {
                                gameSettings.bet -= 10
                            }
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.red)
                    }

                    Button(action: {
                        if gameSettings.selectedTable == 1 || gameSettings.selectedTable == 3 {
                            // Increment by 1
                            if gameSettings.balance >= gameSettings.bet + 1 && gameSettings.bet < 10 {
                                gameSettings.bet += 1
                            }
                        } else if gameSettings.selectedTable == 2 || gameSettings.selectedTable == 4 {
                            // Increment by 10
                            if gameSettings.balance >= gameSettings.bet + 10 {
                                gameSettings.bet += 10
                            }
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.green)
                    }

                }

                // OK button to proceed to GameLogicView
                Button(action: {}) {
                    NavigationLink(destination: GameLogicView()) {
                        Text("Lets start")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(8)
                    }
                }
                .disabled(gameSettings.bet <= 0)
                .buttonStyle(PlainButtonStyle())

                // Back button to return to TableSelectionView
                Button(action: {
                    dismiss()
                }) {
                    Text("Back to Tables")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationBarBackButtonHidden(true)

            // Game Over Overlay
            if gameSettings.balance <= 0 {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(	
                        VStack(spacing: 20) {
                            Text("Game Over!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("You have lost all your balance.")
                                .font(.headline)
                                .foregroundColor(.white)

                            Button(action: {
                                gameSettings.restartGame()
                                dismiss() // Navigate back to table selection view
                            }) {
                                Text("Restart")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    )
            }
        }
        )
    }
}

#Preview {
    BetView().environmentObject(GameSettings())
}

