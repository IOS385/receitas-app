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

---

## ⚠️ Item de conteúdo para vocês decidirem

Descobri isto durante a execução, e não consertei de propósito — é decisão de conteúdo, não bug.

**22 dos 40 alimentos da semente carregam sufixo de estado:** `Arroz branco cozido`, `Patinho cru`, `Cebola crua`, `Alface americana crua`, `Ovo de galinha cru`, `Batata-doce crua`, e assim por diante.

Isso existe por um bom motivo: a tabela TACO lista "batata doce crua" e "batata doce cozida" como entradas **diferentes**, com valores nutricionais diferentes. O sufixo é o que dá rastreabilidade ao código TACO de cada alimento, e é o que faz a nutrição ser auditável.

**Mas esses nomes aparecem na lista de mercado.** Ou seja, a lista de compras dela vai dizer "Cebola crua" e "Patinho cru" — coisa que ninguém escreve num papel de mercado.

Consertar de verdade exige um campo separado de "nome de compra" no banco, além do nome nutricional. É mudança de estrutura, não de dado, e não quis fazer isso de madrugada sem vocês.

**Pergunta para ela:** incomoda? Se sim, eu acrescento o campo e ela vê "Cebola" na lista e "Cebola crua" só na receita. Se não incomoda, fica como está e economizamos uma migração.


---

## Checkpoint 4 — Tasks 18 e 19 · Mês e Mercado

**Commits:** `ebf4160` (Mês) e `ec0ac95` (Mercado) · **APK:** 55,1 MB

Duas telas de uma vez. Agora **três das quatro abas** têm conteúdo real.

### Aba Mês

1. A grade do mês, com o dia de hoje marcado por um ponto de brasa embaixo.
2. **Toque num sábado** → o resumo embaixo muda para *"2 porções o dia todo"*. Toque numa terça → volta para *"1 porção no café e no almoço"*. É a regra de porções aparecendo no calendário.
3. Volte para a aba **Hoje**: a data que você escolheu no Mês é a mesma. As duas telas compartilham a seleção.
4. Substitua algo num dia, volte ao Mês → aquele dia ganha **ponto de brasa no canto**, e o contador *"N neste mês"* sobe.
5. Folheie para outubro com a seta → 31 dias, e o resumo continua no dia que você escolheu.

### Aba Mercado

1. Abre em *"Esta semana"*, agrupada por seção **na ordem do percurso**: hortifrúti, açougue, padaria, laticínios, mercearia.
2. Quantidade convertida para unidade de compra: arroz em **kg**, ovo em **un**.
3. **Sal não aparece** — é "a gosto", e a spec decidiu que isso não entra na lista.
4. **Marque um item** → risca, apaga, e a barra de progresso anda. Marque de novo → desmarca.

   Este é o gesto que mais importa aqui. Meu plano original tinha um bug que fazia a marca **desaparecer** ao ser feita: o app regenerava a lista inteira a cada toque. Achei lendo o código antes de mandar implementar. Se a marca não ficar, me diz.
5. Troque para *"Este mês"* → a lista cresce. *"Escolher…"* abre o seletor de intervalo.

**Vale conferir se as quantidades fazem sentido para vocês** — é o primeiro momento em que dá para julgar se os números do conteúdo estão plausíveis. Lembre que a lista usa os nomes com sufixo ("Cebola crua") — ver a pergunta na seção anterior.

**O que ainda NÃO funciona:** a aba Receitas segue placeholder (Task 20), criar/editar receita (Task 21) e Ajustes (Task 22).
