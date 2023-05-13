//
//  SenderStartView.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import SwiftUI
import web3swift
import Web3Core

struct SenderStartView: View {
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
            let account = manager.senderAccount!
            self.address = account.addressFormattedShort
            let nativeBalance = await manager.balanceProvider.balanceNative(for: account.address)
            let formattedBalance = Utilities.formatToPrecision(nativeBalance, formattingDecimals: 0)
            self.balance = formattedBalance
        }
        .toolbar(.hidden)
        .navigationDestination(isPresented: $showSend) {
            SenderInputView()
        }
    }
}

struct SenderStartView_Previews: PreviewProvider {
    static var previews: some View {
        SenderStartView()
    }
}
