//
//  ClaimNowView.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import SwiftUI

struct ClaimNowView: View {

    @State var currentDate = Date.now
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    @State var showNextView = false
    @State var isLoading = false

    var components: URLComponents

    var body: some View {
        if showNextView {
            ClaimSuccessView()
        } else if isLoading {
            ZStack {
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
                        Text("Claim Now")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(GeistFontColor.title)
                            .cornerRadius(10)
                }
                .padding(.top, 64)
                .padding()
                .blur(radius: 8)
                .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        showNextView = true
                                    }
                                }
                            }
                ProgressView()
                    .font(.largeTitle)
            }
        } else {
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
                    withAnimation {
                        isLoading.toggle()
                    }

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
            .task {
                let manager = Manager.shared
                await manager.configReceiver()
            }
        }
    }
}

struct ClaimNowView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimNowView(components: URLComponents())
    }
}
