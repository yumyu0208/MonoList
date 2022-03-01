//
//  FeaturePagesView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/03/01.
//

import SwiftUI

struct FeaturePagesView: View {
    
    var features: [K.plusPlan.Feature] = K.plusPlan.allFeatures
    @State var showingFeatureTitle: String = K.plusPlan.noAds.title
    var autoScroll = false
    @State private var timer: Timer?
    @State private var isAutoScrolling = false
    
    var body: some View {
        TabView(selection: $showingFeatureTitle) {
            ForEach(features, id: \.title) { feature in
                VStack(spacing: 0) {
                    GroupBox {
                        VStack(spacing: 20) {
                            Spacer(minLength: 0)
                            Image(systemName: feature.image)
                                .font(.title3)
                            Text(feature.title)
                                .font(.headline)
                            Text(feature.description)
                                .font(.body)
                                .foregroundStyle(.secondary)
                            Spacer(minLength: 0)
                        }
                        .multilineTextAlignment(.center)
                    }
                    .groupBoxStyle(.white)
                    .padding(.horizontal, 38)
                    .tag(feature.title)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 50)
                } //: VStack
            }
        } //: TabView
        .tabViewStyle(.page)
        .frame(height: 280)
        .onChange(of: showingFeatureTitle) { showingFeatureTitle in
            if isAutoScrolling {
                isAutoScrolling = false
            } else {
                timer?.invalidate()
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.accentColor)
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.accentColor).withAlphaComponent(0.2)
            if autoScroll {
                timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                    let allFeatures = K.plusPlan.allFeatures
                    guard let currentIndex = allFeatures.firstIndex(where: { $0.title == showingFeatureTitle }) else { return }
                    withAnimation(.easeOut(duration: 0.2)) {
                        if currentIndex + 1 < allFeatures.count {
                            showingFeatureTitle = allFeatures[currentIndex + 1].title
                        } else {
                            showingFeatureTitle = allFeatures[0].title
                        }
                    }
                    isAutoScrolling = true
                }
            }
        }
    }
}

struct FeaturePagesView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturePagesView()
    }
}
