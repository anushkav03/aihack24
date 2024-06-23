//
//  ContentView.swift
//  Stress Penguin
//
//  Created by Mishtu on 23/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.peach
                    .ignoresSafeArea()
                
                VStack {
                    
                    // Replace this NavigationLink with an Image
                    Image("penguin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    NavigationLink(destination: ChatView()) {
                        Text("Talk to Hume")
                            .padding()
                            .background(Color.softPink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
        }
    }
}
