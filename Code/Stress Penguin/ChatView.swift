//
//  ChatView.swift
//  Stress Penguin
//
//  Created by Mishtu on 23/6/24.
//

import SwiftUI

struct ChatView: View {
    @State private var message = ""
    @State private var chatLog = ["Welcome to the chat!"]

    var body: some View {
        ZStack {
            Color.peach
                .ignoresSafeArea()

            VStack {
                ScrollView {
                    ForEach(chatLog, id: \.self) { message in
                        Text(message)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                    }
                }
                .padding()

                HStack(alignment: .bottom) {
                    TextField("Type your message...", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: sendMessage) {
                        Text("Send")
                            .padding()
                            .background(Color.softPink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .navigationTitle("Chat with Hume")
    }

    func sendMessage() {
        chatLog.append("You: \(message)")
        message = ""
        // integrate Humeclear
    }
}

#Preview {
    ChatView()
}
