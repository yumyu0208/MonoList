//
//  OthersSection.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/27.
//

import SwiftUI

struct OthersSection: View {
    var body: some View {
        Section {
            Button {
                // review
            } label: {
                Label("Write a Review", systemImage: "square.and.pencil")
            }
            Button {
                // bug report
            } label: {
                Label("Bug Report", systemImage: "envelope")
            }
            Button {
                // privacy policy
            } label: {
                Label("Privacy Policy", systemImage: "hand.raised")
            }
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
