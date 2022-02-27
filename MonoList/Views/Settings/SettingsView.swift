//
//  SettingsView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/07.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(K.key.isPlusPlan) private var isPlusPlan: Bool = false
    @EnvironmentObject var manager: MonoListManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State var isShowingPlusPlanView: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                if !isPlusPlan {
                    Section(header: Text("Premium Service")) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("MONOLIST +")
                                .font(.headline)
                                .padding(.vertical, 8)
                            VStack(alignment: .leading, spacing: 2) {
                                ForEach(K.plusPlan.allFeatures, id: \.title) { feature in
                                    Text(feature.title)
                                }
                            }
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        }
                        Button {
                            isShowingPlusPlanView = true
                        } label: {
                            Text("See Details")
                                .foregroundStyle(.blue)
                        }
                        .fullScreenCover(isPresented: $isShowingPlusPlanView) {
                            NavigationView {
                                PlusPlanView()
                            }
                        }
                    } //: Section
                }
                ListSettingSection()
                Section(header: Text("Misc")) {
                    NavigationLink(destination: CategoriesView()) {
                        Label("Categories", systemImage: "tag")
                    }
                    //NavigationLink(destination: NotificationSettingView()) {
                    //    Label("Notification", systemImage: "bell")
                    //}
                } //: Section
                
                //Section(header: Text("Development")) {
                //    NavigationLink(destination: DataManagementView()) {
                //        Label("Data Management", systemImage: "sdcard")
                //    }
                //    Toggle(isOn: $isPlusPlan) {
                //        Label("MONOLIST+", systemImage: "star")
                //    }
                //} //: Section
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
            } //: List
            .navigationTitle(Text("Settings"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    XButtonView {
                        dismiss()
                    }
                }
            }
        } //: NavigationView
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
