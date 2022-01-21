//
//  CheckListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/14.
//

import SwiftUI

struct CheckListView: View {
    @AppStorage(K.key.showCompleted) var showCompleted = true
    @Environment(\.managedObjectContext) private var viewContext
    let itemList: ItemList
    @FetchRequest var items: FetchedResults<Item>
    
    @State var showUndo = false
    @State private var showUndoTimer: Timer?
    
    var numberOfCompletedItems: Int {
        numberOfAllItems - items.filter { $0.isCompleted == false }.count
    }
    
    var numberOfAllItems: Int {
        (itemList.items?.count ?? 0)
    }
    
    init(of itemList: ItemList, showCompleted: Bool) {
        self.itemList = itemList
        
        let predicateFormat = showCompleted ? "parentItemList == %@" : "parentItemList == %@ && isCompleted == NO"
        
        _items = FetchRequest(
            sortDescriptors: [
                SortDescriptor(\.order, order: .forward)
            ],
            predicate: NSPredicate(format: predicateFormat, itemList),
            animation: .default.delay(0.3)
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CheckListProgressView(numberOfCompletedItems: numberOfCompletedItems,
                                  numberOfAllItems: numberOfAllItems)
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(items) { item in
                        CheckItemCell(item: item, showAndHideUndoButton: showAndHideUndoButton)
                    } //: VStack
                } //: VStack
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.vertical, 20)
            } //: ScrollView
            .overlay(alignment: .bottomTrailing) {
                if !showCompleted && showUndo {
                    Button {
                        if viewContext.hasChanges {
                            viewContext.undo()
                        }
                        showUndoTimer?.invalidate()
                        withAnimation {
                            showUndo = false
                        }
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    } //: Button
                    .buttonStyle(.largeCircle)
                    .foregroundStyle(.tint)
                    .padding()
                    .transition(.move(edge: .trailing))
                    .animation(.easeOut(duration: 0.2), value: showUndo)
                }
            }
        } //: VStack
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
    
    private func showAndHideUndoButton() {
        showUndoTimer?.invalidate()
        withAnimation {
            showUndo = true
        }
        showUndoTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            withAnimation {
                showUndo = false
                saveData()
            }
        }
    }
}

struct CheckListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        CheckListView(of: itemList, showCompleted: true)
            .environment(\.managedObjectContext, context)
    }
}
