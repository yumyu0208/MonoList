//
//  MonoListApp.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/25.
//

import SwiftUI

@main
struct MonoListApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scene
    @State var deeplink: Deeplinker.Deeplink?
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.deeplink, deeplink)
                .onOpenURL { url in
                    let deeplinker = Deeplinker()
                    guard let deeplink = deeplinker.manage(url: url) else { return }
                    self.deeplink = deeplink
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                        self.deeplink = nil
                    }
                }
                .onChange(of: scene) { scene in
                    if scene == .active {
                        DispatchQueue.global(qos: .background).async {
                            NotificationManager().deleteAllDeliveredNotificationRequests()
                        }
                    }
                }
        }
    }
}
