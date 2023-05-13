//
//  ContentView.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import SwiftUI

struct StartView: View {

    @State var claimStarted = false
    @State var components: URLComponents = URLComponents()

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Send GHO") {
                    SenderStartView()
                }
                .padding()
                NavigationLink(
                    destination: ClaimNowView(components: components),
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
        guard url.scheme == "https" else {
            return
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }

        self.components = components
        claimStarted = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
