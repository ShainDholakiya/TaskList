/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Combine
import Foundation

class TaskStore: ObservableObject {
    
    let tasksJSONURL = URL(fileURLWithPath: "PrioritizedTasks", relativeTo: try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)).appendingPathExtension("json")
    
    @Published var prioritizedTasks: [PrioritizedTasks] = [
        PrioritizedTasks(priority: .high, names: []),
        PrioritizedTasks(priority: .medium, names: []),
        PrioritizedTasks(priority: .low, names: []),
        PrioritizedTasks(priority: .no, names: [])
        ] {
        didSet {
            saveJSONPrioritizedTasks()
        }
    }
    
    init() {
        loadJSONPrioritizedTasks()
    }
    
    func getIndex(for priority: Task.Priority) -> Int {
        prioritizedTasks.firstIndex { $0.priority == priority }!
    }
    
    private func loadJSONPrioritizedTasks() {
//        print(Bundle.main.bundleURL)
//        print(try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false))
//        let tempDirectoryURL = FileManager.default.temporaryDirectory
//        print(tempDirectoryURL)
        
//        print((try? FileManager.default.contentsOfDirectory(atPath: try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).path)) ?? [])
        
        let decoder = JSONDecoder()
        
        do {
            let tasksData = try Data(contentsOf: tasksJSONURL)
            prioritizedTasks = try decoder.decode([PrioritizedTasks].self, from: tasksData)
        } catch {
            print(error)
        }
        
    }
    
    private func saveJSONPrioritizedTasks() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let tasksData = try encoder.encode(prioritizedTasks)
            try tasksData.write(to: tasksJSONURL, options: .atomicWrite) // .atomicWrite writes to separate file first and when succeeded then writes to Task
        } catch {
            print(error)
        }
    }
}


private extension TaskStore.PrioritizedTasks {
    init(priority: Task.Priority, names: [String]) {
        self.init(
            priority: priority,
            tasks: names.map { Task(name: $0) }
        )
    }
}
