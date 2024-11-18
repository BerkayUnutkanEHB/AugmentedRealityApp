**AR Beeldherkenning App**  

### **Beschrijving**  
Dit project is een iOS-app die Augmented Reality (AR) combineert met beeldherkenning. De app maakt gebruik van ARKit en CoreML om objecten in de echte wereld te herkennen via de camera en hier interactieve AR-content aan toe te voegen. Daarnaast biedt de app drie opties: live beeldherkenning via de camera, beeldherkenning via een galerij, en het plaatsen van 3D-objecten in een AR-omgeving.  

---

### **Doel van de Opdracht**  
- Leren implementeren van ARKit voor augmented reality-ervaringen.  
- CoreML gebruiken om objecten te herkennen via getrainde machine learning-modellen.  
- Vision Framework toepassen voor het analyseren en verwerken van camerabeelden.  
- Gebruikers voorzien van interactieve AR-functionaliteiten, zoals het plaatsen van 3D-modellen.  
- Een intuïtieve en gebruiksvriendelijke interface ontwikkelen.  

---

### **Functionaliteiten**  

#### **Basisfunctionaliteiten**  
1. **Beeldherkenning via de camera**  
   - De app schakelt de camera in en herkent objecten in realtime met behulp van CoreML MobilenetV2.  
   - Labels van herkende objecten worden weergegeven.  

2. **Beeldherkenning via de galerij**  
   - Gebruikers kunnen een afbeelding uit hun galerij selecteren om objecten te laten herkennen.  
   - De app geeft een confidence-percentage weer als het model niet volledig zeker is.  

3. **3D-objecten plaatsen in AR**  
   - Gebruikers kunnen 3D-modellen van fruit (bijv. appels, bananen) in de AR-omgeving plaatsen.  
   - De modellen simuleren alsof ze op een tafel liggen.  

---

### **Installatie**  
Volg deze stappen om het project lokaal te installeren en te starten:  

1. **Kloon de repository**  
   ```bash  
   git clone https://github.com/BerkayUnutkanEHB/AugmentedRealityApp.git  
   cd 
   ```  

2. **Installeer afhankelijkheden**  
   - Open het project in Xcode.  
   - Voeg ARKit, Vision, en CoreML toe als frameworks. 

3. **CoreML-configuratie**  
   - Download en voeg het MobilenetV2-model toe aan het Xcode-project.  
   - Configureer het model in de app voor beeldherkenning.  

4. **Start de app in de simulator of op een fysiek apparaat**  
   - Klik op **Run** of gebruik `Cmd + R` in Xcode.  

---

### **Gebruik**  
- **Beeldherkenning via camera**: Kies de optie “Camera” op de homepagina en laat objecten in realtime herkennen. Houd een beetje afstand wanneer je naar een object wijst. 
- **Beeldherkenning via galerij**: Selecteer “Galerij” en upload een afbeelding om objecten te identificeren.  
- **3D-objecten plaatsen**: Gebruik de optie “3D” om virtuele fruitmodellen in de AR-omgeving te plaatsen.  

---
### **Bronnen** 

- **ChatGpt** : 3D-modellen toevoegen
- **Youtube** : https://youtu.be/tiMp_YRlU18?si=wnMc_H6Rn5gaSIyJ , CoreML toepassen in project.
- 

### **Licentie**  
Dit project is gelicentieerd onder de MIT-licentie.  
