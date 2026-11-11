# SoundLink iOS

Prima base nativa SwiftUI per iPhone.

## Aprire il progetto
1. Aprire `SoundLink.xcodeproj` con Xcode su un Mac.
2. Selezionare il target `SoundLink`.
3. Collegare un iPhone e avviare l'app.

## Funzioni già inserite
- Interfaccia SwiftUI in italiano.
- Lettura delle uscite audio attive tramite AVAudioSession.
- Selettore ufficiale di routing iOS tramite MPVolumeView.
- Generazione e riproduzione di un tono di test.
- Indicazione chiara dei limiti di multi-output Bluetooth in iOS.

## Limite tecnico importante
Un'app iOS non può obbligare il sistema a inviare lo stesso flusso audio a due casse Bluetooth A2DP indipendenti. Le opzioni pratiche sono:
- collegare le casse tra loro usando la funzione JBL supportata da quegli specifici modelli;
- usare più dispositivi AirPlay compatibili e il routing gestito da iOS;
- valutare hardware o un protocollo di trasmissione dedicato.

Il tono di test verifica l'uscita selezionata, non certifica la sincronizzazione tra due casse.

## Requisiti
- Xcode 15 o successivo consigliato.
- iOS 16 o successivo.
