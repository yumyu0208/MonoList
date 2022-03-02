//
//  PurchasedView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/03/02.
//

import SwiftUI

struct PurchasedView: View {
    var dismissAction: () -> Void
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            PlusPlanIconView()
            Text("All functions are now available!")
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                dismissAction()
            } label: {
                Text("OK")
                    .font(.system(.headline))
            }
            .buttonStyle(.fitCapsule)
            Spacer()
        }
    }
}

struct PurchasedView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasedView(dismissAction: {})
    }
}
