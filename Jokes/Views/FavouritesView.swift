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
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
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
                .onDelete(perform: removeRows)
            }
            
            .navigationTitle("Favourite Jokes")
        }
    }
    
    //MARK: Functions
    func removeRows(at offsets: IndexSet) {
        
        Task {
            
            try await db!.transaction { core in
                
                // get the id
                var idList = ""
                for offset in offsets {
                    idList += ("\(favouriteJoke.results[offset].id),")
                }
                
                // remove the the final coma
                print(idList)
                idList.removeLast()
                print(idList)
                
                try core.query("DELETE FROM Joke WHERE id IN (?)", idList)
            }
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
