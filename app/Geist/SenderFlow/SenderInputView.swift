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
            Text("Send some GHO 👻")
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
