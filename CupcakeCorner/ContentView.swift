//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by noor on 3/12/25.
//

import SwiftUI

struct Response : Codable {
    let results: [Result]
}

struct Result: Codable {
    let trackId: Int
    let trackName: String
    let collectionName: String
}

struct ContentView: View {
    @State private var results = [Result]()
    var body: some View {
            List(results, id: \.trackId) { item in
                VStack(alignment: .leading) {
                    Text(item.trackName)
                        .font(.headline)
                    Text(item.collectionName)
                }
            }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from:data) {
                results = decodedResponse.results
            }
        } catch {
            print("invalid data")
        }
    }
}

#Preview {
    ContentView()
}
