# CVTECH Lda. - Pastas Departamentais e Políticas de Acesso

**Responsável:** <Kleidmilson Rui Dos Santos Alves> 
**Data:** <21/10/2026>  
**Módulo:** Segurança Linux & Ops (Sessão 5)  

---

## 📌 Visão Geral
Nesta sessão foi configurada a estrutura de pastas departamentais do servidor de ficheiros da CVTECH Lda. em `/srv/cvtech`, aplicando o modelo de permissões Linux (notação octal e simbólica), segregação de acessos por grupos e políticas de hardening de contas/passwords com o utilitário `chage`.

---

## 📁 Estrutura de Pastas e Permissões Configuradas

| Diretório | Dono:Grupo | Permissões (Octal) | Acesso Permitido |
| :--- | :--- | :--- | :--- |
| `/srv/cvtech/rh` | `root:rh` | `770` (`drwxrwx---`) | Apenas membros do grupo `rh` (`alice`) |
| `/srv/cvtech/ti` | `bruno:ti` | `770` (`drwxrwx---`) | Apenas membros do grupo `ti` (`bruno`) |
| `/srv/cvtech/financas` | `root:financas` | `770` (`drwxrwx---`) | Apenas membros do grupo `financas` (`carla`) |
| `/srv/cvtech/publico` | `root:root` | `755` (`drwxr-xr-x`) | Todos podem ler; apenas `root` pode escrever |

---

## ⚙️ Operações Realizadas

1. **Criação da Hierarquia:** Pastas departamentais criadas em `/srv/cvtech/`.
2. **Atribuição de Donos e Grupos:** Definidos grupos departamentais com `chgrp` e dono `bruno` na pasta `/srv/cvtech/ti` via `chown`.
3. **Aplicação de Permissões:** 
   - Restrição `770` aplicada às pastas privadas de RH, TI e Finanças.
   - Permissão `755` aplicada à pasta pública.
4. **Proteção de Documento Confidencial:** Criado o ficheiro `confidencial.txt` em `rh/` e ajustado para permissões `640` (`-rw-r-----`) com grupo `rh`.
5. **Validação de Acessos Cruzados:** Testados os acessos entre utilizadores com `sudo -u`, confirmando o bloqueio de acessos não autorizados.
6. **Hardening de Passwords (`chage`):**
   - Aplicada política à utilizadora `carla`: validade máxima de 90 dias (`-M 90`), aviso 7 dias antes (`-W 7`) e inatividade de 30 dias (`-I 30`).
   - Forçada a alteração de password no próximo login com `chage -d 0`.
   - Testado bloqueio (`passwd -l`) e desbloqueio (`passwd -u`) de contas.

---

## 📄 Ficheiros e Evidências Incluídos
- `sessao5_desafio1_leitura.png`: Leitura de permissões de `/etc/passwd` e `/etc/shadow` e criação inicial das pastas.
- `sessao5_desafio2_acessos.png`: Aplicação de permissões `770`/`755` e testes de acessos cruzados com `sudo -u`.
- `sessao5_desafio3_politica.png`: Verificação da política de expiração com `chage -l` e estado de conta com `passwd -S`.
- `auditoria_acessos.txt`: Relatório completo gerado no Desafio 3.
