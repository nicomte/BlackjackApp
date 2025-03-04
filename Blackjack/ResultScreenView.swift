import SwiftUI

struct ResultScreenView: View {
    let playerScore: Int
    let dealerScore: Int
    let resultMessage: String
    let newBalance: Int
    let onPlayAgain: () -> Void
    
    var textColor: Color {
        if resultMessage.contains("gewonnen") {
            return .green
        } else if resultMessage.contains("verloren") {
            return .red
        } else {
            return .yellow
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(resultMessage)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(textColor) // Farbe basierend auf Ergebnis
            
            Text("Spieler Score: \(playerScore)")
                .font(.title2)
            Text("Dealer Score: \(dealerScore)")
                .font(.title2)
            Text("Neue Balance: \(newBalance)")
                .font(.title2)
            
            Button(action: onPlayAgain) {
                Text("Erneut spielen")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.7))
        .edgesIgnoringSafeArea(.all)
    }
}
