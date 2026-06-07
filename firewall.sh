#!/bin/bash
# ─────────────────────────────────────────────
# ECOTRACK — Règles Firewall iptables
# Étudiant 1 — Sécurisation des réseaux Docker
# ─────────────────────────────────────────────

echo "🔥 Application des règles firewall ECOTRACK..."

# ── RESET — Vider toutes les règles existantes
iptables -F
iptables -X
iptables -Z

# ── POLITIQUE PAR DÉFAUT — Tout bloquer
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

echo "✅ Politique par défaut : DROP"

# ── RÈGLE 1 — Autoriser les connexions établies
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

echo "✅ Règle 1 : Connexions établies autorisées"

# ── RÈGLE 2 — Autoriser loopback (localhost)
iptables -A INPUT -i lo -j ACCEPT

echo "✅ Règle 2 : Loopback autorisé"

# ── RÈGLE 3 — Internet → DMZ : HTTPS (port 443)
iptables -A FORWARD -d 172.20.1.0/24 -p tcp --dport 443 -j ACCEPT

echo "✅ Règle 3 : HTTPS vers DMZ autorisé"

# ── RÈGLE 4 — Internet → DMZ : HTTP (port 80)
iptables -A FORWARD -d 172.20.1.0/24 -p tcp --dport 80 -j ACCEPT

echo "✅ Règle 4 : HTTP vers DMZ autorisé"

# ── RÈGLE 5 — Internet → DMZ : VPN (port 1194)
iptables -A FORWARD -d 172.20.1.0/24 -p udp --dport 1194 -j ACCEPT

echo "✅ Règle 5 : VPN OpenVPN vers DMZ autorisé"

# ── RÈGLE 6 — DMZ → Backend : API (port 3000)
iptables -A FORWARD -s 172.20.1.0/24 -d 172.20.2.0/24 -p tcp --dport 3000 -j ACCEPT

echo "✅ Règle 6 : DMZ → Backend API autorisé"

# ── RÈGLE 7 — DMZ → Backend : HTTP (port 80)
iptables -A FORWARD -s 172.20.1.0/24 -d 172.20.2.0/24 -p tcp --dport 80 -j ACCEPT

echo "✅ Règle 7 : DMZ → Backend HTTP autorisé"

# ── RÈGLE 8 — BLOQUER DMZ → Base de données directement
iptables -A FORWARD -s 172.20.1.0/24 -d 172.20.3.0/24 -j DROP

echo "✅ Règle 8 : DMZ → BDD BLOQUÉ"

# ── RÈGLE 9 — Backend → Base de données : PostgreSQL (port 5432)
iptables -A FORWARD -s 172.20.2.0/24 -d 172.20.3.0/24 -p tcp --dport 5432 -j ACCEPT

echo "✅ Règle 9 : Backend → PostgreSQL autorisé"

# ── RÈGLE 10 — Backend → Backend : Redis (port 6379)
iptables -A FORWARD -s 172.20.2.0/24 -d 172.20.2.0/24 -p tcp --dport 6379 -j ACCEPT

echo "✅ Règle 10 : Backend → Redis autorisé"

# ── RÈGLE 11 — IoT → Backend : API (port 3000)
iptables -A FORWARD -s 172.20.5.0/24 -d 172.20.2.0/24 -p tcp --dport 3000 -j ACCEPT

echo "✅ Règle 11 : IoT → API autorisé"

# ── RÈGLE 12 — BLOQUER IoT → Base de données directement
iptables -A FORWARD -s 172.20.5.0/24 -d 172.20.3.0/24 -j DROP

echo "✅ Règle 12 : IoT → BDD BLOQUÉ"

# ── RÈGLE 13 — BLOQUER IoT → Internet
iptables -A FORWARD -s 172.20.5.0/24 -d 0.0.0.0/0 -j DROP

echo "✅ Règle 13 : IoT → Internet BLOQUÉ"

# ── RÈGLE 14 — Monitoring → Tous : Prometheus scrape (port 9100)
iptables -A FORWARD -s 172.20.4.0/24 -p tcp --dport 9100 -j ACCEPT

echo "✅ Règle 14 : Monitoring → Prometheus scrape autorisé"

# ── RÈGLE 15 — Tous → Monitoring : Logs ELK (port 9200)
iptables -A FORWARD -d 172.20.4.0/24 -p tcp --dport 9200 -j ACCEPT

echo "✅ Règle 15 : Logs → ELK autorisé"

# ── AFFICHER LES RÈGLES APPLIQUÉES
echo ""
echo "📋 Règles firewall appliquées :"
iptables -L FORWARD --line-numbers -n

echo ""
echo "🎉 Firewall ECOTRACK configuré avec succès !"