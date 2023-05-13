//
//  ShareSuccessView.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import SwiftUI

struct ShareSuccessView: View {
    var amount = Constants.amount
    var body: some View {
        ZStack {
            GeistColor.purpleLight2.edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 80))
                    .foregroundColor(GeistColor.purpleDark)
                Text("You send \(Text("\(amount) GHO").foregroundColor(GeistColor.purpleDark).bold())\nto your fren.")
                    .font(.system(size: 32))
                    .foregroundColor(GeistFontColor.secondaryTitle)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
            }
            .padding(32)
        }
        .toolbar(.hidden)
    }
}

struct ShareSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        ShareSuccessView()
    }
}
