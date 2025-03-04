//
//  GameLogicView.swift
//  Blackjack
//
//  Created by HSLU-N0004891 on 18.11.2024.
import SwiftUI

struct Card: Equatable {
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

struct AnimatedCardView: View {
    var card: Card

    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.9

    var body: some View {
        Image(card.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 70, height: 100)
            .padding(5)
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeIn(duration: 0.3)) {
                    opacity = 1.0
                    scale = 1.0
                }
            }
    }
}

struct GameLogicView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gameSettings: GameSettings

    @State private var dealerHand: [Card] = []
    @State private var playerHand: [Card] = []
    @State private var dealerScore: Int = 0
    @State private var playerScore: Int = 0
    @State private var gameOver: Bool = false
    @State private var playerHasStood: Bool = false
    @State private var resultMessage: String = ""
    @State private var deck = Deck()
    @State private var isAnimating: Bool = false
    @State private var showResetMessage: Bool = false
    @State private var resetMessage: String = ""
    @State private var showBetWarning: Bool = false
    @State private var activeElement: String = ""
    @State private var hasRedrawn: Bool = false
    @State private var showResultOverlay: Bool = false // Overlay state
    
    let elements = ["Fire", "Water", "Earth", "Air"]

    var body: some View {
        Image("GameLogicBackground")
            .resizable()
            .ignoresSafeArea()
            .overlay(
                ZStack {
                    VStack {
                        // Dealer's cards and score
                        VStack {
                            Text("Dealer")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(8)

                            HStack {
                                ForEach(dealerHand.indices, id: \.self) { index in
                                    if index == 0 || playerHasStood {
                                        AnimatedCardView(card: dealerHand[index])
                                    } else {
                                        Image("card_back")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 70, height: 100)
                                            .padding(5)
                                    }
                                }
                            }

                            Text("Score: \(playerHasStood ? "\(dealerScore)" : "Hidden")")
                                .font(.body)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(8)
                        }
                        .padding()

                        Spacer()

                        // Player's cards and score
                        VStack {
                            Text("Player")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(8)

                            HStack {
                                ForEach(playerHand.indices, id: \.self) { index in
                                    AnimatedCardView(card: playerHand[index])
                                }
                            }

                            Text("Score: \(playerScore)")
                                .font(.body)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(8)
                        }
                        .padding()

                        Spacer()

                        // Active element display
                        if gameSettings.selectedTable == 3 || gameSettings.selectedTable == 4 {
                            Text("Active Element: \(activeElement) ")
                                .font(.body)
                                .foregroundColor(.red)
                                .padding(10)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(8)
                        }

                        // Game over and actions
                        if gameOver {

                        } else if !playerHasStood {
                            HStack {
                                Button("Hit") { playerHits() }
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)

                                Button("Stand") { playerStands() }
                                    .padding()
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                            if gameSettings.selectedTable == 3 || gameSettings.selectedTable == 4 {
                                Button("Redraw Hand") {
                                    redrawPlayerHand()
                                }
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        
                    }
                    .padding()

                    // Overlay Reset Message
                    if showResetMessage {
                        Text(resetMessage)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .transition(.scale)
                            .zIndex(1)
                    }

                    // Result Overlay
                    if showResultOverlay {
                        Color.black.opacity(0.8)
                            .edgesIgnoringSafeArea(.all)
                            .overlay(
                                VStack {
                                    Text(resultMessage)
                                        .font(.largeTitle)
                                        .foregroundColor(getResultColor()) // Dynamische Textfarbe
                                        .padding(.horizontal)

                                    Text("Your Score: \(playerScore)")
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text("Dealer's Score: \(dealerScore)")
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text("New Balance: \(gameSettings.balance)$")
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Button("Play Again") {
                                        if gameSettings.balance >= gameSettings.bet {
                                            startGame()
                                        } else {
                                            showBetWarning = true
                                        }
                                    }
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    
                                    Button(action: {
                                        gameSettings.bet = 0
                                        dismiss()
                                    }) {
                                        Text("Bet Selection")
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .cornerRadius(10)
                                .shadow(radius: 10)
                            )
                            .transition(.opacity)
                            .animation(.easeInOut, value: showResultOverlay)
                    }
                }
                .onAppear {
                    startGame()
            }
            .navigationBarBackButtonHidden(true)
        )
    }

    func startGame() {
        deck = Deck()
        dealerHand = drawInitialCards()
        playerHand = drawInitialCards()
        dealerScore = calculateScore(for: dealerHand)
        playerScore = calculateScore(for: playerHand)
        gameOver = false
        playerHasStood = false
        resultMessage = ""
        showResultOverlay = false

        // Wette direkt abziehen
        gameSettings.balance -= gameSettings.bet
        
        // Check for double 8s immediately after dealing
        checkForSpecialEffects(in: playerHand)
        // Set a random element for this round
        activeElement = elements.randomElement() ?? "Fire"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isAnimating = true
        }
    }



    func drawInitialCards() -> [Card] {
        return [deck.drawCard(), deck.drawCard()]
    }

    func calculateScore(for hand: [Card]) -> Int {
        var score = 0
        var aceCount = 0

        for card in hand {
            score += adjustCardValue(for: card)
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

    func adjustCardValue(for card: Card) -> Int {
        if gameSettings.selectedTable == 3 || gameSettings.selectedTable == 4 {
            switch activeElement {
            case "Fire":
                return card.suit == "spades" ? card.value - 1 : card.value
            case "Water":
                return card.suit == "clubs" ? card.value - 1 : card.value
            case "Earth":
                return card.suit == "diamonds" ? card.value - 1 : card.value
            case "Air":
                return card.suit == "hearts" ? card.value - 1 : card.value
            default:
                return card.value
            }
        } else{ return card.value}
        
    }
    
    func playerHits() {
        guard !gameOver else { return }
        playerHand.append(deck.drawCard())
        playerScore = calculateScore(for: playerHand)
        checkForSpecialEffects(in: playerHand)
        
        if playerScore > 21 {
            gameOver = true
            resultMessage = "You busted!\nDealer wins."
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showResultOverlay = true
            }
        }
    }

    func checkForSpecialEffects(in hand: [Card]) {
        guard gameSettings.selectedTable == 3 || gameSettings.selectedTable == 4 else { return }

        // Check for Double 8
        let eightCount = hand.filter { $0.rank == "8" }.count
        if eightCount >= 2 {
            resetMessage = "Double 8! Reset!"
            showResetMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                startGame()
                showResetMessage = false
            }
            return
        }

        // Only check the newest card if more than two cards exist
        let cardsToCheck: [Card] = hand.count <= 2 ? hand : [hand.last!]

        // Check for Red 7s (Hearts/Diamonds)
        if cardsToCheck.contains(where: { $0.rank == "7" && ($0.suit == "hearts" || $0.suit == "diamonds") }) {
            resetMessage = "Red 7! Balance Doubled!"
            showResetMessage = true
            gameSettings.balance = Int(ceil(Double(gameSettings.balance) * 2))
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showResetMessage = false
            }
        }

        // Check for Black 7s (Spades/Clubs)
        if cardsToCheck.contains(where: { $0.rank == "7" && ($0.suit == "spades" || $0.suit == "clubs") }) {
            resetMessage = "Black 7! Balance Halved!"
            showResetMessage = true
            gameSettings.balance = max(1, gameSettings.balance / 2) // Ensure at least 1 balance
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showResetMessage = false
            }
        }
    }

    func hasDoubleEight(in hand: [Card]) -> Bool {
        if gameSettings.selectedTable == 3 || gameSettings.selectedTable == 4 {
            let eightCount = hand.filter { $0.rank == "8" }.count
            if eightCount >= 2 {
                resetMessage = "Double 8! Reset!"
                showResetMessage = true
                
                // Delay the restart to let the message display
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    startGame()
                    showResetMessage = false // Hide the message after restart
                }
                return true
            }
            return false
        }
        return false
    }

    func playerStands() {
        playerHasStood = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dealerPlays()
        }
    }

    func dealerPlays() {
        func drawCardWithDelay() {
            if dealerScore < 17 { // Dealer zieht Karten bis mindestens 17 Punkte
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // 0.5 Sekunden Verzögerung
                    let card = deck.drawCard()
                    dealerHand.append(card)
                    dealerScore = calculateScore(for: dealerHand)
                    drawCardWithDelay() // Rekursiver Aufruf für die nächste Karte
                }
            } else {
                // Wenn der Dealer fertig ist, zeige das Ergebnis mit einer Verzögerung
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    determineWinner()
                }
            }
        }
        drawCardWithDelay() // Starte den Zieh-Prozess
    }


    

    func determineWinner() {
        gameOver = true

        if playerScore > 21 {
            resultMessage = "You busted! Dealer wins."
            // Wette bleibt abgezogen
        } else if dealerScore > 21 {
            resultMessage = "Dealer busted! You win!"
            gameSettings.balance += gameSettings.bet * 2 // Wette zurück + Gewinn
        } else if playerScore > dealerScore {
            resultMessage = "You win!"
            gameSettings.balance += gameSettings.bet * 2
        } else if playerScore < dealerScore {
            resultMessage = "Dealer wins."
            // Kein Gewinn
        } else {
            resultMessage = "It's a tie!"
            gameSettings.balance += gameSettings.bet // Wette zurückgeben
        }

        showResultOverlay = true
    }


    func redrawPlayerHand() {
        if !playerHasStood && !gameOver {
            playerHand = drawInitialCards()
            playerScore = calculateScore(for: playerHand)
        }
    }
    
    func getResultColor() -> Color {
        if resultMessage.contains("You win") {
            return .green
        } else if resultMessage.elementsEqual("You busted! Dealer wins.") || resultMessage.contains("Dealer wins") {
            return .red
        } else {
            return .white
        }
    }

}
