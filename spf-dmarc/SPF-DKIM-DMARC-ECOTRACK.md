# ECOTRACK — SPF / DKIM / DMARC
# Defense email pour alertes monitoring
# ETU2 — M1 Cyber-Reseaux INGETIS 2026
# ════════════════════════════════════════

## POURQUOI SPF/DKIM/DMARC ?

Les alertes ECOTRACK partent par email depuis Grafana et Alertmanager.
Sans SPF/DMARC :
- Les emails d'alerte finissent en spam
- Un attaquant peut usurper ecotrack.alerts@gmail.com
- Impossible de prouver l'authenticite des notifications

## 1. SPF — Qui peut envoyer en votre nom ?

### Enregistrement DNS TXT a creer :
  Hote : @
  Type : TXT
  Valeur : "v=spf1 include:_spf.google.com ~all"

### Explication :
  v=spf1                    = version SPF
  include:_spf.google.com   = autoriser Gmail/SMTP Google
  ~all                      = SoftFail pour les autres

### Verification :
  nslookup -type=TXT votre-domaine.fr
  # Outil en ligne : https://mxtoolbox.com/spf.aspx

## 2. DKIM — Signature cryptographique

### Avec Gmail (recommande pour ECOTRACK) :
  Google signe automatiquement les emails @gmail.com
  Aucune configuration DNS supplementaire necessaire

### Pour domaine propre :
  Hote : ecotrack._domainkey
  Type : TXT
  Valeur : "v=DKIM1; k=rsa; p=VOTRE_CLE_PUBLIQUE"

## 3. DMARC — Politique de rejet

### Phase 1 — Monitoring (commencer ici) :
  Hote : _dmarc
  Type : TXT
  Valeur : "v=DMARC1; p=none; rua=mailto:dmarc@votre-domaine.fr"

### Phase 2 — Quarantaine (apres 2 semaines) :
  Valeur : "v=DMARC1; p=quarantine; pct=100; rua=mailto:dmarc@votre-domaine.fr"

### Phase 3 — Rejet strict (production) :
  Valeur : "v=DMARC1; p=reject; pct=100; rua=mailto:dmarc@votre-domaine.fr"

## 4. APPLICATION ECOTRACK

### Configuration Grafana (config/grafana/provisioning) :
  GF_SMTP_ENABLED=true
  GF_SMTP_HOST=smtp.gmail.com:587
  GF_SMTP_USER=ecotrack.alerts@gmail.com
  GF_SMTP_PASSWORD=VOTRE_MOT_DE_PASSE_APPLICATION_GMAIL

### Obtenir un mot de passe application Gmail :
  1. Aller sur myaccount.google.com
  2. Securite → Validation en 2 etapes (activer)
  3. Securite → Mots de passe des applications
  4. Creer un mot de passe pour "ECOTRACK"
  5. Copier le mot de passe genere (16 caracteres)

## 5. VERIFICATION COMPLETE

  # Tester SPF
  nslookup -type=TXT gmail.com | grep spf

  # Outils en ligne
  https://mxtoolbox.com/emailhealth/
  https://www.mail-tester.com/
  https://dmarcian.com/dmarc-inspector/

  # Tester envoi depuis Grafana
  Grafana → Alerting → Contact points → Test

## RESUME POUR LA SOUTENANCE

SPF   : declare les serveurs autorises a envoyer
DKIM  : signe cryptographiquement chaque email
DMARC : definit la politique si SPF ou DKIM echoue

Sans ces 3 mecanismes, les alertes ECOTRACK peuvent :
- Etre usurpees par un attaquant (phishing)
- Etre bloquees par les filtres antispam
- Ne jamais arriver aux administrateurs

ECOTRACK — SPF/DKIM/DMARC | ETU2 | M1 Cyber-Reseaux INGETIS 2026
