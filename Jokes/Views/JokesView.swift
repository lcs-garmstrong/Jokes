//
//  JokesView.swift
//  Jokes
//
//  Created by Graeme Armstrong on 2023-04-14.
//

import Blackbird
import SwiftUI

struct JokesView: View {
    // MARK: Stored properties
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    // 0.0 is invisible, 1.0 is visible
    @State var punchlineOpacity = 0.0
    
    @State var currentJoke: Joke?
    
    // track whether joke has been saved to database.
    @State var saveToDatabase = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                
                Spacer()
                
                if let currentJoke =  currentJoke {
                    
                    // show the joke if it can be unwrapped (if current joke is not nil)
                    Text(currentJoke.setup)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        withAnimation(.easeIn(duration: 1.0)){
                            punchlineOpacity = 1.0
                        }
                    }, label: {
                        Image(systemName: "arrow.down.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .tint(.black)
                    })
                    
                    Text(currentJoke.punchline)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .opacity(punchlineOpacity)
                    
                } else {
                    // Show a spinning wheel indicator that joke is loading
                    ProgressView()
                }
                
                Spacer()
                
                Button(action: {
                    // Reset the interface
                    punchlineOpacity = 0.0
                    
                    Task {
                        // Get another joke
                        withAnimation {
                            currentJoke = nil
                        }
                        currentJoke = await NetworkService.fetch()
                        
                        // reset to button allows for another joke
                        saveToDatabase = false
                        
                    }
                }, label: {
                    Text("Fetch another one")
                })
                .disabled(punchlineOpacity == 0.0 ? true : false)
                .buttonStyle(.borderedProminent)
                
                Button(action:{
                    Task{
                        // write to database
                        if let currentJoke = currentJoke {
                            try await db!.transaction { core in
                                try core.query("INSERT INTO Joke (id, type, setup, punchline) VALUES (?, ?, ?, ?)",
                                               currentJoke.id,
                                               currentJoke.type,
                                               currentJoke.setup,
                                               currentJoke.punchline)
                                
                                // record if joke has been saved
                                saveToDatabase = true
                            }
                        }
                    }
                }, label: {
                    Text("Save for later")
                })
                // disable button until punchine is shown.
                .disabled(punchlineOpacity == 0.0 ? true : false)
                // once saved once can't be saved twice
                .disabled(saveToDatabase == true ? true : false)
                .tint(.green)
                .buttonStyle(.borderedProminent)
                
            }
            .navigationTitle("Fresh Jokes")
        }
        // create an asynchronous ask to be preformed as this viewappears
        .task {
            if currentJoke == nil {
                currentJoke = await NetworkService.fetch()
            }
        }
    }
}

struct JokesView_Previews: PreviewProvider {
    static var previews: some View {
        JokesView()
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
