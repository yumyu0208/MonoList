//
//  EditItemDetail.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/13.
//

import SwiftUI

struct EditItemDetail: View {
    
    enum Field: Hashable {
        case nameField
        case weightField
        case quantityField
        case noteField
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.deeplink) var deeplink
    
    @ObservedObject var item: Item
    @FocusState private var focusedField: Field?
    @State private var weight: String = ""
    @State private var quantity: String = ""
    @State private var note: String = ""
    
    @Namespace var noteID
    
    @State var isShowingAlert: Bool = false
    @State var alertMessage: String?
    
    @State var unitLabel: String = ""
    @State var isShowingChangeUnitConfirmationDialog = false
    @State var newUnitLabel: String?
    
    @State var categoryIsHidden = true
    @State var weightIsHidden = true
    @State var quantityIsHidden = true
    
    var itemIsInvalid: Bool {
        nameIsInvalid || weightIsInvalid || quantityIsInvalid
    }
    
    var nameIsInvalid: Bool {
        item.name.isEmpty
    }
    
    var weightIsInvalid: Bool {
        guard !weight.isEmpty else { return false }
        guard let weight = Double(weight) else { return true }
        if weight >= 0 && weight < 999999 {
            return false
        } else {
            return true
        }
    }
    
    var quantityIsInvalid: Bool {
        guard !quantity.isEmpty else { return false }
        guard let quantity = Int32(quantity) else { return true }
        if quantity >= 1 && quantity < 999999 {
            return false
        } else {
            return true
        }
    }
    
    var showAddDetailButton: Bool {
        categoryIsHidden || weightIsHidden || quantityIsHidden
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                Section {
                    HStack(spacing: 12) {
                        PhotoButtonView(imageData: $item.photo)
                        TextField("Item Name", text: $item.name, prompt: Text("Item Name"))
                            .multilineTextAlignment(.leading)
                            .focused($focusedField, equals: .nameField)
                            .padding(.vertical)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                focusedField = .nameField
                            }
                        Button {
                            item.name = ""
                            focusedField = .nameField
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(Color(UIColor.systemGray4))
                        .opacity(item.name.isEmpty ? 0 : 1)
                        .animation(.easeOut(duration: 0.2), value: weight.isEmpty)
                    } //: HStack
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 20))
                } //: Section
                Section {
                    TextEditor(text: $note)
                        .focused($focusedField, equals: .noteField)
                        .frame(minHeight: 40)
                        .id(noteID)
                        .offset(x: 0, y: 2)
                        .background(alignment: .leading) {
                            Text("Note")
                                .foregroundStyle(.tertiary)
                                .padding(.leading, 4)
                                .opacity(note.isEmpty ? 1 : 0)
                                .animation(.easeOut(duration: 0.2), value: note.isEmpty)
                        }
                } //: Section
                Section {
                    Toggle(isOn: $item.isImportant.animation()) {
                        Label {
                            Text("Important")
                        } icon: {
                            Image(systemName: "exclamationmark")
                                .font(.headline)
                                .foregroundStyle(.red)
                        } //: Label
                    } //: Toggle
                } //: Section
                if !categoryIsHidden {
                    // Select Category Section
                    Section {
                        NavigationLink {
                            SelectCategoryView(selectedCategory: $item.category)
                        } label: {
                            HStack {
                                Label {
                                    Text(item.category?.name ?? "None")
                                        .foregroundStyle(.primary)
                                } icon: {
                                    Image(systemName: item.category?.image ?? "tag")
                                        .foregroundStyle(.tint)
                                        .font(.headline)
                                } //: Label
                            } //: HStack
                        }
                    } header: {
                        HStack {
                            Text("Category")
                            Spacer()
                            Button {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    categoryIsHidden = true
                                }
                            } label: {
                                Text("hide")
                                    .textCase(nil)
                            }
                        }
                    } //: Section
                }
                if !weightIsHidden {
                    Section {
                        HStack {
                            Label {
                                TextField("Weight", text: $weight, prompt: Text("0"))
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.leading)
                                    .focused($focusedField, equals: .weightField)
                            } icon: {
                                Image(systemName: "scalemass")
                                    .foregroundStyle(.tint)
                                    .font(.headline)
                            }
                            Menu {
                                ForEach(K.unitLabel.all, id: \.self) { unitLabel in
                                    Button {
                                        newUnitLabel = unitLabel
                                        isShowingChangeUnitConfirmationDialog = true
                                    } label: {
                                        if self.unitLabel == unitLabel {
                                            Label(unitLabel, systemImage: "checkmark")
                                        } else {
                                            Text(unitLabel)
                                        }
                                    }
                                }
                            } label: {
                                ZStack {
                                    Text("kg")
                                        .opacity(0)
                                    Text(unitLabel)
                                        .id(unitLabel)
                                }
                                .foregroundColor(.primary)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 16)
                                .background(Color(UIColor.systemGray6))
                                .clipShape(Capsule())
                                .shadow(color: Color(K.colors.ui.shadowColor9), radius: 2, y: 2)
                            } //: Menu
                            if !weight.isEmpty {
                                Button {
                                    weight = ""
                                    focusedField = .weightField
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.medium)
                                }
                                .buttonStyle(.plain)
                                .foregroundColor(Color(UIColor.systemGray4))
                            }
                        } //: HStack
                        .animation(.easeOut(duration: 0.2), value: weight.isEmpty)
                    } header: {
                        HStack {
                            HStack(spacing: 0) {
                                Text("Weight")
                                Text("  ( \(unitLabel)/pcs )")
                                    .textCase(nil)
                                    .id(unitLabel)
                            }
                            Spacer()
                            Button {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    weightIsHidden = true
                                }
                            } label: {
                                Text("hide")
                                    .textCase(nil)
                            }
                        } //: HStack
                    } //: Section
                }
                if !quantityIsHidden {
                    Section {
                        HStack {
                            Label {
                                TextField("Quantity", text: $quantity, prompt: Text("1"))
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.leading)
                                    .focused($focusedField, equals: .quantityField)
                            } icon: {
                                Image(systemName: "number")
                                    .foregroundStyle(.tint)
                                    .font(.headline)
                            }
                            Button {
                                quantity = ""
                                focusedField = .quantityField
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.medium)
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(Color(UIColor.systemGray4))
                            .opacity(quantity.isEmpty ? 0 : 1)
                            .animation(.easeOut(duration: 0.2), value: quantity.isEmpty)
                        }
                    } header: {
                        HStack {
                            Text("Quantity")
                            Spacer()
                            Button {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    quantityIsHidden = true
                                }
                            } label: {
                                Text("hide")
                                    .textCase(nil)
                            }
                        }
                    } //: Section
                }
                if showAddDetailButton {
                    Section {
                        Menu {
                            if quantityIsHidden {
                                Button {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        quantityIsHidden = false
                                    }
                                } label: {
                                    Label("Quantity", systemImage: "number")
                                }
                            }
                            if weightIsHidden {
                                Button {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        weightIsHidden = false
                                    }
                                } label: {
                                    Label("Weight", systemImage: "scalemass")
                                }
                            }
                            if categoryIsHidden {
                                Button {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        categoryIsHidden = false
                                    }
                                } label: {
                                    Label("Category", systemImage: "tag")
                                }
                            }
                        } label: {
                            Label("Add Detail", systemImage: "plus.circle")
                                .foregroundStyle(.tint)
                        } //: Menu
                    } //: Section
                }
            } //: List
            .onChange(of: focusedField) { focusedField in
                if focusedField == .noteField {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            proxy.scrollTo(noteID, anchor: .bottom)
                        }
                    }
                }
            }
        } //: ScrollViewReader
        .navigationTitle(Text("Edit Item"))
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled(itemIsInvalid)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                XButtonView {
                    if nameIsInvalid {
                        alertMessage = "Please enter the item name"
                        isShowingAlert = true
                    } else if weightIsInvalid {
                        alertMessage = "Invalid weight value"
                        isShowingAlert = true
                    } else if quantityIsInvalid {
                        alertMessage = "Invalid quantity value"
                        isShowingAlert = true
                    } else {
                        setValue()
                        dismiss()
                    }
                }
            }
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button {
                        focusedField = nil
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .alert("Error", isPresented: $isShowingAlert, presenting: alertMessage) { message in
            Button {
                alertMessage = nil
            } label: {
                Text("OK")
            }
        } message: { message in
            Text(message)
        }
        .confirmationDialog("Change Unit", isPresented: $isShowingChangeUnitConfirmationDialog, titleVisibility: .visible, presenting: newUnitLabel) { newUnitLabel in
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    self.unitLabel = newUnitLabel
                }
            } label: {
                Text("Change the label to \"\(newUnitLabel)\"")
            }
            Button("Cancel", role: .cancel) {
                self.newUnitLabel = nil
            }
        } message: { indexSet in
            Text("Applies to all items in this list.")
        }
        .onAppear {
            weight = (item.weight == 0 ? "" : String(item.weight.string))
            quantity = (item.quantity <= 1 ? "" : String(item.quantity))
            note = item.note ?? ""
            
            let parentItemList = item.parentItemList
            unitLabel = parentItemList.unitLabel
            categoryIsHidden = parentItemList.categoryIsHidden
            weightIsHidden = parentItemList.weightIsHidden
            quantityIsHidden = parentItemList.quantityIsHidden
        }
        .onDisappear {
            setValue()
            saveData()
        }
        .onChange(of: deeplink) { deeplink in
            if deeplink != nil {
                isShowingAlert = false
                dismiss()
            }
        }
    }
    
    private func setValue() {
        item.weight = weight.isEmpty ? 0 : Double(weight)!
        item.quantity = quantity.isEmpty ? 1 : Int32(quantity)!
        item.note = note.isEmpty ? nil : note
        
        item.parentItemList.unitLabel = unitLabel
        item.parentItemList.categoryIsHidden = categoryIsHidden
        item.parentItemList.weightIsHidden = weightIsHidden
        item.parentItemList.quantityIsHidden = quantityIsHidden
    }
    
    private func saveData() {
        do {
            try viewContext.save()
            print("Saved")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct EditItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let items = MonoListManager().fetchItems(context: context)
        NavigationView {
            EditItemDetail(item: items[0])
                .environment(\.managedObjectContext, context)
                .listStyle(.insetGrouped)
        }
    }
}
