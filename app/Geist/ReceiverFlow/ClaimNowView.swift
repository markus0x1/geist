//
//  ClaimNowView.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import SwiftUI

struct ClaimNowView: View {

    var components: URLComponents

    var body: some View {
        VStack {
            Text("👻")
                .font(.system(size: 32))
            Text("You can claim")
                .font(.title)
                .foregroundColor(GeistFontColor.title)
                .padding(.bottom, 8)
            Text("100 GHO")
                .font(.largeTitle)
                .foregroundColor(GeistFontColor.title)
                .padding(.bottom, 64)
            Spacer()
            Text("You have 47h left to claim it")
                .font(.caption)
                .foregroundColor(GeistFontColor.secondaryTitle)
            Button {
                //TODO Withdraw
            } label: {
                Text("Claim Now")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(GeistFontColor.title)
                    .cornerRadius(10)
            }
        }
        .padding(.top, 64)
        .padding()
    }
}

struct ClaimNowView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimNowView(components: URLComponents())
    }
}
