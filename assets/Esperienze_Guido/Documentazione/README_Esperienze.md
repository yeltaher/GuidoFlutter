# Esperienze Guido - Guida e Riferimenti

Questa cartella raccoglie tutto il materiale isolato (Scene e Audio) legato alle Meditazioni e alle Respirazioni. Questi file sono una copia di sicurezza e di organizzazione degli asset originali, pronti per essere esplorati, assemblati o renderizzati.

> [!NOTE]
> Poiché questi file sono stati copiati e non spostati forzatamente, **Unity ha rigenerato i loro file `.meta` e i GUID**. Questo significa che puoi aprirli o esplorarli in sicurezza, senza alterare la struttura del progetto originale. I collegamenti rigidi nelle scene originali non sono stati modificati.

---

## 🎧 Mappatura Scene-Audio

Le esperienze sono divise tra **Procedimento** (la fase di spiegazione vocale) e **L'Esperienza Pura** (la pratica vera e propria).

### 💧 Acqua
- **Scene**: `Procedimento acqua.unity`, `Acqua resp.unity` (Respirazione), scene sotto `Med generale.unity`
- **Voiceover Procedimento**: `Audio\Respirazioni\Acqua\Respirazione-Narici-Alternate_Procedimento.wav`
- **Audio Respirazione/Meditazione**: `Respirazione acqua.wav`
- **SFX Correlati**: `Bolle acqua.wav`, `RespAcqua.wav`
- **Musiche (Meditazione)**: `Musica Percorso Acqua - Meditazione MATTINO / POMERIGGIO / SERA.wav`

### 🌪️ Aria
- **Scene**: `Procedimento aria.unity`, `Aria respirazione.unity`
- **Voiceover Procedimento**: `Percorso-Aria_respiraz_diaframmaticaProcedimento.wav`
- **Audio Respirazione**: `Respirazione aria.wav`
- **SFX Correlati**: `Vento.wav`, `RespAria.mp3`

### 🔥 Fuoco
- **Scene**: `Procedimento fuoco.unity`, `Fuoco resp.unity`
- **Voiceover Procedimento**: `Percorso-Fuoco-Quadrato_Procedimento.wav`
- **Audio Respirazione**: `percorso fuoco quadrato Esercizio fix tempo.wav`
- **SFX Correlati**: `Fuoco.mp3`, `RespFuoco.mp3`

### 🪨 Terra
- **Scene**: `Procedimento terra.unity`, `Respirazione terra.unity`
- **Voiceover Procedimento**: `Respirazione-Percorso-Terra_Procedimento.wav`
- **Audio Respirazione**: `Respirazione terra.wav`
- **SFX Correlati**: `Scintille terra.wav`, `Cuore.wav`, `RespTerra.mp3`

### 🌌 Meditazioni Generali ed Effetti
- Le scene generiche come `Med generale.unity` utilizzano i file audio presenti in `Audio\Meditazioni\Generale` e `Audio\Meditazioni\Effetti`.
- Alcuni di questi includono musica eterea, suoni di particelle (fascio verde, sfere, orologio, ponte), o la voce guida isolata.

---

## 🥽 Guida al Rendering per VR (Video 360 / 180)

Se desideri esportare le scene di meditazione come **Video a 360 gradi** da guardare nel visore in modo passivo, segui questa procedura:

### 1. Installazione Unity Recorder
1. Vai su **Window > Package Manager**.
2. Assicurati di essere in "Unity Registry".
3. Cerca **Unity Recorder** e installalo.

### 2. Impostazione del Render a 360°
1. Apri la finestra **Window > General > Recorder > Recorder Window**.
2. Clicca su **Add Recorder** e scegli **Movie**.
3. Nella sezione **Source**, seleziona **360 View**.
4. Nelle impostazioni del sensore a 360°:
   - **Target**: Seleziona la Main Camera della scena (quella posizionata all'altezza della testa dell'utente).
   - **Stereo**: Spunta questa casella se vuoi un video in 3D Stereoscopico (solitamente layout *Top/Bottom*).
   - **Map Size / Resolution**: Imposta almeno `4096 x 4096` per una buona resa nei visori.
5. In **Output Format**: Scegli `H.264 MP4` (o ProRes se intendi fare color correction).
6. **Frame Rate**: Forza il framerate a `60 FPS` o `72 FPS` per garantire un'esperienza confortevole in VR.
7. Clicca il tasto rosso **START RECORDING** in Play Mode per renderizzare il video.

### 3. Gestione dell'Audio
> [!TIP]
> Unity Recorder attualmente non supporta l'esportazione di **Audio Spaziale (Ambisonics)** direttamente con il video a 360°.
Se vuoi mantenere la spazialità (es: il fuoco si sente a destra se guardi dritto):
1. Registra solo il video (oppure video + audio stereo piatto da Unity).
2. Renderizza l'audio a 360° usando l'**Oculus Spatializer Plugin** in una DAW esterna (o con tool specifici di Unity), per generare un file `.wav` Ambisonics a 4 canali.
3. Inietta i metadati 360 (per YouTube o visori VR locali) usando lo strumento **Spatial Media Metadata Injector** di Google.

---

## ⚡ Considerazioni su Performance (Build Interattiva)
Se il progetto non è pensato per il rendering video ma per l'esecuzione in **Real-time (App per Meta Quest / Cardboard)**:
- **Zero GC Allocs**: La scena di meditazione deve girare fluida (60fps minimo per Cardboard, 72/90fps per Quest). Evita script che causano Garbage Collection mentre si medita.
- **Batched Rendering**: Assicurati che il numero di *Draw Calls* sia basso (inferiore a 100-150 in vista) combinando materiali.
- **Lighting**: Usa Baked Global Illumination e materiali disattivati a ricezione di luce dinamica, specialmente per le scene rilassanti dove niente si muove.
- **Comfort**: Mantieni una telecamera rigorosamente ancorata (niente vibrazioni esterne o animazioni che forzino lo sguardo dell'utente altrove).
