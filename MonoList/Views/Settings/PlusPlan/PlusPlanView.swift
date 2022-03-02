//
//  PlusPlunView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/24.
//

import SwiftUI
import StoreKit

struct PlusPlanView: View {
    @AppStorage(K.key.isPlusPlan) private var isPlusPlan: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @State var feature: K.plusPlan.Feature = K.plusPlan.noAds
    var autoScroll = false
    
    @StateObject var storeManager = StoreManager()
    
    @State var errorAlertIsPresented = false
    @State var alertMessage: String = ""
    
    private var price: String {
        storeManager.products.first?.localizedPrice ?? "Buy"
    }
    
    var body: some View {
        ZStack {
            if !isPlusPlan {
                ScrollView(.vertical) {
                    VStack(spacing: 28) {
                        PlusPlanIconView(size: 120)
                        Text("PlusPlan.description")
                        FeaturePagesView(showingFeatureTitle: feature.title, autoScroll: autoScroll)
                        Button {
                            guard let product = storeManager.products.first else {
                                print("Error")
                                return
                            }
                            storeManager.purchaseProduct(product: product)
                        } label: {
                            Text(price)
                                .font(.system(.headline, design: .rounded))
                        }
                        .buttonStyle(.fitCapsule)
                        .shadow(radius: 8)
                        Button {
                            storeManager.restoreProducts()
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
            } else {
                PurchasedView(dismissAction: { dismiss() })
            }
        }
        .alert("Error", isPresented: $errorAlertIsPresented, presenting: alertMessage, actions: { _ in
            Button("OK") {
                errorAlertIsPresented = false
                alertMessage = ""
            }
        }, message: { message in
            Text(message)
        })
        .onAppear {
            storeManager.enablePlusContentAction = {
                withAnimation {
                    isPlusPlan = true
                }
            }
            storeManager.presentErrorAlertAction = { message in
                alertMessage = message
                errorAlertIsPresented = true
            }
            SKPaymentQueue.default().add(storeManager)
            storeManager.getProducts(productIds: [K.plusPlan.productId])
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



