//
//  JokesView.swift
//  Jokes
//
//  Created by Graeme Armstrong on 2023-04-14.
//

import SwiftUI

struct JokesView: View {
    var body: some View {
        NavigationView{
            VStack {
                Text("You see, mountains aren't just funny.")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .tint(.black)
                })
                
                Text("They are hill areas")
                    .font(.title)
                    .multilineTextAlignment(.center)
            }
            .navigationTitle("Random Jokes")
        }
    }
}

struct JokesView_Previews: PreviewProvider {
    static var previews: some View {
            JokesView()
    }
}