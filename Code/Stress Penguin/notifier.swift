import CoreML
import UserNotifications

class ModelManager {
    
    static let shared = ModelManager()
    
    private init() {}
    
    func useCoreMLModels() {
        // Load the first model
        guard let model1URL = Bundle.main.url(forResource: "model_1", withExtension: "mlmodelc"),
              let model1 = try? model_1(contentsOf: model1URL) else {
            fatalError("Could not load model_1")
        }
        
        // Load the second model
        guard let model2URL = Bundle.main.url(forResource: "model_2", withExtension: "mlmodelc"),
              let model2 = try? model_2(contentsOf: model2URL) else {
            fatalError("Could not load model_2")
        }
        
        // Prepare your fixed input data for model_1
        let meanRR: Double = 885.157845
        let medianRR: Double = 853.763730
        let sdrr: Double = 140.972741
        let hr: Double = 69.499952
        let rmssd: Double = 15.554505
        let sdsd: Double = 15.553371
        let sdrrRmssd: Double = 9.063146
        let sd1: Double = 11.001565
        let sd2: Double = 199.061782
        let sampen: Double = 2.139754
        
        // Create MLMultiArray for model_1 input
        guard let inputArray1 = try? MLMultiArray(shape: [10], dataType: .double) else {
            fatalError("Could not create MLMultiArray")
        }
        
        inputArray1[0] = NSNumber(value: meanRR)
        inputArray1[1] = NSNumber(value: medianRR)
        inputArray1[2] = NSNumber(value: sdrr)
        inputArray1[3] = NSNumber(value: hr)
        inputArray1[4] = NSNumber(value: rmssd)
        inputArray1[5] = NSNumber(value: sdsd)
        inputArray1[6] = NSNumber(value: sdrrRmssd)
        inputArray1[7] = NSNumber(value: sd1)
        inputArray1[8] = NSNumber(value: sd2)
        inputArray1[9] = NSNumber(value: sampen)
        
        let input1 = model_1Input(input: inputArray1)
        
        var model1PredictionIsTrue = false
        var model2PredictionIsTrue = false
        
        // Make the prediction with model_1
        do {
            let prediction1 = try model1.prediction(input: input1)
            print("Model 1 Prediction: \(prediction1.classLabel)")
            if prediction1.classLabel > 0 {
                model1PredictionIsTrue = true
            }
        } catch {
            print("Error making prediction with model_1: \(error)")
        }
        
        // Prepare your fixed input data for model_2
        let bloodOxygenLevel: Double = 89.840
        let numberOfHoursOfSleep: Double = 1.840
        
        // Create MLMultiArray for model_2 input
        guard let inputArray2 = try? MLMultiArray(shape: [2], dataType: .double) else {
            fatalError("Could not create MLMultiArray")
        }
        
        inputArray2[0] = NSNumber(value: bloodOxygenLevel)
        inputArray2[1] = NSNumber(value: numberOfHoursOfSleep)
        
        let input2 = model_2Input(input: inputArray2)
        
        // Make the prediction with model_2
        do {
            let prediction2 = try model2.prediction(input: input2)
            print("Model 2 Prediction: \(prediction2.classLabel)")
            if prediction2.classLabel > 0 {
                model2PredictionIsTrue = true
            }
        } catch {
            print("Error making prediction with model_2: \(error)")
        }
        
        // Send notification if either model's prediction is true
        if model1PredictionIsTrue || model2PredictionIsTrue {
            sendNotification(message: "Stress level is high according to one or more models")
        }
    }
    
    private func sendNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Stress Alert"
        content.body = message
        content.sound = UNNotificationSound.default

        // Create the trigger as a one-second delay.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}
