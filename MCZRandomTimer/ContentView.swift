import SwiftUI

struct ContentView: View {
    @State private var randomNumber = Int.random(in: 1...20)
    @State private var timerLength = 1 // in minutes (1-99)
    @State private var interval = 2.0 // in seconds (1-9)
    @State private var isRunning = false
    @State private var fontSize: CGFloat = 150
    @State private var timeRemaining = 0 // in seconds for countdown
    
    let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var numberTimer: Timer? = nil
    
    var body: some View {
        VStack(spacing: 30) {
            // Countdown timer at the top
            Text("Time left: \(timeRemaining / 60)m \(timeRemaining % 60)s")
                .font(.system(size: 40)) // Good size for visibility
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding()
                .background(Color.yellow.opacity(0.3)) // Light background for contrast
                .cornerRadius(10)
                .opacity(isRunning || timeRemaining > 0 ? 1 : 0) // Show only when relevant
            
            // Display the random number
            Text("\(randomNumber)")
                .font(.system(size: fontSize))
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
            
            // Timer length selection
            HStack {
                Text("Timer (min):")
                    .font(.headline)
                Picker("Minutes", selection: $timerLength) {
                    ForEach(1..<100) { minute in
                        Text("\(minute)").tag(minute)
                    }
                }
                .pickerStyle(.menu)
                .disabled(isRunning)
            }
            
            // Interval for random number change
            HStack {
                Text("Interval (sec):")
                    .font(.headline)
                Picker("Seconds", selection: $interval) {
                    ForEach(1..<10) { second in
                        Text("\(second)").tag(Double(second))
                    }
                }
                .pickerStyle(.menu)
                .disabled(isRunning)
            }
            
            // Start/Stop button
            Button(action: {
                isRunning.toggle()
                if isRunning {
                    timeRemaining = timerLength * 60
                    startNumberTimer()
                } else {
                    stopNumberTimer()
                }
            }) {
                Text(isRunning ? "Stop" : "Start")
                    .font(.title2)
                    .padding()
                    .frame(width: 120)
                    .background(isRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // Font size adjustment buttons
            HStack(spacing: 20) {
                Button(action: { fontSize = max(20, fontSize - 10) }) {
                    Text("Smaller")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Button(action: { fontSize = min(500, fontSize + 10) }) {
                    Text("Larger")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .onReceive(countdownTimer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining == 0 {
                    stopTimer()
                }
            }
        }
    }
    
    func startNumberTimer() {
        numberTimer?.invalidate()
        numberTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if isRunning {
                randomNumber = Int.random(in: 1...20)
            }
        }
    }
    
    func stopNumberTimer() {
        numberTimer?.invalidate()
        numberTimer = nil
    }
    
    func stopTimer() {
        isRunning = false
        stopNumberTimer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
