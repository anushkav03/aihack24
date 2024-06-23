import Foundation

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var chatLog: [String] = ["Welcome to the chat!"]

    func connectWebSocket(apiKey: String) {
        let urlString = "wss://api.hume.ai/v0/evi/chat?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        
        webSocketTask?.resume()
        receiveWebSocketMessages()
    }

    func sendMessage(text: String) {
        let message = UserInput(text: text, type: "user_input", customSessionId: nil)

        guard let jsonData = try? JSONEncoder().encode(message) else {
            print("Failed to encode JSON data")
            return
        }

        if let jsonString = String(data: jsonData, encoding: .utf8) {
            let webSocketMessage = URLSessionWebSocketTask.Message.string(jsonString)
            webSocketTask?.send(webSocketMessage) { error in
                if let error = error {
                    print("WebSocket send error: \(error.localizedDescription)")
                }
            }
            // Append user's message to the chat log
            DispatchQueue.main.async {
                self.chatLog.append("You: \(text)")
            }
        }
    }

    private func receiveWebSocketMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error.localizedDescription)")
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleIncomingMessage(text: text)
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError("Unknown WebSocket message type")
                }
            }
            self?.receiveWebSocketMessages()
        }
    }

    private func handleIncomingMessage(text: String) {
        guard let data = text.data(using: .utf8) else {
            print("Failed to convert text to data")
            return
        }

        do {
            let assistantMessage = try JSONDecoder().decode(AssistantMessage.self, from: data)
            if assistantMessage.type != "audio_output" && assistantMessage.type != "user_message" {
                DispatchQueue.main.async {
                    self.chatLog.append("Hume: \(assistantMessage.message.content)")
                }
            }
        } catch {
            print("Failed to decode assistant message: \(error.localizedDescription)")
            print("Received text: \(text)")
        }
    }

    deinit {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}

struct UserInput: Codable {
    let text: String
    let type: String
    let customSessionId: String?
}

struct AssistantMessage: Codable {
    let from_text: Bool
    let message: Message
    let models: Models
    let type: String
    let customSessionId: String?
    let id: String?
}

struct Message: Codable {
    let content: String
    // Add other properties as needed
}

struct Models: Codable {
    // Define properties for the model results
}
