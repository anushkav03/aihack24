import SwiftUI

struct ChatView: View {
    @State private var message = ""
    @StateObject private var webSocketManager = WebSocketManager()

    // Replace with your actual API key
    private let apiKey = "yGrxRpwGqgdraGtzGMvpSMr6CYVGGmU1z0gb1eCCY0GdjaZs"

    var body: some View {
        ZStack {
            Color.peach
                .ignoresSafeArea()

            VStack {
                ScrollView {
                    ForEach(webSocketManager.chatLog, id: \.self) { message in
                        HStack {
                            if message.starts(with: "You:") {
                                Spacer()
                                Text(message)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(.vertical, 2)
                                    .frame(maxWidth: 300, alignment: .trailing)
                            } else {
                                Text(message)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(.vertical, 2)
                                    .frame(maxWidth: 300, alignment: .leading)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()

                HStack {
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
        .onAppear {
            webSocketManager.connectWebSocket(apiKey: apiKey)
        }
    }

    func sendMessage() {
        webSocketManager.sendMessage(text: message)
        message = ""
    }
}

#Preview {
    ChatView()
}
