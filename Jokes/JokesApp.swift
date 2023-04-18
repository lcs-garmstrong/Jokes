//
//  JokesApp.swift
//  Jokes
//
//  Created by Graeme Armstrong on 2023-04-14.
//

import Blackbird
import SwiftUI

@main
struct JokesApp: App {
    var body: some Scene {
        WindowGroup {
            TabView{
                JokesView()
                    .tabItem{
                        Label("Fresh", systemImage: "carrot")
                    }
                
                FavouritesView()
                    .tabItem{
                        Label("Favourites", systemImage: "face.smiling")
                    }
            }
            // make the database available within our app
            .environment(\.blackbirdDatabase, AppDatabase.instance)
        }
    }
}
