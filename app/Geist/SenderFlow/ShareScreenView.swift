//
//  ShareScreenView.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import SwiftUI
import Web3Core

struct ShareScreenView: View {
    var url: URL = URL(string: "https://gho.xyz")!
    @State private var showNextScreen: Bool = false
    var body: some View {
        VStack {
            Spacer()
            Text(verbatim: "https://geist.xyz/claim?id=0x...")
                .font(.system(size: 12))
                .foregroundColor(GeistFontColor.secondaryTitle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(GeistFontColor.borderSecondary, lineWidth: 1)
                )
                .padding(.vertical, 16)
            Text("Link generated.")
                .font(.system(size: 24))
                .foregroundColor(GeistFontColor.secondaryTitle)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
            Text("Now send it to your fren.")
                .font(.system(size: 24))
                .foregroundColor(GeistFontColor.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            ShareLink(item: url, message: Text("Hey fren, I'm sending you \(Constants.amount) GHO! 👻")) {
                Label("Share", systemImage:  "square.and.arrow.up")
                    .font(.system(size: 24))
                    .foregroundColor(GeistFontColor.title)
            }
            Spacer()
            Button("Share") {
                showNextScreen = true
            }
            .foregroundColor(.white)
        }
        .padding()
        .toolbar(.hidden)
        .navigationDestination(isPresented: $showNextScreen) {
            ShareSuccessView(amount: Constants.amount)
        }
    }
}
