import SwiftUI
import AVFoundation
import MediaPlayer

struct ContentView: View {
    @StateObject private var audio = SoundLinkAudio()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.035, green: 0.07, blue: 0.14), Color(red: 0.02, green: 0.025, blue: 0.055)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    header
                    outputCard
                    routeCard
                    testCard
                    compatibilityNote
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 36)
            }
        }
        .onAppear { audio.refreshRoutes() }
    }
    
    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "hifispeaker.2.fill")
                .font(.system(size: 38, weight: .semibold))
                .foregroundStyle(Color.cyan)
                .padding(.top, 14)
            Text("SoundLink")
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text("Il tuo audio, le tue casse.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.62))
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 4)
    }
    
    private var outputCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("USCITE AUDIO ATTIVE", systemImage: "waveform")
                .font(.caption.weight(.bold))
                .tracking(1.1)
                .foregroundStyle(.cyan)
            if audio.outputs.isEmpty {
                Text("Nessuna uscita esterna rilevata")
                    .foregroundStyle(.white.opacity(0.7))
            } else {
                ForEach(Array(audio.outputs.enumerated()), id: \.offset) { _, output in
                    HStack(spacing: 12) {
                        Image(systemName: output.icon)
                            .font(.title3)
                            .foregroundStyle(.cyan)
                            .frame(width: 34)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(output.name).font(.headline)
                            Text(output.detail).font(.caption).foregroundStyle(.white.opacity(0.55))
                        }
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
            Button {
                audio.refreshRoutes()
            } label: {
                Label("Aggiorna dispositivi", systemImage: "arrow.clockwise")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .background(.white.opacity(0.065), in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.08)))
    }
    
    private var routeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("SCEGLI DOVE ASCOLTARE", systemImage: "airplayaudio")
                .font(.caption.weight(.bold))
                .tracking(1.1)
                .foregroundStyle(.cyan)
            Text("Apri il selettore audio di iOS per scegliere una cassa o un dispositivo AirPlay.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.68))
            HStack {
                Image(systemName: "airplayaudio").font(.title2).foregroundStyle(.cyan)
                Text("Selettore audio iPhone").font(.headline)
                Spacer()
                SystemRoutePicker()
                    .frame(width: 52, height: 44)
                    .accessibilityLabel("Seleziona uscita audio")
            }
            .padding(12)
            .background(.black.opacity(0.2), in: RoundedRectangle(cornerRadius: 14))
        }
        .padding(18)
        .background(.white.opacity(0.065), in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.08)))
    }
    
    private var testCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("PROVA AUDIO", systemImage: "speaker.wave.2.fill")
                .font(.caption.weight(.bold))
                .tracking(1.1)
                .foregroundStyle(.cyan)
            Text("Riproduci un breve tono di test per controllare l'uscita selezionata.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.68))
            Button {
                audio.playTestTone()
            } label: {
                HStack {
                    Image(systemName: audio.isPlaying ? "waveform" : "play.fill")
                    Text(audio.isPlaying ? "Riproduzione in corso…" : "Riproduci test")
                }
                .font(.headline)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.cyan, in: RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .disabled(audio.isPlaying)
            if let message = audio.message {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.65))
            }
        }
        .padding(18)
        .background(.white.opacity(0.065), in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.08)))
    }
    
    private var compatibilityNote: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("NOTA SULLA COMPATIBILITÀ", systemImage: "info.circle")
                .font(.caption.weight(.bold))
                .foregroundStyle(.orange)
            Text("iOS decide quali uscite possono riprodurre audio contemporaneamente. Due casse Bluetooth JBL generiche non possono essere forzate in multi-output da un'app. La riproduzione su più casse può funzionare tramite AirPlay compatibile oppure tramite la funzione di collegamento tra casse prevista dal modello JBL.")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.65))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.orange.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
    }
}

struct AudioOutput: Identifiable {
    let id: String
    let name: String
    let detail: String
    let icon: String
}

@MainActor
final class SoundLinkAudio: ObservableObject {
    @Published var outputs: [AudioOutput] = []
    @Published var isPlaying = false
    @Published var message: String?
    private var player: AVAudioPlayer?
    
    func refreshRoutes() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.allowAirPlay, .allowBluetoothA2DP])
            try session.setActive(true)
        } catch {
            message = "Impossibile inizializzare l'audio: \(error.localizedDescription)"
        }
        outputs = session.currentRoute.outputs.map { output in
            let icon: String
            switch output.portType {
            case .bluetoothA2DP, .bluetoothHFP, .bluetoothLE: icon = "hifispeaker.fill"
            case .airPlay: icon = "airplayaudio"
            case .builtInSpeaker: icon = "iphone"
            case .headphones, .headsetMic: icon = "headphones"
            default: icon = "speaker.wave.2"
            }
            return AudioOutput(id: output.uid, name: output.portName, detail: output.portType.rawValue, icon: icon)
        }
    }
    
    func playTestTone() {
        do {
            let url = try makeTestTone()
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            isPlaying = true
            message = "Test audio avviato sull'uscita selezionata."
            player?.play()
            let duration = player?.duration ?? 2
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(duration + 0.15))
                isPlaying = false
                refreshRoutes()
            }
        } catch {
            isPlaying = false
            message = "Errore durante il test: \(error.localizedDescription)"
        }
    }
    
    private func makeTestTone() throws -> URL {
        let sampleRate = 44_100.0
        let frameCount = Int(sampleRate * 2.0)
        let dataSize = frameCount * 2
        var data = Data()
        func append<T: FixedWidthInteger>(_ value: T) {
            var little = value.littleEndian
            withUnsafeBytes(of: &little) { data.append(contentsOf: $0) }
        }
        data.append(contentsOf: Array("RIFF".utf8))
        append(UInt32(36 + dataSize))
        data.append(contentsOf: Array("WAVEfmt ".utf8))
        append(UInt32(16))
        append(UInt16(1))
        append(UInt16(1))
        append(UInt32(44_100))
        append(UInt32(88_200))
        append(UInt16(2))
        append(UInt16(16))
        data.append(contentsOf: Array("data".utf8))
        append(UInt32(dataSize))
        for index in 0..<frameCount {
            let fade = min(1.0, min(Double(index) / 2200.0, Double(frameCount - index) / 2200.0))
            let sample = Int16(sin(2.0 * Double.pi * 440.0 * Double(index) / sampleRate) * 0.22 * fade * Double(Int16.max))
            append(sample)
        }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("soundlink-test.wav")
        try data.write(to: url, options: .atomic)
        return url
    }
}

private struct SystemRoutePicker: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let view = MPVolumeView(frame: .zero)
        view.showsVolumeSlider = false
        view.showsRouteButton = true
        return view
    }
    func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}
