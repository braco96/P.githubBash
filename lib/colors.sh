#!/bin/bash
VERDE='\033[1;32m'; ROJO='\033[1;31m'; AZUL='\033[1;34m'; NC='\033[0m'
print_info() { echo -e "${AZUL}[INFO]${NC} $1"; }
print_success() { echo -e "${VERDE}[OK]${NC} $1"; }
