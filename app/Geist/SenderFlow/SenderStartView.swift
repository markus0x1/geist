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
        ZStack {
            GeistColor.purpleLight.edgesIgnoringSafeArea(.all)
            VStack {
                VStack {
                    ZStack (alignment: .leading){
                        RoundedRectangle(cornerRadius: 25)
                            .fill(LinearGradient(colors: [GeistColor.purpleLight2, GeistColor.purpleLight], startPoint: .top, endPoint: .bottom))
                            .shadow(color: GeistColor.purpleLight2, radius: 8)
                        VStack(alignment: .leading) {
                            Text("👻")
                                .font(.system(size: 32))
                            Spacer()
                            Text("\(balance) GHO")
                                .font(.system(size: 36))
                                .foregroundColor(GeistFontColor.title)
                                .padding(.top, 4)
                            Text("\(address)")
                                .font(.system(size: 20))
                                .foregroundColor(GeistFontColor.secondaryTitle)
                        }
                        .padding(24)
                    }
                    .frame(maxHeight: 200)
                }
                .padding(.top, 32)
                Spacer()
                Button("Send GHO") {
                    print("send")
                    showSend = true
                }
                .buttonStyle(rounded(backgroundColor: GeistColor.purpleDark, disabledBackgroundColor: GeistColor.gray))
            }
            .padding()
        }
        .task {
            let manager = Manager.shared
            await manager.configSender()
            let account = manager.senderAccount!
            self.address = account.addressFormattedShort
            let balance = await manager.balanceProvider.balanceOf(erc20Token: EthereumAddress(Tokens.GHO)!, for: account.address)
            print(balance, "GHO balance")
            let formattedBalance = Utilities.formatToPrecision(balance)
            self.balance = formattedBalance
        }
        .toolbar(.hidden)
        .navigationDestination(isPresented: $showSend) {
            SenderInputView()
        }
    }
}

struct rounded: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    var backgroundColor: Color
    var disabledBackgroundColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(GeistColor.purpleLight)
            .bold()
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
            .background(isEnabled ? backgroundColor : disabledBackgroundColor)
            .cornerRadius(26.0)
            .shadow(color: GeistColor.purpleLight, radius: 3, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .frame(height: 52)
    }
}
