//
//  OthersSection.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/27.
//

import SwiftUI

struct OthersSection: View {
    
    @State var isShowingMailView = false
    
    var body: some View {
        Section {
            Button {
                ReviewManager.presentReviewSheet()
            } label: {
                Label("Write a Review", systemImage: "square.and.pencil")
            }
            Button {
                isShowingMailView = true
            } label: {
                Label("Bug Report", systemImage: "envelope")
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(isShowing: $isShowingMailView)
            }
            Link(destination: URL(string: K.url.privacyPolicy)!, label: {
                Label("Privacy Policy", systemImage: "hand.raised")
            })
        } footer: {
            AppInformationView()
                .padding(.top, 60)
        } //: Section
    }
}

struct OthersSection_Previews: PreviewProvider {
    static var previews: some View {
        OthersSection()
    }
}
