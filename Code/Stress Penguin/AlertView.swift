//
//  AlertView.swift
//  Stress Penguin
//
//  Created by Mishtu on 23/6/24.
//

import SwiftUI

struct AlertView: View {
    @Binding var showAlertBox: Bool
    let message: String
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                Text(message)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.all, 20)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Button(action: {
                showAlertBox = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .padding(10)
            }
            .offset(x: 8, y: -8)
        }
        .padding()
    }
}

struct AlertViewWrapper: View {
    @State private var showAlert = true

    var body: some View {
        VStack {
            if showAlert {
                AlertView(showAlertBox: $showAlert, message: "You seem stressed")
            } else {
                Text("Take action. You've got this!")
            }
        }
        //.navigationTitle("Alert View")
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AlertViewWrapper()
        }
    }
}
