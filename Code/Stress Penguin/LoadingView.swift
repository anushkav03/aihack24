//
//  LoadingView.swift
//  Stress Penguin
//
//  Created by Mishtu on 23/6/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            Color.darkPeach
                .ignoresSafeArea()
            
            if isActive {
                ContentView()
            } else {
                VStack {
                    Text("Stress Penguin")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LoadingView()
}
