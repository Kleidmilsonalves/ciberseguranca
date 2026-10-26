#!/bin/bash
# setup_s8.sh — Segurança Linux & Ops · Sessão 8 · Desafio Final
# Cria em ~/desafio_final o servidor simulado da CVTECH com as 6 missões.
# As chaves são calculadas a partir do teu nome de utilizador: são diferentes
# para cada formando. Executar SEM sudo: bash setup_s8.sh

D="$HOME/desafio_final"
if [ -d "$D" ]; then
  echo "A pasta $D já existe. Para recomeçar do zero: rm -ri $D"
  exit 1
fi

chave() { printf 'C%s-%s' "$1" "$(printf 'missao%s-%s' "$1" "$(id -un)" | sha256sum | cut -c1-6 | tr 'a-f' 'A-F')"; }

mkdir -p "$D"/arquivo/2026/{q1,q2,q3}/{rh,ti,financas} "$D"/{docs,logs,cofre,ferramentas}

# Missão 1 — Explorar: uma nota oculta algures no arquivo
for q in q1 q2 q3; do
  for d in rh ti financas; do
    printf 'Relatório %s — %s (dados fictícios)\n' "$q" "$d" > "$D/arquivo/2026/$q/$d/relatorio.txt"
  done
done
printf 'Nota do administrador anterior.\nMissão 1 concluída — chave: %s\n' "$(chave 1)" > "$D/arquivo/2026/q2/ti/.nota_do_administrador"

# Missão 2 — Filtrar: uma linha CRITICO no meio de 300 linhas de log
for i in $(seq 1 300); do
  case $((i % 7)) in
    0) t="ERRO falha de ligação ao serviço de email" ;;
    3) t="WARN disco a $((70 + i % 25))% de capacidade" ;;
    *) t="INFO verificação periódica concluída" ;;
  esac
  printf '2026-10-26 %02d:%02d:%02d %s\n' $((8 + i / 60)) $((i % 60)) $((i * 7 % 60)) "$t" >> "$D/logs/servidor.log"
  if [ "$i" -eq 187 ]; then
    printf '2026-10-26 11:07:42 CRITICO integridade do arquivo verificada — chave: %s\n' "$(chave 2)" >> "$D/logs/servidor.log"
  fi
done

# Missão 3 — Permissões: um relatório sem permissões nenhumas
printf 'Relatório confidencial de RH (dados fictícios)\nMissão 3 concluída — chave: %s\nPassword do cofre (Missão 6): Cofre#2026\n' "$(chave 3)" > "$D/docs/relatorio_rh.txt"
chmod 000 "$D/docs/relatorio_rh.txt"

# Missão 5 — Processos: um indexador com defeito que esgota o CPU
cat > "$D/ferramentas/indexador.sh" <<FIM
#!/bin/bash
# Indexador com defeito. Ao receber SIGTERM, regista a chave e termina de forma limpa.
trap 'echo "Indexador terminado corretamente — chave: $(chave 5)" >> "$D/logs/indexador.log"; exit 0' TERM
fim=\$((SECONDS + 10800))
while [ \$SECONDS -lt \$fim ]; do :; done
FIM
cat > "$D/ferramentas/reinicia_indexador.sh" <<FIM
#!/bin/bash
# Volta a lançar o indexador (usar se o terminaste com kill -9).
nohup "$D/ferramentas/indexador.sh" > /dev/null 2>&1 &
echo "Indexador lançado de novo."
FIM
chmod u+x "$D"/ferramentas/*.sh
nohup "$D/ferramentas/indexador.sh" > /dev/null 2>&1 &

# Missão 6 — Cofre: backup cifrado com a chave final
T=$(mktemp -d)
mkdir -p "$T/cofre_cvtech"
printf 'Cofre aberto com sucesso.\nMissão 6 concluída — chave: %s\n' "$(chave 6)" > "$T/cofre_cvtech/chave.txt"
tar -czf "$T/cofre.tar.gz" -C "$T" cofre_cvtech
openssl enc -aes-256-cbc -salt -pbkdf2 -in "$T/cofre.tar.gz" -out "$D/cofre/cofre.tar.gz.enc" -pass pass:'Cofre#2026'
rm -rf "$T"

echo "Desafio final pronto em $D"
echo "Lê o enunciado e começa pela Missão 1. Boa sorte!"
