//
//  MiscSection.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/27.
//

import SwiftUI

struct MiscSection: View {
    var body: some View {
        Section(header: Text("Misc")) {
            NavigationLink(destination: CategoriesView()) {
                Label("Categories", systemImage: "tag")
            }
            //NavigationLink(destination: NotificationSettingView()) {
            //    Label("Notification", systemImage: "bell")
            //}
        } //: Section
    }
}

struct MiscSection_Previews: PreviewProvider {
    static var previews: some View {
        MiscSection()
    }
}
