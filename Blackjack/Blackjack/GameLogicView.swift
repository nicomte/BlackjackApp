//
//  GameLogicView.swift
//  Blackjack
//
//  Created by HSLU-N0004891 on 18.11.2024.
//
import SwiftUI

struct Card {
    var rank: String
    var suit: String
    var value: Int
    
    var imageName: String {
        return "\(rank)_of_\(suit)"
    }
}

class Deck {
    var cards: [Card]
    
    init() {
        let ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"]
        let suits = ["hearts", "diamonds", "clubs", "spades"]
        
        self.cards = []
        
        for suit in suits {
            for rank in ranks {
                let value: Int
                switch rank {
                case "Ace":
                    value = 11
                case "King", "Queen", "Jack":
                    value = 10
                default:
                    value = Int(rank) ?? 0
                }
                
                let card = Card(rank: rank, suit: suit, value: value)
                self.cards.append(card)
            }
        }
        
        self.cards.shuffle()
    }
    
    func drawCard() -> Card {
        return cards.removeFirst()
    }
}

struct GameLogicView: View {
    @EnvironmentObject var gameSettings: GameSettings
    @State private var dealerHand: [Card] = []
    @State private var playerHand: [Card] = []
    @State private var dealerScore: Int = 0
    @State private var playerScore: Int = 0
    @State private var gameOver: Bool = false
    @State private var resultMessage: String = ""
    @State private var deck = Deck()
    
    var body: some View {
        VStack {
            // Dealer's cards
            VStack {
                Text("Dealer")
                    .font(.title)
                    .padding(.top)
                
                HStack {
                    ForEach(dealerHand, id: \.imageName) { card in
                        Image(card.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 100)
                            .padding(5)
                    }
                }
            }
            .padding()
            
            // Spacer between dealer and player sections
            Spacer()
            
            // Player's cards
            VStack {
                Text("Player")
                    .font(.title)
                    .padding(.top)
                
                HStack {
                    ForEach(playerHand, id: \.imageName) { card in
                        Image(card.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 100)
                            .padding(5)
                    }
                }
            }
            .padding()
            
            Spacer()
            
            // Show current score
            Text("Player Score: \(playerScore)")
                .font(.headline)
            Text("Dealer Score: \(dealerScore)")
                .font(.headline)
            
            Spacer()
            
            // Game Over or Continue Button
            if gameOver {
                VStack {
                    Text(resultMessage)
                        .font(.title)
                        .padding()
                    Text("New Balance: \(gameSettings.balance)")
                        .font(.headline)
                        .padding()
                    
                    Button("Play Again") {
                        startGame()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Back to Tables") {
                        // Action to go back to TableSelectionView
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                HStack {
                    Button("Hit") {
                        playerHits()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Stand") {
                        dealerPlays()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .onAppear {
            startGame()
        }
    }
    
    func startGame() {
        dealerHand = drawInitialCards()
        playerHand = drawInitialCards()
        dealerScore = calculateScore(for: dealerHand)
        playerScore = calculateScore(for: playerHand)
        gameOver = false
        resultMessage = ""
    }
    
    func drawInitialCards() -> [Card] {
        var hand: [Card] = []
        hand.append(deck.drawCard())
        hand.append(deck.drawCard())
        return hand
    }
    
    func calculateScore(for hand: [Card]) -> Int {
        var score = 0
        var aceCount = 0
        
        for card in hand {
            score += card.value
            if card.rank == "Ace" {
                aceCount += 1
            }
        }
        
        while score > 21 && aceCount > 0 {
            score -= 10
            aceCount -= 1
        }
        
        return score
    }
    
    func playerHits() {
        if !gameOver {
            playerHand.append(deck.drawCard())
            playerScore = calculateScore(for: playerHand)
            if playerScore > 21 {
                resultMessage = "Player Busted! Dealer Wins!"
                gameOver = true
                gameSettings.balance -= gameSettings.bet
            }
        }
    }
    
    func dealerPlays() {
        if !gameOver {
            while dealerScore < 17 {
                dealerHand.append(deck.drawCard())
                dealerScore = calculateScore(for: dealerHand)
            }
            
            if dealerScore > 21 {
                resultMessage = "Dealer Busted! Player Wins!"
                gameSettings.balance += gameSettings.bet
            } else if dealerScore > playerScore {
                resultMessage = "Dealer Wins!"
                gameSettings.balance -= gameSettings.bet
            } else if dealerScore < playerScore {
                resultMessage = "Player Wins!"
                gameSettings.balance += gameSettings.bet
            } else {
                resultMessage = "It's a Tie!"
            }
            
            gameOver = true
        }
    }
}

#Preview {
    GameLogicView().environmentObject(GameSettings())
}
