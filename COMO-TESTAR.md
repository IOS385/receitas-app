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

---

## Checkpoint 1 — Task 15 · a casca do app

**Commit:** `91b9b25` · **APK:** 51,6 MB

Primeiro APK que vale abrir. As 14 tarefas anteriores não tinham tela.

**O que olhar:**

1. O app abre e mostra **quatro abas** embaixo: Hoje, Mês, Mercado, Receitas. Toque em cada uma — elas trocam.
2. O **tema Esmalte** está aplicado: fundo louça (cinza-azulado bem claro), cartões brancos.
3. As **fontes de verdade**. Isto é o que nenhum teste consegue verificar — o revisor do tema foi honesto sobre isso. Olhe se os títulos aparecem numa condensada alta e escura (Darker Grotesque) e o corpo numa humanista (Manrope). Se algum título parecer fino ou genérico, o eixo de peso da fonte variável não pegou, e eu quero saber.
4. Modo escuro: mude o tema do sistema Android. O app deve acompanhar.

**O que ainda NÃO funciona:** as quatro telas são placeholders com o nome escrito. A aba Hoje ganha conteúdo na Task 16.

**Se algo parecer errado na fonte ou na cor, me diz** — é a única coisa desta fase que teste automatizado não alcança.

---

## Checkpoint 2 — Task 16 · a tela Hoje

**Commit:** `08479c2` · **APK:** 53,4 MB

A aba Hoje ganhou conteúdo. É a tela que sua esposa vai abrir todo dia.

**O que olhar:**

1. **Os quatro horários** com o combo do dia, cada componente com a quantidade já escalada, e as calorias.
2. **As porções, que são o ponto da tela.** Se hoje for dia de semana: café da manhã **1**, almoço **1**, café da tarde **2**, jantar **2**. Confira se bate com a rotina dela.
3. **O espelho.** Café da tarde e jantar vêm **apagados** — sem a faixa marinho no topo do cartão, fundo recuado — com a linha *"repete o almoço, em dobro"*. **E listam os componentes com a quantidade dobrada:** o arroz aparece `120 g` no almoço e `240 g` no jantar.

   Essa parte mudou durante a execução. Meu plano original escondia os componentes no cartão espelhado, e um subagente provou que isso contradizia o próprio motivo de mostrar quantidade na tela. Se você achar que ficou pesado demais, é reversível numa linha — me diz.
4. **O cabeçalho:** dia grande, dia da semana, posição no ciclo, e o total de kcal do dia.

**O que ainda NÃO funciona:** o botão `Substituir` abre uma folha vazia (Task 17), e tocar numa refeição abre uma tela crua (Task 20). Mês, Mercado e Receitas seguem placeholder.

**Uma limitação que eu quero sua opinião:** só o café da manhã e o almoço têm botão `Substituir`. O jantar e o café da tarde não — eles seguem o que você trocar no slot base. O app *sabe* soltar o espelho (está testado), mas não oferece o botão. Faz sentido para vocês, ou ela vai querer trocar só o jantar algum dia?

---

## Checkpoint 3 — Task 17 · substituir refeição

**Commit:** `54a9f5f` · **APK:** 53,8 MB

**Este é o checkpoint mais importante da noite.** É a regra mais sutil do app, e ela só se prova na mão.

**Faça nesta ordem exata:**

1. `Substituir` no **almoço** → escolha outro combo. **O jantar tem que acompanhar.**
2. `Substituir` no **almoço** de novo → toque num componente (ex. a carne). Só aparecem opções da **mesma categoria** — outras proteínas, não arroz. Troque.
3. `Tirar do prato hoje` num componente → ele desaparece só daquele dia.
4. `Voltar ao plano original` → o dia volta ao ciclo e o espelho é restaurado.

**Se o passo 1 não arrastar o jantar, é bug de verdade** — é a regra da spec que eu passei a noite inteira testando.

**O que ainda NÃO funciona:** Mês, Mercado e Receitas seguem placeholder. Tocar numa refeição abre uma tela crua.

**Nota:** o jantar e o café da tarde não têm botão `Substituir` — eles seguem o slot base. Ver a pergunta no fim do Checkpoint 2.
