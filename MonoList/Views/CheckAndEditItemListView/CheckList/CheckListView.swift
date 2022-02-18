//
//  CheckListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/14.
//

import SwiftUI

struct CheckListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var itemList: ItemList
    var showCompleted: Bool
    let allDoneAction: () -> Void
    @FetchRequest var items: FetchedResults<Item>
    @FetchRequest var categories: FetchedResults<Category>
    
    @State var showUndo = false
    @State private var showUndoTimer: Timer?
    
    var showImageViewerAction: (Image) -> Void
    
    var numberOfUnCompletedItems: Int {
        items.filter { $0.isCompleted == false }.count
    }
    
    var numberOfAllItems: Int {
        (itemList.items?.count ?? 0)
    }
    
    var numberOfCompletedItems: Int {
        numberOfAllItems - numberOfUnCompletedItems
    }
    
    init(of itemList: ItemList, showCompleted: Bool, allDoneAction: @escaping () -> Void, showImageViewerAction: @escaping (Image) -> Void) {
        self.itemList = itemList
        self.showCompleted = showCompleted
        self.allDoneAction = allDoneAction
        self.showImageViewerAction = showImageViewerAction
        
        let predicateFormat = showCompleted ? "parentItemList == %@" : "parentItemList == %@ && isCompleted == NO"
        
        _items = FetchRequest(
            sortDescriptors: [
                SortDescriptor(\.order, order: .forward)
            ],
            predicate: NSPredicate(format: predicateFormat, itemList),
            animation: .default.delay(0.3)
        )
        
        _categories = FetchRequest(
            sortDescriptors: [
                SortDescriptor(\.order, order: .forward)
            ],
            animation: .default.delay(0.3)
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CheckListProgressView(numberOfCompletedItems: numberOfCompletedItems,
                                  numberOfAllItems: numberOfAllItems)
            Group {
                switch itemList.form {
                case .list:
                    NomalCheckListView(items: items,
                                       categories: categories,
                                       showAndHideUndoButtonAction: showAndHideUndoButton,
                                       showImageViewerAction: showImageViewerAction)
                case .gallery:
                    PhotoCheckListView(items: items,
                                       categories: categories,
                                       showAndHideUndoButtonAction: showAndHideUndoButton,
                                       showImageViewerAction: showImageViewerAction)
                }
            }
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
        .onChange(of: numberOfUnCompletedItems) { newValue in
            if newValue == 0 {
                allDoneAction()
            }
        }
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
        CheckListView(of: itemList, showCompleted: true, allDoneAction: {}, showImageViewerAction: { _ in })
            .environment(\.managedObjectContext, context)
    }
}
