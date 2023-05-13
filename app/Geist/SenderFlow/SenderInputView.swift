//
//  SenderInputView.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import SwiftUI

struct SenderInputView: View {
    @State private var isGenerating: Bool = false
    @State private var showNextScreen: Bool = false
    private var url: URL
    init() {
        let linkBuilder = LinkBuilder()
        self.url = linkBuilder.generateLink(for: "0xgeist")
    }
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
            if isGenerating {
                Text("Generating a link to share...")
                    .font(.system(size: 24))
                    .foregroundColor(GeistFontColor.title)
                    .multilineTextAlignment(.center)
                ProgressView()
                    .foregroundColor(GeistFontColor.secondaryTitle)
                    .progressViewStyle(.circular)
            }
            Spacer()
            Button("SEND GHO") {
                Task.init {
                    if (isGenerating) { return }
                    isGenerating = true
                    // deposit + generate ID
                    // TODO: generate ID
                    // TOOD: deposit
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                    showNextScreen = true
                }
            }
        }
        .toolbar(.hidden)
        .navigationDestination(isPresented: $showNextScreen) {
            ShareScreenView(url: url)
        }
    }
}

struct SenderInputView_Previews: PreviewProvider {
    static var previews: some View {
        SenderInputView()
    }
}
