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
    
    @AppStorage(K.key.weightUnit) var weightUnit = "g"
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var item: Item
    @FocusState private var focusedField: Field?
    @State private var weight: String = ""
    @State private var quantity: String = ""
    @State private var note: String = ""
    
    @Namespace var noteID
    
    var weightIsInvalid: Bool {
        guard !weight.isEmpty else { return false }
        guard let weight = Double(weight) else { return true }
        if weight >= 0 && weight < 100000000 {
            return false
        } else {
            return true
        }
    }
    
    var quantityIsInvalid: Bool {
        guard !quantity.isEmpty else { return false }
        guard let quantity = Int32(quantity) else { return true }
        if quantity >= 1 && quantity < 100000000 {
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                Section {
                    HStack {
                        TextField("Item Name", text: $item.name, prompt: Text("Item Name"))
                            .multilineTextAlignment(.leading)
                            .focused($focusedField, equals: .nameField)
                        Button {
                            item.name = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(Color(UIColor.systemGray4))
                        .opacity(item.name.isEmpty ? 0 : 1)
                        .animation(.easeOut(duration: 0.2), value: weight.isEmpty)
                    }
                } //: Section
                Section {
                    Toggle(isOn: $item.isImportant.animation()) {
                        Label {
                            Text("Mark as Important")
                        } icon: {
                            Image(systemName: "exclamationmark")
                                .font(.headline)
                                .foregroundStyle(.red)
                        } //: Label
                    } //: Toggle
                } //: Section
                // Select Category Section
                Section {
                    NavigationLink {
                        SelectCategoryView(selectedCategory: $item.category)
                    } label: {
                        HStack {
                            Label {
                                Text("Category")
                                    .foregroundStyle(.primary)
                            } icon: {
                                Image(systemName: "tag")
                                    .foregroundStyle(.tint)
                                    .font(.headline)
                            } //: Label
                            Spacer()
                            Text(item.category?.name ?? "None")
                                .foregroundColor(.secondary)
                        } //: HStack
                    }
                } //: Section
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
                        Button {
                            weight = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(Color(UIColor.systemGray4))
                        .opacity(weight.isEmpty ? 0 : 1)
                        .animation(.easeOut(duration: 0.2), value: weight.isEmpty)
                    }
                } header: {
                    HStack(spacing: 0) {
                        Text("Weight")
                        Text("  ( \(weightUnit)/pcs )")
                            .textCase(nil)
                    }
                } //: Section
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
                    Text("Quantity")
                } //: Section
                Section {
                    TextEditor(text: $note)
                        .frame(minHeight: 180)
                        .focused($focusedField, equals: .noteField)
                        .id(noteID)
                } header: {
                    Text("Note")
                } //: Section
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
        .interactiveDismissDisabled(weightIsInvalid || quantityIsInvalid)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                XButtonView {
                    if weightIsInvalid && quantityIsInvalid {
                        print("Error")
                    } else if weightIsInvalid {
                        print("Error")
                    } else if quantityIsInvalid {
                        print("Error")
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
                        Text("Done")
                            .foregroundColor(.accentColor)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .onAppear {
            weight = (item.weight == 0 ? "" : String(item.weight.string))
            quantity = (item.quantity <= 1 ? "" : String(item.quantity))
            note = item.note ?? ""
        }
        .onDisappear {
            setValue()
            saveData()
        }
    }
    
    private func setValue() {
        item.weight = weight.isEmpty ? 0 : Double(weight)!
        item.quantity = quantity.isEmpty ? 1 : Int32(quantity)!
        item.note = note.isEmpty ? nil : note
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
