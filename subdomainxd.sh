#!/bin/bash

# --- RENK PALETİ ---
RED='\033[0;31m'
L_RED='\033[1;31m'
GREEN='\033[0;32m'
L_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# --- AÇILIŞ ANİMASYONU (MATRIX) ---
clear
echo -e "${GREEN}Sistem protokolleri yükleniyor..."
sleep 0.5
for i in {1..15}; do
    echo -e "${GREEN}$RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM${NC}"
    sleep 0.05
done
clear

# --- BANNER ---
echo -e "${L_RED}"
echo " ██╗  ██╗ █████╗ ██████╗  ██████╗  ██████╗ "
echo " ██║  ██║██╔══██╗██╔══██╗██╔════╝ ██╔═══██╗"
echo " ███████║███████║██████╔╝██║  ███╗██║   ██║"
echo " ██╔══██║██╔══██║██╔══██╗██║   ██║██║   ██║"
echo " ██║  ██║██║  ██║██║  ██║╚██████╔╝╚██████╔╝"
echo " ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ "
echo -e "      ${WHITE}>> SYSTEM SUBSCAN V3.5 - EFENDI HARGOS <<${NC}"
echo -e "${CYAN}--------------------------------------------------${NC}"

# Argüman kontrolü
if [ -z "$1" ]; then
    echo -ne "${YELLOW}[?] Hedef Domain Belirleyin: ${NC}"
    read TARGET
else
    TARGET=$1
fi

if [ -z "$TARGET" ]; then
    echo -e "${L_RED}[!] HATA: Hedef belirtilmedi. Sistem kapatılıyor.${NC}"
    exit 1
fi

echo -e "${CYAN}[*] Hedef:${WHITE} $TARGET"
echo -e "${CYAN}[*] Durum:${WHITE} Operasyon Başlatıldı..."
echo -e "${CYAN}--------------------------------------------------${NC}"
sleep 1

# Sabit listesi
BASES=("admin" "api" "dev" "test" "mail" "vpn" "git" "shop" "secure" "panel" "db" "server" "cloud" "portal")
FOUND=0

# --- FONKSİYONLAR ---
scan_sub() {
    local SUB=$1
    # -m 1: Max 1 saniye bekle, -o /dev/null: Çıktıyı gizle
    RESPONSE=$(curl -I -s -m 1 "$SUB" | head -n 1 | cut -d ' ' -f2)
    
    if [ ! -z "$RESPONSE" ]; then
        echo -e "\r${L_GREEN}[+] BULUNDU: ${WHITE}$SUB ${L_RED}[HTTP $RESPONSE]${NC}          "
        echo -e "\a" # Terminal bip sesi
        return 0
    fi
    return 1
}

# --- TARAMA SÜRECİ ---
echo -e "${YELLOW}[!] Brute-Force Taraması Aktif ediliyor...${NC}\n"

TOTAL_STEPS=$((${#BASES[@]} * 20 + 100))
CURRENT_STEP=0

# Aşama 1: Sözlük Taraması
for base in "${BASES[@]}"; do
    for i in $(seq 1 20); do
        SUB="${base}${i}.${TARGET}"
        
        # İlerleme Çubuğu (Yüzde hesaplama)
        CURRENT_STEP=$((CURRENT_STEP + 1))
        PERCENT=$((CURRENT_STEP * 100 / TOTAL_STEPS))
        printf "\r${BLUE}[${WHITE}%-20s${BLUE}] %d%%${NC}" $(printf "#%.0s" $(seq 1 $((PERCENT / 5)))) $PERCENT
        
        if scan_sub "$SUB"; then
            FOUND=$((FOUND+1))
        fi
    done
done

# Aşama 2: Hızlı Rastgele Tarama (Opsiyonel)
echo -e "\n\n${MAGENTA}[!] Derin Tarama Modu: Rastgele Üretim Başladı...${NC}"
for n in $(seq 1 100); do
    RAND=$(tr -dc 'a-z' < /dev/urandom | head -c 4)
    SUB="${RAND}.${TARGET}"
    
    if scan_sub "$SUB"; then
        FOUND=$((FOUND+1))
    fi
done

# --- FİNAL ---
echo -e "\n${CYAN}--------------------------------------------------${NC}"
if [ $FOUND -gt 0 ]; then
    echo -e "${L_GREEN}[✔] OPERASYON TAMAMLANDI EFENDI HARGOS.${NC}"
    echo -e "${WHITE}Toplam Aktif Subdomain: ${L_RED}$FOUND${NC}"
else
    echo -e "${YELLOW}[!] Operasyon bitti ama hiçbir açık kapı bulunamadı.${NC}"
fi
echo -e "${CYAN}--------------------------------------------------${NC}"