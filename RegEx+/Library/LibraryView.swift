//
//  LibraryView.swift
//  RegEx+
//
//  Created by Lex on 2020/4/21.
//  Copyright © 2020 Lex.sh. All rights reserved.
//

import SwiftUI
import CoreData


struct LibraryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: RegEx.fetchAllRegEx()) var regExItems: FetchedResults<RegEx>
    
    @State private var refreshingId = UUID()
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        List {
            ForEach(regExItems, id: \.self) {
                LibraryItemView(regEx: $0)
            }
            .onDelete(perform: deleteRegEx)
            .id(self.refreshingId)
            .onReceive(self.didSave) { _ in
                DispatchQueue.main.async {
                    self.refreshingId = UUID()
                }
            }
        }
        .navigationBarItems(leading: editButton, trailing: HStack(spacing: 8) {
            aboutButton.padding()
            addButton.padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 0))
        })
        .navigationBarTitle("RegEx+")
        .environment(\.editMode, $editMode)
    }
    
    private var editButton: some View {
        Button(action: {
            self.editMode = self.editMode.isEditing ? .inactive : .active
        }, label: {
            Text(editMode.isEditing ? "Done" : "Edit")
        })
    }
    
    private var aboutButton: some View {
        NavigationLink(destination: AboutView()) {
            Image(systemName: "info.circle")
                .imageScale(.large)
        }
    }
    
    private var addButton: some View {
        Button(action: addRegEx) {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
        }
    }
}

#if DEBUG
struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LibraryView()
                .environment(\.managedObjectContext, DataManager.shared.persistentContainer.viewContext)
        }
    }
}
#endif
