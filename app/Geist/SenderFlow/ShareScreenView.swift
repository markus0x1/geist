//
//  ShareScreenView.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import SwiftUI
import Web3Core

struct ShareScreenView: View {
    var url: URL = URL(string: "https://gho.xyz")!
    @State private var showNextScreen: Bool = false
    var body: some View {
        VStack {
            Spacer()
            Text("Link generated.")
                .font(.system(size: 24))
                .foregroundColor(GeistFontColor.secondaryTitle)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
            Text("Now send it to your fren.")
                .font(.system(size: 24))
                .foregroundColor(GeistFontColor.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            ShareLink(item: url, message: Text("Hey fren, I'm sending you 100 GHO! 👻")) {
                Label("Share", systemImage:  "square.and.arrow.up")
                    .font(.system(size: 24))
                    .foregroundColor(GeistFontColor.title)
            }
            Spacer()
            Button("Share") {
                print("share")
                showNextScreen = true
            }
        }
        .padding()
            .onTapGesture {
                Task.init {
                    let usdc = EthereumAddress("0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48")!
                    let manager = Manager.shared
                    let account = manager.senderAccount.address
                    let balance = await manager.balanceProvider.balanceOf(erc20Token: usdc, for: account)
                    print("BAL:", balance)
                    let balanceEth = await manager.balanceProvider.balanceNative(for: account)
                    print("ETH:", balanceEth)
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
            .toolbar(.hidden)
            .navigationDestination(isPresented: $showNextScreen) {
                ShareSuccessView(amount: 101)
            }
    }
}
