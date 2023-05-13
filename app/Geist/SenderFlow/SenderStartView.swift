//
//  SenderStartView.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import SwiftUI

struct SenderStartView: View {
    @State private var showSend: Bool = false
    var body: some View {
        VStack {
            VStack {
                Text("👻")
                    .font(.system(size: 24))
                Text("1000 GHO")
                    .font(.system(size: 36))
                    .foregroundColor(GeistFontColor.title)
                    .padding(.top, 16)
                Text("0x")
                    .font(.system(size: 24))
                    .foregroundColor(GeistFontColor.secondaryTitle)
            }
            .padding(.top, 64)
            Spacer()
            Button("SEND GHO") {
                print("send")
                showSend = true
            }
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
