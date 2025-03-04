import SwiftUI

struct TableSelectionView: View {
    @EnvironmentObject var gameSettings: GameSettings
    @State private var showingCrazyRules = false // State variable to control modal presentation

    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationView {
            Image("TableSelectionBackground")
                .resizable()
                .ignoresSafeArea()
                .overlay(
                    ZStack {
                        VStack {
                            HStack {
                                Button(action: resetGames) {
                                    Text("Reset Games")
                                        .padding()
                                        .background(Color.red.opacity(0.7))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .padding()
                                Spacer()
                                Text("Balance: $" + String(gameSettings.balance))
                                    .font(.headline)
                                    .foregroundColor(.yellow)
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(8)
                                    .padding()
                            }
                            Spacer()
                        }
                        
                        VStack(spacing: 20) {
                            Text("Select a Table")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(8)
                            

                            
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(1...4, id: \.self) { table in
                                    NavigationLink(
                                        destination: BetView().environmentObject(gameSettings),
                                        label: {
                                            Image("Gambling_Table")
                                                .resizable()
                                                .frame(width: 175, height: 100)
                                                .cornerRadius(8)
                                                .overlay(
                                                    VStack {
                                                        switch table {
                                                        case 1:
                                                            Text("Max Bet: 10 Regular Rules")
                                                                .font(.headline)
                                                                .foregroundColor(.white)
                                                        case 2:
                                                            Text("Max Bet: No Limit Regular Rules")
                                                                .font(.headline)
                                                                .foregroundColor(.white)
                                                        case 3:
                                                            Text("Max Bet: 10 Crazy Rules")
                                                                .font(.headline)
                                                                .foregroundColor(.white)
                                                        case 4:
                                                            Text("Max Bet: No Limit Crazy Rules")
                                                                .font(.headline)
                                                                .foregroundColor(.white)
                                                        default:
                                                            EmptyView()
                                                        }
                                                    }
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
                            // Modal presentation for Crazy Rules
                            .alert(isPresented: $showingCrazyRules) {
                                Alert(title: Text("Crazy Rules"),
                                      message: Text(crazyRulesDescription()),
                                      dismissButton: .default(Text("Got it!")))
                            }
                            Button(action: {
                                showingCrazyRules.toggle()
                            }) {
                                Text("Read Crazy Rules")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(8)
                            }
                            .padding()
                        }
                        .padding()
                    }
                )
        }
    }

    func resetGames() {
        gameSettings.restartGame()
    }

    // Function to return the Crazy Rules description
    private func crazyRulesDescription() -> String {
        return"""
              1. If the Player hits a black 7 his balance will be halved and if the player hits a red 7 it gets doubled
              2. If the Player or the Dealer hits two 8 the game will be reset
              3. The player will have the opportunity to redraw once every round
              4. Every round there will be a random selected element. The element is connected to a cardtype.
              Fire -> on all Spades -1 , Water -> on all Clubs -1, Earth -> on all Diamonds -1, Air -> on all Hearts -1
              """
    }
}

#Preview {
    TableSelectionView()
}
