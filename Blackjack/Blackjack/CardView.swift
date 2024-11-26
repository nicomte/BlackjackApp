//
//  CardView.swift
//  Blackjack
//
//  Created by HSLU-N0004891 on 18.11.2024.
//

import SwiftUI
 
struct CardView: View {
    var card: String
 
    var body: some View {
        Text(card)
            .font(.largeTitle)
            .frame(width: 100, height: 150)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .rotationEffect(.degrees(Double.random(in: -5...5)))
            .padding()
    }
}
