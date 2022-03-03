//
//  PlusPlanAdView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/03/03.
//

import SwiftUI

struct PlusPlanAdView: View {
    
    @State var isShowingPlusPlanView = false
    
    var body: some View {
        HStack {
            Image(K.image.monoListIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                .shadow(color: Color(K.colors.ui.shadowColor9), radius: 2, x: 0, y: 0)
            VStack(alignment: .leading) {
                Text("Premium Content")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("MONOLIST +")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            Spacer()
            Text("See Details")
                .font(.body)
                .foregroundStyle(.primary)
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            isShowingPlusPlanView = true
        }
        .background {
            Color(UIColor.systemGroupedBackground)
        }
        .fullScreenCover(isPresented: $isShowingPlusPlanView) {
            NavigationView {
                PlusPlanView(feature: K.plusPlan.noAds, autoScroll: true)
            }
        }
    }
}

struct PlusPlanAdView_Previews: PreviewProvider {
    static var previews: some View {
        PlusPlanAdView()
    }
}
