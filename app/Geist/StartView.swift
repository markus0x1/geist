//
//  ContentView.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import SwiftUI

struct StartView: View {

    @State var claimStarted = false

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Send GHO") {
                    SenderStartView()
                }
                .padding()
                NavigationLink(
                    destination: ClaimNowView(),
                    isActive: $claimStarted)
                {
                    Label("Receive GHO", systemImage: "giftcard")
                }
            }
            .onOpenURL { incomingURL in
                print("App was opened via URL: \(incomingURL)")
                handleIncomingURL(incomingURL)
            }
        }
        .task {
            let manager = Manager.shared
            await manager.configSender()
            await manager.configReceiver()
        }
    }

    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "geist" else {
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }

        guard let action = components.host, action == "open-claim" else {
            print("Unknown URL, we can't handle this one!")
            return
        }

        claimStarted = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
