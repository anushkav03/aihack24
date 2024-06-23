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
                    
                    NavigationLink(destination: AlertViewWrapper()) {
                        Text("Show Alert")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
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


