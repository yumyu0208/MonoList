//
//  AppInfomationView.swift
//  YCalendar
//
//  Created by 竹田悠真 on 2021/09/02.
//

import SwiftUI

struct AppInformationView: View {
    
    var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    var build: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text("MONOLIST")
                Text("Ver. \(version) (\(build))")
                Text("©︎ 2022 Yuma")
            }
            Spacer()
        }
        .font(.footnote)
        .foregroundColor(.secondary)
    }
}

struct AppInfomationView_Previews: PreviewProvider {
    static var previews: some View {
        AppInformationView()
    }
}
