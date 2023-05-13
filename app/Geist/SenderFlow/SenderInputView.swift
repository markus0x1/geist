//
//  SenderInputView.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import SwiftUI

struct SenderInputView: View {
    @State private var showNextScreen: Bool = false
    var body: some View {
        VStack {
            Text("Send 101 GHO 👻")
                .font(.system(size: 24))
                .foregroundColor(GeistFontColor.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 64)
                .padding(.bottom, 16)
            Spacer()
            Text("Generating a link to share...")
                .font(.system(size: 24))
                .foregroundColor(GeistFontColor.title)
                .multilineTextAlignment(.center)
            ProgressView()
                .foregroundColor(GeistFontColor.secondaryTitle)
                .progressViewStyle(.circular)
            Spacer()
            Button("SEND GHO") {
                print("send")
                showNextScreen = true
            }
        }
        .toolbar(.hidden)
        .navigationDestination(isPresented: $showNextScreen) {
            ShareScreenView()
        }
    }
}

struct SenderInputView_Previews: PreviewProvider {
    static var previews: some View {
        SenderInputView()
    }
}
