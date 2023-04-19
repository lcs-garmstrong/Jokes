//
//  FavouritesView.swift
//  Jokes
//
//  Created by Graeme Armstrong on 2023-04-18.
//

import Blackbird
import SwiftUI

struct FavouritesView: View {
    
    // MARK: Stored properties
    
    @BlackbirdLiveModels({ db in
        try await Joke.read(from: db)
    }) var favouriteJoke
    
    // MARK: computed properties
    var body: some View {
        NavigationView {
            
            List {
                
                ForEach(favouriteJoke.results) { currentJoke in
                    VStack(alignment: .leading) {
                        Text(currentJoke.setup)
                            .bold()
                        Text(currentJoke.punchline)
                    }
                }
                
            }

            .navigationTitle("Favourite Jokes")
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
        // make the database available for this preview
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
