//
//  DevelopmentSection.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/27.
//

import SwiftUI

struct DevelopmentSection: View {
    
    @AppStorage(K.key.isPlusPlan) private var isPlusPlan: Bool = false
    
    var body: some View {
        Section(header: Text("Development")) {
            NavigationLink(destination: DataManagementView()) {
                Label("Data Management", systemImage: "sdcard")
            }
            Toggle(isOn: $isPlusPlan) {
                Label("MONOLIST+", systemImage: "star")
            }
        } //: Section
    }
}

struct DevelopmentSection_Previews: PreviewProvider {
    static var previews: some View {
        DevelopmentSection()
    }
}
