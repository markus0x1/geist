//
//  ContentView.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Send GHO") {
                    ShareScreenView()
                }
                .padding()
                NavigationLink("Receive GHO") {
                    ClaimNowView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
