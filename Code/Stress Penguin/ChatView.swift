import SwiftUI
import AVFoundation
import Speech

struct ChatView: View {
    @State private var message = ""
    @State private var chatLog = ["Welcome to the chat!"]
    @State private var isRecording = false
    
    private let speechRecognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    
    private let webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://api.hume.ai/v0/evi/chat?api_key=$yGrxRpwGqgdraGtzGMvpSMr6CYVGGmU1z0gb1eCCY0GdjaZs")!)

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

                Button(action: toggleRecording) {
                    Text(isRecording ? "Stop Recording" : "Start Recording")
                        .padding()
                        .background(isRecording ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationTitle("Chat with Hume")
        .onAppear {
            setupVoiceRecognition()
            connectWebSocket()
        }
    }

    func sendMessage() {
        chatLog.append("You: \(message)")
        let webSocketMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask.send(webSocketMessage) { error in
            if let error = error {
                print("WebSocket send error: \(error)")
            }
        }
        message = ""
    }

    func setupVoiceRecognition() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            case .denied, .restricted, .notDetermined:
                print("Speech recognition not authorized")
            @unknown default:
                print("Unknown speech recognition authorization status")
            }
        }
    }

    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    func startRecording() {
        guard let speechRecognizer = SFSpeechRecognizer(), speechRecognizer.isAvailable else {
            print("Speech recognizer not available")
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create recognition request")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    let spokenText = result.bestTranscription.formattedString
                    self.message = spokenText
                }
            }

            if let error = error {
                print("Speech recognition error: \(error)")
                self.stopRecording()
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            print("Audio engine start error: \(error)")
        }
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isRecording = false

        // Remove tap on bus to release resources
        audioEngine.inputNode.removeTap(onBus: 0)
    }

    func connectWebSocket() {
        webSocketTask.resume()
        receiveWebSocketMessages()
    }

    func receiveWebSocketMessages() {
        webSocketTask.receive { result in
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        chatLog.append("Hume: \(text)")
                        speak(text)
                    }
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError("Unknown WebSocket message type")
                }
            }
            receiveWebSocketMessages()
        }
    }

    func speak(_ message: String) {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

#Preview {
    ChatView()
}
