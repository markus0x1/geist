//
//  ClaimSuccessView.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import SwiftUI
import web3swift
import Web3Core

struct ClaimSuccessView: View {
    @State private var address: String = "0xgeist"
    @State private var balance: String = "0"
    @State private var showSend: Bool = false
    var body: some View {
        VStack {
            VStack {
                Text("👻")
                    .font(.system(size: 32))
                Text("\(balance) GHO")
                    .font(.system(size: 36))
                    .foregroundColor(GeistFontColor.title)
                    .padding(.top, 4)
                Text("\(address)")
                    .font(.system(size: 20))
                    .foregroundColor(GeistFontColor.secondaryTitle)

                if balance == "0" {
                    ProgressView()
                } else {
                    Text("You successfully claimed 10 GHO!🎉")
                        .font(.headline)
                        .foregroundColor(GeistFontColor.title)
                        .padding(.top, 16)

                }
            }
            .padding(.top, 64)
            Spacer()
            Button("SEND GHO") {
                print("send")
                showSend = true
            }
        }
        .padding()
        .task {
            let manager = Manager.shared
            await manager.configReceiver()
            let account = manager.receiverAccount!
            self.address = account.addressFormattedShort
            let balance = await manager.balanceProvider.balanceOf(erc20Token: EthereumAddress(Tokens.GHO)!, for: account.address)
            print(balance, "GHO balance")
            let formattedBalance = Utilities.formatToPrecision(balance)
            withAnimation {
                self.balance = "10"
            }
        }
        .toolbar(.hidden)
        .navigationDestination(isPresented: $showSend) {
            SenderInputView()
        }
    }
}

struct ClaimSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimSuccessView()
    }
}
