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
    private let backgroundColor: Color = GeistColor.purpleLight.opacity(0.5)
    @State private var showNextScreen: Bool = false
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
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
                Spacer()
                ShareLink(item: url, message: Text("Hey fren, I'm sending you \(Constants.amount) GHO! 👻")) {
                    Label("Share", systemImage:  "square.and.arrow.up")
                        .font(.system(size: 24))
                        .foregroundColor(GeistFontColor.title)
                }
                Text("The person has 48h to claim it.")
                    .font(.system(size: 13))
                    .foregroundColor(GeistFontColor.secondaryTitle)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
                Button("Share") {
                    showNextScreen = true
                }
                .foregroundColor(backgroundColor)
            }
            .padding()
        }
        .toolbar(.hidden)
        .navigationDestination(isPresented: $showNextScreen) {
            ShareSuccessView(amount: Constants.amount)
        }
    }
}
