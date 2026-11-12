# SoundLink iOS

Prototipo nativo SwiftUI per iPhone. Questa branch contiene l'app iOS; la versione web/PWA è pubblicata separatamente da GitHub Pages.

## Dispositivi di riferimento
- JBL Flip 3: JBL Connect (generazione precedente).
- JBL Go 4: Bluetooth A2DP e Auracast.

I due altoparlanti non possono essere raggruppati direttamente con JBL Connect/Auracast: la Flip 3 non è un altoparlante Auracast.

## Funzioni del prototipo nativo
- Interfaccia SwiftUI in italiano.
- Modelli JBL Flip 3 e JBL Go 4 mostrati come dispositivi preferiti già associati all'iPhone.
- Lettura della rotta audio realmente attiva tramite AVAudioSession.
- Aggiornamento automatico quando iOS cambia uscita audio.
- Selettore ufficiale di routing iOS tramite MPVolumeView.
- Tono di test di 2 secondi sull'uscita selezionata.

## Limiti che non vanno nascosti
- La lista mostra la rotta audio attiva, non l'elenco completo dei dispositivi Bluetooth associati.
- Un'app iOS non può forzare due casse Bluetooth A2DP indipendenti a riprodurre contemporaneamente lo stesso audio.
- Il tono di test verifica una sola uscita selezionata; non prova una riproduzione sincronizzata su due casse.
- Il prototipo non riproduce ancora brani musicali né controlla l'audio di Spotify/Apple Music.
- JBL Connect e Auracast sono sistemi diversi e non interoperabili per questa coppia di modelli.

Per ottenere la riproduzione simultanea sulla Flip 3 e sulla Go 4 serve una soluzione esterna compatibile con entrambe le casse, oppure una verifica pratica con un trasmettitore multi-link che dichiari esplicitamente il supporto a due ricevitori A2DP. Non è una funzione ottenibile con il solo codice dell'app.

## Build e distribuzione
- La workflow GitHub Actions compila il target iOS Simulator su macOS.
- Una build Simulator non è installabile su iPhone.
- Per distribuire una vera app su iPhone servono firma Apple e un canale di distribuzione (ad esempio TestFlight); la firma e la pubblicazione non sono configurate in questo repository.
- Requisiti di sviluppo: Xcode 15 o successivo; deployment target iOS 16.
