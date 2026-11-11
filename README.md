# SoundLink iOS

Prima base nativa SwiftUI per iPhone.

## Dispositivi iniziali da testare
- JBL Flip 3: usa JBL Connect.
- JBL Go 4: usa Auracast.

Questi due sistemi non sono interoperabili: il Flip 3 non può collegarsi direttamente al Go 4 tramite il pulsante JBL Connect/Auracast.

## Funzioni già inserite
- Interfaccia SwiftUI in italiano.
- Scheda dedicata ai due modelli JBL dichiarati.
- Lettura delle uscite audio attive tramite AVAudioSession.
- Selettore ufficiale di routing iOS tramite MPVolumeView.
- Generazione e riproduzione di un tono di test.
- Indicazione esplicita dei limiti di multi-output Bluetooth in iOS.

## Limite tecnico importante
Un'app iOS non può obbligare il sistema a inviare lo stesso flusso audio a due casse Bluetooth A2DP indipendenti. Le opzioni pratiche sono:
- collegare le casse tra loro usando la stessa tecnologia JBL supportata da entrambi i modelli;
- usare più dispositivi AirPlay compatibili e il routing gestito da iOS;
- valutare un trasmettitore o hardware esterno che supporti esplicitamente due uscite Bluetooth simultanee.

Per la coppia Flip 3 + Go 4, la prima opzione non è disponibile perché JBL Connect e Auracast sono tecnologie diverse. Non va quindi presentata come una funzione già realizzabile nell'app.

Il tono di test verifica l'uscita selezionata, non certifica la sincronizzazione tra due casse.

## Requisiti
- Xcode 15 o successivo consigliato.
- iOS 16 o successivo.
