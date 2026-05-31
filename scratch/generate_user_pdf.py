import os
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Image, PageBreak, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors

def create_explanatory_pdf(output_path):
    # A4 dimensions are 595.27 x 841.89 points
    doc = SimpleDocTemplate(
        output_path,
        pagesize=A4,
        rightMargin=30,
        leftMargin=30,
        topMargin=30,
        bottomMargin=30
    )
    
    styles = getSampleStyleSheet()
    
    # Custom Palette Japandi Light (matching Light Mode)
    c_bg = colors.HexColor("#ECE7DF")
    c_card = colors.HexColor("#F5F2EC")
    c_accent = colors.HexColor("#5E8C7A") # Japandi Green
    c_text = colors.HexColor("#2D322F") # Charcoal
    c_text_sub = colors.HexColor("#6E7571") # Slate
    
    # Custom Paragraph Styles
    title_style = ParagraphStyle(
        'JapandiTitle',
        parent=styles['Heading1'],
        fontName='Helvetica-Bold',
        fontSize=24,
        textColor=c_text,
        spaceAfter=15,
        alignment=1 # Center
    )
    
    subtitle_style = ParagraphStyle(
        'JapandiSub',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=12,
        textColor=c_text_sub,
        spaceAfter=25,
        alignment=1
    )
    
    section_style = ParagraphStyle(
        'JapandiSection',
        parent=styles['Heading2'],
        fontName='Helvetica-Bold',
        fontSize=16,
        textColor=c_accent,
        spaceBefore=10,
        spaceAfter=8
    )
    
    body_style = ParagraphStyle(
        'JapandiBody',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=10,
        textColor=c_text,
        leading=14,
        spaceAfter=10
    )
    
    story = []
    
    # Base folder for screenshots
    screenshots_dir = r"c:\Users\y.el.taher\Desktop\Yehia\Privato\CodePulse\Progetti\CP26-14 - Guido\2.Software\Guido\GuidoFlutter\screenshots"
    
    # Screenshot mapping
    s_home1 = os.path.join(screenshots_dir, "Screenshot 2026-05-26 104950.png")
    s_home2 = os.path.join(screenshots_dir, "Screenshot 2026-05-26 105001.png")
    s_meditate = os.path.join(screenshots_dir, "Screenshot 2026-05-26 105013.png")
    s_journal = os.path.join(screenshots_dir, "Screenshot 2026-05-26 105029.png")
    s_me1 = os.path.join(screenshots_dir, "Screenshot 2026-05-26 105040.png")
    s_me2 = os.path.join(screenshots_dir, "Screenshot 2026-05-26 105107.png")
    s_settings1 = os.path.join(screenshots_dir, "Screenshot 2026-05-26 105118.png")
    s_settings2 = os.path.join(screenshots_dir, "Screenshot 2026-05-26 105135.png")

    # --- COVER PAGE ---
    story.append(Spacer(1, 120))
    story.append(Paragraph("<b>GUIDO</b>", title_style))
    story.append(Paragraph("<b>MANUALE D'USO SEMPLICE E ILLUSTRATO</b>", subtitle_style))
    story.append(Spacer(1, 20))
    
    # Beautiful cover composition using Home Page screenshot
    if os.path.exists(s_home1):
        story.append(Table([[Image(s_home1, width=160, height=311)]], colWidths=[500], style=TableStyle([('ALIGN', (0,0), (-1,-1), 'CENTER')])))
        
    story.append(Spacer(1, 60))
    story.append(Paragraph("<i>Guida pratica per esplorare la tua app di consapevolezza quotidiana</i>", subtitle_style))
    story.append(PageBreak())
    
    # --- PAGE 1: HOME PAGE ---
    story.append(Paragraph("<b>1. LA HOME PAGE</b>", section_style))
    story.append(Paragraph("<b>Il tuo spazio quotidiano di pace e presenza.</b>", subtitle_style))
    story.append(Paragraph(
        "La schermata iniziale di <b>Guido</b> è pensata per accoglierti con calma fin dal primo istante. "
        "Ecco come è composta e cosa puoi fare:",
        body_style
    ))
    
    desc_home = (
        "• <b>Indicatore dell'Aria:</b> In alto a destra trovi un piccolo pallino che pulsa dolcemente per mostrarti lo stato dell'aria e la temperatura in tempo reale.<br/>"
        "• <b>Il Rituale del Respiro (Cerchio al centro):</b> Questo grande cerchio simula l'espansione e la contrazione dei tuoi polmoni (con un ciclo ideale di 4 secondi). Puoi seguirlo con lo sguardo per rilassare la mente in qualsiasi momento.<br/>"
        "• <b>Suoni Zen e Diario:</b> Due grandi pulsanti centrali ti permettono di accedere all'istante alla tua musica rilassante preferita o alle tue riflessioni.<br/>"
        "• <b>Una frase ispiratrice:</b> Nella parte inferiore trovi pensieri e aforismi zen scelti per darti una sferzata di positività quotidiana."
    )
    story.append(Paragraph(desc_home, body_style))
    story.append(Spacer(1, 10))
    
    # 2 Screenshots for Home
    home_elements = []
    if os.path.exists(s_home1):
        home_elements.append(Image(s_home1, width=150, height=291))
    if os.path.exists(s_home2):
        home_elements.append(Image(s_home2, width=150, height=291))
        
    if len(home_elements) == 2:
        t_home = Table([[home_elements[0], home_elements[1]]], colWidths=[240, 240])
        t_home.setStyle(TableStyle([('ALIGN', (0,0), (-1,-1), 'CENTER'), ('VALIGN', (0,0), (-1,-1), 'MIDDLE')]))
        story.append(t_home)
    elif len(home_elements) == 1:
        story.append(Table([[home_elements[0]]], colWidths=[500], style=TableStyle([('ALIGN', (0,0), (-1,-1), 'CENTER')])))
        
    story.append(PageBreak())
    
    # --- PAGE 2: PERCORSI ZEN ---
    story.append(Paragraph("<b>2. I PERCORSI ZEN</b>", section_style))
    story.append(Paragraph("<b>Meditazioni e respirazioni guidate a portata di dito.</b>", subtitle_style))
    story.append(Paragraph(
        "Questa sezione raccoglie tutte le pratiche per prenderti cura del tuo benessere interiore:",
        body_style
    ))
    
    desc_meditate = (
        "• <b>Filtri a Pillola:</b> Cliccando su <b>ALL</b>, <b>MEDITAZIONI</b> o <b>RESPIRAZIONI</b> puoi filtrare istantaneamente la lista per trovare subito l'attività che desideri.<br/>"
        "• <b>Massima Trasparenza Japandi:</b> Come vedi nello screenshot, abbiamo reso l'intestazione e i filtri <b>completamente trasparenti</b>! Questo significa che non ci sono più brutte fasce piene, e puoi goderti il bellissimo gradiente di sfondo senza interruzioni.<br/>"
        "• <b>Pulsanti Fluttuanti:</b> Le schede scorrono in modo fluido fin sotto l'elegante barra di navigazione fluttuante ovale in basso, dandoti un senso di leggerezza visiva unico."
    )
    story.append(Paragraph(desc_meditate, body_style))
    story.append(Spacer(1, 15))
    
    if os.path.exists(s_meditate):
        story.append(Table([[Image(s_meditate, width=160, height=311)]], colWidths=[500], style=TableStyle([('ALIGN', (0,0), (-1,-1), 'CENTER')])))
        
    story.append(PageBreak())
    
    # --- PAGE 3: DIARIO ZEN ---
    story.append(Paragraph("<b>3. IL DIARIO ZEN</b>", section_style))
    story.append(Paragraph("<b>Uno spazio sicuro per annotare i tuoi pensieri.</b>", subtitle_style))
    story.append(Paragraph(
        "Fermarsi per scrivere è una delle pratiche di consapevolezza più potenti. Ecco come funziona il diario:",
        body_style
    ))
    
    desc_journal = (
        "• <b>Come ti senti? (Selettore dell'Umore):</b> Puoi indicare all'istante il tuo stato d'animo selezionando una delle quattro bellissime chip geometriche: <b>Peaceful</b> (Sereno), <b>Grateful</b> (Grato), <b>Quiet</b> (Tranquillo) o <b>Restless</b> (Agitato).<br/>"
        "• <b>Scrittura Libera:</b> Un ampio spazio pulito ti permette di digitare le tue riflessioni senza distrazioni.<br/>"
        "• <b>Privacy 100% Offline:</b> Tutte le tue parole vengono memorizzate esclusivamente sul tuo telefono e non vengono inviate su internet. I tuoi pensieri rimangono intimi e sicuri, solo per te."
    )
    story.append(Paragraph(desc_journal, body_style))
    story.append(Spacer(1, 15))
    
    if os.path.exists(s_journal):
        story.append(Table([[Image(s_journal, width=160, height=311)]], colWidths=[500], style=TableStyle([('ALIGN', (0,0), (-1,-1), 'CENTER')])))
        
    story.append(PageBreak())
    
    # --- PAGE 4: IL TUO PROFILO ("ME") ---
    story.append(Paragraph("<b>4. IL TUO PROFILO ('ME')</b>", section_style))
    story.append(Paragraph("<b>Tieni traccia del tuo cammino di consapevolezza.</b>", subtitle_style))
    story.append(Paragraph(
        "La scheda 'Me' è il tuo specchio personale per visualizzare quanto sei costante e motivarti ad andare avanti:",
        body_style
    ))
    
    desc_me = (
        "• <b>Statistiche Semplici:</b> Controlla a colpo d'occhio il numero di meditazioni completate, i minuti di respirazione effettuati e la tua costanza settimanale.<br/>"
        "• <b>Grafici Intuitivi:</b> Il tuo progresso è disegnato tramite grafici lineari e minimalisti Japandi, molto chiari da interpretare senza confusione.<br/>"
        "• <b>Cronologia delle Attività:</b> Sotto i grafici trovi la lista dettagliata delle sessioni passate, ideale per rivedere i tuoi traguardi personali."
    )
    story.append(Paragraph(desc_me, body_style))
    story.append(Spacer(1, 10))
    
    # 2 Screenshots for Profile
    me_elements = []
    if os.path.exists(s_me1):
        me_elements.append(Image(s_me1, width=150, height=291))
    if os.path.exists(s_me2):
        me_elements.append(Image(s_me2, width=150, height=291))
        
    if len(me_elements) == 2:
        t_me = Table([[me_elements[0], me_elements[1]]], colWidths=[240, 240])
        t_me.setStyle(TableStyle([('ALIGN', (0,0), (-1,-1), 'CENTER'), ('VALIGN', (0,0), (-1,-1), 'MIDDLE')]))
        story.append(t_me)
    elif len(me_elements) == 1:
        story.append(Table([[me_elements[0]]], colWidths=[500], style=TableStyle([('ALIGN', (0,0), (-1,-1), 'CENTER')])))
        
    story.append(PageBreak())
    
    # --- PAGE 5: IMPOSTAZIONI E VR ---
    story.append(Paragraph("<b>5. LE IMPOSTAZIONI ZEN & MODALITÀ VR</b>", section_style))
    story.append(Paragraph("<b>Personalizza l'audio e immergiti nella realtà virtuale 3D.</b>", subtitle_style))
    story.append(Paragraph(
        "Per rendere l'app adatta alle tue esigenze personali, puoi configurarla facilmente:",
        body_style
    ))
    
    desc_settings = (
        "• <b>Mixer Audio a Scorrimento:</b> Regola separatamente e con precisione il volume della <b>Musica</b> di sottofondo, degli <b>Effetti Sonori</b> della natura e della <b>Voce Guida</b> tramite cursori orizzontali facilissimi da trascinare.<br/>"
        "• <b>Scelta Lingua:</b> Passa da Italiano a Inglese con un semplice tocco.<br/>"
        "• <b>Modalità VR (Virtual Reality):</b> Questa opzione divide lo schermo a metà (come mostrato nel secondo screenshot). Inserendo il telefono in un visore 3D Cardboard economico, sarai trasportato all'interno del meraviglioso scenario 3D a sguardi di Guido per un relax assoluto!"
    )
    story.append(Paragraph(desc_settings, body_style))
    story.append(Spacer(1, 10))
    
    # 2 Screenshots for Settings
    settings_elements = []
    if os.path.exists(s_settings1):
        settings_elements.append(Image(s_settings1, width=150, height=291))
    if os.path.exists(s_settings2):
        settings_elements.append(Image(s_settings2, width=150, height=291))
        
    if len(settings_elements) == 2:
        t_settings = Table([[settings_elements[0], settings_elements[1]]], colWidths=[240, 240])
        t_settings.setStyle(TableStyle([('ALIGN', (0,0), (-1,-1), 'CENTER'), ('VALIGN', (0,0), (-1,-1), 'MIDDLE')]))
        story.append(t_settings)
    elif len(settings_elements) == 1:
        story.append(Table([[settings_elements[0]]], colWidths=[500], style=TableStyle([('ALIGN', (0,0), (-1,-1), 'CENTER')])))
        
    # Build Document
    doc.build(story)
    print(f"Explanatory PDF manual successfully created at: {output_path}")

if __name__ == "__main__":
    out_pdf = r"c:\Users\y.el.taher\Desktop\Yehia\Privato\CodePulse\Progetti\CP26-14 - Guido\2.Software\Guido\GuidoFlutter\guida_esplicativa_guido.pdf"
    create_explanatory_pdf(out_pdf)
