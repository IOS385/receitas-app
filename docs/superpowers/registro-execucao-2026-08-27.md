# Registro de execução — 23 tarefas, 2026-08-26/27

Ledger da execução por subagente: 59 decisões tomadas em nome do Isac, cada uma com o
custo caso esteja errada. Preservado do workspace `.superpowers/sdd/` (git-ignored) para
o histórico não perder o porquê das escolhas.

# SDD ledger — plan: docs/superpowers/plans/2026-08-26-app-refeicoes.md

Spec: `docs/superpowers/specs/2026-08-26-app-refeicoes-design.md` (lida — é a autoridade)
Branch: `feat/mvp-refeicoes` (a partir de `main` @ 0db44ae)
Workspace: `.superpowers/sdd/2026-08-26-app-refeicoes/`

## Setup

Ruling: `git init` + identidade + branch subiram para o setup — `git init` — o repo não
existia, e os scripts de workspace (`sdd-workspace`, `task-brief`, `review-package`)
exigem repo-root. A Task 1 Step 10 fica sendo só o commit, sem o `git init`. Custo se
errado: nenhum — o commit da Task 1 acontece igual.

Ruling: identidade git **pessoal** (`IOS385` / `isacoliveira374@gmail.com`), por repo,
nunca global — app da esposa, projeto pessoal, conforme `~/obsidian` →
`identidade-git-por-repo`. Custo se errado: reescrever autor de commits locais, trivial.

Ruling: trabalho em branch `feat/mvp-refeicoes`, não em `main`. Custo se errado: nenhum.

## Fatos do ambiente verificados antes de dispatchar

Flutter 3.44.1 · Dart 3.12.1 · Android SDK 36.0.0 · **sem emulador** · **sem Visual
Studio** · Java 8 no PATH (Gradle vai precisar de `flutter config --jdk-dir`).
Verificação automática = `flutter analyze` + `flutter test` + `flutter build apk`.

Datas que 5 tarefas assumem, todas conferidas por cálculo:

| Fato | Assumido por | Confere |
|---|---|---|
| 2026-09-01 = terça (coluna 2) | T18 `primeiroDiaDaSemana` | ✓ |
| 2026-09-04 = **sexta** | T5, T12, T16, T17 | ✓ |
| 2026-09-05 = sábado | T5, T12, T16, T18 | ✓ |
| setembro/2026 = 30 dias | T18 | ✓ |
| ciclo 33 de 09-01: 09-04→4, 10-03→33, 10-04→1, 08-31→33, 08-30→32 | T3 | ✓ |
| 2028-02-28 +2d → pos 3 (bissexto) | T3 | ✓ |
| `semanaDe(sexta 09-04)` → 08-31..09-06 | T19 | ✓ |
| `semanaDe(domingo 09-06)` → 08-31..09-06 | T19 | ✓ |

## Varredura de conflitos (pré-flight)

### Pares que compartilham arquivo ou interface

| Produz | Consome | Interface | Achado |
|---|---|---|---|
| T2 `modelos.dart` | T3–T10, T12, T14, T19, T20 | enums, `DataPura`, `Nutrientes`, `unidadesDiscretas/SemMedida` | limpo |
| T4 `espelho.dart` | T8, T16, T17 | `slotBase`, `tipoDoSlot`, `ehEspelhado` | limpo |
| T5 `porcoes.dart` | T11, T12, T18 | `regrasPadrao`, `ehDiaUtil`, `porcoesDoSlot` | limpo — T11 semeia `regrasPadrao`, T12 lê do banco com fallback |
| T6 `escalonamento.dart` | T12 | `escalarQuantidade` | limpo |
| T7 `nutricao.dart` | T9, T12, T20, T21 | `emGramas`, `nutrienteDe`, `ConversaoAusente` | limpo |
| T8 `resolucao.dart` | T12 | `resolverRefeicao` (8 params nomeados) | limpo — T12 passa todos os 8 |
| T9 `mercado.dart` | T12, T19 | `agregarMercado`, `formatarCompra`, `ordemSecoes`, `LinhaIngrediente` | limpo |
| T10 `app_database.dart` | T11–T13, T19–T22 | 13 tabelas + companions | limpo |
| T11 `semente.dart` | T12, T13, T15 (`util_teste`) | `carregarSemente(db, lerAsset:, versao:)` | limpo |
| T12 repos + `database_provider` | T15–T22 | 4 repos + 6 providers | limpo |
| T14 tema | T15–T22 | `temaClaro/Escuro`, `CoresEsmalte`, `CampoRespingo`, `context.esmalte` | limpo |
| T15 `format.dart` | T16 (+`ehEspelhadoSlot`), T18 (+`ehDiaUtilData`), T17, T19–T22 | append sequencial no mesmo arquivo | limpo — appends não colidem |
| T15 `CartaoEsmalte`, `util_teste` | T16–T22 | `apagado`, `onTap`; `envolver(db:, overrides:, brilho:)` | limpo |
| T16 `hoje_provider` | T17, T18, T21, T22 | `dataSelecionadaProvider`, `diaProvider` | limpo |
| T16 → T17 | `abrirSubstituir(context:, data:, refeicao:)` | T16 cria tronco, T17 substitui — **assinatura idêntica nos dois** | limpo |
| T16 → T20 | `ReceitaScreen(receitaId:)` | tronco em T16, real em T20 | limpo |
| T16 → T22 | `AjustesScreen()` | tronco em T16, real em T22 | limpo |
| T15 → T16/18/19/20 | 4 telas-tronco | declarado explicitamente na T15 Step 8 | limpo |
| T20 → T21 | `ReceitaFormScreen({receitaId})` | tronco em T20, real em T21 | limpo |
| T20 `receitas_provider` | T21 | `detalheProvider`, `catalogoProvider`, `IngredienteNaTela` | limpo |
| T22 → `app.dart` (T15) | `themeMode` + `temaModoProvider` | T22 edita `app.dart` criado na T15 | limpo |
| T1 assinatura | T15–T22 checkpoints, T23 | `key.properties`, `signingConfigs` | limpo após a emenda de hoje |

### Auto-consistência de cada tarefa

Tasks 1–12, 14–16, 18–20, 22, 23: texto concorda consigo mesmo — os testes que
especifica batem com o código que especifica, e os arquivos que cria batem com os que
depois toca. Sem achado.

Tasks com achado:

| Task | Achado |
|---|---|
| **T13** | `_variavel` usa `Uint8List` sem `import 'dart:typed_data'`. `package:drift/drift.dart` reexporta, mas depender de reexport é frágil. → **Ruling R3** |
| **T17** | Teste `escolher outro combo grava o override` tem `await` dentro de closure síncrona de `firstWhere` — **não compila**. → **Ruling R2** |
| **T11** | `conversoes.json` traz `concha`, que não existe no enum `Unidade`. O próprio plano manda apagar a linha. Sem ruling — instrução já está no texto. |
| **T21** | `FutureBuilder(future: _carregar())` cria Future nova a cada build; o guard `_carregado` limita, mas é padrão ruim. **Não é conflito de plano** — deixo o revisor levantar naturalmente, sem pré-julgar. |

### Rulings do pré-flight

Ruling R2: o teste da T17 `escolher outro combo grava o override` tem `await` dentro de
closure síncrona (`firstWhere`) — erro de compilação. Hoistar o `await plano.dia(sexta)`
para uma variável antes do `firstWhere`. O plano é o argumento, a spec é a autoridade, e
a spec só exige que a troca no almoço arraste o jantar — a forma do teste é minha.
Custo se errado: nenhum; o teste continua provando a mesma regra.

Ruling R3: acrescentar `import 'dart:typed_data';` em `lib/data/backup.dart`. O
reexport do drift funciona hoje e pode sumir numa minor. Custo se errado: um import a
mais, zero risco.

Ruling R4: as Tasks 1–14 não param para checkpoint de APK (1–13 não têm tela; 14 é tema
sem casca). Primeiro APK que vale abrir é o da T15. A T1 builda só para provar a cadeia
e desarmar o problema do Java 8. Custo se errado: o Isac espera 14 tarefas pelo
primeiro APK visual — mitigado por avisá-lo disso já no início.

---

## Progresso

### Task 1 — NEEDS_CONTEXT (rodada 1), rulings

Ruling R5: `drift_dev: ^2.34.5` → `^2.34.0` e `build_runner: ^2.16.0` → `^2.15.1` no
pubspec, e o plano corrigido junto. Motivo: `flutter_test` do SDK 3.44.1 fixa
`meta: 1.18.0` **exato**; `drift_dev >=2.34.1` e `build_runner >=2.15.2` puxam
`analyzer >=13.3.0` que exige `meta ^1.18.3` — insatisfazível. Verifiquei eu mesmo:
o subagente disse que relaxar só o `drift_dev` resolvia — **não resolve**, o
`build_runner` bloqueia sozinho (saída do pub confirmando no relatório). Os dois valores
escolhidos são os que o `financas-app-mobile` já usa (prior-art). Resolvido de fato:
`analyzer 12.1.0`, `meta 1.18.0`, com `drift 2.34.3` e `flutter_riverpod 3.4.2`
INTACTOS — o recuo é só ferramenta de codegen, dev-only.
Custo se errado: codegen do drift roda numa versão 5 patches atrás; se faltar algum fix
de gerador, sobe quando o Flutter destravar o `meta`.

Ruling R6: criar keystore **nova e dedicada** (`refeicoes.jks`), não reaproveitar a
`financas-release.jks` que o subagente achou em `financas-app-mobile/android/app/`.
Motivo: apps não relacionados não devem compartilhar chave de assinatura — vazamento ou
perda de uma não deve contaminar a outra, e a chave do app de finanças dele não deveria
assinar o app da esposa. Senha `refeicoes2026` (APK doméstico, sem loja).
Custo se errado: nenhum tecnicamente; se ele preferisse chave única, é gerar de novo e
reinstalar o app (não há usuário instalado ainda).

Ruling R7: o subagente afirmou que `flutter_riverpod 3.4.2` também colidia. Verifiquei:
**não colide** — resolveu em 3.4.2 sem tocar. Mantido no valor do brief.
Custo se errado: nenhum, é fato verificado.

Verificação independente do controlador (não confiei no relatório):
- `git log --all` → **0** arquivos sensíveis rastreados em qualquer commit
- `.gitignore:48-50` cobre `android/key.properties`, `*.jks`, `*.keystore`; `git check-ignore` confirma
- permissão `INTERNET` existe só em `android/app/src/{debug,profile}/AndroidManifest.xml` —
  necessária para hot reload/DevTools, **ausente** no `src/main/` de produção. Correto.
- APK release buildou sem precisar de `--jdk-dir` (Java 8 no PATH não atrapalhou).

Ruling R8: Tasks 3–7 vão em **um dispatch batelado**, não cinco. São cinco arquivos
pequenos de Dart puro (`ciclo`, `espelho`, `porcoes`, `escalonamento`, `nutricao`), mesma
forma, código completo no plano, **sem dependência entre si** — só de `modelos.dart` da
T2. Uma superfície de revisão coerente ("funções puras do domínio") em vez de cinco
ciclos de dispatch+revisão para ~30 linhas cada. Tasks 2, 8 e 9 seguem sozinhas: a 2 é a
fundação de tipos que todas consomem, a 8 é o coração (17 testes, a regra ambígua da
spec 6.3), a 9 tem lógica própria de agregação.
Custo se errado: se a revisão do lote reprovar, o fix round cobre cinco arquivos em vez
de um — ainda mais barato que cinco revisões separadas.

Task 1: revisão rodada 1 — spec ✅, 1 Important (teste de trilhos com match literal de
substring: `import "..."` com aspas duplas e `export` passam batido; `prefer_single_quotes`
não está no lint, então nada força a convenção que o teste assume).

Ruling R9 (achado mandado-pelo-plano): **consertar**, apesar de o código ter vindo verbatim
do brief Step 4. A Global Constraint da spec é *"lib/domain não importa flutter nem drift"*
— a forma do teste é meio, não fim. Guarda-corpo que passa vacuamente é pior que nenhum:
dá confiança falsa por 22 tarefas. Conserto: regex tolerante a `import`/`export` e a aspas
simples ou duplas. **Não** adicionar `prefer_single_quotes` ao lint — com a regex, estilo de
aspas fica irrelevante; resolver no teste e não na convenção.
Exigi prova de que o guarda-corpo tem dente: criar violação temporária com aspas duplas,
ver falhar, trocar por `export`, ver falhar, apagar.
Custo se errado: nenhum — teste mais estrito não quebra código correto.

Task 1: fix round 1/5 despachado (1 achado). Implementador reportou DONE em `129c057`,
com a prova exigida: duas falhas provocadas de propósito (import aspas duplas de
`package:flutter/`; export aspas simples de `package:drift/`), ambas nomeando o arquivo
violador, mais checagem extra de `package:http/` com aspas duplas. Violação temporária e
pasta `lib/domain/` vazia apagadas depois. `flutter test` e `flutter analyze` limpos.
Nota do implementador que vale vigiar na re-revisão: a 1ª tentativa colapsou `\s` num
`\s` inválido em string não-raw do Dart; resolveu com concatenação de strings raw.
Re-revisão escopada despachada sobre `77d9eed..129c057` (1 arquivo, 15 inserções).

Task 1: fix round 1/5 (1 endereçado, 0 aberto — regex de trilhos tolera import/export e
aspas simples/duplas; re-revisor validou 5 padrões positivos e 3 negativos por conta
própria, e confirmou que as raw strings evitam o colapso de `\s`; nenhuma quebra nova;
commits 77d9eed..129c057)
Task 1: complete (commits 0db44ae..129c057, review clean)

Ruling R10: Task 2 vai no modelo mais barato (haiku). O plano traz o código completo de
implementação E de teste — é transcrição mais execução, que é exatamente o caso em que a
orientação de seleção de modelo manda usar o tier mais barato. Risco conhecido:
`extension type const DataPura(String iso)` é sintaxe Dart 3.3+ e pouco comum, então
avisei explicitamente no dispatch. Uso esta tarefa como sonda: se o tier barato tropeçar
aqui, subo o lote 3–7 para sonnet.
Custo se errado: um fix round a mais numa tarefa de 2 arquivos, ou re-dispatch em tier
acima — barato, e a informação vale para as 20 tarefas seguintes.

Task 2: implementada em `75b8998` (haiku, 14 tool uses, 131s). 11/11 testes verdes
(9 novos + 2 de trilhos), analyze limpo. Ruling R10 confirmado: o tier barato deu conta
da transcrição, `extension type` incluído — **lote 3–7 vai no mesmo tier**.

Verificação independente do controlador (executei código, não li asserção):
- `DataPura.de(DateTime(2026,9,4,23,59)).iso` → `2026-09-04` (zero à esquerda OK)
- `comoDateTime.isUtc` → **true** — é o que a T3 depende para o cálculo de ciclo não
  ser envenenado por fuso
- hora descartada (`dia=4`); dois horários do mesmo dia **iguais**
- `DataPura('2026-10-03').comoDateTime.difference(DataPura('2026-09-01')...).inDays` → **32**,
  que dá posição 33 no ciclo de 33 — casa com a tabela de fatos do pré-flight
- `grep` confirma **zero imports** em `lib/domain/modelos.dart`
Teste descartável apagado depois (`test/_check_tmp.dart`).

Task 2: revisão rodada 1 — spec ✅ (byte-idêntico ao brief), qualidade **Aprovado**,
0 Critical, 0 Important, 1 Minor informativo (`library;`), 1 item ⚠️ não verificável.

Revisor fez uma verificação que vale registrar: comprovou empiricamente que
`extension type` **encaminha `==`/`hashCode` não sobrescritos para o tipo de
representação** (aqui `String.==`, estrutural). Logo o teste `cedo == tarde` do brief
tem dente de verdade — se `DataPura.de` capturasse hora, as strings ISO divergiriam e o
teste falharia. Não é teste de identidade vácuo.

⚠️ resolvido por mim (o revisor foi bloqueado pelo classificador de permissões antes de
conseguir rodar): removi `library;` temporariamente e rodei
`flutter analyze lib/domain/modelos.dart` →
`info - Dangling library doc comment ... dangling_library_doc_comments — 1 issue found`.
Restaurei → `No issues found!`. **`library;` é obrigatório**, não enfeite: sem ele a
Global Constraint "analyze limpo" quebra. O furo era do MEU plano, não do implementador.
Corrigi o bloco de código do plano (Task 2 Step 3) para incluir `library;`.
Verifiquei que o problema é isolado a `modelos.dart`: os outros 6 arquivos de domínio do
plano começam com `import`, não com doc comment solto, então não reincidem.
Minor descartado como não-achado — era comportamento correto e exigido.

Task 2: complete (commits 129c057..75b8998, review clean)

Tasks 3–7 (lote): DONE em 5 commits — 84189d9 (ciclo), 0f5ebf1 (espelho), 826fdb2
(porcoes), 4691672 (escalonamento), 5355efb (nutricao). Haiku, 38 tool uses, 275s.

Verificação independente do controlador — o relatório do lote tinha DOIS números errados:
disse `modelos_test.dart: 8` (é **9**) e total `50` (é **49**). Fui checar se um teste
tinha desaparecido: `git diff --quiet 75b8998 HEAD -- test/modelos_test.dart` → **INTACTO**,
e `flutter test` → **+49 All tests passed**. Nada perdido; só aritmética descuidada no
relato.
Sinal registrado: relatório de tier barato não serve como fonte de contagem — verificar
sempre por comando. Não invalida o código, que está correto.

Tasks 3–7: revisão rodada 1 — spec ✅ nas cinco, 1 **Critical**, 1 Minor. Revisão de alta
qualidade; verifiquei as duas alegações rodando Dart em vez de aceitar.

**Critical confirmado (ponto flutuante).** `escalonamento.dart:19` calcula
`quantidade * (porcoes / rendimento)` — a razão primeiro. Erro de ponto flutuante empurra
resultado exato acima da fronteira inteira e o `ceil()` erra por 1. Reproduzi os 3 casos
do revisor exatamente (21×9/7 → 27.000000000000004 → 28). Varredura minha em q,p,r ≤ 50,
só casos de resultado inteiro exato: **165 erros** na ordem atual, **0** na proposta.

Ruling R11: consertar (`quantidade * porcoes / rendimento`), sem epsilon. Transparência
que o revisor não checou e eu checei: nos valores REAIS de hoje (`porcoes` ∈ {1,2},
`rendimento` 1–6, `quantidade` ≤ 400) a ordem atual **não erra nenhuma vez** — é bug
latente, não ativo. Conserto de uma linha, risco zero, e a tabela de porções da tela de
Ajustes é feita para ela editar depois: no dia em que `porcoes` sair de {1,2}, acorda.
Custo se errado: nenhum — a ordem nova é estritamente mais precisa.

**Minor confirmado, e o erro era MEU.** O doc comment de `posicaoNoCiclo` (que eu escrevi
no plano) afirma "em Dart, `-1 % 33` devolve `-1`". **Falso.** Rodei: `%` sobre `int` em
Dart é **euclidiano**, sempre em `[0, tamanho)` — `-2 % 33` = **31**. Quem trunca é
`remainder()` (dá −1). Dart difere de C/Java/JS. Varri 1601 dias comparando módulo duplo
vs simples: **0 divergências** — a redundância é no-op nesta linguagem, e o "teste
decisivo" do plano não discrimina o que eu afirmei.

Ruling R12: **corrigir só o comentário, manter o código.** O módulo duplo é inofensivo e
protege contra troca futura de `%` por `remainder()`; mexer em aritmética que funciona no
núcleo do domínio por cosmética é o movimento mais arriscado. Corrigi o plano nos dois
pontos (comentário do ciclo e ordem do escalonamento).
Custo se errado: código carrega 2 operações redundantes — irrelevante.
Também corrigi ao Isac, na conversa, a afirmação falsa que eu tinha feito sobre `-1 % 33`.

Fix round 1/5 despachado com exigência de teste-que-falha-primeiro (28/56/64 antes,
27/55/63 depois).

Tasks 3–7: fix round 1/5 — implementador DONE em `18743a3`. Verificação minha por comando
(não pelo relatório): **50 testes** declarados e 50 passando; `escalonamento.dart:23` =
`quantidade * porcoes / rendimento`; teste novo afirma 27/55/63; comentário de
`posicaoNoCiclo` corrigido E corpo intacto (`ciclo.dart:21` segue com o módulo duplo e o
`assert`). Desta vez a contagem do relatório bateu.
Re-revisão escopada despachada sobre `5355efb..18743a3` (3 arquivos, 21 inserções), com
pedido explícito de confirmar que a reordenação não quebrou os outros 4 comportamentos de
`escalarQuantidade`.
Briefs 8 e 9 extraídos e prontos para dispatch.

Ruling R13: a re-revisão escopada do fix do lote 3–7 **morreu por falha de plataforma**
(`API error: You've hit your session limit`), não por problema de código. Completei a
verificação eu mesmo, por execução de Dart, em vez de parar a execução até o reset.
Justificativa: a proibição da skill é sobre o controlador **consertar** achados — o que eu
fiz foi verificar por comando, e a alternativa era parar o dia. Cobri o que a re-revisão ia
cobrir e mais:
- os 3 casos de ponto flutuante → 27/55/63 ✓ (ordem antiga daria 28/56/64, confirmado)
- os 4 comportamentos vizinhos que a reordenação podia ter quebrado: sem-medida não escala
  (aGosto e pitada), discreta com piso 1, discreta arredonda p/ cima, contínua não
  arredonda, contínua dobra, contínua reduz, `rendimento` 0 não divide, `rendimento`
  **negativo** não divide (caso que nem estava na lista do revisor)
- **12/12 verificações OK**
- corpo de `posicaoNoCiclo` intacto, só o comentário mudou (conferido antes por grep)
Custo se errado: um par de olhos independentes menos neste fix de 21 linhas. Mitigado por
a revisão final de branch cobrir tudo de novo.

Tasks 3–7: fix round 1/5 (2 endereçados, 0 aberto — ordem de ponto flutuante + comentário
do módulo; verificado pelo controlador por falha de plataforma na re-revisão;
commits 5355efb..18743a3)
Tasks 3–7: complete (commits 75b8998..18743a3, review clean)

Plano corrigido e commitado (4 correções minhas encontradas durante a execução).
Fase A: 7 de 9 tarefas de domínio prontas. Restam T8 (resolverRefeicao, o coração) e T9.

Task 8: implementada em `549961e` (haiku, 12 tool uses, 116s). Verificação minha:
`resolucao_test.dart` = **18** testes; suíte = **68** passando; `resolucao.dart` importa só
`espelho.dart` e `modelos.dart` (constraint OK).

Duas correções de contagem:
- O **plano dizia "17 testes"** no texto do Step 4 da T8 — erro MEU de contagem. O brief
  tem 18 testes de fato (5 + 5 + 6 + 2 por grupo). Plano corrigido para 18.
- O relatório disse suíte de 69; são **68**. Terceiro relatório seguido com total errado.
  Padrão consolidado: **nunca usar relatório como fonte de contagem**; verificar por comando
  sempre. O código nunca foi afetado — só o relato.

Revisão despachada (sonnet) com pedido de traçar um cenário que eu não sei se os 18 testes
cobrem: **substituição de componente no `slotBase` combinada com substituição de combo no
próprio slot, na mesma data.** Se não estiver coberto, é lacuna de teste, não bug.

Task 8: revisão rodada 1 — spec ✅, qualidade **Aprovado**, 0 Critical, 0 Important,
2 Minor (ambos sobre força de TESTE, não sobre implementação). Revisor traçou os 7 pontos
manualmente, escreveu 3 probes próprias, rodou e apagou.

Respondeu o cenário que eu pedi: substituição de componente no `slotBase` + substituição de
combo no próprio slot, mesma data → **correto**, verificado inclusive com combo id diferente
do valor do ciclo. A camada do base é ignorada porque `espelhoIntacto` vira false no passo 1.

Minor 1 (deferred): o teste `override no jantar nao volta para o almoco`
(`test/resolucao_test.dart:121-125`) é **mais fraco que o nome sugere**. Ao resolver
`almoco`, `base == slot`, então o passo 2 nunca é avaliado e a chave `(data, jantar)` nunca
é consultada — o teste passaria mesmo com a ordem dos casos 1/2/3 invertida. Quem discrimina
de fato a precedência é `override no almoco arrasta o jantar junto` (2 vence 3) e
`override proprio vence o override do slot base` (1 vence 2). Não é bug; é nome que promete
mais do que o teste prova.

Minor 2 (deferred): sem teste oficial combinando override de **combo** E de **componente**
no mesmo slot próprio. Revisor verificou por probe que o comportamento está correto — é
lacuna de suíte, não defeito.

Ruling R14: os dois Minor **não entram em fix round** (regra da skill), mas o Minor 2 é
lacuna de regressão no coração do domínio, exatamente na combinação que a usuária vai
produzir naturalmente. Em vez de um fix round só para isso, mando os dois testes como
**rider na Task 9** — mesma camada, 12 linhas, uma revisão. Fecha a lacuna
permanentemente sem pagar um ciclo de dispatch inteiro.
Custo se errado: 12 linhas de teste a mais numa tarefa vizinha; se a T9 reprovar por causa
disso, separo.

Task 8: complete (commits 74996bf..549961e, review clean, 2 minor deferidos e endereçados
como rider na T9)

Task 9 (+ rider): implementada em `3be26b2` (haiku, 19 tool uses, 211s). Verificação minha:
`mercado_test.dart`=13, `resolucao_test.dart`=20 (18+2 rider), suíte=**83 passando**,
`flutter analyze` limpo, nenhum `flutter`/`drift` em `lib/domain` (constraint aguentou a
Fase A inteira). Contagem do relatório bateu desta vez.
**Os dois testes do rider passaram de primeira** — meus valores esperados estavam certos, e
o Minor 2 da T8 está fechado com guarda permanente.
Revisão despachada (sonnet) com um pedido de opinião, não só constatação: `agregarMercado`
propaga `ConversaoAusente`, então uma lista de um mês abortaria por UM alimento sem
conversão. Quero o julgamento do revisor sobre se isso é aceitável dado que a T11 tem testes
de integridade garantindo conversão para todo alimento.
Briefs 10–13 (Fase B) extraídos e prontos.

Task 9: revisão rodada 1 — spec ✅ (tarefa e rider), 1 **Important**, 2 Minor.
Revisor confirmou que `lib/domain/resolucao.dart` NÃO foi tocado pelo rider (só teste), e
que os dois testes do rider têm dente.

**Important, provado empiricamente pelo revisor:** ele removeu a linha
`if (g == 0) continue;` de `mercado.dart:68` e **os 13 testes continuaram passando**. O
teste `ignora ingrediente a gosto` não guarda o que o nome promete, porque sempre combina a
linha zerada com outra linha não-zero do MESMO `alimentoId` — somar 0 não muda o total.
Falta o caso de um alimento aparecer SÓ como `pitada`/`aGosto`, que sem o skip entraria na
lista com `gramas: 0`. Fix round 1 despachado com 3 testes novos e exigência de provocar a
falha comentando a linha, depois restaurar.

Ruling R15 (Minor 1, contestado e mantido): o revisor apontou que
`secoes[...] ?? SecaoMercado.mercearia` e `unidadesCompra[...] ?? UnidadeCompra.kg` são
fallback silencioso, inconsistente com o `ConversaoAusente` que estoura na mesma função.
**Mantenho como está.** A assimetria é justificada, não descuido: seção faltando põe o item
na mercearia em vez da prateleira certa — degradação cosmética, a lista segue correta e
utilizável. Conversão faltando tornaria a **quantidade** desconhecida, e não existe padrão
honesto para quantidade. Regra: falha alto onde o valor não pode ser inventado; degrada onde
pode. Documentei isso como comentário no plano, para não parecer descuido a quem ler depois.
Custo se errado: um alimento mal-categorizado aparece na seção errada da lista, e ela
percebe no mercado.

Ruling R16 (Minor 2): ramo `gramasPorUnidade <= 0` sem teste — mandei junto no fix round,
2 expects. Barato demais para deferir.

⚠️ do revisor a CARREGAR para tarefa futura: `agregarMercado` propaga `ConversaoAusente`
sem try/catch, então quem chamar (T12 `RepoMercado.gerar`, T19 tela de Mercado) precisa
capturar e mostrar erro acionável em vez de travar a tela. O revisor concordou que propagar
é correto para função de domínio puro — a responsabilidade é do chamador. **Levar isso no
dispatch da T12 e da T19.**

## Mudança de modo: execução autônoma (Isac dormindo, 2026-08-26 ~20h)

Ruling R17: os checkpoints de APK das Tasks 15–22 **deixam de ser pontos de parada**. Eu
continuo buildando o APK em cada tarefa visual (é a verificação de que a cadeia de release
segue de pé, e é barato), mas **não espero resposta** — sigo para a tarefa seguinte e
acumulo o roteiro de teste de cada checkpoint num arquivo único que ele lê ao acordar.
Motivo: parar e esperar num checkpoint com ele dormindo desperdiça a noite inteira; o
propósito dos checkpoints era feedback humano cedo, e o cedo agora é amanhã.
Custo se errado: se uma decisão visual estiver errada, ela se propaga por várias telas antes
de ele ver. Mitigado por: a direção visual já foi escolhida e refinada em 3 rodadas de mock,
e cada tarefa é revisada por spec + qualidade de todo jeito.

Ruling R18: limites do que faço sozinho enquanto ele dorme. **Não faço:** criar remote,
push, publicar, nem instalar no aparelho dele. **Faço:** implementar, testar, revisar,
commitar na branch local `feat/mvp-refeicoes`, e buildar APK local.
A **Task 23 Step 5** (roteiro de 12 verificações no aparelho) é a única coisa que fica
pendente por natureza — exige o celular na mão. Vou deixá-la explicitamente marcada como
pendente-para-o-Isac em vez de fingir concluída.

Ruling R19: se um fix round estourar o cap de 5 rodadas numa tarefa, eu adjudico e sigo
(regra da skill), em vez de parar a noite esperando resposta. Toda adjudicação vai no
ledger com o custo se errado, e entra na lista final que ele lê.

Plano de batelamento do restante, para não gastar a noite em overhead de dispatch:
- Fase B (T10 tabelas drift, T11 semente, T12 repositórios, T13 backup): **uma por vez**.
  São grandes e interdependentes — T11 depende do schema da T10, T12 depende das duas, T13
  depende do schema. Batelar aqui trocaria overhead por retrabalho.
- Fase C: avalio par a par. T18+T19 (Mês, Mercado) são telas independentes entre si e
  candidatas a lote. T16+T17 e T20+T21 são acopladas (uma substitui tronco da outra), então
  seguem em sequência.

Task 9: fix round 1/5 (2 endereçados, 0 aberto — 3 testes novos; re-revisor comentou a linha
`if (g == 0) continue;`, confirmou que os dois testes de aGosto/pitada **falham** sem ela, e
restaurou com `git diff` vazio; `lib/domain/mercado.dart` intacto; commits 3be26b2..4189621)
Task 9: complete (commits 549961e..4189621, review clean)

## ✅ FASE A COMPLETA — 9/9 tarefas, 86 testes, analyze limpo

`lib/domain/` tem 8 arquivos, **zero imports de flutter/drift**, e a constraint é vigiada por
teste. Toda a regra de negócio do app está escrita e testada sem precisar de device.
Commits da fase: 0db44ae..4189621.

Bugs reais achados e consertados na Fase A (nenhum era do implementador — todos do MEU plano):
1. Versões de `drift_dev`/`build_runner` insatisfazíveis com o `meta` fixado pelo SDK
2. `library;` faltando após doc comment (quebrava `analyze` limpo)
3. Ordem de operações de ponto flutuante no `ceil` do escalonamento (165 casos de erro)
4. Racional do módulo duplo descrevia Dart errado (`%` é euclidiano, não truncado)
5. Teste de trilhos com match literal de substring (aspas duplas e `export` escapavam)
6. Teste de "a gosto" sem dente (provado removendo a linha guardada)
7. Contagem de testes errada no texto do plano (17 → 18)

Ruling R20: Task 10 vai em **sonnet**, não no tier barato. Motivo: é a primeira tarefa que
roda `build_runner` (codegen do drift), e o `drift_dev` foi rebaixado para 2.34.0 por causa
do conflito de `meta` — se o codegen tiver quirk, depurar exige julgamento, e tier barato
tende a girar em volta. O schema também é a fundação que T11–T22 consomem.

Task 10: **BLOCKED** na rodada 1 — implementador parou e perguntou, exatamente como o
contrato pedia. Bloqueio real, não erro dele: `test/app_database_test.dart` não **compila**
porque `package:drift/drift.dart` e `package:flutter_test` (via `package:matcher`) ambos
exportam `isNull` sem qualificação.

Verificação minha no pacote — o escopo é MAIOR do que ele viu:
`drift-2.34.3/lib/src/runtime/query_builder/expressions/null_check.dart` tem **duas**
funções top-level deprecadas, não uma:
  linha 5:  `Expression<bool> isNull(Expression inner)`
  linha 10: `Expression<bool> isNotNull(Expression inner)`
Ele tropeçou no `isNull`. O `isNotNull` ia derrubar a **Task 13** do mesmo jeito, porque
`backup_test.dart` usa `isNotNull` duas vezes.

Ruling R21: `import 'package:drift/drift.dart' hide isNull, isNotNull;` nos dois arquivos de
teste afetados (`app_database_test.dart` e `backup_test.dart`). Escondo **os dois** símbolos,
não só o que quebrou, para o arquivo ficar imune se alguém acrescentar o outro depois.
Rejeitei as alternativas: import com prefixo poluiria todas as referências a drift no
arquivo, e trocar `isNull` por `equals(null)` afastaria o teste do brief sem ganho.
**Corrigi o plano nos dois lugares de uma vez**, então a T13 não bate na mesma parede.
Custo se errado: nenhum — é resolução de nome, zero efeito em runtime ou em asserção.

Ruling R22: aviso do drift_dev `Duplicate orderings/filters detected for field
"overridesComponenteRefs" on table "$ReceitasTable"` — **aceito, não silenciado**.
Causa: `OverridesComponente` tem 2 FKs para `Receitas` (`receitaOriginalId` e
`receitaNovaId`), e o gerador de Managers não sabe nomear os dois lados. Afeta só
`db.managers`, API de conveniência que este projeto **não usa** em lugar nenhum (usamos
`db.select`/`db.into`/`db.update` diretos). Recusei anotar `@ReferenceName()` para calar:
seria ruído no schema por causa de uma API não usada.
Custo se errado: se alguma tarefa futura quiser `db.managers` nessas duas colunas, precisa
das anotações. Nenhuma tarefa do plano usa.

Nota: codegen do drift **funcionou** com `drift_dev 2.34.0` rebaixado — gerou
`app_database.g.dart` com 304.699 bytes. O risco que motivou o Ruling R20 (sonnet para esta
tarefa) não se materializou no codegen, mas o julgamento foi usado no bloqueio do `isNull`.

Task 10: implementada em `097e650` após o desbloqueio. Verificação minha:
`app_database_test.dart`=6, suíte=**92 passando**, analyze limpo. Codegen gerou
`app_database.g.dart` (~300 KB), commitado junto (mesma prática do `financas-app-mobile`).
O implementador deixou minhas edições do plano fora do commit dele, corretamente.

Ruling R23: o pacote de revisão da T10 **exclui `*.g.dart`**. 300 KB de código gerado pelo
build_runner afogaria o revisor e roubaria atenção do schema escrito à mão, que é o que
importa. Mantive o `--stat` completo no topo do pacote para ele ver que o arquivo existe e
qual o tamanho. Revisar saída de gerador é revisar o gerador, não o nosso código.
Custo se errado: se o gerador produzir algo errado a partir de schema certo, a revisão não
pega — mas isso apareceria como falha de compilação ou de teste, e os 92 testes passam.

Task 10: revisão rodada 1 — spec ✅ (byte-a-byte com o brief, confirmado por `diff`),
qualidade **Aprovado**, 0 Critical, 0 Important, 1 Minor, 1 ⚠️.

Revisor fez as provas que pedi, não só leitura:
- **removeu o `PRAGMA foreign_keys = ON`** (`app_database.dart:188`) → o teste
  `chave estrangeira esta ligada` **falhou** (`Expected: throws / Actual: emitted <1>` — o
  insert com FKs 999/999 foi aceito calado), os outros 5 seguiram verdes. Restaurou,
  `git diff` vazio. O guarda-corpo tem dente.
- confirmou no pacote real que o `export` de `query_builder.dart` em drift 2.34.3 **não**
  esconde `isNull`/`isNotNull`, e que `matcher-0.12.19/core_matchers.dart:39` define
  `const Matcher isNull` — a colisão é fato, não suposição.
- `grep -rn "\.managers" lib/ test/` → **nada**. A API afetada pelo aviso do drift_dev
  realmente não é usada, confirmando o Ruling R22.
- 13 tabelas, 8 PKs compostas (todas conferidas), 10 `textEnum` e **zero** `intEnum`,
  4 instâncias de `DataPuraConverter` batendo com as 4 colunas de data, `receitaNovaId`
  nullable sem default.

Minor descartado: o relatório do implementador escreve "7 tabelas" e lista 8. Só prosa de
relatório — o código tem 8, confirmado. Eu também disse 7 no dispatch (com ressalva de
conferir). Artefato de workspace, apagado no fim; não vale fix round.

Ruling R24 (⚠️ do revisor): o teste de duplicata por PK composta cobre só `OverridesCombo`;
as outras 7 tabelas de PK composta não têm teste análogo. **Não vou acrescentar.** Testar as
8 seria testar o SQLite, não o nosso código: a restrição é declarativa, o drift a gera e o
SQLite a impõe. Um teste prova que o mecanismo funciona; as outras 7 declarações estão
verificadas por revisão contra o brief, que é a ferramenta certa para declaração.
Custo se errado: se uma PK composta estiver declarada errada em alguma das 7, entra
duplicata sem teste pegar. Mitigado: o revisor conferiu as 8 uma a uma contra o código.

Task 10: complete (commits 4189621..097e650, review clean)

Ruling R25: Task 11 (semente) vai em **sonnet**. É 714 linhas de brief, quase tudo
transcrição de JSON em volume (40 alimentos, ~74 conversões, 24 receitas, 8 combos, 8 itens
de ciclo). Tier barato daria conta da lógica, mas erro de digitação em volume alto custa fix
round caro, e os testes de integridade da tarefa (todo alimento com conversão de grama, todo
alimento por unidade com massa) transformariam cada typo em ida e volta.

Task 11: implementada em `38c9130`. **Validação independente minha, por script Python** sobre
os 5 JSON — não confiei no relatório nem nos testes da tarefa:
- 40 alimentos · **73** conversões (74 − `concha`) · 24 receitas · 8 combos · 8 itens de ciclo
- **todo** valor de enum do JSON existe em `modelos.dart` (Unidade, SecaoMercado,
  CategoriaReceita, UnidadeCompra, TipoCombo) — zero inválidos
- **todas** as referências cruzadas resolvem: conversão→alimento, receita→ingrediente→alimento,
  combo→receita, ciclo→combo
- ciclo cobre posições 1–4 nos 2 tipos, **sem par (posicao,tipo) duplicado**
- linha `concha` removida como instruído
- suíte: **100 testes**, analyze limpo
O implementador também validou por script antes de rodar os testes — por isso os 8 passaram
de primeira. Boa prática, registrada.

Revisão despachada (sonnet) com foco deslocado: mandei **não** re-verificar integridade de
dado (já fiz) e concentrar no **carregador** e na força dos 8 testes. O ponto que marquei
como mais importante: confirmar que a guarda `origem == 'usuario'` pula a receita
**inteira, incluindo os ingredientes**. Se pular só o update da linha `receitas` mas ainda
apagar e reinserir ingredientes, a edição da usuária é destruída **pela metade** — pior que
sobrescrever inteiro, porque fica inconsistente e ela não percebe.

Nota do implementador a carregar: ids autoincrement de `receitaIngredientes`/`comboReceitas`
**não são determinísticos entre cargas**. Inofensivo hoje (ninguém referencia esses ids),
mas relevante para a **T13 (backup)**: o export/import restaura linhas com id explícito, o
que preserva; e para qualquer tarefa futura que queira referenciar ingrediente por id.

Task 11: revisão rodada 1 — spec ✅, **carregador Aprovado**, 1 Important (lacuna de
cobertura), 1 Minor, 1 ⚠️.

Revisão do mais alto padrão até aqui: o revisor fez **mutation testing real**, três mutações
separadas, restaurando e conferindo `git status` a cada uma. Primeiro provou que o CÓDIGO
está certo (o `continue` da guarda cobre o bloco inteiro; o `delete` roda antes do loop,
escopado por id), depois provou que os TESTES não guardam isso:
1. removeu o `delete` de `receitaIngredientes` (→ duplicação real) — 8 testes passaram
2. moveu a guarda de `origem=='usuario'` para depois do delete de ingredientes
   (→ **destruição parcial**, o pior bug possível da tarefa) — 8 testes passaram
3. removeu o guard de `configPadrao` (→ `data_inicio_ciclo` resetaria a cada carga) —
   8 testes passaram

Ruling R26: os três entram em **fix round**, classificados como Important e não Minor. Não é
preciosismo: são os guarda-corpos dos três invariantes mais frágeis da tarefa, e dois deles
protegem **dado da usuária**. Regressão em qualquer um passaria a suíte inteira calada.
Custo se errado: 3 testes a mais numa suíte que já tem 100.

**Padrão consolidado do projeto — quarta ocorrência.** Testes sem dente já apareceram em:
trilhos (match literal), "a gosto" (soma com zero), e agora três na semente. A causa é
sempre a mesma e é minha: **escrevi os testes do plano para DEMONSTRAR o comportamento, não
para GUARDÁ-LO.** Teste que demonstra usa o caminho feliz; teste que guarda ataca o
invariante. Consequência prática adotada: daqui pra frente, em toda revisão, peço
explicitamente prova por mutação nos invariantes críticos da tarefa — e nos fix rounds exijo
que o implementador provoque a falha antes de declarar pronto.

O teste 2 que mandei é desenhado para pegar a destruição parcial: em vez de conferir que o
nome sobreviveu, ele **apaga um ingrediente** e verifica que a semente não o ressuscita.

Task 11: fix round 1/5 — implementador DONE em `6b4957c`, 11 testes em `semente_test.dart`,
suíte **103**. Ele foi honesto ao registrar que a mutação 2 dele foi mais destrutiva que a do
revisor (moveu a guarda para depois de TUDO, então o nome também era sobrescrito) e derrubou
o teste antigo junto — o que prova que o teste novo falha, mas **não** que ele pega o caso
específico da destruição parcial.

**Verificação minha, com a mutação precisa** (guarda vira condicional só no upsert de
`receitas`; nome preservado, delete+reinsert de ingredientes roda mesmo assim):
  `nao sobrescreve receita que virou do usuario` → **PASSOU** (cego, como o revisor disse)
  `semente nao restaura ingrediente que o usuario apagou` → **FALHOU**, única falha
Exatamente um teste pegou, e é o novo. `semente.dart` restaurado, `git diff` vazio, 103
testes verdes.
Isso fecha a dúvida que a mutação larga do implementador deixava em aberto: o teste guarda o
caso específico, não só um caso qualquer.

Task 11: fix round 1/5 (3 endereçados, 0 aberto). Provas do re-revisor:
- teste 1: com o `delete` comentado, `receitaIngredientes` foi de **93 → 186** linhas
  (duplicação exata) e o teste falhou. Restaurado, diff vazio.
- teste 2: já provado por mim com a mutação precisa (só o teste novo cai).
- teste 3: com `configPadrao` trocado por upsert, `data_inicio_ciclo` virou `2026-08-26` em
  vez de `2020-01-01` e o teste falhou. Restaurado.
Higiene: diff toca só `test/semente_test.dart` (+55), os 8 originais intactos,
`lib/data/semente.dart` e `assets/semente/` não tocados. Suíte 103.
Task 11: complete (commits d233f45..6b4957c, review clean)

Ruling R27: Task 12 (repositórios) vai em **sonnet**. É o maior brief do plano (935 linhas),
e é a primeira tarefa **integrativa**: `RepoPlano.dia()` junta as 8 peças do domínio com o
banco — ciclo, espelho, porções, escalonamento, nutrição, resolução — e monta o objeto que
5 telas vão consumir. Não é transcrição isolada; erro aqui é erro de fiação entre camadas.

Task 12: **NEEDS_CONTEXT** na rodada 1 — bloqueio de altíssimo valor. O implementador parou
com 12/14 testes passando e duas perguntas objetivas. **Os dois problemas são do MEU plano.**

Ele também confirmou, lendo o fonte do drift 2.34.3, que `t.data.equals(data.iso)` compila e
funciona (equivalente a `equalsValue` porque `DataPuraConverter.toSql` é identidade) — a
dúvida que eu tinha marcado como "pare e pergunte" resolveu-se sozinha. Bom sinal.

**Bug A (meu):** emendei `tamanho_ciclo='4'` num teste só, mas **dois** testes de
`repo_plano_test.dart` caem na posição 5+ do ciclo com a semente de 4 dias
(`sabado tem 2 porcoes em tudo` e `dia anterior ao inicio do ciclo`).
Ruling R28: vai para o `setUp()` global. Custo se errado: nenhum.

**Bug B (meu, de dado) — auditado por script próprio:** existe **exatamente um** par
`(alimento, unidade)` usado em receita sem conversão cadastrada:
`(9 Azeite de oliva, colherCha)`, nas receitas 15 e 21, que caem nas posições **2 e 3** do
ciclo. Ou seja: qualquer data que resolva para essas posições estourava `ConversaoAusente`,
e o intervalo `2026-09-01..2026-09-07` do `repo_mercado_test` atravessa as duas.
Ruling R29: **acrescentar a conversão** (`colherCha = 3 g`, coerente com `colherSopa = 8`),
não mudar as datas de teste. Mudar o teste para desviar do dado ruim esconderia o problema, e
o intervalo do brief existe justamente para atravessar fim de semana e exercitar porções
diferentes por dia. Custo se errado: 1 linha de JSON.

**Ruling R30 — o achado que mais vale deste bloqueio.** Os 3 testes de integridade da T11
verificam "todo alimento tem conversão para g/ml" e "todo alimento por unidade tem conversão
de unidade". **Nenhum verifica o invariante que importa:** que todo par
`(alimento, unidade)` **usado em alguma receita** tem conversão. É exatamente por isso que o
bug B sobreviveu à Task 11 e só apareceu na integração da T12.
Mandei acrescentar esse teste AGORA, com prova de dente (rodar antes de acrescentar a
conversão e ver falhar nomeando azeite nas receitas 15 e 21).
Esse teste vale mais que os outros três juntos: é o que vai proteger a semente completa de
**182 receitas** quando ela for gerada no Plano 2. Sem ele, o mesmo bug voltaria multiplicado
por 40 alimentos novos e centenas de pares.
Corrigi o plano nos 4 pontos (conversão, setUp global, remoção da emenda per-teste, teste novo).

Nota de CONTEÚDO para o Plano 2 (não bloqueante, não vou mexer agora): `azeite colherSopa = 8 g`
está baixo — o valor real é ~13,5 g. Afeta precisão de caloria de um ingrediente de
884 kcal/100 g. **Não corrijo agora de propósito:** é dado de conteúdo, o portão de revisão é
a esposa do Isac, e alterar valores base às 21h sem ela ver é o tipo de "melhoria" silenciosa
que a spec manda evitar. Registrar na revisão de conteúdo.

Observação de processo: a falha alta do `ConversaoAusente` **provou seu valor aqui**. Ela nos
entregou o bug B em vez de esconder uma caloria faltando na tela. Se eu tivesse aceitado o
try/catch que a tentação pedia, o bug viveria até a esposa perceber que a lista de mercado
estava sem azeite.

Task 12: revisão rodada 1 — spec ✅, **os 4 repositórios aprovados** (zero bug funcional),
4 Important, 1 Minor, 1 ⚠️. Todos os Important são cobertura, provados por mutação:

1. **`repo_plano.dart:194`** — trocou `quantidade` por `ing.quantidade` em `emGramas` →
   **125/125 passaram**. A regra que EU marquei como a mais crítica da tarefa (nutrição sobre
   quantidade escalada) não tem guarda nenhuma. **Sexta ocorrência do padrão.**
2. **`repo_plano.dart:102`** — inverteu `orderBy(t.ordem)` para `desc` → **21/21 passaram**.
   A ordem dos componentes do prato (base, leguminosa, proteína, legume, salada) não é
   protegida; os testes usam `firstWhere`/`contains`, indiferentes à posição.
3. **`diasEditados`** — removeu o `where` de intervalo inteiro → **14/14 passaram**, porque o
   teste só insere UM override no banco todo. Filtro certo por leitura, sem rede.
4. **`RepoReceitas` tem ZERO teste.** Não existe `repo_receitas_test.dart`. Está dentro do
   escopo do brief (que não pediu), mas deixa `salvar` marcando `origem='usuario'` e
   `excluir` desativando verificados só por leitura.

Ruling R31: os quatro entram em fix round. Os 3 primeiros são 3 testes baratos guardando
invariantes que a spec exige. O 4º é decisão de escopo: o brief não pediu
`repo_receitas_test.dart`, mas **`RepoReceitas` é o repositório que toca dado criado pela
usuária**, e 3 telas (T20, T21, T17) vão depender de `salvar` marcar posse corretamente.
Zero cobertura ali é risco desproporcional ao custo de 8 testes. Mandei criar.
Custo se errado: ~8 testes a mais e um arquivo novo fora da lista do brief.

Minor 5 aceito: `repo_config.dart` perdeu o `import 'package:drift/drift.dart'` do brief
porque estava sem uso e o `analyze` acusava `unused_import`. Correto — `ConfigCompanion` vem
de `app_database.dart`. Sexta divergência, todas justificadas.

⚠️ do revisor, honesto e sem conserto possível: "overrides filtrados por data não carregam o
banco inteiro" é **performance, não correção** — com poucos registros de teste, filtrar ou
não produz resultado idêntico, então nenhuma asserção prova isso. Verificado só por leitura.
Aceito: não vou inventar teste de performance com 8 linhas de dado.

Positivo registrado: o revisor mutou `DiaResolvido.total` para `refeicoes.first.nutrientes` e
o teste `nutricao do dia soma as quatro refeicoes` **falhou corretamente**
(`Expected: 4535.79, Actual: 490.5`). Esse tem dente para o que afirma.

Task 12: fix round 1/5 despachado e implementado em `e504f51`. Verificação minha:
suíte **136**, e `git diff --quiet 825edf4 e504f51 -- lib/` → **INTACTO**, o fix é só teste.
`repo_plano_test.dart` 17, `repo_receitas_test.dart` 8 (arquivo novo).
Implementador conferiu cada nome e contagem esperada contra a semente real antes de
escrever — nada precisou de ajuste.

Registrei no plano (Step 11 novo da T12) uma **tabela invariante → mutação que o teste mata**.
Motivo: sem isso, quem ler o plano depois vê 11 testes e não sabe por que existem, e alguém
"simplifica" o teste de nutrição achando que é redundante. Documentei também que
`repo_receitas_test.dart` não estava na lista original do brief, e por quê.

Ruling R32: na re-revisão, em vez de ditar as mutações dos 8 testes de `RepoReceitas`, dei
**três opções e pedi que o re-revisor escolha duas e justifique**. Re-revisor que só executa
a mutação ditada verifica o meu raciocínio, não o código; escolhendo, tem chance de achar o
que eu não pensei.

Criado `COMO-TESTAR.md` na raiz do repo — é o arquivo que o Isac lê ao acordar, acumulando o
roteiro de cada checkpoint de APK (Ruling R17). Já contém: onde fica o APK, qual keystore
assina, o aviso de que o ciclo tem 4 dias e não 33 nesta fase (navegar para o dia 5 dá erro
**esperado**, não bug), e o resumo do que Fases A e B entregaram sem tela.

Task 12: fix round 1/5 (4 endereçados, 0 aberto). Re-revisor provou as 4 por mutação e
escolheu, das 3 opções que dei para `RepoReceitas`, as duas que protegem **dado da usuária**:
`origem: Value('usuario')` → `Value('seed')`, e `excluir` de UPDATE para DELETE real. Ambas
derrubaram os testes-alvo. Higiene ok (só 2 arquivos de teste; os 14 originais intactos),
`git diff lib/` vazio no fim.
Confirmou também que os testes novos são honestos, verificando o que eu tinha pedido: a
comparação `×2` do teste de nutrição discrimina de fato (arroz rende 1, almoço usa 1, jantar
usa 2 — com quantidade crua os dois seriam iguais), e as datas do teste de intervalo estão
uma dentro e uma fora.
Task 12: complete (commits 6b4957c..e504f51, review clean)

## Estado: Fase B em 3/4 — 136 testes

Ruling R33: Task 13 (backup) vai em **sonnet**, apesar do brief ser pequeno (244 linhas).
Motivo: é a feature que protege contra **perda total de dado** — celular quebrado, app
reinstalado. O código tem sutilezas que erram calado: `PRAGMA foreign_keys = OFF` durante o
import, delete em ordem **inversa** de `allTables` para não brigar com dependência, e a
função `_variavel` com pattern matching sobre tipo dinâmico. Errar o round-trip aqui é o
tipo de bug que só aparece quando ela mais precisa.
Já estão pré-aplicados no plano os dois rulings anteriores que afetam esta tarefa:
`import 'dart:typed_data'` (R3) e `hide isNull, isNotNull` (R21).

Task 13: revisão rodada 1 — spec ✅, **0 Critical** (nenhum dos 6 ataques produziu perda ou
corrupção de dado), 2 Important, 2 Minor. Melhor revisão técnica do projeto.

**Important (a) — achado que eu NÃO previ, provado empiricamente:**
`PRAGMA foreign_keys = OFF` **é no-op dentro de uma transação.** O revisor rodou o pragma
dentro do `db.transaction()`, fez `SELECT` dele em seguida → devolveu **1 (ligado)**, e um
insert órfão de propósito estourou `FOREIGN KEY constraint failed`. A proteção que o meu
código anuncia **não existe**.
Hoje não causa perda porque a ordem de `allSchemaEntities` é ordenação topológica válida nos
dois sentidos — delete reverso apaga filho antes do pai, insert direto insere pai antes do
filho. Mas o comentário atribui a segurança ao pragma, e **se alguém reordenar a lista
`tables:` do `@DriftDatabase`, o import quebra e o "OFF" não salva.**
Ruling R34: consertar — pragma FORA da transação, `ON` num `finally` para religar mesmo se o
import estourar. Custo se errado: nenhum; é a forma correta e documentada.

**Important (b):** `formatoBackup` é escrito no JSON e **nunca validado** no import. Hoje
invisível (só existe formato 1); no dia da mudança incompatível, backup antigo é aceito em
silêncio. Ruling R35: validar e lançar.

Minor (a): o teste de JSON malformado cobre só falha **antes** da transação (quebra no
`jsonDecode`). Falha **no meio**, depois do DELETE, não está na suíte — o revisor testou por
fora e funciona. Mandei virar teste permanente.

Ruling R36 (Minor b): **remover** o branch `Uint8List` de `_variavel` — inalcançável e
enganoso: não há coluna blob, e o `JsonEncoder` do export estouraria antes de produzir um.
Branch de decode para algo que o encode não produz é falso senso de cobertura. Sai junto o
`import 'dart:typed_data'` e o `// ignore: unnecessary_import` (o motivo do import morre com
o branch — isso desfaz parte do Ruling R3, que agora sei ter sido baseado em premissa errada).
**Manter** o branch `bool`, que também é morto hoje (o `customSelect` devolve int cru 0/1) mas
é defensivo de graça se o formato futuro codificar booleano como true/false — com comentário
dizendo isso, para ninguém tentar removê-lo depois.

Resultado dos 6 ataques que eu pedi: 5 passaram, 1 furou (o do pragma).
Vale registrar o mais bem defendido — o ataque 4, que era **minha** suspeita mais forte:
`double` com valor inteiro exato (`76.0`) sobrevive ao round-trip. O revisor rastreou etapa
por etapa e explicou POR QUÊ, em vez de só constatar: `double.toString()` do Dart **sempre**
emite `.0` para inteiros exatos, então `jsonEncode`/`jsonDecode` nunca colapsa para `int`; e a
afinidade REAL do SQLite força ponto flutuante na leitura mesmo se tivesse sido bindado como
inteiro. Dois mecanismos convergindo. Minha suspeita era razoável e estava errada.
Ataques que também passaram: `receitaNovaId` nulo em coluna INTEGER (semântica de "componente
removido" preservada), `bool false` nas 4 colunas, `DateTime` em segundos unix, e rollback de
falha no meio da transação.

Task 13: fix round 1/5 (4 endereçados, 0 aberto). Provas do re-revisor:
- pragma: `OFF` fora da transação vale 0 antes do primeiro DELETE, e DELETE em tabela-pai com
  filhas populadas **não estoura** — a proteção passou a ser real, não no-op
- formato: removendo a validação, o teste falha (`Expected: throws, Actual: emitted <null>`)
- falha no meio: o JSON do teste passa por `jsonDecode` E pela validação de formato, e só
  estoura no INSERT (`table receitas has no column named coluna_que_nao_existe`), depois do
  DELETE. A transação reverte. **O teste não passava por motivo errado.**
- branch morto: `Uint8List` e `dart:typed_data` fora, `bool` mantido com comentário,
  `analyze` limpo sem o `ignore`
- **ponto 5 (o motivo do conserto existir):** pragma = 1 confirmado nos TRÊS cenários —
  import bem-sucedido, falha na validação (antes da transação), e falha no meio da transação.
  O `finally` executa em todos. Rollback não restaura estado de conexão; o `finally` sim.
Task 13: complete (commits eeb674a..9f6c95d, review clean)

## ✅ FASE B COMPLETA — 13/23 tarefas, 142 testes

Camada de dados de pé: 13 tabelas drift, semente idempotente dos 4 primeiros dias,
4 repositórios, backup com round-trip provado nas 13 tabelas.
Commits da fase: 4189621..9f6c95d.

Bugs reais achados na Fase B (todos do MEU plano, nenhum dos implementadores):
1. Colisão `isNull`/`isNotNull` entre drift e matcher (2 arquivos de teste não compilavam)
2. `db.dispose` não existe em `GeneratedDatabase` — só `close()`
3. `ultimaLista()` sem desempate: drift grava DateTime em segundos, duas gerações no mesmo
   segundo empatavam e o ORDER BY ficava não-determinístico
4. `tamanho_ciclo` emendado em 1 teste quando 2 precisavam
5. **Dado faltando:** `(azeite, colherCha)` sem conversão — estourava nas posições 2 e 3
6. **Invariante de integridade que faltava:** nenhum teste verificava que todo par
   `(alimento, unidade)` USADO em receita tem conversão. É o que vai proteger as 182 receitas
   do Plano 2.
7. `PRAGMA foreign_keys = OFF` dentro da transação é **no-op** — a proteção não existia
8. `formatoBackup` escrito e nunca validado
9. Branch `Uint8List` morto e enganoso em `_variavel`

Lacunas de teste sem dente encontradas e fechadas na Fase B: 8 (semente 3, repositórios 4,
backup 1). Total do projeto: 11.

Ruling R37: Task 14 (tema) vai em **sonnet**. Envolve download de 4 fontes, eixo de fonte
variável (`fontVariations`, não `fontWeight` — erro que falha CALADO), `ThemeExtension`
customizada e um `CustomPainter`. Muita superfície de detalhe que compila errado sem avisar.

Ruling R38: o plano da T14 tem um artefato bobo meu — o Step 5 manda escrever um
`CampoRespingo` deliberadamente incompleto com uma classe `CoresEsmaltePlaceholder`, e o
Step 7 substitui. Vou instruir o implementador a **escrever a versão final direto** e pular a
dança do placeholder. Custo se errado: nenhum; o resultado é idêntico e sem passo inútil.

Task 14: implementada em `3e1df86`. Suíte **150**, analyze limpo. As 4 fontes com tamanhos
esperados (91/165/135/136 KB) e o implementador conferiu também os **magic bytes**
(`00 01 00 00`, assinatura sfnt/TrueType) — prova melhor que tamanho, porque descarta página
HTML de erro que casualmente tenha o tamanho certo. Boa iniciativa dele.
`pubspec.yaml` preservou os assets da semente e **nenhum `weight:` nas fontes variáveis**.
Instrução do Ruling R38 seguida: `respingo.dart` escrito direto na versão final, sem o
`CoresEsmaltePlaceholder`, Step 7 pulado.

**ERRO DE PROCESSO MEU:** despachei a T14 referenciando `task-14-brief.md`, que eu **nunca
extraí**. O implementador não adivinhou nem inventou requisito: foi à fonte autoritativa
(`docs/superpowers/plans/...md:4334-4923`), fez o trabalho, e **me avisou explicitamente** da
divergência. Comportamento exemplar.
Ruling R39: extraí de uma vez os briefs **14 a 23**, para não reincidir nas 9 tarefas
restantes. Custo se errado: nenhum; são arquivos derivados do plano.

**ERRO DE FERRAMENTA MEU:** meu comando de contagem usava `grep -cE '^\s*test\('`, que
**não conta `testWidgets(`**. Contei 149 onde o Flutter reporta 150. A Fase C é inteira de
widget test, então isso ia me enganar em 9 tarefas seguidas.
Ruling R40: contador corrigido para `'^\s*(test|testWidgets)\('`. Confirmado: bate 150 com o
`flutter test`. Registro porque é exatamente o tipo de erro de instrumentação que faz o
controlador confiar em número errado — o mesmo problema que eu vinha cobrando dos relatórios.

Revisão despachada (sonnet) com pedido de prova por mutação em 3 pontos: a regra dos 17 px
(que eu ditei), mais **dois testes que ele escolhe** entre os 8, com justificativa.

Task 14: revisão rodada 1 — spec ✅ (19 valores de cor conferidos token a token contra a
spec 11.1), **0 Critical**, 2 Important, ambos provados por mutação, ambos em coisas que a
tarefa existia para prevenir:

1. **`test/tema_test.dart:40-45`** — o teste `fonte variavel declara o eixo de peso` verifica
   só `displayLarge` e `bodyMedium`. O revisor trocou `titleMedium` de `fontVariations` para
   `fontWeight` — **a regressão exata que eu sinalizei como "falha calado"** — e os 8 testes
   passaram. Cinco estilos podem reverter sem detecção.
2. **`test/tema_test.dart:58-76`** — o teste do `CampoRespingo` afirma só a cor do
   `DefaultTextStyle`. Removeu a borda e trocou o `IconTheme` para preto: 8 testes passaram.
   O **aro** (assinatura da direção visual) e o ícone branco regridem em silêncio.

Ruling R41: consertar os dois. O item 1 é o mais valioso: generalizo o teste para iterar os
8 estilos e exigir `fontVariations` + eixo `wght` em todo estilo que não seja `IBMPlexMono`
(fonte estática, cujo peso vem do arquivo). Mandei **manter** o teste antigo — o novo o
generaliza, mas remover teste que passa não traz ganho.
Custo se errado: 2 testes a mais.

**Ocorrências 12 e 13 do padrão** (teste que demonstra em vez de guardar). Total do projeto:
13 lacunas fechadas.

O revisor também confirmou o que eu já suspeitava e declarou como ⚠️ honesto: a aparência
**real** da fonte renderizada (peso visual, legibilidade abaixo de 17 px) e a existência do
eixo `wght` **dentro** do arquivo `.ttf` não são verificáveis em widget test — exigiriam app
em device ou ferramenta de fonte. Aceito: é limite real da ferramenta, não preguiça. Fica
para o checkpoint de APK da T15, onde o Isac vê a fonte de verdade.

Task 14: fix round 1/5 (2 endereçados, 0 aberto). Re-revisor provou as duas, e — o que eu
pedi de propósito — repetiu a mutação num **segundo** estilo (`displaySmall`, escolha dele):
falhou também. Isso é o que prova a **generalização**; provar só em `titleMedium` confirmaria
o teste no único ponto já conhecido.
Higiene ok, os 8 originais intactos, `git diff lib/` vazio, suíte **152**.
Confirmou que a exclusão do `IBMPlexMono` do laço é correta (fonte estática, só `labelMedium`
usa) e não esconde outro estilo.
Task 14: complete (commits ec4f248..1cfc2f7, review clean)

Ruling R42: o re-revisor opinou (eu pedi opinião, não verificação) que vale reescrever a
asserção da borda do `CampoRespingo` — hoje ela falha com `type 'Null' is not a subtype of
type 'Border'`, erro de cast que não diz que a borda está nula. Concordo: o guarda-corpo
funciona, mas a mensagem é inútil para quem depurar em seis meses. **Vai como rider na T15**,
em vez de gastar um ciclo de dispatch em 3 linhas.
Custo se errado: mensagem de falha continua feia; zero risco funcional.

## Estado: 14/23 tarefas, 152 testes. Fase C iniciada (1/10).

Ruling R43: Task 15 vai em **sonnet**. É a tarefa mais consequente da Fase C mesmo não sendo
a maior: cria `test/util_teste.dart`, o auxiliar que **7 tarefas seguintes** consomem
(`envolver(widget, db:, overrides:, brilho:)` + `bancoDeTeste()`). Assinatura errada ali
custa retrabalho em 7 tarefas. Também cria `app.dart` (casca de 4 abas), `format.dart`
(consumido por 8 telas) e o `CartaoEsmalte`. E é o **primeiro checkpoint de APK**.

Task 15: implementada em `91b9b25`, mas o subagente **parou no meio** — devolveu sem status,
esperando notificação de um build que lançou em **background** e nunca chegou.

Verificação minha antes de decidir (não perguntei ao agente, fui olhar):
- commit no lugar, **árvore limpa**
- todos os 7 arquivos existem + os 4 troncos de tela
- **167 testes passando** (`format_test` 11, `app_test` 4, `tema_test` 10), analyze limpo
- rider do `tema_test` aplicado: `expect(deco.border, isNotNull, reason: ...)` antes do cast
- **o APK em disco é o da Task 1** — 49.011.309 bytes, timestamp 19:01. O build da T15 não
  completou.
- **relatório não existe**

Ruling R44: retomei o mesmo agente em vez de refazer ou de buildar eu mesmo. Motivo: o código
está commitado e verde, então não há o que reimplementar; o que falta é (a) build em primeiro
plano e (b) o relatório, que é artefato dele e depende do contexto do que ele fez. Buildar eu
mesmo enquanto ele também builda arriscaria dois Gradle concorrentes no mesmo diretório.
Instruí explicitamente **primeiro plano, não background** — foi o background que o travou.
Custo se errado: um round-trip a mais.

Lição de processo registrada: `run_in_background` num build longo dentro de subagente é
armadilha — ele devolve o turno sem status e fica ocioso esperando algo que não vem por aquele
canal. Nos próximos dispatches com checkpoint de APK, vou dizer explicitamente "primeiro
plano".

Task 15: revisão rodada 1 — spec ✅, qualidade **Aprovado**, **zero achados**. Primeira tarefa
da noite sem fix round.
Revisor fez 4 mutações (1 que eu ditei + **3 escolhidas por ele**), todas falhando isoladas e
todas restauradas byte-idênticas:
1. (ditada) removeu o guard `if (onTap == null)` → só `cartao sem onTap nao cria area de toque`
   falhou
2. (escolha dele) incluiu `Unidade.unidade` no set de plural → `Expected: '2 un' / Actual: '2 uns'`
3. (escolha dele) deslocou `_diasSemana` para começar em domingo → `Expected: 'sexta' /
   Actual: 'quinta'`. Off-by-one clássico que eu tinha sinalizado.
4. (escolha dele) removeu a troca condicional de fundo do cartão apagado. **Justificativa que
   vale registrar:** escolheu esse porque o teste afirma duas propriedades acopladas (cor da
   borda + cor de fundo) na mesma asserção, e havia risco de cobrir só uma. A mutação provou
   que cobre as duas.
Ele também verificou independentemente (por Python) que 2026-09-04 é sexta e 2026-09-05 é
sábado, em vez de aceitar minha afirmação.

**Dois bugs do MEU plano corrigidos nesta tarefa:**
1. **`CartaoEsmalte` quebrava em tempo de PINTURA.** Flutter proíbe `borderRadius` não-zero com
   `Border` de cores não-uniformes — e o aro superior é de cor diferente **de propósito**, é a
   assinatura da direção visual. Não é erro de compilação nem de teste: é exceção no primeiro
   paint. Corrigido com `ClipRRect` por fora, preservando o `Border`.
2. **`util_teste.dart` não compilava:** `Override` não está no barrel público do
   `flutter_riverpod` 3.4.2, só em `package:riverpod/misc.dart`. Importado de lá + `riverpod`
   promovido a dev_dependency (senão `depend_on_referenced_packages` reprova o analyze).
Ambos corrigidos no plano.

Task 15: complete (commits 1cfc2f7..91b9b25, review clean)
**CHECKPOINT 1 DE APK: 51.657.670 bytes, timestamp 22:32.** Roteiro escrito em `COMO-TESTAR.md`.

## Estado: 15/23 tarefas, 167 testes. Fase C em 2/10.

Ruling R45: Task 16 (tela Hoje) em **sonnet**. É a primeira tela com conteúdo real, consome a
pilha inteira (repositório → domínio → tema), e é onde o **espelho** aparece visualmente pela
primeira vez. Também cria 3 troncos novos (folha de substituir, receita, ajustes).

Task 16: **BLOCKED** na rodada 1 — 174/176 testes, 2 falhando. O implementador parou e
perguntou, com dump da árvore de widgets provando que não eram erros de transcrição dele.
Duas contradições reais do meu plano, e a primeira é **erro de DESIGN meu**, não de teste.

**Ruling R46 (design, não teste): o cartão espelhado passa a LISTAR os componentes.**
Contradição: o Step 1 do brief diz que cartão espelhado escreve "repete o almoço, em dobro"
**em vez de** listar componentes; o teste afirma `find.text('240 g')`, que é o arroz do jantar
a 2 porções. Irreconciliável.
Resolvi contra o **meu próprio argumento do Step 3**: escrevi que a quantidade aparece na tela
Hoje porque "ela decide se tem ingrediente sem abrir a receita". Isso vale **mais** para o
jantar, que é a quantidade maior. Esconder os componentes do espelhado obriga a dobrar tudo de
cabeça — o trabalho que a tela existe para poupar.
E o sinal de "isto é repetição" não depende do texto: quem carrega é o **visual apagado**
(cartão sem aro, fundo recuado). O texto era redundante com o visual E escondia dado útil.
Decisão: espelhado mostra a linha "repete …, em dobro" **e** a lista com quantidades dobradas.
Continua sem rodapé de kcal e sem SUBSTITUIR (só os 2 slots base têm botão), então o teste
`espelhado ... nao oferece substituir` (`findsNWidgets(2)`) segue válido.
Custo se errado: cartão espelhado mais alto/denso. Reversível numa linha.

**Ruling R47 (infraestrutura): viewport de celular em `util_teste.dart`.**
O padrão do `flutter_test` é **800×600 — mais BAIXO que qualquer celular real.** O botão
SUBSTITUIR do almoço cai em y≈719, fora da viewport, e o `tap()` **erra em silêncio** (avisa,
não falha). Ia me morder nas Tasks 17–22 também.
Autorizei `telaDeCelular(tester)` em `util_teste.dart` (412×915 dp, densidade 3, com
`addTearDown` para resetar) — infraestrutura compartilhada, lugar certo do conserto. Pedi que
confirme qual API compila (`tester.view.physicalSize` ou `tester.binding.setSurfaceSize`).
Custo se errado: nenhum; testes passam a representar aparelho real em vez de uma tela que não
existe.

**Ruling R48:** aprovei os 2 consertos que ele já tinha identificado — o
`import 'hoje_provider.dart';` que meu brief omitiu (sem ele não compila) e a remoção do
`unused_import` de `flutter_riverpod` se o analyze acusar.

Observação para a T17, anotada e não resolvida agora: **como ela substitui o jantar
independentemente?** Só os slots base têm botão SUBSTITUIR, então o caminho
`espelhoIntacto = false` (domínio testado, spec 6.2) **não tem entrada pela interface**.
Substituir o almoço cascateia para o jantar, o que atende a spec. Mas quebrar o espelho é
capacidade que o modelo suporta e a UI não expõe. **Decidir na T17.**

Task 16: revisão rodada 1 — spec ✅, qualidade **Aprovado**, 0 Critical, 0 Important, 2 Minor.
Revisor fez **6 mutações**, todas restauradas, `git status` limpo:
- `espelhado` forçado `false` E depois `true` → 3 testes caem em cada caso, por razões
  inversas. **A distinção prato-original vs repetição é real e testada, não decorativa.**
- `porcoes: 1` fixo no escalonamento → o teste da quantidade escalada falha (`240 g` não
  encontrado). Prova que ele distingue as duas quantidades, não só "algum texto com g".
- apagou a conversão do arroz do banco → `dia.when(error:)` renderiza
  `ConversaoAusente: alimento 1 nao tem conversao para g`, **sem tela branca**. Fecha o ⚠️
  que vinha carregado desde a T9: a tela captura o que o domínio propaga.
- `telaDeCelular` não vaza viewport: 2 rodadas completas de `flutter test` dão 176/176
  idêntico, e `hoje_screen_test.dart` isolado dá 9/9.

**Minor 1 (real):** o teste do cabeçalho é toothless quanto ao **valor** de kcal — o revisor
somou +9999 ao número e os 9 testes passaram. Ele só confere a existência do rótulo
`KCAL NO DIA`. Nenhum teste da suíte cobre o total diário numérico nesta tela.

**Minor 2 (real, e mais interessante que o rótulo):** o comentário de `_LinhaComponente` diz
"primeiro ingrediente com **massa**", mas a lógica só exclui `aGosto`/`pitada` — qualquer
unidade discreta conta. Não é hipotético: **8 receitas da semente** têm a medida principal
discreta, ex. id 15 mostra `2 fatia` de pão e ignora os `2 unidade` de ovo. Código veio
verbatim do brief, então é erro meu de comentário, não do implementador.

Ruling R49: os dois Minor vão como **rider na T17**, não em fix round — mesmo padrão que já
usei duas vezes. O Minor 1 vale consertar de verdade (o total de kcal é número que ela vai
olhar); vou pedir asserção **relacional** (a tela renderiza o que o repositório calcula) em vez
de número mágico, para não ficar frágil se a semente mudar.

Ruling R50 (a pergunta que eu tinha deixado em aberto): **mantenho sem botão SUBSTITUIR nos
slots espelhados.** A spec exige substituição em dois níveis (combo inteiro ou componente) e
não exige soltar o espelho pela interface; substituir o almoço cascateia para o jantar, o que
atende ao pedido original dela. A capacidade de quebrar o espelho fica no domínio, testada,
para uma versão futura. **Perguntei ao Isac no `COMO-TESTAR.md`** — se ela quiser trocar só o
jantar, é adição pequena depois.
Custo se errado: ela não consegue trocar só o jantar sem trocar o almoço. Mitigado por a
pergunta estar explícita no roteiro que ele vai ler.

Task 16: complete (commits 22aa9bf..08479c2, review clean, 2 minor como rider na T17)
**CHECKPOINT 2 DE APK: 53.427.198 bytes.** Roteiro escrito.

## Estado: 16/23 tarefas, 176 testes. Fase C em 3/10.

Task 17: implementada em `54a9f5f`. Suíte **184**, analyze limpo, APK 53.820.506 bytes.
Riders A e B aplicados; o A provado por mutação (+9999 no valor renderizado faz a asserção
relacional falhar).

**Consequência não prevista da minha decisão de design da T16.** Ao fazer o cartão espelhado
listar componentes, criei ambiguidade nos testes de tela: como o jantar espelha o almoço, os
nomes de componente passaram a aparecer em **três** lugares simultâneos — cartão do almoço,
cartão espelhado do jantar, e dentro da folha de substituição. O `find.text(...)` sem escopo
virou ambíguo. O implementador resolveu escopando com
`find.descendant(of: find.byType(BottomSheet), ...)` (7 usos), mesmo padrão que o brief já
usava em outro teste, e verificou contra a semente antes de editar. **Produção não foi
alterada por causa disso.**
Registro porque é um custo real de uma decisão minha: melhorei a tela e encareci os testes.
Não me faz querer reverter — a decisão continua certa pelo motivo original —, mas as Tasks
18–22 vão herdar essa necessidade de escopo em qualquer teste que abra overlay sobre a Hoje.

Segundo conserto de teste: `Voltar ao plano original` caía fora da viewport de 412 dp por
quebra de linha em nomes longos de combo. Resolvido com `tester.ensureVisible(...)` antes do
`tap()` — 1 uso. É o mesmo tipo de problema que o `telaDeCelular` resolveu para a T16, mas
aqui o conteúdo é mais alto que a tela mesmo num aparelho real, então `ensureVisible` é a
ferramenta certa (scroll até o alvo), não aumentar a viewport.

**CHECKPOINT 3 DE APK escrito no roteiro** — marcado como o mais importante da noite, com os
4 gestos em ordem e o aviso de que se o passo 1 não arrastar o jantar é bug real.

Task 17: revisão rodada 1 — spec ✅, implementação **aprovada**, 1 Important.
Revisor provou por mutação, todas restauradas:
- `substituirCombo` gravando sempre em `jantar` → `escolher outro combo grava o override`
  falhou (`Expected: <5> Actual: <8>`). **A regra do espelho chega à tela de verdade.**
- mesma mutação no nível de componente → `trocar componente grava e reflete no jantar` falhou
- `receitaNovaId: null` → `comp.receitaId` (auto-loop, viraria no-op) → `tirar do prato`
  falhou (`Expected: <4> Actual: <5>`). Escolheu esse porque é asserção só de contagem, o tipo
  fraco que historicamente passava vácuo neste projeto — e aqui não passou.
- confirmou que os 7 `find.descendant` **não** são só negativos: linhas 104 e 109 são
  `findsOneWidget` escopados, que falhariam se a folha não renderizasse nada
- confirmou `SingleChildScrollView` real, então o `ensureVisible` não mascara botão
  inalcançável

**Important, e é o achado que eu pedi para ele caçar:** `ref.invalidate(diaProvider)` tem
**cobertura ZERO**. Ele removeu **as 4** chamadas e os 8 testes passaram igual.
Causa raiz: **todas** as asserções pós-tap chamam `plano.dia(sexta)` numa instância NOVA de
`RepoPlano`. Provam que o **banco** gravou, nunca que a **tela** redesenhou.
Consequência: alguém remove um `invalidate`, a gravação segue funcionando, a tela para de
atualizar, a usuária toca e conclui que o app ignorou. Nenhum teste pega.

Ruling R51: fix round com asserção contra a **árvore de widgets** depois do tap, não contra o
banco. Pedi prova removendo um `invalidate` e vendo o teste cair.
Custo se errado: 2 asserções a mais num teste.

## LIÇÃO A CARREGAR PARA AS TASKS 18–22

Este é o **14º** teste sem dente do projeto, e revela um padrão específico de teste de TELA
que eu não tinha nomeado antes:

> Teste de tela que verifica o resultado **no banco** em vez de **na árvore de widgets** prova
> a metade errada. A gravação é responsabilidade do repositório (já testada na T12); o que o
> teste de tela precisa provar é que a interface **reflete** a mudança.

Vou exigir explicitamente, nos dispatches das Tasks 18–22, que ao menos uma asserção por
interação seja contra a árvore renderizada. Vale para: marcar item no mercado (barra de
progresso), escolher dia no calendário (resumo muda), salvar receita (catálogo atualiza),
trocar aparência (tema muda).

Ruling R52: **Tasks 18 (Mês) e 19 (Mercado) vão em UM lote.** São telas independentes entre si
— nenhuma importa a outra, e só a T18 acrescenta algo a `format.dart` (`ehDiaUtilData`).
Um dispatch, uma revisão, um checkpoint de APK. Economiza ~7 turnos numa noite que já está
longa, e a superfície de revisão continua coerente ("duas telas de leitura sobre o mesmo
repositório"). Tasks 20+21 seguem acopladas (a 21 substitui tronco da 20), então não batelo.
Custo se errado: fix round cobre duas telas em vez de uma.

Task 17: fix round 1/5 (1 endereçado). Re-revisor confirmou por mutação que
`escolher outro combo grava o override` **falha** sem o `invalidate` do combo (cai a asserção
`findsWidgets`), e que **não há risco de colisão** no `findsNothing` — o nome do combo 8 é
único na semente. Higiene ok, 10 inserções, `lib/` intocado.

**Mas o teste extra que eu mandei fazer achou o resto do problema:** removendo os outros
**três** `invalidate` (linhas ~117, 160, 175), **os 8 testes passam**. Só 1 dos 4 branches
ficou coberto.

Ruling R53: **fix round 2**, fechando os três. Não deferi nem virei rider, por dois motivos:
(a) o implementador está **em contexto agora** e já tem o padrão na mão — explicar de novo numa
tarefa futura custa mais que 3 asserções agora; (b) os três branches são três das quatro
formas de ela usar a folha, e o pior é `Voltar ao plano original`: ela reseta o dia, a tela não
muda, e conclui que o botão não funciona.
Exigi mutação **uma por vez** (remover só o da 160, ver cair o teste certo, restaurar) em vez
de remover os três juntos — remover em bloco provaria que "algum" teste cai, não que **cada**
asserção guarda **seu** branch.
Custo se errado: 3 asserções a mais.

Nota de método: pedir ao re-revisor para checar o **resto** do problema (os outros 3
`invalidate`), e não só confirmar o conserto do achado, é o que transformou um fix parcial em
fix completo. Sem esse pedido eu teria fechado a T17 com 1 de 4 branches protegidos, achando
que resolvi.

Task 17: fix round 2/5 (3 endereçados, 0 aberto) em `86717fc`. Implementador provou os três
**um por vez** como exigi — removeu só o `invalidate` da 160, viu cair o teste de troca de
componente, restaurou; idem 175 (remoção) e 117 (voltar ao original). `git diff lib/` vazio.
Nenhum nome esperado precisou de ajuste contra a semente.
Task 17: complete (commits 418cead..86717fc, review clean)
**CHECKPOINT 3 DE APK: 53.820.506 bytes.** Roteiro escrito, marcado como o mais importante.

## Estado: 17/23 tarefas, 184 testes. Fase C em 4/10.

Tasks 18+19: **Task 18 pronta e commitada** em `ebf4160` (10/10 testes, analyze limpo).
**Task 19 BLOQUEADA** na rodada 1 — 9/11 testes; o implementador parou e perguntou de quem era
o erro, em vez de editar o teste.

Diagnóstico dele, correto: o teste do brief faz `find.text('Batata-doce')`, mas o alimento id 6
da semente se chama **`"Batata-doce crua"`**. `find.text` casa por igualdade exata, então nunca
acha. Ele confirmou que o item **renderiza de fato** na semana testada (combo 8 cai no dia 4,
que usa a receita 4, que usa o alimento 6) — o finder é que procura a string errada.

Ruling R54: **a semente está certa, o teste está errado (erro meu).** `"Batata-doce crua"` segue
a convenção TACO, que lista cru e cozido como entradas **distintas** com valores diferentes; o
sufixo é o que dá rastreabilidade ao `taco: C0117` e faz a nutrição ser auditável. Mudar o nome
perderia isso. Corrigir o teste para o nome real, com `find.text` exato e **não**
`find.textContaining` — exato é mais honesto: se o nome mudar, quero o teste caindo e alguém
decidindo, em vez de casar por acidente.
Custo se errado: nenhum.

**Achado de CONTEÚDO que a pergunta dele destapou.** Auditei a semente: **22 dos 40 alimentos**
carregam sufixo de estado (`Arroz branco cozido`, `Patinho cru`, `Cebola crua`,
`Ovo de galinha cru`...). Esses nomes aparecem **na lista de mercado** — a lista de compras dela
vai dizer "Cebola crua", que ninguém escreve num papel de mercado.
Ruling R55: **não consertar agora.** O conserto de verdade exige campo separado de "nome de
compra" no schema, além do nome nutricional — mudança de **estrutura**, não de dado, e o portão
de revisão de conteúdo é a esposa dele. Mesmo tratamento que dei ao `azeite colherSopa = 8 g`.
**Escrito no `COMO-TESTAR.md` como pergunta direta para ela**, com o trade-off explicado
(rastreabilidade TACO vs. legibilidade da lista).
Custo se errado: a lista de mercado fica com nomes esquisitos até alguém decidir. Visível, não
silencioso.

Pedi também que ele responda uma pergunta de método: com o `listaMercadoProvider` único do
brief (o que chamava `gerar()` e era invalidado ao marcar), o teste `marcar de novo desmarca`
teria **falhado ou passado vácuo**? Quero saber se o teste pegaria o bug que eu achei por
leitura — se não pegaria, é a 15ª lacuna do mesmo tipo.

Tasks 18+19: revisão rodada 1 — spec ✅ nas duas, 0 Critical, **1 Important**, 3 Minor.
Revisor fez 6 provas por mutação, todas restauradas. Duas que valem registro:
- acrescentou `ref.invalidate(listaIdProvider)` junto do outro no `onTap` de marcar → o teste
  de progresso falhou. **Confirma que o split de providers é o que sustenta a marca**, não o
  invalidate seletivo por acaso.
- mutou `ordemSecoes` para ordem alfabética → o teste de ordem física falhou
  (`Expected: < 272.0, Actual: 560.0`). Não é vácuo.
- apagou conversão do arroz → `.when(error:)` mostra `ConversaoAusente`, `takeException()`
  nulo, cabeçalho intacto. Sem tela branca, igual à T16.
- confirmou por grep que **nenhum** dos 2 arquivos de teste chama `db.select`/`into`/`update` —
  a regra "asserção contra a árvore, não contra o banco" foi cumprida.

**Important — bug que EU classifiquei como risco baixo no pré-flight. Estava errado.**
`mes_provider.dart:9-19` usava `ref.watch(dataSelecionadaProvider)` no `build()`: qualquer
mudança de data, inclusive de outra tela, reconstruía o notifier e **descartava o mês
folheado**. Provado por teste descartável: folheou 1 mês, chamou `avancar(1)` por fora, o mês
voltou sozinho.
Agravante: o comentário afirmava *"independe da data selecionada"* — **o oposto do que o código
fazia.** Comentário que mente é pior que o bug: o próximo leitor confia e constrói em cima.
Ruling R56: consertar com `ref.read` + comentário honesto + **teste permanente**. Conserto sem
guarda-corpo volta na primeira refatoração, e `watch` vs `read` é exatamente o que alguém
"corrige de volta" achando que está restaurando reatividade.
Custo se errado: se algum dia outra tela precisar mover o mês visível, faz via método do
notifier em vez de por efeito colateral de `watch`.

Erro meu no rascunho do fix: cravei `'OUTUBRO 2026'` no teste, mas a data da máquina é
**agosto/2026**, então o mês visível é agosto e o seguinte é setembro. O implementador calculou
em runtime em vez de cravar — o que também evita o teste quebrar quando setembro chegar.

Fix round 1/5 (1 endereçado). Re-revisor provou a mutação `read`→`watch`, confirmou que tocar
dia da grade **continua funcionando** (e explicou por quê: a grade só mostra dias do mês
visível, então o dia tocado nunca está fora dele), e resolveu a dúvida que eu levantei sobre
31/dez: **passa**, porque `DateTime.utc(2026, 13)` normaliza para 2027-01.
Minor aceito: o teste novo depende de `DateTime.now()` — não quebra em data nenhuma (verificado),
só não é determinístico no que exercita. Custo de consertar não se paga agora.

Tasks 18+19: complete (commits 86717fc..00d209b, review clean, 3 minor deferidos)
**CHECKPOINT 4 DE APK: 57.769.598 bytes.** Roteiro escrito para as duas telas.

## Estado: 19/23 tarefas, 205 testes. Fase C em 6/10.

Ruling R57: **Tasks 20 e 21 vão em UM lote**, e o acoplamento delas **favorece** o lote em vez
de impedir: a T20 criaria `receita_form_screen.dart` como tronco e a T21 o substituiria. Juntas,
o implementador escreve a versão real direto e o tronco nunca existe. Menos passo inútil, igual
ao que fiz na T14 com o `CoresEsmaltePlaceholder`.

Tasks 20+21: revisão rodada 1 — spec ✅ nas duas, escopo limpo, painel de nutrição travado
confirmado (só 2 `TextField`: nome e preparo). **2 Critical, 4 Important, 1 Minor.**

**C1 e C2 — o maior achado de cobertura da noite.** O revisor forçou o cálculo nutricional a
devolver `Nutrientes.zero` em DOIS lugares (`_calcular` do formulário e `detalheProvider`) e
**todos os 26 testes passaram**. O número nutricional na tela não tinha nenhum teste: a
aritmética está coberta em `nutricao_test.dart`, mas a fiação ingredientes→número exibido era
inverificada.
Gravidade além do rótulo: a dona pediu literalmente "valor nutricional/calorias essas coisas",
e a decisão de calcular por ingrediente pela TACO (em vez de valor fixo) foi tomada para o
número seguir certo quando a porção dobra ou ela troca componente. Sem teste, essa decisão de
arquitetura inteira ficava sem guarda-corpo.

**I4 — numeração dos passos podia estar INVERTIDA.** Mutação `passos.length - i` (passo 1
mostrando "5") passou, porque o teste conferia existência de "1" e "5" soltos, nunca a
correspondência número↔passo. Ela seguiria a receita na ordem errada.

Ruling R58: consertar C1, C2, I4 e I1 (4 testes). **Não** consertar I2 (lápis no catálogo),
I3 (excluída sai da lista) e M1 (FutureBuilder refaz 2 queries por rebuild): as duas primeiras
comportam-se por dado e `repo_receitas_test.dart` já testa o filtro `ativa` e o `origem` virando
`usuario`; a renderização é condicional simples. M1 é otimização, não corretude.

**O implementador pegou o MEU teste sendo vácuo — e era um teste escrito para consertar teste
vácuo.** O teste 4 do meu rascunho não provava nada: a receita nova cai no índice 17, fora do
`cacheExtent` da `ListView.builder`; e a 1ª correção dele (digitar na busca) **mascarava o bug**,
porque `catalogoProvider` observa `filtroProvider` e digitar força refetch independente do
`invalidate`. Ele rodou a prova ANTES de aceitar, viu passar com o bug injetado, e trocou por
`scrollUntilVisible` na lista vertical.
**15ª ocorrência do padrão, e a mais instrutiva: escrever teste que guarda é difícil, e a única
defesa confiável é provocar a falha antes de acreditar.**

Fix round 1/5 (4 endereçados) em `21d3028`. Re-revisor provou os 4 um por vez com mensagens
precisas (`Found 0 widgets with text '364'`; `Expected: > 0, Actual: 0.0`;
`Found 0 widgets with text '1' descending from Row`; `Bad state: No element`), confirmou que o
teste 4 **depende** do `invalidate` e não passa por outro caminho, e checou que o valor 364 do
teste 2 não coincide com outros números na tela (rende=1, tempo=35).
Tasks 20+21: complete (commits 6ec2c34..21d3028, review clean, 3 minor deferidos)
**CHECKPOINT 5 DE APK: 58.376.010 bytes.** Roteiro escrito, marcado como o ponto de julgar o
CONTEÚDO das receitas.

## Estado: 21/23 tarefas, 235 testes. Fase C em 8/10.

Ruling R59: gerei o **ícone do app** eu mesmo, por script Python (PNG 1024×1024, 14 KB), em vez
de delegar. Motivo: subagente não gera imagem, e a Task 23 pede o arquivo. Usei a **mesma
semente `Random(7)` e os mesmos três passos (37/53/71)** do `PinturaRespingo`, mais o aro na
borda — o ícone é literalmente o elemento-assinatura da direção Esmalte, não um desenho
paralelo. Validado como PNG 1024×1024 por leitura de header.
Custo se errado: ícone feio; trocável a qualquer momento sem tocar em código.

Ruling R60: **Tasks 22 e 23 vão em UM lote.** A 22 é a última tela; a 23 é polimento de release
(ícone, auditoria de manifesto, build final). A 23 depende da 22 estar pronta para o build final
fazer sentido, então sequenciá-las em dispatches separados só adicionaria um ciclo. O ícone já
está no disco.

## REVISÃO FINAL DE BRANCH — 3 Critical, 6 Important, 14 Minor

A revisão da branch inteira (opus, 43 commits, spec + plano + ledger) achou o que 22 revisões
por tarefa **não podiam** ver. Vale registrar como o achado mais importante da noite:

**C1 — a aba Mercado nunca abria, em nenhum aparelho.** `semente.dart` gravava
`tamanho_ciclo = '33'` com só 4 posições em `ciclo.json`. O intervalo padrão do Mercado é
`semanaDe(now)` — **sete dias consecutivos**, que nunca cabem em {1,2,3,4}. Estourava
`Bad state: ciclo sem combo para posicao N` na primeira abertura, sempre.
**Os 244 testes eram cegos POR CONSTRUÇÃO:** `util_teste.dart:31` fazia
`definir('tamanho_ciclo','4')`. Todo teste rodava com 4; só produção com 33. E
`semente_test.dart:61` afirmava `'33'` três linhas abaixo de `cicloItens hasLength(8)` — as
duas asserções juntas **eram** o bug, no mesmo arquivo.
Pior: **eu documentei o sintoma como esperado** no ledger (linha 711) e no `COMO-TESTAR.md`
("navegar para o dia 5 dá erro, é esperado") sem perceber que inutilizava uma aba inteira.

**C2 — reabrir o app apagava todas as marcas do mercado**, e criava lista nova a cada abertura.
`ultimaLista()` — com o desempate por `id` que eu mandei consertar na T12 — **nunca era chamado
em `lib/`**. Contradizia literalmente o racional de D6.

**C3 — o formulário não editava quantidade nem unidade.** Derrubava D8 e a mitigação do Risco 2
da spec 18: o conteúdo é chute e a defesa era ela corrigir sozinha. Inclusive o azeite de 8 g
que eu deixei para ela decidir — ela não teria como consertar.

Ruling R61: **onda única de conserto com 9 itens** (C1, C2, C3, I1, I3, I4, I5, I6, Minor),
depois **2 resíduos** que o implementador registrou, depois **1 item** que o re-revisor propôs.
Três rodadas em vez da "onda única" que a skill pede. Adjudiquei assim porque os resíduos 1 e 3
eram caminhos de VOLTA para bugs recém-fechados (fallback `33` literal reabria C1; `main()` sem
teste reabria I4), não achados novos. Fechar caminho de volta é parte de fechar o bug.
Custo se errado: duas rodadas a mais de dispatch numa noite já longa.

Descoberta técnica do implementador que muda o entendimento do app: **o riverpod 3 reexecuta
provider falho 10× com backoff (~38 s) mantendo `AsyncLoading` COM erro anexado** — então
`.when(error:)` nunca disparava. Os branches `error:` que 4 telas já tinham **nunca funcionaram**.
Ruling R62: desligar retry no **app inteiro** (`semRetry` nomeada). App offline com SQLite
local: toda falha é determinística, retry só troca "erro em 100 ms" por "gira 38 s".

Correção que o re-revisor me deu e eu aceitei: o `assert(tamanho > 0)` em `posicaoNoCiclo` é
**removido em release**. Logo o `salvo > 0` que o implementador acrescentou ao meu esboço é a
**única** checagem que sobrevive ao APK — não era zelo extra, era a rede.

Estado final: **261 testes**, analyze limpo, APK 56,9 MB assinado, 0 segredos no histórico,
manifesto de produção sem permissões.
Corrigi o `COMO-TESTAR.md`, que continha a informação errada sobre o dia 5 — o documento que o
Isac lê não podia carregar a desculpa que escondeu um Critical.
