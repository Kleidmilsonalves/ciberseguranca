# CVTECH Lda. - Proteção de Dados, Backup e Automação

**Responsável:** Kleidmilson Rui Dos Santos Alves 
**Data:** 25/10/2026  
**Módulo:** Segurança Linux & Ops (Sessão 7)  

---

## 📌 Visão Geral
Nesta sessão foi implementada uma solução automatizada de cópias de segurança (*backups*) para os documentos da pasta `/empresa` da CVTECH Lda. A solução combina compactação de dados, cifra simétrica e agendamento automático via *daemon* de tarefas do sistema (`cron`).

---

## 🛠️ Arquitetura da Solução de Backup

A solução cumpre três pilares fundamentais de proteção de dados:
1. **Compressão:** Redução do espaço em disco utilizando `tar` e `gzip` (`.tar.gz`).
2. **Cifra Simétrica:** Proteção do arquivo com o algoritmo `AES-256-CBC` via OpenSSL e chave guardada no ficheiro oculto e restrito `.backup_pass` (`chmod 600`).
3. **Automação:** Script em Bash com verificação de erros (`backup_cvtech.sh`) agendado na tabela do utilizador via `cron`.

---

## ⚙️ Operações Realizadas

1. **Gestão de Arquivos (`tar`/`gzip`):**
   - Criação de arquivo comprimido `empresa_manual.tar.gz`.
   - Inspeção do conteúdo sem extração (`tar -tzf`).
   - Restauro de teste em `/restauro` e validação de integridade com `diff -r`.

2. **Cifra e Segurança (`openssl`):**
   - Cifra do arquivo comprimido gerando o ficheiro `.tar.gz.enc`.
   - Validação da ilegibilidade dos dados (presença do cabeçalho `Salted__`).
   - Proteção das credenciais de automação em `~/.backup_pass` com permissões `600` (`-rw-------`).

3. **Automação e Agendamento (`cron`):**
   - Criação do script `backup_cvtech.sh` com tratamento de erros (validação de origem/password) e logs operacionais.
   - Teste de restauração direta via *pipeline* (`openssl | tar`).
   - Agendamento de testes no `crontab` e transição para o horário de produção (`30 2 * * *`).
   - Hardening da pasta de destino com permissões `700` (`chmod 700 ~/backups`).

---

## 📄 Ficheiros e Evidências Incluídos
- `sessao7_desafio1_tar.png`: Criação do arquivo `tar.gz`, medição de tamanho com `du`/`ls` e confirmação de cópia idêntica com `diff`.
- `sessao7_desafio2_openssl.png`: Validação da cifra (`Salted__`), tentativa negada pelo `tar` e teste de `bad decrypt`.
- `sessao7_desafio3_cron.png`: Listagem do `crontab -l` e verificação da criação automática de backups na pasta `~/backups`.
- `sessao7_desafio3_restauro.png`: Teste de restauração e leitura de conteúdo do backup automático cifrado via *pipeline*.
- `backup_cvtech.sh`: Script em Bash responsável pelo ciclo de vida do backup e registo no `backup.log`.

> ⚠️ **Nota de Segurança:** O ficheiro contendo a palavra-passe de cifra (`~/.backup_pass`) foi intencionalmente mantido fora deste repositório por razões de conformidade e boas práticas de segurança.
