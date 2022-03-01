//
//  PlusPlunView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/24.
//

import SwiftUI

struct PlusPlanView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var feature: K.plusPlan.Feature = K.plusPlan.noAds
    var autoScroll = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 28) {
                PlusPlanIconView(size: 120)
                Text("Unlock all content with a single payment.")
                FeaturePagesView(showingFeatureTitle: feature.title, autoScroll: autoScroll)
                Button {
                    
                } label: {
                    Text("360円")
                        .font(.system(.headline, design: .rounded))
                }
                .buttonStyle(.fitCapsule)
                .shadow(radius: 8)
                Button {
                    
                } label: {
                    Text("Restore")
                        .padding(8)
                }
                .foregroundColor(.accentColor)

            } //: VStack
            .multilineTextAlignment(.center)
            .padding(.vertical, 28)
        } // Scroll
        .background {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
        }
        .navigationTitle(Text("Premium Content"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                XButtonView {
                    dismiss()
                }
            }
        }
    }
}

struct PlusPlunView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                PlusPlanView()
            }
            
            NavigationView {
                PlusPlanView()
            }
            .preferredColorScheme(.dark)
        }
    }
}



