//
//  ListSettingView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/25.
//

import SwiftUI

struct ListSettingSection: View {
    
    @AppStorage(K.key.automaticUncheck) private var automaticUncheck: Bool = true
    @AppStorage(K.key.achievementDisplayFormat) private var achievementDisplayFormat: String = K.achievementDisplayFormat.fraction
    @AppStorage(K.key.hideCompleted) private var hideCompleted: Bool = false
    @AppStorage(K.key.listForm) private var listForm: String = K.listForm.list.name
    @AppStorage(K.key.unitLabel) private var unitLabel: String = K.unitLabel.gram
    
    var body: some View {
        Section {
            NavigationLink {
                SelectionView(title: "Progress Format",
                              selectedItem: $achievementDisplayFormat,
                              allItems: K.achievementDisplayFormat.all)
            } label: {
                HStack {
                    Text("Progress Format")
                        .foregroundStyle(.primary)
                    Spacer()
                    Text(achievementDisplayFormat.localized)
                        .foregroundStyle(.secondary)
                        .id(achievementDisplayFormat)
                }
            }
            Toggle(isOn: $automaticUncheck) {
                Text("Automatically Uncheck")
            }
        } header: {
            Text("All Lists")
        } footer: {
            Text("description.automaticUncheck")
        } //: Section
        Section {
            Toggle(isOn: $hideCompleted) {
                Text("Hide Completed")
            }
            NavigationLink {
                SelectionView(title: "Form",
                              selectedItem: $listForm,
                              allItems: K.listForm.all)
            } label: {
                HStack {
                    Text("Form")
                        .foregroundStyle(.primary)
                    Spacer()
                    Text(listForm.localized)
                        .foregroundStyle(.secondary)
                        .id(listForm)
                }
            }
            NavigationLink {
                SelectionView(title: "Unit Label",
                              selectedItem: $unitLabel,
                              allItems: K.unitLabel.all)
            } label: {
                HStack {
                    Text("Unit Label")
                        .foregroundStyle(.primary)
                    Spacer()
                    Text(unitLabel)
                        .foregroundStyle(.secondary)
                        .id(unitLabel)
                }
            }
        } header: {
            Text("New Lists")
        } footer: {
            Text("description.newLists")
        } //: Section
    }
}

struct ListSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListSettingSection()
        }
    }
}
