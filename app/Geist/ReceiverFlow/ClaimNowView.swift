//
//  ClaimNowView.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import SwiftUI

struct ClaimNowView: View {

    var body: some View {
        VStack {
            Text("Hello, World!")
        }
            .onOpenURL { incomingURL in
                print("App was opened via URL: \(incomingURL)")
                handleIncomingURL(incomingURL)
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
    }

}

struct ClaimNowView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimNowView()
    }
}
