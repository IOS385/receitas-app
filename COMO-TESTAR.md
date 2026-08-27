# Como testar o app — roteiro por checkpoint

Isac, este arquivo acumula o que olhar em cada APK que eu buildei durante a noite.
Cada seção corresponde a uma tarefa visual concluída.

**O APK fica sempre no mesmo lugar**, sobrescrito a cada build:

```
build/app/outputs/flutter-apk/app-release.apk
```

Assinado com a keystore nova e dedicada (`~/chaves/refeicoes.jks`, alias `refeicoes`,
senha `refeicoes2026`) — **não** a do `financas-app-mobile`.

Se quiser testar um checkpoint intermediário em vez do último, o commit de cada um está
listado abaixo; dá para voltar com `git checkout <hash>` e rodar
`flutter build apk --release`.

---

## Antes de começar

O app abre com **4 dias de ciclo**, não 33. A semente completa é o **Plano 2**, e ela
depende de uma coisa: **sua esposa revisar esses 4 dias primeiro.** Se o jeito dela de
medir arroz ou temperar carne for diferente do meu chute, é mais barato descobrir em
24 receitas do que em 182.

Uma consequência prática disso: navegar para o **dia 5 do ciclo** vai dar erro, porque
não existe conteúdo lá. Nos testes eu configurei `tamanho_ciclo = 4`; no app real ele
está em 33, então datas fora das 4 primeiras posições não têm combo. **Isso é
esperado nesta fase**, não é bug para reportar.

---

## O que já está pronto e testado (sem tela)

Fases A e B — 136 testes automatizados, `flutter analyze` limpo. Nada disso tem
interface ainda, mas é o que faz as telas funcionarem:

- Posição no ciclo de 33 dias, incluindo navegação para datas passadas
- O espelho: café da tarde repete o da manhã, jantar repete o almoço
- Porções por dia da semana (1 no café e almoço de dia útil, 2 no resto)
- Escalonamento de quantidade com arredondamento para cima em unidade discreta
- Nutrição calculada por ingrediente pela tabela TACO
- Substituição em dois níveis, com a regra do espelho
- Agregação da lista de mercado por intervalo, agrupada por seção
- Banco SQLite com 13 tabelas, semente idempotente, backup

---

## Checkpoints

*(As seções abaixo vão sendo preenchidas conforme cada tarefa visual fecha.)*
