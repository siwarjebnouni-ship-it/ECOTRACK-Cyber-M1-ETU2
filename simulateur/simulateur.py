import requests
import random
import time
from datetime import datetime

API_URL = "http://eco-api:3000/api/sensors/data"

ZONES = [
    "Centre-Ville", "Bellecour", "Part-Dieu", "Confluence",
    "Vieux-Lyon", "Croix-Rousse", "Gerland", "Monplaisir",
    "Bron", "Villeurbanne", "Caluire", "Vénissieux"
]

def generer_capteur(capteur_id):
    return {
        "container_id": f"ECO-{capteur_id:04d}",
        "fill_level": random.randint(0, 100),
        "temperature": round(random.uniform(5, 45), 1),
        "battery": random.randint(20, 100),
        "zone": random.choice(ZONES),
        "timestamp": datetime.now().isoformat(),
        "lat": round(random.uniform(45.72, 45.80), 6),
        "lng": round(random.uniform(4.80, 4.90), 6)
    }

def envoyer_donnees(capteur_id):
    data = generer_capteur(capteur_id)
    try:
        response = requests.post(API_URL, json=data, timeout=5)
        if response.status_code == 200:
            print(f"✅ Capteur {data['container_id']} — {data['fill_level']}% plein")
        else:
            print(f"⚠️  Capteur {data['container_id']} — Erreur {response.status_code}")
    except Exception as e:
        print(f"❌ Capteur {data['container_id']} — {str(e)}")

def main():
    print("🚀 Démarrage simulateur ECOTRACK IoT")
    print("📡 2000 capteurs actifs")
    print("─" * 50)
    cycle = 1
    while True:
        print(f"\n📊 Cycle {cycle} — {datetime.now().strftime('%H:%M:%S')}")
        for capteur_id in range(1, 2001):
            envoyer_donnees(capteur_id)
            time.sleep(0.01)
        print(f"\n⏳ Prochain envoi dans 15 minutes...")
        time.sleep(900)
        cycle += 1

if __name__ == "__main__":
    main()