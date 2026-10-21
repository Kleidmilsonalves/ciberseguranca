#!/bin/bash
# prepara_s5.sh — Segurança Linux & Ops · Sessão 5
# Repõe os grupos e as contas da Sessão 4 (se faltarem) para o laboratório
# de permissões. Não altera contas que já existam. Executar com: sudo bash prepara_s5.sh

if [ "$(id -u)" -ne 0 ]; then
  echo "Este script tem de ser executado com sudo: sudo bash prepara_s5.sh"
  exit 1
fi

for g in rh ti financas; do
  getent group "$g" > /dev/null || { groupadd "$g"; echo "Grupo criado: $g"; }
done

criar() {   # criar CONTA "NOME COMPLETO" GRUPO
  if id "$1" > /dev/null 2>&1; then
    echo "Conta já existe: $1"
  else
    useradd -m -s /bin/bash -c "$2" "$1"
    echo "$1:CvTech#2026" | chpasswd
    echo "Conta criada: $1 (password do laboratório: CvTech#2026)"
  fi
  usermod -aG "$3" "$1"
}

criar alice "Alice Fortes" rh
criar bruno "Bruno Lima"   ti
criar carla "Carla Santos" financas
usermod -aG sudo bruno

echo
echo "Estado das contas da CVTECH:"
id alice
id bruno
id carla
