//
//  PlusPlanSection.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/27.
//

import SwiftUI

struct PlusPlanSection: View {
    
    @State var isShowingPlusPlanView: Bool = false
    
    var body: some View {
        Section(header: Text("Premium")) {
            VStack(alignment: .leading, spacing: 8) {
                Text("MONOLIST +")
                    .font(.title3.bold())
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(K.plusPlan.allFeatures, id: \.title) { feature in
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle")
                                .font(.caption)
                            Text(feature.title)
                                .font(.callout)
                        }
                    }
                }
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
            Button {
                isShowingPlusPlanView = true
            } label: {
                Text("See Details")
                    .foregroundStyle(.blue)
            }
            .fullScreenCover(isPresented: $isShowingPlusPlanView) {
                NavigationView {
                    PlusPlanView(autoScroll: true)
                }
            }
        } //: Section
    }
}

struct PlusPlanSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PlusPlanSection()
        }
    }
}
