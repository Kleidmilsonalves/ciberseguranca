# CVTECH Lda. - Processos e Monitorização de Sistemas (Diagnóstico Sob Pressão)

**Responsável:** Kleidmilson Rui Dos Santos Alves  
**Data:** 25/10/2026 
**Módulo:** Segurança Linux & Ops (Sessão 6)  

---

## 📌 Visão Geral
Nesta sessão foi simulação uma situação de emergência operacional no servidor da CVTECH Lda., onde processos descontrolados causavam consumo excessivo de CPU. Foram aplicadas técnicas de monitorização de sistema em tempo real, gestão de trabalhos em segundo plano (*jobs*), interrupção graciosa e forçada de processos e auditoria de registos de sistema e *sudo*.

---

## ⚙️ Operações Realizadas

1. **Monitorização de Sistema:**
   - Inspeção de processos com `ps aux` (ordenação por uso de CPU/memória) e `ps u`.
   - Monitorização dinâmica com `top` e `htop`, avaliando métricas de *Load Average*.

2. **Controlo de Trabalhos (*Jobs*):**
   - Lançamento de processos em *background* com `&`.
   - Alternância entre *foreground* e *background* com `fg`, `bg` e suspensão via `Ctrl+Z` (sinal `SIGTSTP`).
   - Terminação direcionada de *jobs* com `kill %ID`.

3. **Resolução de Incidente Operacional:**
   - Identificação do processo culpado (`cvtech-sync.sh`) com consumo próximo de 100% de CPU.
   - Encerramento limpo do processo culpado usando o sinal `SIGTERM` (`kill PID`), validando a normalização da CPU em tempo real via `tail -f`.
   - Identificação e eliminação de processo resistente (`cvtech-relatorio.sh`) com o sinal estrito `SIGKILL` (`kill -9 PID`).

4. **Auditoria e Logs:**
   - Inspeção do registo de comandos executados com privilégios de administração via `auth.log` / `journalctl _COMM=sudo`.
   - Extração de estatísticas e métricas de erros do monitor (`servidor.log`).
   - Redação do relatório do incidente com cronologia e recomendações técnicas.

---

## 📄 Ficheiros e Evidências Incluídos
- `sessao6_desafio1_jobs.png`: Sequência de comandos de controlo de *jobs* (`&`, `jobs`, `fg`, `Ctrl+Z`, `bg` e `kill %1`).
- `sessao6_desafio2_diagnostico.png`: Identificação do processo culpado no topo do consumo de CPU via `ps aux --sort=-%cpu`.
- `sessao6_desafio2_log.png`: Acompanhamento do log em tempo real via `tail -f` a confirmar a linha "CPU normalizada".
- `sessao6_desafio3_logs.png`: Rasto de auditoria do `sudo` consultado via `journalctl` / `auth.log`.
- `relatorio_incidente.txt`: Relatório técnico completo do incidente com cronologia, processos ativos e recomendações.
