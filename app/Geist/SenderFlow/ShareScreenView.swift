//
//  ShareScreenView.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import SwiftUI
import Web3Core

struct ShareScreenView: View {
    var body: some View {
        Text("0,1 ETH")
            .onTapGesture {
                Task.init {
                    let usdc = EthereumAddress("0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48")!
                    let manager = Manager.shared
                    let account = manager.senderAccount.address
                    let balance = await manager.balanceProvider.balanceOf(erc20Token: usdc, for: account)
                    print("BAL:", balance)
                }
            }
            .onAppear {
//                let accountProvider = AccountProvider()
//                let wallet = try! accountProvider.importAccount(privateKey: "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80")
//                print(wallet)
//                let sender = try! accountProvider.createSenderAccount()
//                let receiver = try! accountProvider.createReceiverAccount()
                Task.init {
                    let manager = Manager.shared
                    await manager.configSender()
                }
            }
    }
}
