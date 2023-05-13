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
    @State private var balance: String = "0"
    @State private var address: String = "0xgeist"

    var body: some View {
        VStack {
            Text("Claim Successfull")
            Text("New Balance: \(balance) GHO")
        }
        .task {
            let manager = Manager.shared
            let account = manager.receiverAccount!
            self.address = account.addressFormattedShort
            let nativeBalance = await manager.balanceProvider.balanceNative(for: account.address)
            let formattedBalance = Utilities.formatToPrecision(nativeBalance, formattingDecimals: 0)
            self.balance = formattedBalance
        }
    }
}

struct ClaimSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimSuccessView()
    }
}
