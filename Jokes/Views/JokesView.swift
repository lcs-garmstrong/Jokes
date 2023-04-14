//
//  JokesView.swift
//  Jokes
//
//  Created by Graeme Armstrong on 2023-04-14.
//

import SwiftUI

struct JokesView: View {
    
    // 0.0 is invisible, 1.0 is visible
    @State var punchlineOpacity = 0.0
    
    @State var currentJoke: Joke?
    
    var body: some View {
        NavigationView{
            VStack {
                
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
                           }
                       }, label: {
                           Text("Fetch another one")
                       })
                       .disabled(punchlineOpacity == 0.0 ? true : false)
                       .buttonStyle(.borderedProminent)
                
            }
            .navigationTitle("Random Jokes")
        }
        // create an asynchronous ask to be preformed as this viewappears
        .task {
            currentJoke = await NetworkService.fetch()
        }
    }
}

struct JokesView_Previews: PreviewProvider {
    static var previews: some View {
        JokesView()
    }
}
