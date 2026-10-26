#!/bin/bash
# verifica_s8.sh — Segurança Linux & Ops · Sessão 8 · Desafio Final
# Verifica o estado das 6 missões. Executar SEM sudo: bash verifica_s8.sh

D="$HOME/desafio_final"
R="$D/relatorio_final.txt"
chave() { printf 'C%s-%s' "$1" "$(printf 'missao%s-%s' "$1" "$(id -un)" | sha256sum | cut -c1-6 | tr 'a-f' 'A-F')"; }
tem() { [ -f "$R" ] && grep -q "$(chave "$1")" "$R"; }
ok=0
res() { if [ "$2" = "1" ]; then echo "  [OK]  Missão $1 — $3"; ok=$((ok + 1)); else echo "  [  ]  Missão $1 — $3"; fi; }

[ -d "$D" ] || { echo "Não encontro $D. Executa primeiro: bash setup_s8.sh"; exit 1; }
echo "===== Verificação do Desafio Final — $(id -un) ====="

m=0; tem 1 && m=1; res 1 "$m" "Explorar: chave da nota oculta no relatório final"
m=0; tem 2 && m=1; res 2 "$m" "Filtrar: chave da linha CRITICO no relatório final"

m=0; p=$(stat -c %a "$D/docs/relatorio_rh.txt" 2>/dev/null)
[ "$p" = "640" ] && tem 3 && m=1
res 3 "$m" "Permissões: relatorio_rh.txt com 640 (atual: ${p:-?}) e chave no relatório"

m=0
if getent group auditores > /dev/null && id auditor > /dev/null 2>&1; then
  id -nG auditor | grep -qw auditores && [ -d /home/auditor ] && \
  [ "$(getent passwd auditor | cut -d: -f7)" = "/bin/bash" ] && m=1
fi
res 4 "$m" "Contas: grupo auditores e conta auditor (pasta pessoal, bash, no grupo)"

m=0; vivo=$(ps aux | grep -c '[d]esafio_final/ferramentas/indexador')
[ "$vivo" -eq 0 ] && tem 5 && m=1
res 5 "$m" "Processos: indexador terminado com SIGTERM e chave no relatório"

m=0; [ -f "$D/cofre/restaurado/cofre_cvtech/chave.txt" ] && tem 6 && m=1
res 6 "$m" "Cofre: backup decifrado em cofre/restaurado e chave no relatório"

echo "Resultado: $ok/6 missões concluídas"
[ "$ok" -eq 6 ] && echo "Parabéns! Desafio final concluído."
