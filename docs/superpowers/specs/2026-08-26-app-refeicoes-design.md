# App de Refeições — documento de design

**Data:** 2026-08-26
**Status:** aprovado para planejamento
**Autor:** Isac (produto) + Claude (design técnico)

---

## 1. Objetivo

Aplicativo Android que organiza as refeições de um plano alimentar já pronto ao longo
dos dias do mês. A usuária é uma pessoa só — cozinha em casa, todo dia, para si e para
o marido. O app responde três perguntas, nesta ordem de frequência:

1. O que eu cozinho agora, e para quantas pessoas?
2. O que preciso comprar, e quanto?
3. Não quero isso hoje — o que posso pôr no lugar?

O plano de origem tem **33 dias** de rotação, quatro horários por dia. Cada refeição é
um conjunto de componentes (`arroz + feijão + bife acebolado + cenoura + salada`), não
uma receita única.

## 2. Restrições

| Restrição | Origem |
|---|---|
| Offline total, sem nenhuma chamada de API | decisão do Isac |
| Sem imagens de prato nesta versão | decisão do Isac |
| Android, APK assinado, sem loja | decisão do Isac |
| Sem login, sem nuvem, sem conta | consequência de "offline total" |

## 3. Decisões fechadas

| # | Decisão | Por quê |
|---|---|---|
| D1 | Plano é **função pura + exceções**, não tabela materializada | Banco mínimo, nunca desalinha, funciona em qualquer data sem gerar nada, mudar a data de início recalcula tudo sem migração |
| D2 | **drift** (SQLite tipado) + **Riverpod** | Mesma stack já validada em `financas-app-mobile`; erro de coluna vira erro de compilação, migrações versionadas, streams reativas |
| D3 | Nutrição **calculada por ingrediente** via recorte da tabela TACO | Único jeito de o número continuar certo quando a porção dobra ou um componente é trocado |
| D4 | Substituição em **dois níveis**: refeição inteira ou componente solto | Na prática quase sempre falta só um item; trocar o prato todo por causa da carne é atrito |
| D5 | Café da tarde e jantar **espelham** manhã e almoço | É o que o plano de origem já faz; espelho evita duplicar 33 refeições no seed |
| D6 | Lista de mercado é **materializada**; o plano não | Ela marca itens dentro do mercado ao longo de minutos; a lista não pode se mexer embaixo dela se o plano mudar no meio |
| D7 | Identidade visual **Esmalte** (panela de ágata), com modo claro e escuro | Escolhida entre 10 direções na rodada de mocks |
| D8 | CRUD completo de receitas | Sem isso o app vira PDF interativo e morre no segundo mês |
| D9 | Export/import `.json` | "Local" significa que celular quebrado é dado perdido; backup é a contrapartida obrigatória |

## 4. Arquitetura

```
apresentação   telas Flutter + widgets            (lib/ui/)
     │          consomem providers, não tocam no banco
     ▼
estado         providers Riverpod                 (lib/state/)
     │          combinam repositórios, expõem modelos de view
     ▼
domínio        motor do plano, escalonamento,     (lib/domain/)
     │          nutrição, agregação de mercado
     │          — Dart puro, sem drift, sem Flutter, 100% testável
     ▼
dados          repositórios + drift               (lib/data/)
                arquivo SQLite no aparelho
```

A camada de domínio não importa `drift` nem `flutter`. Recebe estruturas simples e
devolve estruturas simples. É onde mora toda a regra que precisa de teste, e é o que
permite testar o motor do plano sem abrir banco nenhum.

## 5. Modelo de dados

### 5.1 Alimentos e unidades

```
alimento
  id                 PK
  nome               texto
  taco_codigo        texto?          -- rastreabilidade até a fonte
  kcal_100g          real
  carboidrato_g      real            -- por 100 g
  proteina_g         real
  gordura_g          real
  fibra_g            real
  sodio_mg           real
  secao_mercado      enum            -- hortifruti | acougue | padaria | laticinios
                                     -- | mercearia | bebidas | congelados
  unidade_compra     enum            -- kg | litro | unidade

conversao_unidade
  alimento_id        FK
  unidade            enum
  gramas             real
  PK (alimento_id, unidade)
  -- (azeite, colherSopa, 8) · (alho, dente, 3) · (ovo, unidade, 50)
```

`conversao_unidade` é o que faz "1 colher de sopa de azeite" virar caloria **e** virar
"500 ml" na lista de mercado. Sem ela, nutrição e mercado não fecham.

### 5.2 Receitas

```
receita
  id                 PK
  nome               texto
  categoria          enum            -- base | proteina | leguminosa | vegetal
                                     -- | salada | molho | bebida | pao | fruta
                                     -- rótulo de `vegetal` na interface é "Legume"
  rendimento_porcoes int             -- em quantas porções os ingredientes rendem
  tempo_preparo_min  int
  modo_preparo       texto           -- passos separados por quebra de linha
  foto_path          texto?          -- nulo nesta versão; campo existe para depois
  origem             enum            -- seed | usuario
  ativa              bool

receita_ingrediente
  id                 PK
  receita_id         FK
  alimento_id        FK
  ordem              int
  quantidade         real
  unidade            enum
  observacao         texto?          -- "picada", "sem sal"
```

`categoria` não é enfeite: é ela que alimenta o seletor de substituição de componente.
Trocar "bife acebolado" só oferece outras receitas de categoria `proteina`.

### 5.3 Combos e ciclo

```
combo                                -- uma refeição montada, ex. "almoço do dia 4"
  id                 PK
  nome               texto
  tipo               enum            -- cafe | refeicao
  origem             enum
  ativo              bool

combo_receita
  combo_id           FK
  receita_id         FK
  ordem              int
  PK (combo_id, receita_id)

ciclo_item                           -- a rotação; 33 × 2 = 66 linhas
  posicao            int             -- 1..33
  tipo_slot          enum            -- cafe | refeicao
  combo_id           FK
  PK (posicao, tipo_slot)
```

### 5.4 Configuração e exceções

```
config
  chave              PK              -- 'data_inicio_ciclo', 'tamanho_ciclo', 'tema'
  valor              texto

regra_porcao                         -- 8 linhas, editável sem migração
  slot               enum            -- cafeManha | almoco | cafeTarde | jantar
  dia_util           bool
  porcoes            int
  PK (slot, dia_util)

override_combo                       -- ela trocou a refeição inteira
  data               date
  slot               enum
  combo_id           FK
  PK (data, slot)

override_componente                  -- ela trocou (ou removeu) um componente
  data               date
  slot               enum
  receita_original_id FK
  receita_nova_id    FK?             -- nulo = componente removido do prato
  PK (data, slot, receita_original_id)
```

O espelho **não é campo**. `cafeTarde` lê o combo de `cafeManha` a menos que exista
override em `cafeTarde`. A linha de override *é* a quebra do espelho — zero estado extra.

### 5.5 Lista de mercado

```
lista_compra
  id                 PK
  data_inicio        date
  data_fim           date
  criada_em          datetime

lista_compra_item
  lista_id           FK
  alimento_id        FK
  quantidade_g       real            -- normalizada em grama ou mililitro
  marcado            bool
  PK (lista_id, alimento_id)
```

Esta é a única coisa que materializa, e de propósito (ver D6).

## 6. Motor do plano

Assinatura central, em Dart puro:

```dart
RefeicaoResolvida resolver(DateTime data, SlotRefeicao slot)
```

### 6.1 Posição no ciclo

```
posicao(data) = ((diasEntre(data_inicio, data) % N) + N) % N + 1
```

O módulo duplo é obrigatório: Dart devolve resto negativo para datas anteriores a
`data_inicio`, e ela precisa poder navegar para trás no calendário. `N` vem de
`config.tamanho_ciclo` (33), não é constante no código.

Datas são tratadas como data pura (ano-mês-dia), nunca como instante. Diferença
calculada sobre datas normalizadas para meio-dia UTC, para não quebrar em horário
de verão.

### 6.2 Resolução do combo

Ordem de precedência, primeira que casar vence:

1. `override_combo(data, slot)` → esse combo. **O espelho está quebrado neste slot.**
2. Se `slot` é espelhado e existe `override_combo(data, slotBase(slot))` → esse combo.
3. `ciclo_item(posicao(data), tipoSlot(slot)).combo`

Onde:

```
slotBase(cafeTarde) = cafeManha
slotBase(jantar)    = almoco
slotBase(x)         = x
tipoSlot(cafeManha|cafeTarde) = cafe
tipoSlot(almoco|jantar)       = refeicao
```

### 6.3 Resolução dos componentes

Partindo dos componentes do combo resolvido, aplica-se `override_componente`:

- Se o passo 1 acima venceu (o slot tem override próprio de combo), aplicam-se
  **somente** os overrides de componente daquele mesmo slot.
- Caso contrário, aplicam-se os overrides de componente do `slotBase`, e depois os
  do próprio slot.

Regra em uma frase: **um slot que já se soltou do espelho não herda mais nada do espelho.**

Componente com `receita_nova_id` nulo é removido do prato.

### 6.4 Porções

```
porcoes(slot, data) = regra_porcao[slot][ehDiaUtil(data)]
```

Semente padrão:

| Refeição | Seg–sex | Sáb–dom |
|---|---|---|
| Café da manhã | 1 | 2 |
| Almoço | 1 | 2 |
| Café da tarde | 2 | 2 |
| Jantar | 2 | 2 |

De manhã e no almoço ela está sozinha durante a semana; à tarde e à noite são dois.
No fim de semana são dois o dia todo.

## 7. Escalonamento de porção

```
fator = porcoes(slot, data) / receita.rendimento_porcoes
```

Aplicado a cada ingrediente:

- **Unidade discreta** (`unidade`, `dente`, `fatia`, `folha`) → arredonda **para cima**.
  `1 ovo × 1,5 = 2 ovos`. Meio ovo não vai na panela.
- **Unidade contínua** (`g`, `ml`, `colherSopa`, `colherCha`, `xicara`) → mantém o
  decimal internamente; arredonda só na exibição (grama e mililitro para inteiro,
  colher e xícara para meio).
- **`aGosto` e `pitada`** → não escalam e não entram no cálculo nutricional (ver 8.2).

**A nutrição é calculada sobre as quantidades já arredondadas**, não sobre as exatas.
Se a receita dobrada usa 2 ovos porque 1,5 arredondou para cima, a caloria mostrada é
a de 2 ovos — é o que efetivamente vai ser comido.

## 8. Nutrição

### 8.1 Cálculo

Para cada ingrediente:

```
gramas = quantidade_escalada × conversao_unidade(alimento, unidade).gramas
kcal   = gramas / 100 × alimento.kcal_100g
```

Idem para carboidrato, proteína, gordura, fibra e sódio. A receita soma seus
ingredientes; a refeição soma suas receitas; o dia soma suas quatro refeições.

Para `unidade = g`, a conversão é a identidade — mas continua vindo da tabela, sem
atalho no código, para o cálculo ter um caminho só.

### 8.2 Ingrediente sem medida

`aGosto` e `pitada` contribuem **zero** para todos os nutrientes. Vale sobretudo para
sal, o que subestima o sódio de propósito: chutar um valor seria pior que declarar
que não foi medido. A tela de receita mostra a nota "sal e temperos a gosto não entram
na conta" quando a receita tem algum desses.

### 8.3 Fonte

Recorte da **TACO** (Tabela Brasileira de Composição de Alimentos, UNICAMP), com
`taco_codigo` preservado por alimento para auditoria. Alimentos industrializados que
não existem na TACO (achocolatado, requeijão, pão de forma) usam rótulo do fabricante,
marcados com `taco_codigo = null`.

## 9. Lista de mercado

Dado um intervalo `[inicio, fim]`:

1. Para cada data no intervalo, para cada um dos 4 slots, resolver a refeição e
   escalar os ingredientes (seções 6 e 7).
2. Somar por `alimento_id`, normalizando tudo para grama (ou mililitro).
3. Converter para unidade de compra:
   - `kg` se ≥ 1000 g, senão `g`
   - `litro` se ≥ 1000 ml, senão `ml`
   - `unidade` sempre arredondada **para cima**
4. Agrupar por `secao_mercado`, na ordem física de um mercado: hortifrúti, açougue,
   padaria, laticínios, mercearia, congelados, bebidas.
5. Persistir como `lista_compra` + itens.

Atalhos na interface: "esta semana" (segunda a domingo corrente), "este mês", e
intervalo livre.

Marcar item é o gesto principal da tela e altera só `marcado`. Gerar a lista de novo
para o mesmo intervalo cria uma lista nova — a anterior não é sobrescrita.

## 10. Telas

| Tela | Papel |
|---|---|
| **Hoje** | Abertura do app. Quatro blocos na ordem do relógio, com porção, componentes já escalados com quantidade, e kcal. Espelhados vêm apagados e sem aro, escrito "repete o almoço". |
| **Mês** | Calendário do mês. Ponto de brasa marca dia com substituição. Tocar num dia mostra o resumo e a regra de porção daquele dia. |
| **Mercado** | Seletor de intervalo, progresso, itens agrupados por seção com quantidade convertida e caixa de marcar. |
| **Receitas** | Catálogo com busca e filtro por categoria. Botão de nova receita. |
| **Receita** | Macros no topo (calculados), ingredientes com quantidade, modo de preparo numerado. Ações: substituir no dia, editar. |
| **Editar receita** | Nome, categoria, rendimento, tempo, ingredientes, passos. O painel de macros é **travado**, com a nota de que vem da TACO. |
| **Ajustes** | Início e tamanho do ciclo, tabela de porções, export/import, aparência, uso de espaço. |
| **Substituir** (folha) | Dois níveis: trocar a refeição inteira por outra do ciclo, ou tocar um componente e trocar só ele por outro da mesma categoria. |

Navegação: quatro abas fixas (Hoje, Mês, Mercado, Receitas). Ajustes fica atrás do
`⋯` da barra superior. Receita e Editar são empilhadas.

Nutrição **não tem tela própria** — mora onde a decisão acontece.

## 11. Sistema visual — Esmalte

Referência: a panela de ágata esmaltada. Branco esmaltado, marinho salpicado, aro
escuro onde o esmalte termina.

### 11.1 Cores

| Token | Claro | Escuro | Papel |
|---|---|---|---|
| `marinho` | `#14263F` | `#0B1927` | campo salpicado, dia escolhido, ações |
| `anil` | `#2C4A73` | `#3C5F87` | segundo plano do marinho, aro no escuro |
| `aro` | `#0A1017` | `#0A1017` | régua escura sob a barra superior |
| `esmalte` (superfície) | `#FFFFFF` | `#16232F` | cartões, superfície de conteúdo |
| `louça` (fundo) | `#E9EDF0` | `#0E1720` | fundo do app |
| `água` (superfície 2) | `#F3F7F9` | `#1D2C3A` | campos, cartões espelhados |
| `brasa` | `#C7412B` | `#E4694E` | substituir, hoje, dia editado — **e nada mais** |
| `ink` / `ink2` / `ink3` | `#0E1519` / `#3E4A55` / `#7C8B98` | `#EAF0F4` / `#AAB9C6` / `#74889A` | texto primário, secundário, terciário |
| `line` | `#D5DEE4` | `#25374A` | bordas e divisores |

### 11.2 Tipografia

- **Darker Grotesque** 800 — números e títulos, apenas em corpo ≥ 17 px. Abaixo disso
  a família perde legibilidade e não deve ser usada.
- **Manrope** 400/500/700/800 — corpo, rótulos, botões.
- **IBM Plex Mono** 400 — toda medida: quantidade, kcal, grama, data do ciclo.
  Monoespaçada não é estética aqui, é alinhamento de coluna.

As três são OFL e vão empacotadas no APK. Nenhuma fonte é baixada em tempo de execução.

### 11.3 As três assinaturas

**O respingo.** Três camadas de `radial-gradient` com passos de 37, 53 e 71 px — primos
entre si, de modo que o padrão não repete visivelmente. Vive só no campo marinho: barra
superior, dia selecionado no calendário, botão de nova receita. **Nunca atrás de texto
corrido.**

**O aro.** 2,5 px de marinho na borda superior de cada cartão. Refeição espelhada perde
o aro e vira cinza — dá para distinguir prato original de repetição sem ler uma palavra.

**A brasa.** Único quente da paleta, racionado em três usos: ação de substituir, ponto
de hoje no calendário, marca de dia editado. Uma quarta aplicação tira a força das
outras três.

### 11.4 Piso de qualidade

Alvo de contraste WCAG AA em texto; foco visível em todo controle; `MediaQuery`
respeitando redução de movimento; toque mínimo de 44 dp; layout íntegro em telas
estreitas (360 dp) e com fonte do sistema ampliada.

## 12. Conteúdo semente

Produzido offline por mim, versionado no repositório como JSON em `assets/seed/`,
importado para o banco na primeira execução e guardado por `seed_version` em `config`
para permitir atualização futura sem apagar o que ela criou.

| Arquivo | Volume estimado |
|---|---|
| `alimentos.json` | ~214 alimentos com nutrição e seção |
| `conversoes.json` | ~120 conversões unidade→grama |
| `receitas.json` | ~182 componentes com ingredientes e preparo |
| `combos.json` | 66 combos (33 cafés + 33 refeições) |
| `ciclo.json` | 66 linhas de rotação |

O conteúdo é um entregável em si, separado do código, e deve ser revisado pela usuária
antes do build final — quantidades e modos de preparo são chute informado até ela
confirmar.

**Atualização de semente sem perder edição.** Quando ela edita uma receita que veio da
semente, `origem` vira `usuario` naquela linha. Uma atualização futura de semente só
insere linhas novas e sobrescreve linhas que ainda estejam com `origem = seed`. O que
ela encostou é dela e nunca é sobrescrito — sem precisar de coluna extra de controle.

**Tamanho do ciclo.** `config.tamanho_ciclo` é lido pelo motor em vez de constante no
código, mas nesta versão a tela de Ajustes o exibe sem permitir alteração: mudar de 33
para outro número exigiria criar ou remover linhas de `ciclo_item`, o que não tem
interface. O campo existe para o dia em que essa tela existir.

## 13. Backup

`Ajustes → Exportar backup` grava um `.json` com todas as tabelas mais `seed_version` e
um carimbo de data. `Importar backup` **substitui** o conteúdo do aparelho, com
confirmação explícita antes.

O arquivo é compartilhado pelo seletor nativo do Android (Drive, WhatsApp, e-mail).
Não há sincronização nem envio automático.

## 14. Testes

Domínio é Dart puro e leva teste unitário primeiro (TDD). Casos que precisam existir:

**Motor do plano**
- posição no ciclo no dia exato do início, no dia seguinte, no dia 33, no 34
- posição em data **anterior** ao início (resto negativo)
- ciclo atravessando virada de mês e de ano
- override de combo em `cafeManha` reflete em `cafeTarde`
- override de combo em `cafeTarde` **não** reflete de volta em `cafeManha`
- slot com override próprio não herda override de componente do slot base
- override de componente com `receita_nova_id` nulo remove o componente

**Porções e escalonamento**
- segunda-feira dá 1 porção no almoço, sábado dá 2
- unidade discreta arredonda para cima (1 ovo × 1,5 = 2)
- unidade contínua não arredonda internamente
- nutrição usa a quantidade arredondada, não a exata

**Nutrição**
- receita com ingrediente `aGosto` não soma nutriente
- conversão colher→grama entra no cálculo
- alimento sem conversão cadastrada falha alto, não silenciosamente

**Mercado**
- soma o mesmo alimento vindo de unidades diferentes na mesma linha
- 1200 g vira "1,2 kg"; 800 g continua "800 g"
- intervalo que atravessa fim de semana aplica porção diferente por dia

**Dados**
- importar o seed duas vezes não duplica linha
- atualização de semente não sobrescreve receita que ela editou (`origem = usuario`)
- export → import devolve o mesmo estado

## 15. Distribuição

Build local na máquina do Isac, APK release assinado com keystore própria,
instalado direto no aparelho — mesmo caminho já percorrido em `financas-app-mobile`.
Sem loja, sem conta de desenvolvedor.

## 16. Fora de escopo

Explicitamente **não** entram nesta versão:

- Foto dos pratos (o campo `foto_path` existe e fica nulo)
- Qualquer chamada de rede, API ou modelo de linguagem em tempo de execução
- Login, conta, nuvem, sincronização, múltiplos usuários
- iOS — o código não cria dependência só-Android, mas não haverá build
- Controle de despensa ou estoque
- Notificações e lembretes
- Mais de um ciclo ou mais de um plano simultâneo
- Lista de compras compartilhada entre aparelhos

## 17. Suposições assumidas

Decisões tomadas por mim na ausência de instrução, revisáveis a custo baixo:

1. Nutrição calculada sobre quantidade arredondada (seção 7)
2. `aGosto` e `pitada` valem zero nutriente (seção 8.2)
3. Override de componente cascateia do slot base enquanto o espelho estiver intacto (6.3)
4. Regenerar lista de mercado cria lista nova em vez de sobrescrever (seção 9)
5. Ordem das seções do mercado segue o percurso físico de um mercado, não o alfabeto
6. Editar receita de semente transfere a posse para ela e a protege de atualização (seção 12)

## 18. Riscos

| Risco | Mitigação |
|---|---|
| O conteúdo semente é o maior custo do projeto e o mais fácil de subestimar | Tratar como entregável separado, com revisão da usuária antes do build final |
| Quantidades e modos de preparo escritos por mim podem não bater com o jeito dela de cozinhar | CRUD completo desde o início (D8); ela corrige o que estiver errado sem depender de código |
| Alimento industrializado sem TACO deixa a nutrição menos confiável | `taco_codigo` nulo marca a linha; a origem fica auditável |
| Darker Grotesque é fonte de display e some em corpo pequeno | Regra explícita: só ≥ 17 px (11.2) |
