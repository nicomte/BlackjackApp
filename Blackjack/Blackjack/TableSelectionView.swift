//
//  TableSelectionView.swift
//  Blackjack
//
//  Created by HSLU-N0004891 on 13.11.2024.
//
import SwiftUI

struct TableSelectionView: View {
    @EnvironmentObject var gameSettings: GameSettings
 
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
 
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Button(action: resetGames) {
                            Text("Reset Games")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                        Spacer()
                        Text("Current Balance: $" + String(gameSettings.balance))
                            .font(.headline)
                            .padding()
                    }
                    Spacer()
                }
 
                VStack(spacing: 20) {
                    Text("Select a Table")
                        .font(.title)
 
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(1...4, id: \.self) { table in
                            NavigationLink(
                                destination: BetView().environmentObject(gameSettings),
                                label: {
                                    Image("Gambling_Table")
                                        .resizable()
                                        .frame(width: 175, height: 100) // Scale down for 2x2 layout
                                        .cornerRadius(8)
                                        .overlay(
                                            Text("Table \(table)")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .shadow(radius: 2),
                                            alignment: .bottom
                                        )
                                }
                            )
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    gameSettings.selectedTable = table
                                }
                            )
                        }
                    }
                    // Summary text
                    Text("""
                    Tables on the left (1 & 3): Bet up to $10.
                    Tables on the right (2 & 4): Unlimited betting.
                    Tables on the top (1 & 2): Basic Blackjack rules.
                    Tables on the bottom (3 & 4): Include special card effects.
                    """)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(
                        Color(red: 0 / 255, green: 100 / 255, blue: 66 / 255)
                    )
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding()
                }
                .padding()
            }
        }
    }
 
    func resetGames() {
        // Reset game state and balance if needed
    }
}
 
#Preview {
    TableSelectionView()
}
