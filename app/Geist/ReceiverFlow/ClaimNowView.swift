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
            Text("You received 100 GHO Token")
                .font(.title)
                .padding(.bottom, 64)
            Text("You have 47h left to claim it")
                .font(.caption)
                NavigationLink {
                    ClaimSuccessView()
                } label: {
                    Text("Claim Now")
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct ClaimNowView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimNowView()
    }
}
