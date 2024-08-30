//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Luke Wolfram on 8/28/24.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil

    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/seed/picsum/200/100") else { return }
           let (data, response) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("IMAGE RETURNED SUCCESSFULLY!")
            }
            } catch {
                print(error.localizedDescription)
        }
    }
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/seed/picsum/200/100") else { return }
           let (data, response) = try await URLSession.shared.data(from: url)
            self.image2 = UIImage(data: data)
            } catch {
                print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("CLICK ME!") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task {
//                await viewModel.fetchImage()
//            }
//            Task {
//                await viewModel.fetchImage2()
//            }
//            Task(priority: .low) {
//                try? await Task.sleep(nanoseconds: 2000000000)
//                await Task.yield()
//                print("LOW : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("MED : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .high) {
//                print("HIGH : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .background) {
//                print("backgrou d : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("utility : \(Thread.current) : \(Task.currentPriority)")
//            }
            
            
//        Task(priority: .userInitiated) {
//            print("userinitiated : \(Thread.current) : \(Task.currentPriority)")
//            
//            Task.detached {
//                print("detached : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//        }
        }
    }

#Preview {
    TaskBootcamp()
}
