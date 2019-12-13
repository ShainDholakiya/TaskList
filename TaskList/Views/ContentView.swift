//
//  ContentView.swift
//  TaskList
//
//  Created by Shain Dholakiya on 11/24/19.
//  Copyright © 2019 Shain Dholakiya. All rights reserved.
//

import SwiftUI

struct ContentView: View {
//    var taskStore = TaskStore();
    @ObservedObject var taskStore: TaskStore
    @State var modalIsPresented = false
    
    var body: some View {
//        List(taskStore.tasks.indices) { index in
//            Text(self.taskStore.tasks[index].name)
//        }
        NavigationView {
            List {
                ForEach(taskStore.prioritizedTasks) { index in
                    SectionView(
                        prioritizedTasks: self.$taskStore.prioritizedTasks[index]
                    )
                }
            }
        .listStyle( GroupedListStyle() )
            .navigationBarTitle("Tasks")
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    Button(
                        action: { self.modalIsPresented = true }
                    ) {
                    Image(systemName: "plus")
                    }
            )
        }
        .sheet(isPresented: $modalIsPresented) {
            NewTaskView( taskStore: self.taskStore )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( taskStore: TaskStore() )
    }
}
