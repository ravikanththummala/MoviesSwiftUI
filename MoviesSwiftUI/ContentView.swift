//
//  ContentView.swift
//  MoviesSwiftUI
//
//  Created by Ravikanth on 10/26/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var movies:[Movie] = []
    @State private var search: String = ""
    @State private var cancallables: Set<AnyCancellable> = []
    
    private let searchSubject = CurrentValueSubject<String, Never>("")
    
    let httpClient:HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    private func setUpSearchPublisher(){
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { searcTxt in
                loadMovies(search: searcTxt)
            }.store(in: &cancallables)
    }
    
    private func loadMovies(search:String) {
        httpClient.fetchMovies(search: search)
            .sink { _ in } receiveValue: { movies in
                self.movies = movies
            }.store(in: &cancallables)
    }
    
    var body: some View {
        List(movies){ movie in
            HStack{
                    
                AsyncImage(url: movie.poster) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                } placeholder: {
                    ProgressView()
                }
                
                Text(movie.title)

            }
        }
        .onAppear{
            setUpSearchPublisher()
        }
        .searchable(text: $search)
        .onChange(of: search) {
            searchSubject.send(search)
        }
    }
}

#Preview {
    NavigationStack {
        ContentView(httpClient:HTTPClient())
    }
}
