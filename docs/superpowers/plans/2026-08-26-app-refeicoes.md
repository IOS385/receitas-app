# App de Refeições — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** App Android offline que organiza um plano alimentar de ciclo fixo nos dias do calendário, com ingredientes escalados por porção, lista de mercado agregada, nutrição calculada e substituição em dois níveis.

**Architecture:** Três camadas. `lib/domain/` é Dart puro — sem Flutter, sem drift — e concentra toda a regra: posição no ciclo, espelho, porções, escalonamento, nutrição, agregação de mercado. `lib/data/` guarda tabelas drift e repositórios sobre um arquivo SQLite local. `lib/presentation/` tem uma pasta por tela, com o provider Riverpod ao lado do widget que o consome. O plano do dia nunca é materializado: é função pura do ciclo mais linhas de exceção.

**Tech Stack:** Flutter 3.44.1 · Dart 3.12.1 · drift 2.34 · flutter_riverpod 3.x (sem codegen) · SQLite local · sem rede.

**Spec:** `docs/superpowers/specs/2026-08-26-app-refeicoes-design.md`

## Global Constraints

- **Flutter 3.44.1, Dart SDK `^3.12.1`.** Verificado na máquina de build.
- **Nenhuma chamada de rede em tempo de execução.** Nem API, nem fonte remota, nem telemetria. Um `import` de `dart:io` HttpClient ou `package:http` é falha de revisão.
- **`lib/domain/` não importa `package:flutter` nem `package:drift`.** É a regra que mantém o domínio testável sem device. Verificável por grep.
- **Nomes de domínio em português** (`refeicao`, `combo`, `receita`, `porcoes`), sufixos estruturais em inglês (`_screen.dart`, `_sheet.dart`, `_provider.dart`, `_test.dart`) — segue a convenção já usada em `financas-app-mobile`.
- **Datas são data pura**, nunca instante. Persistidas como texto ISO `YYYY-MM-DD`. Comparação e diferença sempre sobre `DateTime.utc(ano, mes, dia)`.
- **Riverpod sem code generation.** Providers declarados à mão (`NotifierProvider`, `Provider`, `FutureProvider`), como no projeto anterior.
- **Testes de domínio rodam sem device:** `flutter test` usa a Dart VM. Não há emulador nesta máquina e não há Visual Studio — build de Windows desktop não é opção. Verificação é `flutter analyze` + `flutter test` + `flutter build apk`.
- **`arredondamento para cima` só em unidade discreta:** `unidade`, `dente`, `fatia`, `folha`.
- **`pitada` e `aGosto` valem zero nutriente e não escalam.**
- **Tamanho do ciclo vem de `config`,** nunca constante literal no código.
- **Paleta Esmalte e escala tipográfica** conforme seção 11 da spec. `Darker Grotesque` só em corpo ≥ 17 px.

## Checkpoints de APK

Preferência do Isac, dada em 2026-08-26 durante a execução: *"a cada passo
implementado, q tenha algo visual.. quero um apk buildado e me sinaliza pra abrir e
testar"*.

**Toda tarefa que muda o que aparece na tela termina com um checkpoint de APK.** Isso
vale para as Tasks 15 a 22. O checkpoint é sempre o mesmo:

```bash
flutter analyze && flutter test && flutter build apk --release
```

E então **parar e avisar o Isac**, com três coisas na mensagem:

1. o caminho do APK: `build/app/outputs/flutter-apk/app-release.apk`
2. **o que olhar** nesta tarefa especificamente — não "teste o app", mas os dois ou
   três gestos que a tarefa acabou de tornar possíveis
3. o que ainda **não** funciona, para ele não caçar bug que é escopo de tarefa futura

Consequências disso no plano:

- A **keystore e a assinatura sobem para a Task 1** (Steps 7–9), não ficam na 23.
  Sem isso não há APK instalável nos checkpoints, e o problema de Java só apareceria
  no fim.
- As Tasks 1 a 14 **não** têm checkpoint de APK: 1 a 13 não têm tela (domínio e dados),
  e a 14 é o tema, que só aparece quando a Task 15 monta a casca. A Task 1 tem build
  próprio, para provar a cadeia.
- A Task 23 deixa de ser "configurar assinatura" e passa a ser **polimento de release
  e verificação final no aparelho**.
- Instalação é manual: **não há emulador nem device conectado** nesta máquina.

---

## Estrutura de arquivos

```
lib/
  main.dart                       ProviderScope + AppRefeicoes
  app.dart                        MaterialApp, tema claro/escuro, shell de abas

  domain/                         Dart puro — sem flutter, sem drift
    modelos.dart                  enums, DataPura, Nutrientes, RefeicaoResolvida
    ciclo.dart                    posicaoNoCiclo
    espelho.dart                  slotBase, ehEspelhado, tipoDoSlot
    porcoes.dart                  ehDiaUtil, porcoesDoSlot, regrasPadrao
    escalonamento.dart            escalarQuantidade
    nutricao.dart                 emGramas, nutrienteDeIngrediente
    resolucao.dart                resolverRefeicao
    mercado.dart                  agregarMercado, formatarCompra, ordemSecoes

  data/
    app_database.dart             tabelas drift + AppDatabase
    conversores.dart              TypeConverter de DataPura
    semente.dart                  carga idempotente do JSON de semente
    backup.dart                   export/import .json
    database_provider.dart        providers de banco e repositórios
    repo_plano.dart               leitura do ciclo e escrita de overrides
    repo_receitas.dart            CRUD de receitas e combos
    repo_mercado.dart             geração e marcação de lista
    repo_config.dart              config e regras de porção

  presentation/
    format.dart                   formatação de quantidade, kcal, data
    tema/
      cores.dart                  tokens Esmalte, claro e escuro
      tipografia.dart             escala + fontVariations
      tema.dart                   ThemeData claro e escuro
      respingo.dart               CustomPainter do salpicado
    widgets/
      cartao_esmalte.dart         cartão com aro superior
    hoje/       hoje_screen.dart · hoje_provider.dart
    mes/        mes_screen.dart · mes_provider.dart
    mercado/    mercado_screen.dart · mercado_provider.dart
    receitas/   receitas_screen.dart · receita_screen.dart
                receita_form_screen.dart · receitas_provider.dart
    ajustes/    ajustes_screen.dart
    substituir/ substituir_sheet.dart

assets/
  semente/     alimentos.json · conversoes.json · receitas.json
               combos.json · ciclo.json
  fontes/      DarkerGrotesque-var.ttf · Manrope-var.ttf
               IBMPlexMono-Regular.ttf · IBMPlexMono-Medium.ttf

test/                             chato, espelhando o nome do arquivo de origem
  ciclo_test.dart · espelho_test.dart · porcoes_test.dart
  escalonamento_test.dart · nutricao_test.dart · resolucao_test.dart
  mercado_test.dart · app_database_test.dart · semente_test.dart
  backup_test.dart · repo_plano_test.dart · repo_mercado_test.dart
  tema_test.dart · hoje_screen_test.dart · substituir_sheet_test.dart
  mes_screen_test.dart · mercado_screen_test.dart
  receitas_screen_test.dart · receita_form_screen_test.dart
  ajustes_screen_test.dart
```

Regra de decomposição: cada arquivo de `domain/` tem uma responsabilidade e um arquivo
de teste homônimo. Nenhum deles passa de ~120 linhas. `resolucao.dart` é o único que
compõe os outros, e por isso é o único que precisa de todos eles em contexto.

---

# Fase A — fundação e domínio puro

Nove tarefas, todas sem banco e sem Flutter. Ao fim da fase, toda a regra de negócio
está escrita e testada, e nada disso depende de device, emulador ou build Android.

---

### Task 1: Projeto, dependências e trilhos

**Files:**
- Create: `pubspec.yaml` (via `flutter create`, depois editado)
- Create: `analysis_options.yaml`
- Create: `test/trilhos_test.dart`
- Create: `.gitignore` (via `flutter create`)

**Interfaces:**
- Consumes: nada
- Produces: projeto que compila; `flutter test` e `flutter analyze` verdes; a regra
  "domínio não importa flutter" já vigiada por teste.

- [ ] **Step 1: Criar o projeto**

Rodar na pasta pai de `Receitas App`, com o nome do pacote em snake_case:

```bash
cd "C:/Users/Usuario/Documents"
flutter create --org br.com.isac --project-name refeicoes_app --platforms android "Receitas App"
```

`flutter create` sobre uma pasta existente preserva `docs/` e `mocks/`. Confirmar que
`docs/superpowers/` continua lá antes de seguir.

- [ ] **Step 2: Declarar as dependências**

Substituir os blocos `dependencies` e `dev_dependencies` de `pubspec.yaml`:

```yaml
environment:
  sdk: ^3.12.1

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  drift: ^2.34.3
  sqlite3_flutter_libs: ^0.6.0+eol
  flutter_riverpod: ^3.4.2
  path_provider: ^2.1.6
  path: ^1.9.1
  intl: ^0.20.3
  share_plus: ^13.3.0
  file_picker: ^12.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  drift_dev: ^2.34.0
  build_runner: ^2.15.1
```

**Por que as duas ferramentas de codegen recuam** (corrigido em 2026-08-26, durante a
execução): `flutter_test` do SDK 3.44.1 fixa **`meta: 1.18.0` exato**. `drift_dev ≥ 2.34.1`
e `build_runner ≥ 2.15.2` dependem de `analyzer ≥ 13.3.0`, que exige `meta ^1.18.3` —
insatisfazível. Não é erro de digitação: são de fato as versões mais recentes publicadas,
e o grafo não fecha nesta versão do Flutter.

Relaxar só o `drift_dev` **não basta** — `build_runner` bloqueia sozinho. Os dois valores
acima são exatamente os que o `financas-app-mobile` já usa, e resolvem: `analyzer 12.1.0`,
`meta 1.18.0`, com `drift 2.34.3` e `flutter_riverpod 3.4.2` **intactos** no runtime. O
recuo é dev-only, não afeta o app.

Não adicionar `google_fonts`: ele baixa fonte em tempo de execução, o que viola a
restrição global de rede zero. As fontes entram como asset na Task 14.

- [ ] **Step 3: Endurecer o lint**

Substituir `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
  errors:
    invalid_annotation_target: ignore

linter:
  rules:
    - always_declare_return_types
    - prefer_final_locals
    - unawaited_futures
    - avoid_print
```

- [ ] **Step 4: Escrever o teste que vigia a arquitetura**

`test/trilhos_test.dart`:

```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('lib/domain nao importa flutter nem drift', () {
    final dir = Directory('lib/domain');
    if (!dir.existsSync()) return;

    final proibidos = <String>[];
    for (final f in dir.listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart')) continue;
      final texto = f.readAsStringSync();
      for (final pacote in const ['package:flutter/', 'package:drift/']) {
        if (texto.contains("import '$pacote")) {
          proibidos.add('${f.path} importa $pacote');
        }
      }
    }
    expect(proibidos, isEmpty, reason: proibidos.join('\n'));
  });

  test('nenhum arquivo de lib faz chamada de rede', () {
    final proibidos = <String>[];
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!f.path.endsWith('.dart') || f.path.endsWith('.g.dart')) continue;
      final texto = f.readAsStringSync();
      for (final agulha in const ['package:http/', 'HttpClient(', 'WebSocket.']) {
        if (texto.contains(agulha)) proibidos.add('${f.path} usa $agulha');
      }
    }
    expect(proibidos, isEmpty, reason: proibidos.join('\n'));
  });
}
```

- [ ] **Step 5: Rodar e confirmar verde**

```bash
flutter pub get
flutter analyze
flutter test test/trilhos_test.dart
```

Esperado: `analyze` sem issues; dois testes passando. `lib/domain` ainda não existe —
o primeiro teste sai cedo e passa, e volta a ter dente na Task 2.

- [ ] **Step 6: Apagar o teste de exemplo**

`flutter create` gera `test/widget_test.dart` apontando para um contador que não existe
mais. Remover:

```bash
rm test/widget_test.dart
```

- [ ] **Step 7: Criar a keystore e a config de assinatura**

A assinatura vem **agora**, não no fim. Dois motivos: o Isac quer APK instalável a
cada tarefa visual (ver **Checkpoints de APK** nas Global Constraints), e o problema
de Java precisa aparecer no primeiro build, não no vigésimo terceiro.

Reaproveitar a keystore do `financas-app-mobile` ou criar nova:

```bash
keytool -genkey -v -keystore "$HOME/chaves/refeicoes.jks" \
  -keyalg RSA -keysize 2048 -validity 10000 -alias refeicoes
```

Guardar a senha. Perder a keystore = nunca mais atualizar o app instalado.

`android/key.properties` (barra normal, mesmo no Windows):

```properties
storePassword=SUA_SENHA
keyPassword=SUA_SENHA
keyAlias=refeicoes
storeFile=C:/Users/Usuario/chaves/refeicoes.jks
```

Acrescentar ao `.gitignore` da raiz **antes** de qualquer commit que toque em `android/`:

```
android/key.properties
*.jks
*.keystore
```

Em `android/app/build.gradle.kts`, antes do bloco `android {`:

```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
```

E dentro de `android { ... }`:

```kotlin
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
```

Trocar também o rótulo em `android/app/src/main/AndroidManifest.xml`:

```xml
android:label="Refeições"
```

E conferir que **não** existe `<uses-permission android:name="android.permission.INTERNET"/>`
fora do bloco de debug. Se houver, remover — o app não usa rede.

- [ ] **Step 8: Provar a cadeia de build (o primeiro APK)**

```bash
flutter build apk --release
```

Esperado: `Built build/app/outputs/flutter-apk/app-release.apk`.

O app ainda é o contador padrão do `flutter create` — o valor deste passo é
**descobrir agora** que a cadeia funciona. Se o Gradle reclamar de versão de Java, é
o Java 8 no PATH (verificado nesta máquina: `1.8.0_251`); o Gradle precisa de JDK 17+:

```bash
flutter config --jdk-dir "C:/Program Files/Android/Android Studio/jbr"
```

Repetir o build até passar. **Não seguir para a Task 2 com o build quebrado** — todas
as tarefas visuais dependem dele.

- [ ] **Step 9: Conferir que a assinatura é de release, não de debug**

```bash
"$ANDROID_HOME/build-tools/36.0.0/apksigner" verify --print-certs \
  build/app/outputs/flutter-apk/app-release.apk
```

Esperado: certificado listado, sem aviso de chave de debug. Se apontar debug, o
`key.properties` não foi lido — conferir o caminho de `storeFile`.

- [ ] **Step 10: Commit**

```bash
git init
git add -A
git commit -m "chore: scaffold Flutter com drift, riverpod, lint e assinatura de release"
```

Confirmar que o segredo **não** entrou:

```bash
git show --stat HEAD | grep -c key.properties
```

Esperado: `0`. Se der `1`, desfazer o commit antes de seguir.

---

### Task 2: Modelos e vocabulário do domínio

**Files:**
- Create: `lib/domain/modelos.dart`
- Test: `test/modelos_test.dart`

**Interfaces:**
- Consumes: nada
- Produces:
  - `enum SlotRefeicao { cafeManha, almoco, cafeTarde, jantar }`
  - `enum TipoCombo { cafe, refeicao }`
  - `enum CategoriaReceita { base, proteina, leguminosa, vegetal, salada, molho, bebida, pao, fruta }`
  - `enum Unidade { g, ml, unidade, colherSopa, colherCha, xicara, dente, fatia, folha, pitada, aGosto }`
  - `enum SecaoMercado { hortifruti, acougue, padaria, laticinios, mercearia, congelados, bebidas }`
  - `enum UnidadeCompra { kg, litro, unidade }`
  - `const Set<Unidade> unidadesDiscretas`, `const Set<Unidade> unidadesSemMedida`
  - `extension type const DataPura(String iso)` com `DataPura.de(DateTime)`, `.comoDateTime`, `.rotuloCurto`
  - `class Nutrientes` com `zero`, `operator +`, `escalar(double)`
  - `class RefeicaoResolvida`

- [ ] **Step 1: Escrever os testes que falham**

`test/modelos_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  group('DataPura', () {
    test('formata com zero a esquerda', () {
      expect(DataPura.de(DateTime(2026, 9, 4)).iso, '2026-09-04');
      expect(DataPura.de(DateTime(2026, 12, 31)).iso, '2026-12-31');
    });

    test('ida e volta preserva o dia', () {
      final d = DataPura.de(DateTime(2027, 1, 5));
      expect(d.comoDateTime, DateTime.utc(2027, 1, 5));
    });

    test('ignora a hora do DateTime de origem', () {
      final cedo = DataPura.de(DateTime(2026, 9, 4, 0, 1));
      final tarde = DataPura.de(DateTime(2026, 9, 4, 23, 59));
      expect(cedo, tarde);
    });
  });

  group('Nutrientes', () {
    const a = Nutrientes(kcal: 100, carboidrato: 10, proteina: 5,
        gordura: 2, fibra: 1, sodio: 50);

    test('soma campo a campo', () {
      final s = a + a;
      expect(s.kcal, 200);
      expect(s.proteina, 10);
      expect(s.sodio, 100);
    });

    test('zero e elemento neutro', () {
      expect((a + Nutrientes.zero).kcal, a.kcal);
      expect((a + Nutrientes.zero).sodio, a.sodio);
    });

    test('escalar multiplica todos os campos', () {
      final m = a.escalar(0.5);
      expect(m.kcal, 50);
      expect(m.carboidrato, 5);
      expect(m.fibra, 0.5);
    });
  });

  group('conjuntos de unidade', () {
    test('discretas sao exatamente as quatro contaveis', () {
      expect(unidadesDiscretas, {
        Unidade.unidade, Unidade.dente, Unidade.fatia, Unidade.folha,
      });
    });

    test('sem medida sao pitada e a gosto', () {
      expect(unidadesSemMedida, {Unidade.pitada, Unidade.aGosto});
    });

    test('grama nao e discreta nem sem medida', () {
      expect(unidadesDiscretas.contains(Unidade.g), isFalse);
      expect(unidadesSemMedida.contains(Unidade.g), isFalse);
    });
  });
}
```

- [ ] **Step 2: Rodar e ver falhar**

```bash
flutter test test/modelos_test.dart
```

Esperado: FAIL — `Target of URI doesn't exist: 'package:refeicoes_app/domain/modelos.dart'`.

- [ ] **Step 3: Escrever os modelos**

`lib/domain/modelos.dart`:

```dart
/// Vocabulário do domínio. Dart puro: nada aqui conhece Flutter nem banco.
library;

enum SlotRefeicao { cafeManha, almoco, cafeTarde, jantar }

enum TipoCombo { cafe, refeicao }

enum CategoriaReceita {
  base, proteina, leguminosa, vegetal, salada, molho, bebida, pao, fruta,
}

enum Unidade {
  g, ml, unidade, colherSopa, colherCha, xicara, dente, fatia, folha,
  pitada, aGosto,
}

enum SecaoMercado {
  hortifruti, acougue, padaria, laticinios, mercearia, congelados, bebidas,
}

enum UnidadeCompra { kg, litro, unidade }

/// Unidades que só existem em número inteiro. Meio ovo não vai na panela.
const Set<Unidade> unidadesDiscretas = {
  Unidade.unidade, Unidade.dente, Unidade.fatia, Unidade.folha,
};

/// Unidades sem medida: não escalam e não somam nutriente (spec 8.2).
const Set<Unidade> unidadesSemMedida = {Unidade.pitada, Unidade.aGosto};

/// Data pura (ano-mês-dia), sem hora e sem fuso. Guardada como ISO `YYYY-MM-DD`,
/// que é também a forma persistida no banco.
extension type const DataPura(String iso) {
  factory DataPura.de(DateTime d) {
    final ano = d.year.toString().padLeft(4, '0');
    final mes = d.month.toString().padLeft(2, '0');
    final dia = d.day.toString().padLeft(2, '0');
    return DataPura('$ano-$mes-$dia');
  }

  /// Sempre UTC — é o que impede diferença de dias de errar por fuso.
  DateTime get comoDateTime {
    final p = iso.split('-');
    return DateTime.utc(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
  }

  String get rotuloCurto {
    final p = iso.split('-');
    return '${p[2]}/${p[1]}';
  }
}

/// Valores nutricionais absolutos de uma porção já escalada.
class Nutrientes {
  final double kcal;
  final double carboidrato;
  final double proteina;
  final double gordura;
  final double fibra;
  final double sodio;

  const Nutrientes({
    required this.kcal,
    required this.carboidrato,
    required this.proteina,
    required this.gordura,
    required this.fibra,
    required this.sodio,
  });

  static const Nutrientes zero = Nutrientes(
    kcal: 0, carboidrato: 0, proteina: 0, gordura: 0, fibra: 0, sodio: 0,
  );

  Nutrientes operator +(Nutrientes o) => Nutrientes(
        kcal: kcal + o.kcal,
        carboidrato: carboidrato + o.carboidrato,
        proteina: proteina + o.proteina,
        gordura: gordura + o.gordura,
        fibra: fibra + o.fibra,
        sodio: sodio + o.sodio,
      );

  Nutrientes escalar(double f) => Nutrientes(
        kcal: kcal * f,
        carboidrato: carboidrato * f,
        proteina: proteina * f,
        gordura: gordura * f,
        fibra: fibra * f,
        sodio: sodio * f,
      );
}

/// O que o motor devolve para um par (data, slot).
class RefeicaoResolvida {
  final SlotRefeicao slot;
  final int porcoes;
  final int comboId;
  final List<int> receitaIds;

  /// Falso quando este slot tem substituição própria e por isso deixou de
  /// espelhar o slot base.
  final bool espelhoIntacto;

  const RefeicaoResolvida({
    required this.slot,
    required this.porcoes,
    required this.comboId,
    required this.receitaIds,
    required this.espelhoIntacto,
  });
}
```

- [ ] **Step 4: Rodar e ver passar**

```bash
flutter test test/modelos_test.dart test/trilhos_test.dart
flutter analyze
```

Esperado: todos verdes. O teste de trilhos agora tem `lib/domain/` de verdade para
varrer e continua passando.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/modelos.dart test/modelos_test.dart
git commit -m "feat(domain): vocabulario do dominio, DataPura e Nutrientes"
```

---

### Task 3: Posição no ciclo

**Files:**
- Create: `lib/domain/ciclo.dart`
- Test: `test/ciclo_test.dart`

**Interfaces:**
- Consumes: `DataPura` de `modelos.dart`
- Produces: `int posicaoNoCiclo({required DataPura inicio, required DataPura data, required int tamanho})` — devolve 1..tamanho

- [ ] **Step 1: Escrever os testes que falham**

O caso decisivo é a data anterior ao início: `-1 % 33` em Dart devolve `-1`, e sem o
módulo duplo a função devolveria `0` ou negativo, quebrando a navegação para trás.

`test/ciclo_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/ciclo.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  const inicio = DataPura('2026-09-01');
  int pos(String iso) =>
      posicaoNoCiclo(inicio: inicio, data: DataPura(iso), tamanho: 33);

  test('o dia do inicio e a posicao 1', () {
    expect(pos('2026-09-01'), 1);
  });

  test('avanca um por dia', () {
    expect(pos('2026-09-02'), 2);
    expect(pos('2026-09-04'), 4);
  });

  test('o ultimo dia do ciclo e 33', () {
    expect(pos('2026-10-03'), 33);
  });

  test('depois do 33 volta para 1', () {
    expect(pos('2026-10-04'), 1);
    expect(pos('2026-10-05'), 2);
  });

  test('data anterior ao inicio nao devolve zero nem negativo', () {
    expect(pos('2026-08-31'), 33);
    expect(pos('2026-08-30'), 32);
    expect(pos('2026-07-30'), 1);
  });

  test('atravessa a virada de ano', () {
    const natal = DataPura('2026-12-20');
    expect(
      posicaoNoCiclo(
          inicio: natal, data: const DataPura('2027-01-05'), tamanho: 33),
      17,
    );
  });

  test('respeita ano bissexto', () {
    expect(
      posicaoNoCiclo(
          inicio: const DataPura('2028-02-28'),
          data: const DataPura('2028-03-01'),
          tamanho: 33),
      3,
    );
  });

  test('o tamanho e parametro, nao constante', () {
    expect(
      posicaoNoCiclo(
          inicio: inicio, data: const DataPura('2026-09-08'), tamanho: 7),
      1,
    );
  });

  test('sempre devolve entre 1 e o tamanho', () {
    for (var i = -400; i < 400; i++) {
      final d = DataPura.de(inicio.comoDateTime.add(Duration(days: i)));
      final p = posicaoNoCiclo(inicio: inicio, data: d, tamanho: 33);
      expect(p, inInclusiveRange(1, 33), reason: 'falhou em ${d.iso}');
    }
  });
}
```

- [ ] **Step 2: Rodar e ver falhar**

```bash
flutter test test/ciclo_test.dart
```

Esperado: FAIL — `Target of URI doesn't exist: '.../domain/ciclo.dart'`.

- [ ] **Step 3: Implementar**

`lib/domain/ciclo.dart`:

```dart
import 'modelos.dart';

/// Posição de uma data dentro do ciclo, de 1 a [tamanho].
///
/// Atenção ao operador: em Dart, `%` sobre `int` é **euclidiano** — o resultado
/// é sempre em `[0, tamanho)` mesmo para dias negativos (`-2 % 33 == 31`).
/// Isso difere de C, Java e JavaScript. Quem quer o resto truncado usa
/// `remainder()`, que devolveria `-2` e quebraria a navegação para datas
/// anteriores ao início do ciclo.
///
/// O módulo duplo abaixo é redundante nesta linguagem, e fica de propósito:
/// custa nada e protege se alguém trocar `%` por `remainder()`. O teste de
/// varredura de 800 dias é o que guarda essa promessa.
int posicaoNoCiclo({
  required DataPura inicio,
  required DataPura data,
  required int tamanho,
}) {
  assert(tamanho > 0, 'tamanho do ciclo precisa ser positivo');
  final dias = data.comoDateTime.difference(inicio.comoDateTime).inDays;
  return ((dias % tamanho) + tamanho) % tamanho + 1;
}
```

- [ ] **Step 4: Rodar e ver passar**

```bash
flutter test test/ciclo_test.dart
```

Esperado: 9 testes passando, incluindo a varredura de 800 dias.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/ciclo.dart test/ciclo_test.dart
git commit -m "feat(domain): posicao no ciclo com modulo duplo para datas passadas"
```

---

### Task 4: Espelho de refeições

**Files:**
- Create: `lib/domain/espelho.dart`
- Test: `test/espelho_test.dart`

**Interfaces:**
- Consumes: `SlotRefeicao`, `TipoCombo` de `modelos.dart`
- Produces: `SlotRefeicao slotBase(SlotRefeicao)`, `bool ehEspelhado(SlotRefeicao)`, `TipoCombo tipoDoSlot(SlotRefeicao)`

- [ ] **Step 1: Escrever os testes que falham**

`test/espelho_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/espelho.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  test('cafe da tarde espelha o cafe da manha', () {
    expect(slotBase(SlotRefeicao.cafeTarde), SlotRefeicao.cafeManha);
  });

  test('jantar espelha o almoco', () {
    expect(slotBase(SlotRefeicao.jantar), SlotRefeicao.almoco);
  });

  test('slots base sao base de si mesmos', () {
    expect(slotBase(SlotRefeicao.cafeManha), SlotRefeicao.cafeManha);
    expect(slotBase(SlotRefeicao.almoco), SlotRefeicao.almoco);
  });

  test('ehEspelhado separa os dois pares', () {
    expect(ehEspelhado(SlotRefeicao.cafeTarde), isTrue);
    expect(ehEspelhado(SlotRefeicao.jantar), isTrue);
    expect(ehEspelhado(SlotRefeicao.cafeManha), isFalse);
    expect(ehEspelhado(SlotRefeicao.almoco), isFalse);
  });

  test('o espelho nao e circular', () {
    for (final s in SlotRefeicao.values) {
      expect(slotBase(slotBase(s)), slotBase(s),
          reason: 'slotBase precisa ser idempotente para $s');
    }
  });

  test('tipo do slot agrupa cafes e refeicoes', () {
    expect(tipoDoSlot(SlotRefeicao.cafeManha), TipoCombo.cafe);
    expect(tipoDoSlot(SlotRefeicao.cafeTarde), TipoCombo.cafe);
    expect(tipoDoSlot(SlotRefeicao.almoco), TipoCombo.refeicao);
    expect(tipoDoSlot(SlotRefeicao.jantar), TipoCombo.refeicao);
  });
}
```

- [ ] **Step 2: Rodar e ver falhar**

```bash
flutter test test/espelho_test.dart
```

Esperado: FAIL — arquivo inexistente.

- [ ] **Step 3: Implementar**

`lib/domain/espelho.dart`:

```dart
import 'modelos.dart';

/// O slot de onde este slot herda conteúdo. Café da tarde repete o café da
/// manhã e o jantar repete o almoço — é o que o plano de origem já faz.
SlotRefeicao slotBase(SlotRefeicao slot) => switch (slot) {
      SlotRefeicao.cafeTarde => SlotRefeicao.cafeManha,
      SlotRefeicao.jantar => SlotRefeicao.almoco,
      SlotRefeicao.cafeManha => SlotRefeicao.cafeManha,
      SlotRefeicao.almoco => SlotRefeicao.almoco,
    };

bool ehEspelhado(SlotRefeicao slot) => slotBase(slot) != slot;

/// Qual pool do ciclo alimenta este slot.
TipoCombo tipoDoSlot(SlotRefeicao slot) =>
    slotBase(slot) == SlotRefeicao.cafeManha
        ? TipoCombo.cafe
        : TipoCombo.refeicao;
```

- [ ] **Step 4: Rodar e ver passar**

```bash
flutter test test/espelho_test.dart
```

Esperado: 6 testes passando.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/espelho.dart test/espelho_test.dart
git commit -m "feat(domain): espelho de cafe da tarde e jantar"
```

---

### Task 5: Porções por slot e dia da semana

**Files:**
- Create: `lib/domain/porcoes.dart`
- Test: `test/porcoes_test.dart`

**Interfaces:**
- Consumes: `SlotRefeicao`, `DataPura` de `modelos.dart`
- Produces: `bool ehDiaUtil(DataPura)`, `int porcoesDoSlot({required SlotRefeicao slot, required DataPura data, required Map<(SlotRefeicao, bool), int> regras})`, `const Map<(SlotRefeicao, bool), int> regrasPadrao`

- [ ] **Step 1: Escrever os testes que falham**

`test/porcoes_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/domain/porcoes.dart';

void main() {
  // 2026-09-04 e uma sexta; 2026-09-05 sabado; 2026-09-06 domingo;
  // 2026-09-07 segunda.
  const sexta = DataPura('2026-09-04');
  const sabado = DataPura('2026-09-05');
  const domingo = DataPura('2026-09-06');
  const segunda = DataPura('2026-09-07');

  int p(SlotRefeicao s, DataPura d) =>
      porcoesDoSlot(slot: s, data: d, regras: regrasPadrao);

  test('reconhece dia util', () {
    expect(ehDiaUtil(sexta), isTrue);
    expect(ehDiaUtil(segunda), isTrue);
    expect(ehDiaUtil(sabado), isFalse);
    expect(ehDiaUtil(domingo), isFalse);
  });

  test('durante a semana ela almoca sozinha', () {
    expect(p(SlotRefeicao.cafeManha, sexta), 1);
    expect(p(SlotRefeicao.almoco, sexta), 1);
  });

  test('durante a semana a tarde e a noite sao dois', () {
    expect(p(SlotRefeicao.cafeTarde, sexta), 2);
    expect(p(SlotRefeicao.jantar, sexta), 2);
  });

  test('no fim de semana tudo e dois', () {
    for (final slot in SlotRefeicao.values) {
      expect(p(slot, sabado), 2, reason: '$slot no sabado');
      expect(p(slot, domingo), 2, reason: '$slot no domingo');
    }
  });

  test('regrasPadrao cobre as oito combinacoes', () {
    expect(regrasPadrao.length, 8);
    for (final slot in SlotRefeicao.values) {
      for (final util in [true, false]) {
        expect(regrasPadrao.containsKey((slot, util)), isTrue,
            reason: 'falta ($slot, $util)');
      }
    }
  });

  test('aceita regra customizada', () {
    const custom = {
      (SlotRefeicao.almoco, true): 3,
      (SlotRefeicao.almoco, false): 4,
    };
    expect(
        porcoesDoSlot(
            slot: SlotRefeicao.almoco, data: sexta, regras: custom),
        3);
    expect(
        porcoesDoSlot(
            slot: SlotRefeicao.almoco, data: sabado, regras: custom),
        4);
  });

  test('regra faltando cai em uma porcao em vez de estourar', () {
    expect(
        porcoesDoSlot(
            slot: SlotRefeicao.jantar, data: sexta, regras: const {}),
        1);
  });
}
```

- [ ] **Step 2: Rodar e ver falhar**

```bash
flutter test test/porcoes_test.dart
```

Esperado: FAIL — arquivo inexistente.

- [ ] **Step 3: Implementar**

`lib/domain/porcoes.dart`:

```dart
import 'modelos.dart';

/// Segunda a sexta. Sábado e domingo são fim de semana.
bool ehDiaUtil(DataPura data) {
  final d = data.comoDateTime.weekday;
  return d >= DateTime.monday && d <= DateTime.friday;
}

/// Quantas porções este slot rende nesta data.
///
/// Regra ausente cai em 1 em vez de estourar: uma tabela incompleta no banco
/// não pode impedir a tela de abrir.
int porcoesDoSlot({
  required SlotRefeicao slot,
  required DataPura data,
  required Map<(SlotRefeicao, bool), int> regras,
}) =>
    regras[(slot, ehDiaUtil(data))] ?? 1;

/// Semente da tabela `regra_porcao`.
///
/// De manhã e no almoço ela está sozinha durante a semana; à tarde e à noite
/// são dois. No fim de semana são dois o dia todo.
const Map<(SlotRefeicao, bool), int> regrasPadrao = {
  (SlotRefeicao.cafeManha, true): 1,
  (SlotRefeicao.cafeManha, false): 2,
  (SlotRefeicao.almoco, true): 1,
  (SlotRefeicao.almoco, false): 2,
  (SlotRefeicao.cafeTarde, true): 2,
  (SlotRefeicao.cafeTarde, false): 2,
  (SlotRefeicao.jantar, true): 2,
  (SlotRefeicao.jantar, false): 2,
};
```

- [ ] **Step 4: Rodar e ver passar**

```bash
flutter test test/porcoes_test.dart
```

Esperado: 7 testes passando.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/porcoes.dart test/porcoes_test.dart
git commit -m "feat(domain): porcoes por slot e dia da semana"
```

---

### Task 6: Escalonamento de quantidade

**Files:**
- Create: `lib/domain/escalonamento.dart`
- Test: `test/escalonamento_test.dart`

**Interfaces:**
- Consumes: `Unidade`, `unidadesDiscretas`, `unidadesSemMedida` de `modelos.dart`
- Produces: `double escalarQuantidade({required double quantidade, required Unidade unidade, required int porcoes, required int rendimento})`

- [ ] **Step 1: Escrever os testes que falham**

`test/escalonamento_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/escalonamento.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  double e(double q, Unidade u, int porcoes, int rendimento) =>
      escalarQuantidade(
          quantidade: q, unidade: u, porcoes: porcoes, rendimento: rendimento);

  test('unidade continua multiplica direto', () {
    expect(e(120, Unidade.g, 2, 1), 240);
    expect(e(200, Unidade.ml, 2, 1), 400);
  });

  test('unidade continua mantem o decimal', () {
    expect(e(100, Unidade.g, 3, 2), 150);
    expect(e(1, Unidade.colherSopa, 3, 2), 1.5);
  });

  test('unidade discreta arredonda para cima', () {
    expect(e(1, Unidade.unidade, 3, 2), 2);
    expect(e(1, Unidade.dente, 3, 2), 2);
    expect(e(2, Unidade.fatia, 3, 2), 3);
  });

  test('discreta que da inteiro exato nao infla', () {
    expect(e(1, Unidade.unidade, 2, 1), 2);
    expect(e(3, Unidade.unidade, 1, 1), 3);
  });

  test('a gosto e pitada nao escalam', () {
    expect(e(1, Unidade.aGosto, 4, 1), 1);
    expect(e(1, Unidade.pitada, 4, 1), 1);
  });

  test('reduzir porcao tambem funciona', () {
    expect(e(400, Unidade.g, 1, 4), 100);
  });

  test('reduzir discreta ainda arredonda para cima', () {
    // meia unidade continua sendo uma unidade inteira na panela
    expect(e(1, Unidade.unidade, 1, 2), 1);
  });

  test('rendimento zero nao divide por zero', () {
    expect(e(100, Unidade.g, 2, 0), 100);
  });
}
```

- [ ] **Step 2: Rodar e ver falhar**

```bash
flutter test test/escalonamento_test.dart
```

Esperado: FAIL — arquivo inexistente.

- [ ] **Step 3: Implementar**

`lib/domain/escalonamento.dart`:

```dart
import 'dart:math' as math;

import 'modelos.dart';

/// Ajusta a quantidade de um ingrediente para o número de porções do slot.
///
/// Unidade discreta arredonda para cima: meio ovo não vai na panela.
/// Unidade contínua mantém o decimal — o arredondamento fica para a exibição.
/// `pitada` e `aGosto` não escalam (spec 7).
double escalarQuantidade({
  required double quantidade,
  required Unidade unidade,
  required int porcoes,
  required int rendimento,
}) {
  if (unidadesSemMedida.contains(unidade)) return quantidade;
  if (rendimento <= 0) return quantidade;

  // Multiplica ANTES de dividir. Calcular a razão `porcoes / rendimento`
  // primeiro introduz erro de ponto flutuante que empurra resultados exatos
  // para cima da fronteira inteira, e o `ceil()` abaixo então erra por 1:
  // `21 * (9 / 7)` dá 27.000000000000004 e arredonda para 28, não 27.
  final bruto = quantidade * porcoes / rendimento;
  if (unidadesDiscretas.contains(unidade)) {
    return math.max(1, bruto.ceil()).toDouble();
  }
  return bruto;
}
```

- [ ] **Step 4: Rodar e ver passar**

```bash
flutter test test/escalonamento_test.dart
```

Esperado: 8 testes passando.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/escalonamento.dart test/escalonamento_test.dart
git commit -m "feat(domain): escalonamento com arredondamento de unidade discreta"
```

---

### Task 7: Nutrição

**Files:**
- Create: `lib/domain/nutricao.dart`
- Test: `test/nutricao_test.dart`

**Interfaces:**
- Consumes: `Unidade`, `unidadesSemMedida`, `Nutrientes` de `modelos.dart`
- Produces:
  - `class ConversaoAusente implements Exception` com campos `alimentoId`, `unidade`
  - `double emGramas({required Unidade unidade, required double quantidade, required Map<Unidade, double> conversoes, required int alimentoId})`
  - `Nutrientes nutrienteDe({required Nutrientes por100g, required double gramas})`

- [ ] **Step 1: Escrever os testes que falham**

`test/nutricao_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/domain/nutricao.dart';

void main() {
  const conversoesOvo = {Unidade.g: 1.0, Unidade.unidade: 50.0};

  group('emGramas', () {
    test('grama passa pela tabela, sem atalho', () {
      expect(
          emGramas(
              unidade: Unidade.g,
              quantidade: 150,
              conversoes: conversoesOvo,
              alimentoId: 1),
          150);
    });

    test('unidade converte pela tabela', () {
      expect(
          emGramas(
              unidade: Unidade.unidade,
              quantidade: 2,
              conversoes: conversoesOvo,
              alimentoId: 1),
          100);
    });

    test('a gosto vale zero grama', () {
      expect(
          emGramas(
              unidade: Unidade.aGosto,
              quantidade: 1,
              conversoes: conversoesOvo,
              alimentoId: 1),
          0);
    });

    test('conversao faltando estoura alto, nao devolve zero calado', () {
      expect(
        () => emGramas(
            unidade: Unidade.xicara,
            quantidade: 1,
            conversoes: conversoesOvo,
            alimentoId: 7),
        throwsA(isA<ConversaoAusente>()
            .having((e) => e.alimentoId, 'alimentoId', 7)
            .having((e) => e.unidade, 'unidade', Unidade.xicara)),
      );
    });
  });

  group('nutrienteDe', () {
    const arrozPor100g = Nutrientes(
        kcal: 128, carboidrato: 28.1, proteina: 2.5,
        gordura: 0.2, fibra: 1.6, sodio: 1);

    test('cem gramas devolve a tabela inteira', () {
      final n = nutrienteDe(por100g: arrozPor100g, gramas: 100);
      expect(n.kcal, closeTo(128, 0.001));
      expect(n.proteina, closeTo(2.5, 0.001));
    });

    test('escala proporcional a grama', () {
      final n = nutrienteDe(por100g: arrozPor100g, gramas: 240);
      expect(n.kcal, closeTo(307.2, 0.01));
      expect(n.carboidrato, closeTo(67.44, 0.01));
    });

    test('zero grama devolve zero nutriente', () {
      final n = nutrienteDe(por100g: arrozPor100g, gramas: 0);
      expect(n.kcal, 0);
      expect(n.sodio, 0);
    });

    test('soma de ingredientes acumula', () {
      final total = nutrienteDe(por100g: arrozPor100g, gramas: 100) +
          nutrienteDe(por100g: arrozPor100g, gramas: 100);
      expect(total.kcal, closeTo(256, 0.001));
    });
  });
}
```

- [ ] **Step 2: Rodar e ver falhar**

```bash
flutter test test/nutricao_test.dart
```

Esperado: FAIL — arquivo inexistente.

- [ ] **Step 3: Implementar**

`lib/domain/nutricao.dart`:

```dart
import 'modelos.dart';

/// Falta uma linha em `conversao_unidade` para este par alimento/unidade.
///
/// Estoura de propósito: devolver zero calado esconderia caloria faltando na
/// tela, que é pior do que quebrar durante a carga da semente.
class ConversaoAusente implements Exception {
  final int alimentoId;
  final Unidade unidade;

  const ConversaoAusente(this.alimentoId, this.unidade);

  @override
  String toString() =>
      'ConversaoAusente: alimento $alimentoId nao tem conversao para '
      '${unidade.name}';
}

/// Converte uma quantidade para gramas (ou mililitros) usando a tabela.
///
/// Grama também passa pela tabela, sem atalho no código: o cálculo tem um
/// caminho só, e conversão faltando aparece sempre do mesmo jeito.
double emGramas({
  required Unidade unidade,
  required double quantidade,
  required Map<Unidade, double> conversoes,
  required int alimentoId,
}) {
  if (unidadesSemMedida.contains(unidade)) return 0;

  final gramasPorUnidade = conversoes[unidade];
  if (gramasPorUnidade == null) {
    throw ConversaoAusente(alimentoId, unidade);
  }
  return quantidade * gramasPorUnidade;
}

/// Nutrientes de uma massa a partir da tabela por 100 g.
Nutrientes nutrienteDe({
  required Nutrientes por100g,
  required double gramas,
}) =>
    por100g.escalar(gramas / 100);
```

- [ ] **Step 4: Rodar e ver passar**

```bash
flutter test test/nutricao_test.dart
flutter analyze
```

Esperado: 8 testes passando, analyze limpo.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/nutricao.dart test/nutricao_test.dart
git commit -m "feat(domain): conversao para grama e calculo nutricional"
```

---

### Task 8: Resolução da refeição

Esta é a tarefa central do domínio. É onde ciclo, espelho e as duas camadas de
substituição se encontram, e é a única regra da spec com ambiguidade real
(seção 6.3): **um slot que já se soltou do espelho não herda mais nada dele.**

**Files:**
- Create: `lib/domain/resolucao.dart`
- Test: `test/resolucao_test.dart`

**Interfaces:**
- Consumes: `slotBase`, `tipoDoSlot` de `espelho.dart`; `SlotRefeicao`, `TipoCombo`, `DataPura`, `RefeicaoResolvida` de `modelos.dart`
- Produces:
  ```dart
  RefeicaoResolvida resolverRefeicao({
    required DataPura data,
    required SlotRefeicao slot,
    required int posicao,
    required int porcoes,
    required Map<(int, TipoCombo), int> ciclo,
    required Map<int, List<int>> componentesDoCombo,
    required Map<(DataPura, SlotRefeicao), int> overridesCombo,
    required Map<(DataPura, SlotRefeicao), Map<int, int?>> overridesComponente,
  })
  ```

- [ ] **Step 1: Escrever os testes que falham**

`test/resolucao_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/domain/resolucao.dart';

void main() {
  const data = DataPura('2026-09-04');

  // ciclo minimo: posicao 4 tem cafe 40 e refeicao 41
  const ciclo = {
    (4, TipoCombo.cafe): 40,
    (4, TipoCombo.refeicao): 41,
  };

  // combo 40 = [tapioca 1, mamao 2, suco 3]
  // combo 41 = [arroz 10, feijao 11, picadinho 12, batata 13, salada 14]
  // combo 99 = [strogonoff 20, arroz 10]
  const componentes = {
    40: [1, 2, 3],
    41: [10, 11, 12, 13, 14],
    99: [20, 10],
  };

  RefeicaoResolvida r(
    SlotRefeicao slot, {
    Map<(DataPura, SlotRefeicao), int> combos = const {},
    Map<(DataPura, SlotRefeicao), Map<int, int?>> comps = const {},
    int porcoes = 1,
  }) =>
      resolverRefeicao(
        data: data,
        slot: slot,
        posicao: 4,
        porcoes: porcoes,
        ciclo: ciclo,
        componentesDoCombo: componentes,
        overridesCombo: combos,
        overridesComponente: comps,
      );

  group('sem nenhuma excecao', () {
    test('cafe da manha pega o combo de cafe do ciclo', () {
      final res = r(SlotRefeicao.cafeManha);
      expect(res.comboId, 40);
      expect(res.receitaIds, [1, 2, 3]);
      expect(res.espelhoIntacto, isTrue);
    });

    test('almoco pega o combo de refeicao do ciclo', () {
      expect(r(SlotRefeicao.almoco).comboId, 41);
    });

    test('cafe da tarde espelha o cafe da manha', () {
      final res = r(SlotRefeicao.cafeTarde);
      expect(res.comboId, 40);
      expect(res.receitaIds, [1, 2, 3]);
      expect(res.espelhoIntacto, isTrue);
    });

    test('jantar espelha o almoco', () {
      expect(r(SlotRefeicao.jantar).comboId, 41);
    });

    test('carrega as porcoes recebidas', () {
      expect(r(SlotRefeicao.jantar, porcoes: 2).porcoes, 2);
    });
  });

  group('substituicao de combo', () {
    test('override no almoco troca o combo', () {
      final res = r(SlotRefeicao.almoco,
          combos: {(data, SlotRefeicao.almoco): 99});
      expect(res.comboId, 99);
      expect(res.receitaIds, [20, 10]);
    });

    test('override no almoco arrasta o jantar junto', () {
      final res = r(SlotRefeicao.jantar,
          combos: {(data, SlotRefeicao.almoco): 99});
      expect(res.comboId, 99, reason: 'o espelho ainda esta intacto');
      expect(res.espelhoIntacto, isTrue);
    });

    test('override no jantar solta o espelho', () {
      final res = r(SlotRefeicao.jantar,
          combos: {(data, SlotRefeicao.jantar): 99});
      expect(res.comboId, 99);
      expect(res.espelhoIntacto, isFalse);
    });

    test('override no jantar nao volta para o almoco', () {
      final res = r(SlotRefeicao.almoco,
          combos: {(data, SlotRefeicao.jantar): 99});
      expect(res.comboId, 41, reason: 'o almoco continua o do ciclo');
    });

    test('override proprio vence o override do slot base', () {
      final res = r(SlotRefeicao.jantar, combos: {
        (data, SlotRefeicao.almoco): 99,
        (data, SlotRefeicao.jantar): 40,
      });
      expect(res.comboId, 40);
      expect(res.espelhoIntacto, isFalse);
    });
  });

  group('substituicao de componente', () {
    test('troca um componente e preserva a ordem', () {
      final res = r(SlotRefeicao.almoco, comps: {
        (data, SlotRefeicao.almoco): {12: 20},
      });
      expect(res.receitaIds, [10, 11, 20, 13, 14]);
    });

    test('componente com destino nulo e removido', () {
      final res = r(SlotRefeicao.almoco, comps: {
        (data, SlotRefeicao.almoco): {14: null},
      });
      expect(res.receitaIds, [10, 11, 12, 13]);
    });

    test('troca no almoco reflete no jantar com espelho intacto', () {
      final res = r(SlotRefeicao.jantar, comps: {
        (data, SlotRefeicao.almoco): {12: 20},
      });
      expect(res.receitaIds, [10, 11, 20, 13, 14]);
    });

    test('slot com override de combo proprio nao herda componente do base', () {
      final res = r(SlotRefeicao.jantar,
          combos: {(data, SlotRefeicao.jantar): 41},
          comps: {
            (data, SlotRefeicao.almoco): {12: 20},
          });
      expect(res.receitaIds, [10, 11, 12, 13, 14],
          reason: 'o jantar se soltou do espelho e ignora o almoco');
    });

    test('camada do slot roda depois da camada do base', () {
      final res = r(SlotRefeicao.jantar, comps: {
        (data, SlotRefeicao.almoco): {12: 20},
        (data, SlotRefeicao.jantar): {20: 13},
      });
      expect(res.receitaIds, [10, 11, 13, 13, 14]);
    });

    test('substituicao de componente sozinha nao solta o espelho', () {
      final res = r(SlotRefeicao.jantar, comps: {
        (data, SlotRefeicao.jantar): {12: 20},
      });
      expect(res.espelhoIntacto, isTrue);
      expect(res.comboId, 41);
    });
  });

  group('falha alto', () {
    test('posicao sem combo no ciclo estoura', () {
      expect(
        () => resolverRefeicao(
          data: data,
          slot: SlotRefeicao.almoco,
          posicao: 7,
          porcoes: 1,
          ciclo: ciclo,
          componentesDoCombo: componentes,
          overridesCombo: const {},
          overridesComponente: const {},
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('combo sem componentes cadastrados estoura', () {
      expect(
        () => r(SlotRefeicao.almoco,
            combos: {(data, SlotRefeicao.almoco): 555}),
        throwsA(isA<StateError>()),
      );
    });
  });
}
```

- [ ] **Step 2: Rodar e ver falhar**

```bash
flutter test test/resolucao_test.dart
```

Esperado: FAIL — arquivo inexistente.

- [ ] **Step 3: Implementar**

`lib/domain/resolucao.dart`:

```dart
import 'espelho.dart';
import 'modelos.dart';

/// Resolve qual refeição cai em (data, slot), aplicando o ciclo e as duas
/// camadas de exceção.
///
/// Precedência do combo, primeira que casar vence:
///   1. override próprio do slot — e aqui o espelho está quebrado
///   2. override do slot base, se este slot for espelhado
///   3. o combo do ciclo na posição do dia
///
/// Depois, as substituições de componente. A regra em uma frase: um slot que
/// já se soltou do espelho não herda mais nada do espelho.
RefeicaoResolvida resolverRefeicao({
  required DataPura data,
  required SlotRefeicao slot,
  required int posicao,
  required int porcoes,
  required Map<(int, TipoCombo), int> ciclo,
  required Map<int, List<int>> componentesDoCombo,
  required Map<(DataPura, SlotRefeicao), int> overridesCombo,
  required Map<(DataPura, SlotRefeicao), Map<int, int?>> overridesComponente,
}) {
  final base = slotBase(slot);

  var espelhoIntacto = true;
  var comboId = overridesCombo[(data, slot)];

  if (comboId != null) {
    espelhoIntacto = false;
  } else if (base != slot) {
    comboId = overridesCombo[(data, base)];
  }

  comboId ??= ciclo[(posicao, tipoDoSlot(slot))] ??
      (throw StateError(
          'ciclo sem combo para posicao $posicao / ${tipoDoSlot(slot).name}'));

  final originais = componentesDoCombo[comboId] ??
      (throw StateError('combo $comboId sem componentes cadastrados'));

  // Camadas de substituição de componente, na ordem em que se aplicam.
  final camadas = <(DataPura, SlotRefeicao)>[
    if (espelhoIntacto && base != slot) (data, base),
    (data, slot),
  ];

  var receitas = List<int>.of(originais);
  for (final chave in camadas) {
    final subs = overridesComponente[chave];
    if (subs == null) continue;

    final proxima = <int>[];
    for (final id in receitas) {
      if (!subs.containsKey(id)) {
        proxima.add(id);
        continue;
      }
      final destino = subs[id];
      if (destino != null) proxima.add(destino); // nulo = removido do prato
    }
    receitas = proxima;
  }

  return RefeicaoResolvida(
    slot: slot,
    porcoes: porcoes,
    comboId: comboId,
    receitaIds: receitas,
    espelhoIntacto: espelhoIntacto,
  );
}
```

- [ ] **Step 4: Rodar e ver passar**

```bash
flutter test test/resolucao_test.dart
```

Esperado: 18 testes passando. Os que mais importam são
`override no jantar nao volta para o almoco` e
`slot com override de combo proprio nao herda componente do base`.

- [ ] **Step 5: Rodar a suíte inteira e analisar**

```bash
flutter test
flutter analyze
```

Esperado: tudo verde.

- [ ] **Step 6: Commit**

```bash
git add lib/domain/resolucao.dart test/resolucao_test.dart
git commit -m "feat(domain): resolucao de refeicao com espelho e duas camadas de override"
```

---

### Task 9: Agregação da lista de mercado

**Files:**
- Create: `lib/domain/mercado.dart`
- Test: `test/mercado_test.dart`

**Interfaces:**
- Consumes: `SecaoMercado`, `UnidadeCompra`, `Unidade` de `modelos.dart`; `emGramas` de `nutricao.dart`
- Produces:
  - `class LinhaIngrediente` — entrada da agregação (`alimentoId`, `unidade`, `quantidade`)
  - `class ItemMercado` — saída (`alimentoId`, `gramas`, `secao`, `unidadeCompra`)
  - `List<ItemMercado> agregarMercado({required List<LinhaIngrediente> linhas, required Map<int, Map<Unidade, double>> conversoes, required Map<int, SecaoMercado> secoes, required Map<int, UnidadeCompra> unidadesCompra})`
  - `({double valor, String unidade}) formatarCompra({required double gramas, required UnidadeCompra compra, required double? gramasPorUnidade})`
  - `const List<SecaoMercado> ordemSecoes`

- [ ] **Step 1: Escrever os testes que falham**

`test/mercado_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/mercado.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  // 1 arroz (kg, mercearia) · 2 ovo (unidade, mercearia) · 3 alface (un, hortifruti)
  const conversoes = {
    1: {Unidade.g: 1.0, Unidade.xicara: 180.0},
    2: {Unidade.g: 1.0, Unidade.unidade: 50.0},
    3: {Unidade.g: 1.0, Unidade.unidade: 300.0},
  };
  const secoes = {
    1: SecaoMercado.mercearia,
    2: SecaoMercado.mercearia,
    3: SecaoMercado.hortifruti,
  };
  const compras = {
    1: UnidadeCompra.kg,
    2: UnidadeCompra.unidade,
    3: UnidadeCompra.unidade,
  };

  List<ItemMercado> agregar(List<LinhaIngrediente> linhas) => agregarMercado(
        linhas: linhas,
        conversoes: conversoes,
        secoes: secoes,
        unidadesCompra: compras,
      );

  group('agregarMercado', () {
    test('soma o mesmo alimento em uma linha so', () {
      final r = agregar(const [
        LinhaIngrediente(alimentoId: 1, unidade: Unidade.g, quantidade: 120),
        LinhaIngrediente(alimentoId: 1, unidade: Unidade.g, quantidade: 240),
      ]);
      expect(r, hasLength(1));
      expect(r.single.gramas, 360);
    });

    test('soma unidades diferentes do mesmo alimento', () {
      // 2 ovos (100 g) + 100 g de ovo = 200 g
      final r = agregar(const [
        LinhaIngrediente(
            alimentoId: 2, unidade: Unidade.unidade, quantidade: 2),
        LinhaIngrediente(alimentoId: 2, unidade: Unidade.g, quantidade: 100),
      ]);
      expect(r.single.gramas, 200);
    });

    test('ignora ingrediente a gosto', () {
      final r = agregar(const [
        LinhaIngrediente(alimentoId: 1, unidade: Unidade.g, quantidade: 100),
        LinhaIngrediente(
            alimentoId: 1, unidade: Unidade.aGosto, quantidade: 1),
      ]);
      expect(r.single.gramas, 100);
    });

    test('ordena por secao seguindo o percurso do mercado', () {
      final r = agregar(const [
        LinhaIngrediente(alimentoId: 1, unidade: Unidade.g, quantidade: 100),
        LinhaIngrediente(alimentoId: 3, unidade: Unidade.g, quantidade: 300),
      ]);
      expect(r.map((e) => e.secao).toList(),
          [SecaoMercado.hortifruti, SecaoMercado.mercearia]);
    });

    test('devolve lista vazia para entrada vazia', () {
      expect(agregar(const []), isEmpty);
    });

    test('carrega secao e unidade de compra no item', () {
      final r = agregar(const [
        LinhaIngrediente(alimentoId: 2, unidade: Unidade.g, quantidade: 50),
      ]);
      expect(r.single.secao, SecaoMercado.mercearia);
      expect(r.single.unidadeCompra, UnidadeCompra.unidade);
    });
  });

  group('formatarCompra', () {
    test('vira quilo a partir de mil gramas', () {
      final f = formatarCompra(
          gramas: 1200, compra: UnidadeCompra.kg, gramasPorUnidade: null);
      expect(f.valor, closeTo(1.2, 0.001));
      expect(f.unidade, 'kg');
    });

    test('abaixo de mil continua em grama', () {
      final f = formatarCompra(
          gramas: 800, compra: UnidadeCompra.kg, gramasPorUnidade: null);
      expect(f.valor, 800);
      expect(f.unidade, 'g');
    });

    test('mil gramas exatos ja viram quilo', () {
      final f = formatarCompra(
          gramas: 1000, compra: UnidadeCompra.kg, gramasPorUnidade: null);
      expect(f.valor, 1);
      expect(f.unidade, 'kg');
    });

    test('litro segue a mesma regra', () {
      final f = formatarCompra(
          gramas: 3000, compra: UnidadeCompra.litro, gramasPorUnidade: null);
      expect(f.valor, 3);
      expect(f.unidade, 'L');
    });

    test('unidade divide pela massa e arredonda para cima', () {
      // 260 g de ovo com 50 g por ovo = 5,2 ovos = 6 ovos
      final f = formatarCompra(
          gramas: 260, compra: UnidadeCompra.unidade, gramasPorUnidade: 50);
      expect(f.valor, 6);
      expect(f.unidade, 'un');
    });

    test('unidade sem massa cadastrada cai em grama em vez de estourar', () {
      final f = formatarCompra(
          gramas: 260, compra: UnidadeCompra.unidade, gramasPorUnidade: null);
      expect(f.unidade, 'g');
    });
  });

  test('ordemSecoes cobre todas as secoes, sem repetir', () {
    expect(ordemSecoes.toSet(), SecaoMercado.values.toSet());
    expect(ordemSecoes, hasLength(SecaoMercado.values.length));
  });
}
```

- [ ] **Step 2: Rodar e ver falhar**

```bash
flutter test test/mercado_test.dart
```

Esperado: FAIL — arquivo inexistente.

- [ ] **Step 3: Implementar**

`lib/domain/mercado.dart`:

```dart
import 'dart:math' as math;

import 'modelos.dart';
import 'nutricao.dart';

/// Ordem física de um mercado, não alfabética: é o percurso que ela faz.
const List<SecaoMercado> ordemSecoes = [
  SecaoMercado.hortifruti,
  SecaoMercado.acougue,
  SecaoMercado.padaria,
  SecaoMercado.laticinios,
  SecaoMercado.mercearia,
  SecaoMercado.congelados,
  SecaoMercado.bebidas,
];

/// Uma linha de ingrediente já escalada, vinda de um dia do intervalo.
class LinhaIngrediente {
  final int alimentoId;
  final Unidade unidade;
  final double quantidade;

  const LinhaIngrediente({
    required this.alimentoId,
    required this.unidade,
    required this.quantidade,
  });
}

/// Um alimento somado ao longo do intervalo inteiro.
class ItemMercado {
  final int alimentoId;

  /// Sempre em grama (ou mililitro). A conversão para unidade de compra é
  /// assunto da exibição.
  final double gramas;
  final SecaoMercado secao;
  final UnidadeCompra unidadeCompra;

  const ItemMercado({
    required this.alimentoId,
    required this.gramas,
    required this.secao,
    required this.unidadeCompra,
  });
}

/// Soma todas as linhas por alimento e devolve na ordem do percurso do mercado.
///
/// Acumula sempre em grama — inclusive para alimento comprado por unidade.
/// É o que permite somar "2 ovos" de uma receita com "100 g de ovo" de outra
/// na mesma linha.
List<ItemMercado> agregarMercado({
  required List<LinhaIngrediente> linhas,
  required Map<int, Map<Unidade, double>> conversoes,
  required Map<int, SecaoMercado> secoes,
  required Map<int, UnidadeCompra> unidadesCompra,
}) {
  final soma = <int, double>{};

  for (final l in linhas) {
    final g = emGramas(
      unidade: l.unidade,
      quantidade: l.quantidade,
      conversoes: conversoes[l.alimentoId] ?? const {},
      alimentoId: l.alimentoId,
    );
    if (g == 0) continue; // pitada e a gosto não entram na compra
    soma.update(l.alimentoId, (v) => v + g, ifAbsent: () => g);
  }

  // Assimetria proposital com o `ConversaoAusente` acima: seção e unidade de
  // compra caem em padrão, quantidade não. Seção faltando põe o item na
  // mercearia em vez da sua prateleira — degradação cosmética, a lista continua
  // correta. Conversão faltando tornaria a QUANTIDADE desconhecida, e não há
  // padrão honesto para isso. Falha alto onde o valor não pode ser inventado;
  // degrada onde pode.
  final itens = soma.entries
      .map((e) => ItemMercado(
            alimentoId: e.key,
            gramas: e.value,
            secao: secoes[e.key] ?? SecaoMercado.mercearia,
            unidadeCompra: unidadesCompra[e.key] ?? UnidadeCompra.kg,
          ))
      .toList();

  itens.sort((a, b) {
    final s = ordemSecoes.indexOf(a.secao).compareTo(ordemSecoes.indexOf(b.secao));
    return s != 0 ? s : a.alimentoId.compareTo(b.alimentoId);
  });

  return itens;
}

/// Converte a massa acumulada para a unidade em que a coisa é comprada.
///
/// [gramasPorUnidade] é a conversão `Unidade.unidade` do alimento, necessária
/// só quando ele é comprado por unidade. Sem ela, cai para grama em vez de
/// estourar: lista de mercado incompleta é melhor que tela que não abre.
({double valor, String unidade}) formatarCompra({
  required double gramas,
  required UnidadeCompra compra,
  required double? gramasPorUnidade,
}) {
  switch (compra) {
    case UnidadeCompra.kg:
      return gramas >= 1000
          ? (valor: gramas / 1000, unidade: 'kg')
          : (valor: gramas, unidade: 'g');

    case UnidadeCompra.litro:
      return gramas >= 1000
          ? (valor: gramas / 1000, unidade: 'L')
          : (valor: gramas, unidade: 'ml');

    case UnidadeCompra.unidade:
      if (gramasPorUnidade == null || gramasPorUnidade <= 0) {
        return (valor: gramas, unidade: 'g');
      }
      final n = math.max(1, (gramas / gramasPorUnidade).ceil());
      return (valor: n.toDouble(), unidade: 'un');
  }
}
```

- [ ] **Step 4: Rodar e ver passar**

```bash
flutter test test/mercado_test.dart
```

Esperado: 13 testes passando.

- [ ] **Step 5: Fechar a fase — suíte inteira**

```bash
flutter test
flutter analyze
```

Esperado: toda a Fase A verde, sem issue. O domínio está completo e nenhuma
linha dele conhece Flutter, drift ou rede.

- [ ] **Step 6: Commit**

```bash
git add lib/domain/mercado.dart test/mercado_test.dart
git commit -m "feat(domain): agregacao da lista de mercado e unidade de compra"
```

---

# Fase B — camada de dados

Quatro tarefas. Ao fim da fase existe um arquivo SQLite no aparelho, carregado com
a semente, com repositórios que alimentam o domínio e backup que sobrevive a
celular quebrado.

---

### Task 10: Tabelas drift e banco

**Files:**
- Create: `lib/data/conversores.dart`
- Create: `lib/data/app_database.dart`
- Create: `test/app_database_test.dart`
- Modify: `pubspec.yaml` (nada a mudar se a Task 1 foi feita)

**Interfaces:**
- Consumes: enums e `DataPura` de `lib/domain/modelos.dart`
- Produces:
  - `class AppDatabase extends _$AppDatabase` com `schemaVersion == 1`
  - Tabelas: `Alimentos`, `Conversoes`, `Receitas`, `ReceitaIngredientes`, `Combos`, `ComboReceitas`, `CicloItens`, `Config`, `RegrasPorcao`, `OverridesCombo`, `OverridesComponente`, `ListasCompra`, `ListaCompraItens`
  - `class DataPuraConverter extends TypeConverter<DataPura, String>`

- [ ] **Step 1: Escrever os conversores**

`lib/data/conversores.dart`:

```dart
import 'package:drift/drift.dart';

import '../domain/modelos.dart';

/// Grava `DataPura` como texto ISO `YYYY-MM-DD`. É o que mantém a promessa de
/// data pura: nada de fuso, nada de instante, e ordenável como string.
class DataPuraConverter extends TypeConverter<DataPura, String> {
  const DataPuraConverter();

  @override
  DataPura fromSql(String fromDb) => DataPura(fromDb);

  @override
  String toSql(DataPura value) => value.iso;
}
```

- [ ] **Step 2: Escrever as tabelas e o banco**

`lib/data/app_database.dart`:

```dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../domain/modelos.dart';
import 'conversores.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------- alimentos

@DataClassName('Alimento')
class Alimentos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get tacoCodigo => text().nullable()();
  RealColumn get kcal100g => real()();
  RealColumn get carboidratoG => real()();
  RealColumn get proteinaG => real()();
  RealColumn get gorduraG => real()();
  RealColumn get fibraG => real()();
  RealColumn get sodioMg => real()();
  TextColumn get secaoMercado => textEnum<SecaoMercado>()();
  TextColumn get unidadeCompra => textEnum<UnidadeCompra>()();
}

@DataClassName('Conversao')
class Conversoes extends Table {
  IntColumn get alimentoId => integer().references(Alimentos, #id)();
  TextColumn get unidade => textEnum<Unidade>()();
  RealColumn get gramas => real()();

  @override
  Set<Column> get primaryKey => {alimentoId, unidade};
}

// ----------------------------------------------------------------- receitas

@DataClassName('Receita')
class Receitas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get categoria => textEnum<CategoriaReceita>()();
  IntColumn get rendimentoPorcoes => integer().withDefault(const Constant(1))();
  IntColumn get tempoPreparoMin => integer().withDefault(const Constant(0))();
  TextColumn get modoPreparo => text().withDefault(const Constant(''))();
  TextColumn get fotoPath => text().nullable()();
  TextColumn get origem => text().withDefault(const Constant('seed'))();
  BoolColumn get ativa => boolean().withDefault(const Constant(true))();
}

@DataClassName('ReceitaIngrediente')
class ReceitaIngredientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get receitaId => integer().references(Receitas, #id)();
  IntColumn get alimentoId => integer().references(Alimentos, #id)();
  IntColumn get ordem => integer()();
  RealColumn get quantidade => real()();
  TextColumn get unidade => textEnum<Unidade>()();
  TextColumn get observacao => text().nullable()();
}

// ------------------------------------------------------------ combos e ciclo

@DataClassName('Combo')
class Combos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get tipo => textEnum<TipoCombo>()();
  TextColumn get origem => text().withDefault(const Constant('seed'))();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
}

@DataClassName('ComboReceita')
class ComboReceitas extends Table {
  IntColumn get comboId => integer().references(Combos, #id)();
  IntColumn get receitaId => integer().references(Receitas, #id)();
  IntColumn get ordem => integer()();

  @override
  Set<Column> get primaryKey => {comboId, receitaId};
}

@DataClassName('CicloItem')
class CicloItens extends Table {
  IntColumn get posicao => integer()();
  TextColumn get tipoSlot => textEnum<TipoCombo>()();
  IntColumn get comboId => integer().references(Combos, #id)();

  @override
  Set<Column> get primaryKey => {posicao, tipoSlot};
}

// ------------------------------------------------------ config e excecoes

@DataClassName('ConfigLinha')
class Config extends Table {
  TextColumn get chave => text()();
  TextColumn get valor => text()();

  @override
  Set<Column> get primaryKey => {chave};
}

@DataClassName('RegraPorcao')
class RegrasPorcao extends Table {
  TextColumn get slot => textEnum<SlotRefeicao>()();
  BoolColumn get diaUtil => boolean()();
  IntColumn get porcoes => integer()();

  @override
  Set<Column> get primaryKey => {slot, diaUtil};
}

@DataClassName('OverrideCombo')
class OverridesCombo extends Table {
  TextColumn get data => text().map(const DataPuraConverter())();
  TextColumn get slot => textEnum<SlotRefeicao>()();
  IntColumn get comboId => integer().references(Combos, #id)();

  @override
  Set<Column> get primaryKey => {data, slot};
}

@DataClassName('OverrideComponente')
class OverridesComponente extends Table {
  TextColumn get data => text().map(const DataPuraConverter())();
  TextColumn get slot => textEnum<SlotRefeicao>()();
  IntColumn get receitaOriginalId => integer().references(Receitas, #id)();

  /// Nulo significa componente removido do prato, não ausência de regra.
  IntColumn get receitaNovaId => integer().nullable().references(Receitas, #id)();

  @override
  Set<Column> get primaryKey => {data, slot, receitaOriginalId};
}

// -------------------------------------------------------------- mercado

@DataClassName('ListaCompra')
class ListasCompra extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dataInicio => text().map(const DataPuraConverter())();
  TextColumn get dataFim => text().map(const DataPuraConverter())();
  DateTimeColumn get criadaEm => dateTime()();
}

@DataClassName('ListaCompraItem')
class ListaCompraItens extends Table {
  IntColumn get listaId => integer().references(ListasCompra, #id)();
  IntColumn get alimentoId => integer().references(Alimentos, #id)();
  RealColumn get quantidadeG => real()();
  BoolColumn get marcado => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {listaId, alimentoId};
}

// -------------------------------------------------------------- o banco

@DriftDatabase(tables: [
  Alimentos,
  Conversoes,
  Receitas,
  ReceitaIngredientes,
  Combos,
  ComboReceitas,
  CicloItens,
  Config,
  RegrasPorcao,
  OverridesCombo,
  OverridesComponente,
  ListasCompra,
  ListaCompraItens,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _abrir());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  static QueryExecutor _abrir() {
    return LazyDatabase(() async {
      final pasta = await getApplicationDocumentsDirectory();
      final arquivo = File(p.join(pasta.path, 'refeicoes.sqlite'));
      return NativeDatabase.createInBackground(arquivo);
    });
  }
}
```

- [ ] **Step 3: Gerar o código do drift**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Esperado: `lib/data/app_database.g.dart` criado. Se falhar por conflito de versão,
rodar `flutter pub upgrade --major-versions drift drift_dev` e repetir.

- [ ] **Step 4: Escrever o teste**

`test/app_database_test.dart`:

```dart
// `hide`: drift exporta `isNull`/`isNotNull` top-level deprecados que
// colidem com os matchers homonimos do package:matcher.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/domain/modelos.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));
  });

  tearDown(() async => db.close());

  test('abre no schema 1', () {
    expect(db.schemaVersion, 1);
  });

  test('grava e le um alimento com enums', () async {
    final id = await db.into(db.alimentos).insert(AlimentosCompanion.insert(
          nome: 'Arroz branco cozido',
          kcal100g: 128,
          carboidratoG: 28.1,
          proteinaG: 2.5,
          gorduraG: 0.2,
          fibraG: 1.6,
          sodioMg: 1,
          secaoMercado: SecaoMercado.mercearia,
          unidadeCompra: UnidadeCompra.kg,
        ));

    final lido = await (db.select(db.alimentos)
          ..where((t) => t.id.equals(id)))
        .getSingle();

    expect(lido.nome, 'Arroz branco cozido');
    expect(lido.secaoMercado, SecaoMercado.mercearia);
    expect(lido.unidadeCompra, UnidadeCompra.kg);
    expect(lido.tacoCodigo, isNull);
  });

  test('DataPura vai e volta como texto ISO', () async {
    final combo = await db.into(db.combos).insert(
        CombosCompanion.insert(nome: 'Almoco teste', tipo: TipoCombo.refeicao));

    await db.into(db.overridesCombo).insert(OverridesComboCompanion.insert(
          data: const DataPura('2026-09-04'),
          slot: SlotRefeicao.almoco,
          comboId: combo,
        ));

    final lido = await db.select(db.overridesCombo).getSingle();
    expect(lido.data, const DataPura('2026-09-04'));
    expect(lido.data.iso, '2026-09-04');
  });

  test('chave primaria composta impede duplicata de override', () async {
    final combo = await db.into(db.combos).insert(
        CombosCompanion.insert(nome: 'X', tipo: TipoCombo.refeicao));

    Future<void> gravar() =>
        db.into(db.overridesCombo).insert(OverridesComboCompanion.insert(
              data: const DataPura('2026-09-04'),
              slot: SlotRefeicao.almoco,
              comboId: combo,
            ));

    await gravar();
    await expectLater(gravar(), throwsA(isA<Exception>()));
  });

  test('receitaNovaId nula significa componente removido', () async {
    final r = await db.into(db.receitas).insert(ReceitasCompanion.insert(
        nome: 'Salada', categoria: CategoriaReceita.salada));

    await db.into(db.overridesComponente).insert(
        OverridesComponenteCompanion.insert(
          data: const DataPura('2026-09-04'),
          slot: SlotRefeicao.almoco,
          receitaOriginalId: r,
        ));

    final lido = await db.select(db.overridesComponente).getSingle();
    expect(lido.receitaNovaId, isNull);
  });

  test('chave estrangeira esta ligada', () async {
    await expectLater(
      db.into(db.comboReceitas).insert(ComboReceitasCompanion.insert(
            comboId: 999,
            receitaId: 999,
            ordem: 0,
          )),
      throwsA(isA<Exception>()),
    );
  });
}
```

- [ ] **Step 5: Rodar e ver passar**

```bash
flutter test test/app_database_test.dart
flutter analyze
```

Esperado: 6 testes passando. O teste de chave estrangeira só passa porque
`beforeOpen` liga `PRAGMA foreign_keys` — SQLite vem com ela desligada.

- [ ] **Step 6: Commit**

```bash
git add lib/data/ test/app_database_test.dart
git commit -m "feat(data): tabelas drift, conversor de DataPura e banco local"
```

---

### Task 11: Semente

**Files:**
- Create: `assets/semente/alimentos.json`
- Create: `assets/semente/conversoes.json`
- Create: `assets/semente/receitas.json`
- Create: `assets/semente/combos.json`
- Create: `assets/semente/ciclo.json`
- Create: `lib/data/semente.dart`
- Create: `test/semente_test.dart`
- Modify: `pubspec.yaml` (seção `flutter:` ganha `assets:`)

**Interfaces:**
- Consumes: `AppDatabase`
- Produces: `Future<void> carregarSemente(AppDatabase db, {required String Function(String) lerAsset, required int versao})` — idempotente

**Escopo desta tarefa:** apenas os **4 primeiros dias** do ciclo, o bastante para o
app rodar de ponta a ponta e os testes serem reais. O conteúdo completo (33 dias,
~182 receitas) é um entregável separado — ver "Plano 2" no fim deste documento.

- [ ] **Step 1: Declarar os assets**

Em `pubspec.yaml`, dentro da seção `flutter:`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/semente/
```

- [ ] **Step 2: Escrever a semente mínima**

`assets/semente/alimentos.json` — os alimentos dos 4 primeiros dias. Valores de
kcal, macro e fibra por 100 g vindos da TACO; `taco` nulo marca item de rótulo.

```json
[
  {"id": 1,  "nome": "Arroz branco cozido",       "taco": "C0001", "kcal": 128, "carb": 28.1, "prot": 2.5,  "gord": 0.2,  "fibra": 1.6, "sodio": 1,   "secao": "mercearia",  "compra": "kg"},
  {"id": 2,  "nome": "Feijao carioca cozido",     "taco": "C0022", "kcal": 76,  "carb": 13.6, "prot": 4.8,  "gord": 0.5,  "fibra": 8.5, "sodio": 2,   "secao": "mercearia",  "compra": "kg"},
  {"id": 3,  "nome": "Patinho cru",               "taco": "C0301", "kcal": 133, "carb": 0,    "prot": 21.7, "gord": 4.5,  "fibra": 0,   "sodio": 52,  "secao": "acougue",    "compra": "kg"},
  {"id": 4,  "nome": "Cenoura crua",              "taco": "C0104", "kcal": 34,  "carb": 7.7,  "prot": 1.3,  "gord": 0.2,  "fibra": 3.2, "sodio": 3,   "secao": "hortifruti", "compra": "kg"},
  {"id": 5,  "nome": "Batata inglesa crua",       "taco": "C0113", "kcal": 64,  "carb": 14.7, "prot": 1.8,  "gord": 0,    "fibra": 1.3, "sodio": 2,   "secao": "hortifruti", "compra": "kg"},
  {"id": 6,  "nome": "Batata-doce crua",          "taco": "C0117", "kcal": 118, "carb": 28.2, "prot": 1.3,  "gord": 0.1,  "fibra": 2.6, "sodio": 9,   "secao": "hortifruti", "compra": "kg"},
  {"id": 7,  "nome": "Cebola crua",               "taco": "C0102", "kcal": 39,  "carb": 8.9,  "prot": 1.7,  "gord": 0.1,  "fibra": 2.2, "sodio": 1,   "secao": "hortifruti", "compra": "kg"},
  {"id": 8,  "nome": "Alho cru",                  "taco": "C0100", "kcal": 113, "carb": 23.9, "prot": 7,    "gord": 0.2,  "fibra": 4.3, "sodio": 6,   "secao": "hortifruti", "compra": "kg"},
  {"id": 9,  "nome": "Azeite de oliva",           "taco": "C0402", "kcal": 884, "carb": 0,    "prot": 0,    "gord": 100,  "fibra": 0,   "sodio": 0,   "secao": "mercearia",  "compra": "litro"},
  {"id": 10, "nome": "Extrato de tomate",         "taco": null,    "kcal": 61,  "carb": 13.9, "prot": 2.4,  "gord": 0.3,  "fibra": 2.6, "sodio": 380, "secao": "mercearia",  "compra": "kg"},
  {"id": 11, "nome": "Sal",                       "taco": "C0501", "kcal": 0,   "carb": 0,    "prot": 0,    "gord": 0,    "fibra": 0,   "sodio": 38758,"secao": "mercearia", "compra": "kg"},
  {"id": 12, "nome": "Alface americana crua",     "taco": "C0130", "kcal": 14,  "carb": 2.4,  "prot": 0.6,  "gord": 0.1,  "fibra": 1.7, "sodio": 5,   "secao": "hortifruti", "compra": "unidade"},
  {"id": 13, "nome": "Pepino cru",                "taco": "C0142", "kcal": 10,  "carb": 2,    "prot": 0.9,  "gord": 0,    "fibra": 1.1, "sodio": 1,   "secao": "hortifruti", "compra": "unidade"},
  {"id": 14, "nome": "Goma de tapioca",           "taco": null,    "kcal": 350, "carb": 87,   "prot": 0,    "gord": 0,    "fibra": 0.5, "sodio": 2,   "secao": "mercearia",  "compra": "kg"},
  {"id": 15, "nome": "Queijo coalho",             "taco": null,    "kcal": 310, "carb": 2,    "prot": 22,   "gord": 24,   "fibra": 0,   "sodio": 690, "secao": "laticinios", "compra": "kg"},
  {"id": 16, "nome": "Mamao formosa",             "taco": "C0203", "kcal": 45,  "carb": 11.6, "prot": 0.8,  "gord": 0.1,  "fibra": 1.8, "sodio": 3,   "secao": "hortifruti", "compra": "kg"},
  {"id": 17, "nome": "Suco de uva integral",      "taco": null,    "kcal": 60,  "carb": 15,   "prot": 0.3,  "gord": 0,    "fibra": 0,   "sodio": 5,   "secao": "bebidas",    "compra": "litro"},
  {"id": 18, "nome": "Mostarda",                  "taco": null,    "kcal": 66,  "carb": 5,    "prot": 4,    "gord": 3.5,  "fibra": 3,   "sodio": 1120,"secao": "mercearia",  "compra": "kg"},
  {"id": 19, "nome": "Mel",                       "taco": "C0605", "kcal": 309, "carb": 84,   "prot": 0,    "gord": 0,    "fibra": 0,   "sodio": 6,   "secao": "mercearia",  "compra": "kg"},
  {"id": 20, "nome": "Pao frances",               "taco": "C0705", "kcal": 300, "carb": 58.6, "prot": 8,    "gord": 3.1,  "fibra": 2.3, "sodio": 648, "secao": "padaria",    "compra": "unidade"},
  {"id": 21, "nome": "Manteiga com sal",          "taco": "C0801", "kcal": 726, "carb": 0.1,  "prot": 0.4,  "gord": 82.4, "fibra": 0,   "sodio": 579, "secao": "laticinios", "compra": "kg"},
  {"id": 22, "nome": "Leite integral",            "taco": "C0803", "kcal": 61,  "carb": 4.7,  "prot": 3.2,  "gord": 3.3,  "fibra": 0,   "sodio": 45,  "secao": "laticinios", "compra": "litro"},
  {"id": 23, "nome": "Achocolatado em po",        "taco": null,    "kcal": 400, "carb": 88,   "prot": 4,    "gord": 2,    "fibra": 3,   "sodio": 120, "secao": "mercearia",  "compra": "kg"},
  {"id": 24, "nome": "Banana prata",              "taco": "C0206", "kcal": 98,  "carb": 26,   "prot": 1.3,  "gord": 0.1,  "fibra": 2,   "sodio": 1,   "secao": "hortifruti", "compra": "kg"},
  {"id": 25, "nome": "Ovo de galinha cru",        "taco": "C0901", "kcal": 143, "carb": 1.6,  "prot": 13,   "gord": 8.9,  "fibra": 0,   "sodio": 168, "secao": "mercearia",  "compra": "unidade"},
  {"id": 26, "nome": "Pao de forma",              "taco": null,    "kcal": 253, "carb": 47,   "prot": 8,    "gord": 3,    "fibra": 2.5, "sodio": 480, "secao": "padaria",    "compra": "unidade"},
  {"id": 27, "nome": "Laranja pera",              "taco": "C0221", "kcal": 37,  "carb": 8.9,  "prot": 1,    "gord": 0.1,  "fibra": 0.8, "sodio": 1,   "secao": "hortifruti", "compra": "kg"},
  {"id": 28, "nome": "Carne moida acem crua",     "taco": "C0305", "kcal": 137, "carb": 0,    "prot": 20.6, "gord": 5.7,  "fibra": 0,   "sodio": 58,  "secao": "acougue",    "compra": "kg"},
  {"id": 29, "nome": "Feijao preto cozido",       "taco": "C0025", "kcal": 77,  "carb": 14,   "prot": 4.5,  "gord": 0.5,  "fibra": 8.4, "sodio": 2,   "secao": "mercearia",  "compra": "kg"},
  {"id": 30, "nome": "Abobrinha italiana crua",   "taco": "C0122", "kcal": 19,  "carb": 4.3,  "prot": 1.1,  "gord": 0.2,  "fibra": 1.3, "sodio": 2,   "secao": "hortifruti", "compra": "kg"},
  {"id": 31, "nome": "Milho verde em conserva",   "taco": null,    "kcal": 98,  "carb": 17,   "prot": 3,    "gord": 1.2,  "fibra": 2.5, "sodio": 240, "secao": "mercearia",  "compra": "kg"},
  {"id": 32, "nome": "Iogurte natural integral",  "taco": "C0810", "kcal": 51,  "carb": 1.9,  "prot": 4.1,  "gord": 3,    "fibra": 0,   "sodio": 52,  "secao": "laticinios", "compra": "kg"},
  {"id": 33, "nome": "Limao taiti",               "taco": "C0219", "kcal": 32,  "carb": 11.1, "prot": 0.9,  "gord": 0.1,  "fibra": 1.2, "sodio": 1,   "secao": "hortifruti", "compra": "kg"},
  {"id": 34, "nome": "Cuscuz de milho",           "taco": "C0708", "kcal": 113, "carb": 25.3, "prot": 2.4,  "gord": 0.5,  "fibra": 1.5, "sodio": 1,   "secao": "mercearia",  "compra": "kg"},
  {"id": 35, "nome": "File de frango cru",        "taco": "C0401", "kcal": 119, "carb": 0,    "prot": 21.5, "gord": 3,    "fibra": 0,   "sodio": 50,  "secao": "acougue",    "compra": "kg"},
  {"id": 36, "nome": "Chuchu cru",                "taco": "C0126", "kcal": 17,  "carb": 4.1,  "prot": 0.7,  "gord": 0.1,  "fibra": 1.3, "sodio": 1,   "secao": "hortifruti", "compra": "kg"},
  {"id": 37, "nome": "Rucula crua",               "taco": "C0146", "kcal": 13,  "carb": 2.2,  "prot": 1.8,  "gord": 0.2,  "fibra": 1.7, "sodio": 8,   "secao": "hortifruti", "compra": "unidade"},
  {"id": 38, "nome": "Tomate cereja",             "taco": "C0150", "kcal": 15,  "carb": 3.1,  "prot": 1.1,  "gord": 0.2,  "fibra": 1.2, "sodio": 1,   "secao": "hortifruti", "compra": "kg"},
  {"id": 39, "nome": "Queijo parmesao",           "taco": "C0815", "kcal": 453, "carb": 1.7,  "prot": 35.6, "gord": 33.5, "fibra": 0,   "sodio": 1800,"secao": "laticinios", "compra": "kg"},
  {"id": 40, "nome": "Vinagre balsamico",         "taco": null,    "kcal": 88,  "carb": 17,   "prot": 0.5,  "gord": 0,    "fibra": 0,   "sodio": 23,  "secao": "mercearia",  "compra": "litro"}
]
```

`assets/semente/conversoes.json` — cada alimento **precisa** de `g`, e de `unidade`
quando for comprado por unidade. Conversão faltando estoura na carga (Task 7).

```json
[
  {"alimento": 1,  "unidade": "g", "gramas": 1},
  {"alimento": 1,  "unidade": "xicara", "gramas": 160},
  {"alimento": 2,  "unidade": "g", "gramas": 1},
  {"alimento": 2,  "unidade": "concha", "gramas": 80},
  {"alimento": 3,  "unidade": "g", "gramas": 1},
  {"alimento": 4,  "unidade": "g", "gramas": 1},
  {"alimento": 4,  "unidade": "unidade", "gramas": 90},
  {"alimento": 5,  "unidade": "g", "gramas": 1},
  {"alimento": 5,  "unidade": "unidade", "gramas": 120},
  {"alimento": 6,  "unidade": "g", "gramas": 1},
  {"alimento": 7,  "unidade": "g", "gramas": 1},
  {"alimento": 7,  "unidade": "unidade", "gramas": 110},
  {"alimento": 8,  "unidade": "g", "gramas": 1},
  {"alimento": 8,  "unidade": "dente", "gramas": 3},
  {"alimento": 9,  "unidade": "g", "gramas": 1},
  {"alimento": 9,  "unidade": "colherSopa", "gramas": 8},
  {"alimento": 9,  "unidade": "colherCha", "gramas": 3},
  {"alimento": 10, "unidade": "g", "gramas": 1},
  {"alimento": 10, "unidade": "colherSopa", "gramas": 15},
  {"alimento": 11, "unidade": "g", "gramas": 1},
  {"alimento": 12, "unidade": "g", "gramas": 1},
  {"alimento": 12, "unidade": "unidade", "gramas": 300},
  {"alimento": 12, "unidade": "folha", "gramas": 10},
  {"alimento": 13, "unidade": "g", "gramas": 1},
  {"alimento": 13, "unidade": "unidade", "gramas": 130},
  {"alimento": 14, "unidade": "g", "gramas": 1},
  {"alimento": 14, "unidade": "colherSopa", "gramas": 20},
  {"alimento": 15, "unidade": "g", "gramas": 1},
  {"alimento": 15, "unidade": "fatia", "gramas": 30},
  {"alimento": 16, "unidade": "g", "gramas": 1},
  {"alimento": 16, "unidade": "fatia", "gramas": 150},
  {"alimento": 17, "unidade": "ml", "gramas": 1},
  {"alimento": 17, "unidade": "g", "gramas": 1},
  {"alimento": 18, "unidade": "g", "gramas": 1},
  {"alimento": 18, "unidade": "colherCha", "gramas": 5},
  {"alimento": 19, "unidade": "g", "gramas": 1},
  {"alimento": 19, "unidade": "colherCha", "gramas": 7},
  {"alimento": 20, "unidade": "g", "gramas": 1},
  {"alimento": 20, "unidade": "unidade", "gramas": 50},
  {"alimento": 21, "unidade": "g", "gramas": 1},
  {"alimento": 21, "unidade": "colherCha", "gramas": 5},
  {"alimento": 22, "unidade": "ml", "gramas": 1},
  {"alimento": 22, "unidade": "g", "gramas": 1},
  {"alimento": 23, "unidade": "g", "gramas": 1},
  {"alimento": 23, "unidade": "colherSopa", "gramas": 12},
  {"alimento": 24, "unidade": "g", "gramas": 1},
  {"alimento": 24, "unidade": "unidade", "gramas": 86},
  {"alimento": 25, "unidade": "g", "gramas": 1},
  {"alimento": 25, "unidade": "unidade", "gramas": 50},
  {"alimento": 26, "unidade": "g", "gramas": 1},
  {"alimento": 26, "unidade": "unidade", "gramas": 400},
  {"alimento": 26, "unidade": "fatia", "gramas": 25},
  {"alimento": 27, "unidade": "g", "gramas": 1},
  {"alimento": 27, "unidade": "unidade", "gramas": 180},
  {"alimento": 28, "unidade": "g", "gramas": 1},
  {"alimento": 29, "unidade": "g", "gramas": 1},
  {"alimento": 30, "unidade": "g", "gramas": 1},
  {"alimento": 30, "unidade": "unidade", "gramas": 200},
  {"alimento": 31, "unidade": "g", "gramas": 1},
  {"alimento": 32, "unidade": "g", "gramas": 1},
  {"alimento": 33, "unidade": "g", "gramas": 1},
  {"alimento": 33, "unidade": "unidade", "gramas": 100},
  {"alimento": 34, "unidade": "g", "gramas": 1},
  {"alimento": 35, "unidade": "g", "gramas": 1},
  {"alimento": 36, "unidade": "g", "gramas": 1},
  {"alimento": 36, "unidade": "unidade", "gramas": 200},
  {"alimento": 37, "unidade": "g", "gramas": 1},
  {"alimento": 37, "unidade": "unidade", "gramas": 100},
  {"alimento": 38, "unidade": "g", "gramas": 1},
  {"alimento": 38, "unidade": "unidade", "gramas": 12},
  {"alimento": 39, "unidade": "g", "gramas": 1},
  {"alimento": 39, "unidade": "colherSopa", "gramas": 6},
  {"alimento": 40, "unidade": "ml", "gramas": 1},
  {"alimento": 40, "unidade": "g", "gramas": 1},
  {"alimento": 40, "unidade": "colherSopa", "gramas": 15}
]
```

**Atenção:** `concha` não existe no enum `Unidade`. Ou remover a linha do alimento 2,
ou acrescentar `concha` ao enum em `modelos.dart` e ao conjunto contínuo. **Escolha
desta tarefa: remover a linha** — o feijão é medido em grama. Apagar a linha
`{"alimento": 2, "unidade": "concha", ...}` antes de seguir.

`assets/semente/receitas.json` — os componentes dos 4 primeiros dias.

```json
[
  {"id": 1, "nome": "Arroz branco", "categoria": "base", "rende": 1, "tempo": 20,
   "preparo": "Refogue o alho no azeite ate dourar.\nJunte o arroz e mexa por um minuto.\nAcrescente agua fervente, tempere com sal e cozinhe tampado ate secar.",
   "ingredientes": [
     {"alimento": 1, "quantidade": 120, "unidade": "g"},
     {"alimento": 8, "quantidade": 1, "unidade": "dente"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 2, "nome": "Feijao carioca", "categoria": "leguminosa", "rende": 1, "tempo": 40,
   "preparo": "Cozinhe o feijao na pressao por 25 minutos.\nRefogue alho e cebola no azeite.\nJunte o feijao cozido e apure por 10 minutos.",
   "ingredientes": [
     {"alimento": 2, "quantidade": 90, "unidade": "g"},
     {"alimento": 8, "quantidade": 1, "unidade": "dente"},
     {"alimento": 7, "quantidade": 30, "unidade": "g"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 3, "nome": "Picadinho de carne com legumes", "categoria": "proteina", "rende": 1, "tempo": 35,
   "preparo": "Tempere a carne com sal e alho e deixe descansar 10 minutos.\nAqueca o azeite e sele a carne em fogo alto ate dourar por fora.\nJunte a cebola, refogue ate ficar transparente e acrescente o extrato.\nAdicione cenoura, batata e agua ate cobrir. Tampe.\nCozinhe 20 minutos em fogo baixo, ate os legumes ficarem macios.",
   "ingredientes": [
     {"alimento": 3, "quantidade": 150, "unidade": "g"},
     {"alimento": 4, "quantidade": 60, "unidade": "g"},
     {"alimento": 5, "quantidade": 70, "unidade": "g"},
     {"alimento": 7, "quantidade": 40, "unidade": "g", "observacao": "picada"},
     {"alimento": 8, "quantidade": 1, "unidade": "dente"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 10, "quantidade": 15, "unidade": "g"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 4, "nome": "Batata-doce cozida e amassada", "categoria": "vegetal", "rende": 1, "tempo": 25,
   "preparo": "Cozinhe a batata-doce em agua e sal ate ficar macia.\nEscorra e amasse ainda quente com a manteiga.",
   "ingredientes": [
     {"alimento": 6, "quantidade": 110, "unidade": "g"},
     {"alimento": 21, "quantidade": 1, "unidade": "colherCha"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 5, "nome": "Alface americana e pepino com molho de mostarda e mel", "categoria": "salada", "rende": 1, "tempo": 8,
   "preparo": "Lave e rasgue a alface, fatie o pepino.\nMisture mostarda, mel, azeite e limao ate emulsionar.\nRegue na hora de servir.",
   "ingredientes": [
     {"alimento": 12, "quantidade": 5, "unidade": "folha"},
     {"alimento": 13, "quantidade": 40, "unidade": "g"},
     {"alimento": 18, "quantidade": 1, "unidade": "colherCha"},
     {"alimento": 19, "quantidade": 1, "unidade": "colherCha"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 33, "quantidade": 10, "unidade": "g"}
   ]},
  {"id": 6, "nome": "Tapioca com queijo coalho", "categoria": "base", "rende": 1, "tempo": 10,
   "preparo": "Peneire a goma na frigideira quente ate formar o disco.\nDistribua o queijo, dobre e doure dos dois lados.",
   "ingredientes": [
     {"alimento": 14, "quantidade": 3, "unidade": "colherSopa"},
     {"alimento": 15, "quantidade": 1, "unidade": "fatia"}
   ]},
  {"id": 7, "nome": "Mamao", "categoria": "fruta", "rende": 1, "tempo": 3,
   "preparo": "Corte em fatias e sirva gelado.",
   "ingredientes": [{"alimento": 16, "quantidade": 150, "unidade": "g"}]},
  {"id": 8, "nome": "Suco de uva", "categoria": "bebida", "rende": 1, "tempo": 2,
   "preparo": "Sirva gelado.",
   "ingredientes": [{"alimento": 17, "quantidade": 200, "unidade": "ml"}]},
  {"id": 9, "nome": "Pao frances com manteiga", "categoria": "pao", "rende": 1, "tempo": 5,
   "preparo": "Corte o pao ao meio e passe a manteiga.\nLeve a chapa quente ate dourar.",
   "ingredientes": [
     {"alimento": 20, "quantidade": 1, "unidade": "unidade"},
     {"alimento": 21, "quantidade": 1, "unidade": "colherCha"}
   ]},
  {"id": 10, "nome": "Leite com achocolatado", "categoria": "bebida", "rende": 1, "tempo": 3,
   "preparo": "Aqueca o leite e dissolva o achocolatado.",
   "ingredientes": [
     {"alimento": 22, "quantidade": 200, "unidade": "ml"},
     {"alimento": 23, "quantidade": 2, "unidade": "colherSopa"}
   ]},
  {"id": 11, "nome": "Banana", "categoria": "fruta", "rende": 1, "tempo": 1,
   "preparo": "Descasque e sirva.",
   "ingredientes": [{"alimento": 24, "quantidade": 1, "unidade": "unidade"}]},
  {"id": 12, "nome": "Bife acebolado", "categoria": "proteina", "rende": 1, "tempo": 20,
   "preparo": "Tempere o bife com sal e alho.\nSele em frigideira bem quente, dois minutos de cada lado.\nRetire a carne, doure a cebola na mesma frigideira e devolva o bife.",
   "ingredientes": [
     {"alimento": 3, "quantidade": 150, "unidade": "g"},
     {"alimento": 7, "quantidade": 60, "unidade": "g"},
     {"alimento": 8, "quantidade": 1, "unidade": "dente"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 13, "nome": "Cenoura cozida com manteiga", "categoria": "vegetal", "rende": 1, "tempo": 15,
   "preparo": "Cozinhe a cenoura em rodelas ate ficar macia.\nEscorra e salteie na manteiga com sal.",
   "ingredientes": [
     {"alimento": 4, "quantidade": 100, "unidade": "g"},
     {"alimento": 21, "quantidade": 1, "unidade": "colherCha"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 14, "nome": "Alface, tomate e cebola roxa com molho de azeite e limao", "categoria": "salada", "rende": 1, "tempo": 8,
   "preparo": "Rasgue a alface e fatie tomate e cebola.\nTempere com azeite, limao e sal na hora de servir.",
   "ingredientes": [
     {"alimento": 12, "quantidade": 5, "unidade": "folha"},
     {"alimento": 38, "quantidade": 60, "unidade": "g"},
     {"alimento": 7, "quantidade": 30, "unidade": "g"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 33, "quantidade": 10, "unidade": "g"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 15, "nome": "Pao de forma com ovo mexido", "categoria": "pao", "rende": 1, "tempo": 10,
   "preparo": "Bata os ovos com sal.\nMexa em fogo baixo com um fio de azeite ate firmar.\nSirva sobre o pao torrado.",
   "ingredientes": [
     {"alimento": 26, "quantidade": 2, "unidade": "fatia"},
     {"alimento": 25, "quantidade": 2, "unidade": "unidade"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherCha"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 16, "nome": "Suco de laranja", "categoria": "bebida", "rende": 1, "tempo": 5,
   "preparo": "Esprema as laranjas e sirva na hora.",
   "ingredientes": [{"alimento": 27, "quantidade": 2, "unidade": "unidade"}]},
  {"id": 17, "nome": "Carne moida refogada tradicional", "categoria": "proteina", "rende": 1, "tempo": 25,
   "preparo": "Refogue alho e cebola no azeite.\nJunte a carne moida e mexa ate perder a cor rosada.\nAcrescente o extrato, tempere e apure por 10 minutos.",
   "ingredientes": [
     {"alimento": 28, "quantidade": 150, "unidade": "g"},
     {"alimento": 7, "quantidade": 40, "unidade": "g"},
     {"alimento": 8, "quantidade": 1, "unidade": "dente"},
     {"alimento": 10, "quantidade": 15, "unidade": "g"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 18, "nome": "Feijao preto", "categoria": "leguminosa", "rende": 1, "tempo": 45,
   "preparo": "Cozinhe o feijao preto na pressao por 30 minutos.\nRefogue alho e cebola e junte o feijao.\nApure ate engrossar o caldo.",
   "ingredientes": [
     {"alimento": 29, "quantidade": 90, "unidade": "g"},
     {"alimento": 8, "quantidade": 1, "unidade": "dente"},
     {"alimento": 7, "quantidade": 30, "unidade": "g"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 19, "nome": "Abobrinha refogada com alho", "categoria": "vegetal", "rende": 1, "tempo": 15,
   "preparo": "Doure o alho no azeite.\nJunte a abobrinha em meia-lua e refogue ate ficar macia sem desmanchar.",
   "ingredientes": [
     {"alimento": 30, "quantidade": 120, "unidade": "g"},
     {"alimento": 8, "quantidade": 1, "unidade": "dente"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 20, "nome": "Alface, cenoura ralada e milho com molho de iogurte", "categoria": "salada", "rende": 1, "tempo": 8,
   "preparo": "Misture alface, cenoura ralada e milho escorrido.\nBata o iogurte com limao e sal e regue na hora.",
   "ingredientes": [
     {"alimento": 12, "quantidade": 5, "unidade": "folha"},
     {"alimento": 4, "quantidade": 40, "unidade": "g", "observacao": "ralada"},
     {"alimento": 31, "quantidade": 40, "unidade": "g"},
     {"alimento": 32, "quantidade": 40, "unidade": "g"},
     {"alimento": 33, "quantidade": 10, "unidade": "g"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 21, "nome": "Cuscuz com ovo cozido", "categoria": "base", "rende": 1, "tempo": 15,
   "preparo": "Hidrate o cuscuz com agua e sal e deixe descansar 10 minutos.\nCozinhe no vapor por 8 minutos.\nSirva com o ovo cozido em rodelas e um fio de azeite.",
   "ingredientes": [
     {"alimento": 34, "quantidade": 80, "unidade": "g"},
     {"alimento": 25, "quantidade": 1, "unidade": "unidade"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherCha"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 22, "nome": "Frango grelhado simples", "categoria": "proteina", "rende": 1, "tempo": 22,
   "preparo": "Tempere o file com sal, alho e limao e deixe 15 minutos.\nGrelhe em fogo medio, cinco minutos de cada lado.",
   "ingredientes": [
     {"alimento": 35, "quantidade": 150, "unidade": "g"},
     {"alimento": 8, "quantidade": 1, "unidade": "dente"},
     {"alimento": 33, "quantidade": 10, "unidade": "g"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 23, "nome": "Chuchu refogado com cebola", "categoria": "vegetal", "rende": 1, "tempo": 18,
   "preparo": "Refogue a cebola no azeite.\nJunte o chuchu em cubos, tampe e cozinhe no proprio vapor ate ficar macio.",
   "ingredientes": [
     {"alimento": 36, "quantidade": 130, "unidade": "g"},
     {"alimento": 7, "quantidade": 40, "unidade": "g"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 11, "quantidade": 1, "unidade": "aGosto"}
   ]},
  {"id": 24, "nome": "Rucula, tomate-cereja e parmesao com molho balsamico", "categoria": "salada", "rende": 1, "tempo": 7,
   "preparo": "Disponha a rucula e os tomates cortados ao meio.\nLasque o parmesao por cima e regue com azeite e balsamico.",
   "ingredientes": [
     {"alimento": 37, "quantidade": 50, "unidade": "g"},
     {"alimento": 38, "quantidade": 60, "unidade": "g"},
     {"alimento": 39, "quantidade": 2, "unidade": "colherSopa"},
     {"alimento": 9, "quantidade": 1, "unidade": "colherSopa"},
     {"alimento": 40, "quantidade": 1, "unidade": "colherSopa"}
   ]}
]
```

`assets/semente/combos.json` — 4 cafés e 4 refeições, montando os dias 1 a 4.

```json
[
  {"id": 1, "nome": "Pao frances, banana e leite com achocolatado", "tipo": "cafe",
   "receitas": [9, 10, 11]},
  {"id": 2, "nome": "Pao de forma com ovo mexido e suco de laranja", "tipo": "cafe",
   "receitas": [15, 16]},
  {"id": 3, "nome": "Cuscuz com ovo cozido e leite com achocolatado", "tipo": "cafe",
   "receitas": [21, 10]},
  {"id": 4, "nome": "Tapioca com queijo, mamao e suco de uva", "tipo": "cafe",
   "receitas": [6, 7, 8]},

  {"id": 5, "nome": "Bife acebolado com arroz, feijao, cenoura e salada", "tipo": "refeicao",
   "receitas": [1, 2, 12, 13, 14]},
  {"id": 6, "nome": "Carne moida com arroz, feijao preto, abobrinha e salada", "tipo": "refeicao",
   "receitas": [1, 18, 17, 19, 20]},
  {"id": 7, "nome": "Frango grelhado com arroz, feijao, chuchu e rucula", "tipo": "refeicao",
   "receitas": [1, 2, 22, 23, 24]},
  {"id": 8, "nome": "Picadinho de carne com arroz, feijao, batata-doce e salada", "tipo": "refeicao",
   "receitas": [1, 2, 3, 4, 5]}
]
```

`assets/semente/ciclo.json`:

```json
[
  {"posicao": 1, "tipo": "cafe", "combo": 1},
  {"posicao": 1, "tipo": "refeicao", "combo": 5},
  {"posicao": 2, "tipo": "cafe", "combo": 2},
  {"posicao": 2, "tipo": "refeicao", "combo": 6},
  {"posicao": 3, "tipo": "cafe", "combo": 3},
  {"posicao": 3, "tipo": "refeicao", "combo": 7},
  {"posicao": 4, "tipo": "cafe", "combo": 4},
  {"posicao": 4, "tipo": "refeicao", "combo": 8}
]
```

- [ ] **Step 3: Escrever o teste que falha**

`test/semente_test.dart`:

```dart
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/domain/modelos.dart';

String lerDoDisco(String nome) =>
    File('assets/semente/$nome').readAsStringSync();

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));
  });
  tearDown(() async => db.close());

  test('carrega a semente inteira', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    expect(await db.select(db.alimentos).get(), hasLength(40));
    expect(await db.select(db.receitas).get(), hasLength(24));
    expect(await db.select(db.combos).get(), hasLength(8));
    expect(await db.select(db.cicloItens).get(), hasLength(8));
  });

  test('carregar duas vezes nao duplica', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    expect(await db.select(db.alimentos).get(), hasLength(40));
    expect(await db.select(db.combos).get(), hasLength(8));
  });

  test('grava as regras de porcao padrao', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final regras = await db.select(db.regrasPorcao).get();

    expect(regras, hasLength(8));
    final almocoUtil = regras.firstWhere(
        (r) => r.slot == SlotRefeicao.almoco && r.diaUtil);
    expect(almocoUtil.porcoes, 1);
    final jantarUtil = regras.firstWhere(
        (r) => r.slot == SlotRefeicao.jantar && r.diaUtil);
    expect(jantarUtil.porcoes, 2);
  });

  test('grava a versao e o tamanho do ciclo em config', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final linhas = await db.select(db.config).get();
    final mapa = {for (final l in linhas) l.chave: l.valor};

    expect(mapa['seed_version'], '1');
    expect(mapa['tamanho_ciclo'], '33');
    expect(mapa['data_inicio_ciclo'], isNotEmpty);
  });

  test('nao sobrescreve receita que virou do usuario', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    await (db.update(db.receitas)..where((t) => t.id.equals(1))).write(
        const ReceitasCompanion(
            nome: Value('Arroz do jeito dela'), origem: Value('usuario')));

    await carregarSemente(db, lerAsset: lerDoDisco, versao: 2);

    final r = await (db.select(db.receitas)..where((t) => t.id.equals(1)))
        .getSingle();
    expect(r.nome, 'Arroz do jeito dela');
  });

  test('todo alimento tem conversao para grama', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    final alimentos = await db.select(db.alimentos).get();
    final conv = await db.select(db.conversoes).get();
    final comGrama = conv
        .where((c) => c.unidade == Unidade.g || c.unidade == Unidade.ml)
        .map((c) => c.alimentoId)
        .toSet();

    for (final a in alimentos) {
      expect(comGrama, contains(a.id), reason: '${a.nome} sem conversao base');
    }
  });

  test('alimento comprado por unidade tem conversao de unidade', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    final porUnidade = (await db.select(db.alimentos).get())
        .where((a) => a.unidadeCompra == UnidadeCompra.unidade);
    final conv = await db.select(db.conversoes).get();
    final temUnidade = conv
        .where((c) => c.unidade == Unidade.unidade)
        .map((c) => c.alimentoId)
        .toSet();

    for (final a in porUnidade) {
      expect(temUnidade, contains(a.id), reason: '${a.nome} sem g por unidade');
    }
  });

  test('todo par (alimento, unidade) usado em receita tem conversao', () async {
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    final conv = {
      for (final c in await db.select(db.conversoes).get())
        (c.alimentoId, c.unidade)
    };
    final alimentos = {
      for (final a in await db.select(db.alimentos).get()) a.id: a.nome
    };

    final faltando = <String>[];
    for (final i in await db.select(db.receitaIngredientes).get()) {
      if (unidadesSemMedida.contains(i.unidade)) continue;
      if (!conv.contains((i.alimentoId, i.unidade))) {
        faltando.add('receita ${i.receitaId}: '
            '${alimentos[i.alimentoId]} em ${i.unidade.name}');
      }
    }
    expect(faltando, isEmpty, reason: faltando.join('
'));
  });

  test('todo json da semente e valido', () {
    for (final nome in const [
      'alimentos.json', 'conversoes.json', 'receitas.json',
      'combos.json', 'ciclo.json',
    ]) {
      expect(() => jsonDecode(lerDoDisco(nome)), returnsNormally,
          reason: nome);
    }
  });
}
```

- [ ] **Step 4: Rodar e ver falhar**

```bash
flutter test test/semente_test.dart
```

Esperado: FAIL — `lib/data/semente.dart` não existe.

- [ ] **Step 5: Implementar o carregador**

`lib/data/semente.dart`:

```dart
import 'dart:convert';

import 'package:drift/drift.dart';

import '../domain/modelos.dart';
import '../domain/porcoes.dart';
import 'app_database.dart';

/// Carrega a semente para dentro do banco, de forma idempotente.
///
/// Rodar duas vezes não duplica nada. Linha que a usuária editou — marcada com
/// `origem = 'usuario'` — nunca é sobrescrita (spec seção 12).
Future<void> carregarSemente(
  AppDatabase db, {
  required String Function(String nome) lerAsset,
  required int versao,
}) async {
  List<dynamic> ler(String nome) =>
      jsonDecode(lerAsset(nome)) as List<dynamic>;

  await db.transaction(() async {
    // --- alimentos
    for (final raw in ler('alimentos.json')) {
      final a = raw as Map<String, dynamic>;
      await db.into(db.alimentos).insertOnConflictUpdate(AlimentosCompanion(
            id: Value(a['id'] as int),
            nome: Value(a['nome'] as String),
            tacoCodigo: Value(a['taco'] as String?),
            kcal100g: Value((a['kcal'] as num).toDouble()),
            carboidratoG: Value((a['carb'] as num).toDouble()),
            proteinaG: Value((a['prot'] as num).toDouble()),
            gorduraG: Value((a['gord'] as num).toDouble()),
            fibraG: Value((a['fibra'] as num).toDouble()),
            sodioMg: Value((a['sodio'] as num).toDouble()),
            secaoMercado:
                Value(SecaoMercado.values.byName(a['secao'] as String)),
            unidadeCompra:
                Value(UnidadeCompra.values.byName(a['compra'] as String)),
          ));
    }

    // --- conversoes
    for (final raw in ler('conversoes.json')) {
      final c = raw as Map<String, dynamic>;
      await db.into(db.conversoes).insertOnConflictUpdate(ConversoesCompanion(
            alimentoId: Value(c['alimento'] as int),
            unidade: Value(Unidade.values.byName(c['unidade'] as String)),
            gramas: Value((c['gramas'] as num).toDouble()),
          ));
    }

    // --- receitas e ingredientes
    for (final raw in ler('receitas.json')) {
      final r = raw as Map<String, dynamic>;
      final id = r['id'] as int;

      final existente = await (db.select(db.receitas)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();

      // O que ela encostou é dela: seed nunca sobrescreve.
      if (existente != null && existente.origem == 'usuario') continue;

      await db.into(db.receitas).insertOnConflictUpdate(ReceitasCompanion(
            id: Value(id),
            nome: Value(r['nome'] as String),
            categoria:
                Value(CategoriaReceita.values.byName(r['categoria'] as String)),
            rendimentoPorcoes: Value(r['rende'] as int),
            tempoPreparoMin: Value(r['tempo'] as int),
            modoPreparo: Value(r['preparo'] as String),
            origem: const Value('seed'),
          ));

      await (db.delete(db.receitaIngredientes)
            ..where((t) => t.receitaId.equals(id)))
          .go();

      final ingredientes = r['ingredientes'] as List<dynamic>;
      for (var i = 0; i < ingredientes.length; i++) {
        final ing = ingredientes[i] as Map<String, dynamic>;
        await db
            .into(db.receitaIngredientes)
            .insert(ReceitaIngredientesCompanion.insert(
              receitaId: id,
              alimentoId: ing['alimento'] as int,
              ordem: i,
              quantidade: (ing['quantidade'] as num).toDouble(),
              unidade: Unidade.values.byName(ing['unidade'] as String),
              observacao: Value(ing['observacao'] as String?),
            ));
      }
    }

    // --- combos
    for (final raw in ler('combos.json')) {
      final c = raw as Map<String, dynamic>;
      final id = c['id'] as int;

      await db.into(db.combos).insertOnConflictUpdate(CombosCompanion(
            id: Value(id),
            nome: Value(c['nome'] as String),
            tipo: Value(TipoCombo.values.byName(c['tipo'] as String)),
            origem: const Value('seed'),
          ));

      await (db.delete(db.comboReceitas)..where((t) => t.comboId.equals(id)))
          .go();

      final receitas = (c['receitas'] as List<dynamic>).cast<int>();
      for (var i = 0; i < receitas.length; i++) {
        await db.into(db.comboReceitas).insert(ComboReceitasCompanion.insert(
              comboId: id,
              receitaId: receitas[i],
              ordem: i,
            ));
      }
    }

    // --- ciclo
    for (final raw in ler('ciclo.json')) {
      final c = raw as Map<String, dynamic>;
      await db.into(db.cicloItens).insertOnConflictUpdate(CicloItensCompanion(
            posicao: Value(c['posicao'] as int),
            tipoSlot: Value(TipoCombo.values.byName(c['tipo'] as String)),
            comboId: Value(c['combo'] as int),
          ));
    }

    // --- regras de porcao
    for (final entrada in regrasPadrao.entries) {
      final (slot, util) = entrada.key;
      await db.into(db.regrasPorcao).insertOnConflictUpdate(
          RegrasPorcaoCompanion(
              slot: Value(slot),
              diaUtil: Value(util),
              porcoes: Value(entrada.value)));
    }

    // --- config: só grava o que ainda não existe, para não pisar na escolha dela
    Future<void> configPadrao(String chave, String valor) async {
      final atual = await (db.select(db.config)
            ..where((t) => t.chave.equals(chave)))
          .getSingleOrNull();
      if (atual != null) return;
      await db
          .into(db.config)
          .insert(ConfigCompanion.insert(chave: chave, valor: valor));
    }

    await configPadrao('tamanho_ciclo', '33');
    await configPadrao(
        'data_inicio_ciclo', DataPura.de(DateTime.now()).iso);
    await configPadrao('tema', 'sistema');

    await db.into(db.config).insertOnConflictUpdate(
        ConfigCompanion.insert(chave: 'seed_version', valor: '$versao'));
  });
}
```

- [ ] **Step 6: Rodar e ver passar**

```bash
flutter test test/semente_test.dart
flutter analyze
```

Esperado: 8 testes passando. Se `todo alimento tem conversao para grama` falhar,
falta linha em `conversoes.json` — o teste diz o nome do alimento.

- [ ] **Step 7: Commit**

```bash
git add assets/semente/ lib/data/semente.dart test/semente_test.dart pubspec.yaml
git commit -m "feat(data): semente dos quatro primeiros dias com carga idempotente"
```

---

### Task 12: Repositórios

**Files:**
- Create: `lib/data/repo_config.dart`
- Create: `lib/data/repo_plano.dart`
- Create: `lib/data/repo_receitas.dart`
- Create: `lib/data/repo_mercado.dart`
- Create: `lib/data/database_provider.dart`
- Create: `test/repo_plano_test.dart`
- Create: `test/repo_mercado_test.dart`

**Interfaces:**
- Consumes: `AppDatabase`, todo o `lib/domain/`
- Produces:
  - `class RepoConfig` — `Future<DataPura> inicioCiclo()`, `Future<int> tamanhoCiclo()`, `Future<Map<(SlotRefeicao,bool),int>> regras()`, `Future<void> definir(String, String)`
  - `class DiaResolvido` — `data`, `posicao`, `refeicoes` (`List<RefeicaoDoDia>`)
  - `class RefeicaoDoDia` — `slot`, `porcoes`, `comboId`, `comboNome`, `espelhoIntacto`, `componentes` (`List<ComponenteDoDia>`), `nutrientes`
  - `class ComponenteDoDia` — `receitaId`, `nome`, `categoria`, `ingredientes` (`List<IngredienteEscalado>`), `nutrientes`
  - `class IngredienteEscalado` — `alimentoId`, `nome`, `quantidade`, `unidade`, `observacao`
  - `class RepoPlano` — `Future<DiaResolvido> dia(DataPura)`, `Future<void> substituirCombo(...)`, `Future<void> substituirComponente(...)`, `Future<void> limparOverrides(DataPura, SlotRefeicao)`, `Future<Set<DataPura>> diasEditados(DataPura, DataPura)`
  - `class RepoReceitas` — `Future<List<Receita>> listar({CategoriaReceita? categoria, String? busca})`, `Future<int> salvar(...)`, `Future<void> excluir(int)`, `Future<List<Combo>> combosDoTipo(TipoCombo)`
  - `class RepoMercado` — `Future<int> gerar(DataPura, DataPura)`, `Future<void> marcar(int, int, bool)`
  - providers Riverpod para todos eles

- [ ] **Step 1: Escrever `RepoConfig`**

`lib/data/repo_config.dart`:

```dart
import 'package:drift/drift.dart';

import '../domain/modelos.dart';
import '../domain/porcoes.dart';
import 'app_database.dart';

class RepoConfig {
  final AppDatabase db;
  const RepoConfig(this.db);

  Future<String?> ler(String chave) async {
    final l = await (db.select(db.config)..where((t) => t.chave.equals(chave)))
        .getSingleOrNull();
    return l?.valor;
  }

  Future<void> definir(String chave, String valor) => db
      .into(db.config)
      .insertOnConflictUpdate(ConfigCompanion.insert(chave: chave, valor: valor));

  Future<DataPura> inicioCiclo() async =>
      DataPura(await ler('data_inicio_ciclo') ?? DataPura.de(DateTime.now()).iso);

  Future<int> tamanhoCiclo() async =>
      int.tryParse(await ler('tamanho_ciclo') ?? '') ?? 33;

  Future<Map<(SlotRefeicao, bool), int>> regras() async {
    final linhas = await db.select(db.regrasPorcao).get();
    if (linhas.isEmpty) return regrasPadrao;
    return {for (final l in linhas) (l.slot, l.diaUtil): l.porcoes};
  }
}
```

- [ ] **Step 2: Escrever `RepoPlano`**

`lib/data/repo_plano.dart`:

```dart
import 'package:drift/drift.dart';

import '../domain/ciclo.dart';
import '../domain/escalonamento.dart';
import '../domain/modelos.dart';
import '../domain/nutricao.dart';
import '../domain/porcoes.dart';
import '../domain/resolucao.dart';
import 'app_database.dart';
import 'repo_config.dart';

class IngredienteEscalado {
  final int alimentoId;
  final String nome;
  final double quantidade;
  final Unidade unidade;
  final String? observacao;

  const IngredienteEscalado({
    required this.alimentoId,
    required this.nome,
    required this.quantidade,
    required this.unidade,
    this.observacao,
  });
}

class ComponenteDoDia {
  final int receitaId;
  final String nome;
  final CategoriaReceita categoria;
  final List<IngredienteEscalado> ingredientes;
  final Nutrientes nutrientes;

  const ComponenteDoDia({
    required this.receitaId,
    required this.nome,
    required this.categoria,
    required this.ingredientes,
    required this.nutrientes,
  });
}

class RefeicaoDoDia {
  final SlotRefeicao slot;
  final int porcoes;
  final int comboId;
  final String comboNome;
  final bool espelhoIntacto;
  final List<ComponenteDoDia> componentes;
  final Nutrientes nutrientes;

  const RefeicaoDoDia({
    required this.slot,
    required this.porcoes,
    required this.comboId,
    required this.comboNome,
    required this.espelhoIntacto,
    required this.componentes,
    required this.nutrientes,
  });
}

class DiaResolvido {
  final DataPura data;
  final int posicao;
  final int tamanhoCiclo;
  final List<RefeicaoDoDia> refeicoes;

  const DiaResolvido({
    required this.data,
    required this.posicao,
    required this.tamanhoCiclo,
    required this.refeicoes,
  });

  Nutrientes get total =>
      refeicoes.fold(Nutrientes.zero, (a, r) => a + r.nutrientes);
}

class RepoPlano {
  final AppDatabase db;
  final RepoConfig config;

  const RepoPlano(this.db, this.config);

  /// Monta o dia inteiro: quatro slots resolvidos, escalados e somados.
  Future<DiaResolvido> dia(DataPura data) async {
    final inicio = await config.inicioCiclo();
    final tamanho = await config.tamanhoCiclo();
    final regrasPorcao = await config.regras();
    final posicao =
        posicaoNoCiclo(inicio: inicio, data: data, tamanho: tamanho);

    final ciclo = {
      for (final c in await db.select(db.cicloItens).get())
        (c.posicao, c.tipoSlot): c.comboId,
    };

    final componentesDoCombo = <int, List<int>>{};
    final ligacoes = await (db.select(db.comboReceitas)
          ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
        .get();
    for (final l in ligacoes) {
      componentesDoCombo.putIfAbsent(l.comboId, () => []).add(l.receitaId);
    }

    final overridesCombo = {
      for (final o in await (db.select(db.overridesCombo)
            ..where((t) => t.data.equals(data.iso)))
          .get())
        (o.data, o.slot): o.comboId,
    };

    final overridesComponente =
        <(DataPura, SlotRefeicao), Map<int, int?>>{};
    for (final o in await (db.select(db.overridesComponente)
          ..where((t) => t.data.equals(data.iso)))
        .get()) {
      overridesComponente
          .putIfAbsent((o.data, o.slot), () => {})[o.receitaOriginalId] =
          o.receitaNovaId;
    }

    final combos = {
      for (final c in await db.select(db.combos).get()) c.id: c,
    };
    final receitas = {
      for (final r in await db.select(db.receitas).get()) r.id: r,
    };
    final alimentos = {
      for (final a in await db.select(db.alimentos).get()) a.id: a,
    };

    final conversoes = <int, Map<Unidade, double>>{};
    for (final c in await db.select(db.conversoes).get()) {
      conversoes.putIfAbsent(c.alimentoId, () => {})[c.unidade] = c.gramas;
    }

    final ingredientesPorReceita = <int, List<ReceitaIngrediente>>{};
    for (final i in await (db.select(db.receitaIngredientes)
          ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
        .get()) {
      ingredientesPorReceita.putIfAbsent(i.receitaId, () => []).add(i);
    }

    final refeicoes = <RefeicaoDoDia>[];
    for (final slot in SlotRefeicao.values) {
      final porcoes =
          porcoesDoSlot(slot: slot, data: data, regras: regrasPorcao);

      final res = resolverRefeicao(
        data: data,
        slot: slot,
        posicao: posicao,
        porcoes: porcoes,
        ciclo: ciclo,
        componentesDoCombo: componentesDoCombo,
        overridesCombo: overridesCombo,
        overridesComponente: overridesComponente,
      );

      final componentes = <ComponenteDoDia>[];
      var nutrRefeicao = Nutrientes.zero;

      for (final rid in res.receitaIds) {
        final receita = receitas[rid];
        if (receita == null) continue;

        final escalados = <IngredienteEscalado>[];
        var nutrReceita = Nutrientes.zero;

        for (final ing in ingredientesPorReceita[rid] ?? const []) {
          final quantidade = escalarQuantidade(
            quantidade: ing.quantidade,
            unidade: ing.unidade,
            porcoes: porcoes,
            rendimento: receita.rendimentoPorcoes,
          );
          final alimento = alimentos[ing.alimentoId];
          if (alimento == null) continue;

          escalados.add(IngredienteEscalado(
            alimentoId: alimento.id,
            nome: alimento.nome,
            quantidade: quantidade,
            unidade: ing.unidade,
            observacao: ing.observacao,
          ));

          // Nutrição sobre a quantidade JÁ arredondada (spec seção 7).
          final gramas = emGramas(
            unidade: ing.unidade,
            quantidade: quantidade,
            conversoes: conversoes[alimento.id] ?? const {},
            alimentoId: alimento.id,
          );
          nutrReceita = nutrReceita +
              nutrienteDe(
                por100g: Nutrientes(
                  kcal: alimento.kcal100g,
                  carboidrato: alimento.carboidratoG,
                  proteina: alimento.proteinaG,
                  gordura: alimento.gorduraG,
                  fibra: alimento.fibraG,
                  sodio: alimento.sodioMg,
                ),
                gramas: gramas,
              );
        }

        componentes.add(ComponenteDoDia(
          receitaId: rid,
          nome: receita.nome,
          categoria: receita.categoria,
          ingredientes: escalados,
          nutrientes: nutrReceita,
        ));
        nutrRefeicao = nutrRefeicao + nutrReceita;
      }

      refeicoes.add(RefeicaoDoDia(
        slot: slot,
        porcoes: porcoes,
        comboId: res.comboId,
        comboNome: combos[res.comboId]?.nome ?? '',
        espelhoIntacto: res.espelhoIntacto,
        componentes: componentes,
        nutrientes: nutrRefeicao,
      ));
    }

    return DiaResolvido(
      data: data,
      posicao: posicao,
      tamanhoCiclo: tamanho,
      refeicoes: refeicoes,
    );
  }

  Future<void> substituirCombo({
    required DataPura data,
    required SlotRefeicao slot,
    required int comboId,
  }) =>
      db.into(db.overridesCombo).insertOnConflictUpdate(
          OverridesComboCompanion.insert(
              data: data, slot: slot, comboId: comboId));

  /// [receitaNovaId] nulo remove o componente do prato naquele dia.
  Future<void> substituirComponente({
    required DataPura data,
    required SlotRefeicao slot,
    required int receitaOriginalId,
    required int? receitaNovaId,
  }) =>
      db.into(db.overridesComponente).insertOnConflictUpdate(
          OverridesComponenteCompanion.insert(
            data: data,
            slot: slot,
            receitaOriginalId: receitaOriginalId,
            receitaNovaId: Value(receitaNovaId),
          ));

  /// Devolve o slot ao ciclo, restaurando o espelho.
  Future<void> limparOverrides(DataPura data, SlotRefeicao slot) async {
    await (db.delete(db.overridesCombo)
          ..where((t) => t.data.equals(data.iso) & t.slot.equalsValue(slot)))
        .go();
    await (db.delete(db.overridesComponente)
          ..where((t) => t.data.equals(data.iso) & t.slot.equalsValue(slot)))
        .go();
  }

  /// Datas do intervalo que têm alguma substituição — alimenta o ponto de
  /// brasa no calendário.
  Future<Set<DataPura>> diasEditados(DataPura de, DataPura ate) async {
    final combos = await (db.select(db.overridesCombo)
          ..where((t) => t.data.isBetweenValues(de.iso, ate.iso)))
        .get();
    final comps = await (db.select(db.overridesComponente)
          ..where((t) => t.data.isBetweenValues(de.iso, ate.iso)))
        .get();
    return {...combos.map((e) => e.data), ...comps.map((e) => e.data)};
  }
}
```

- [ ] **Step 3: Escrever o teste de `RepoPlano`**

`test/repo_plano_test.dart`:

```dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/domain/modelos.dart';

String lerDoDisco(String nome) =>
    File('assets/semente/$nome').readAsStringSync();

void main() {
  late AppDatabase db;
  late RepoPlano repo;

  // 2026-09-04 e sexta; 2026-09-05 sabado.
  const sexta = DataPura('2026-09-04');
  const sabado = DataPura('2026-09-05');

  setUp(() async {
    db = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final config = RepoConfig(db);
    // ciclo comeca em 2026-09-01 para o dia 4 cair na posicao 4
    await config.definir('data_inicio_ciclo', '2026-09-01');
    // a semente desta fase tem so 4 posicoes; sem isto, qualquer data que caia
    // na posicao 5+ estoura `StateError: ciclo sem combo`
    await config.definir('tamanho_ciclo', '4');
    repo = RepoPlano(db, config);
  });
  tearDown(() async => db.close());

  RefeicaoDoDia slotDe(DiaResolvido d, SlotRefeicao s) =>
      d.refeicoes.firstWhere((r) => r.slot == s);

  test('resolve os quatro slots do dia', () async {
    final d = await repo.dia(sexta);
    expect(d.posicao, 4);
    expect(d.refeicoes, hasLength(4));
  });

  test('sexta tem 1 porcao no almoco e 2 no jantar', () async {
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.almoco).porcoes, 1);
    expect(slotDe(d, SlotRefeicao.jantar).porcoes, 2);
  });

  test('sabado tem 2 porcoes em tudo', () async {
    final d = await repo.dia(sabado);
    for (final r in d.refeicoes) {
      expect(r.porcoes, 2, reason: '${r.slot}');
    }
  });

  test('jantar espelha o combo do almoco', () async {
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.jantar).comboId,
        slotDe(d, SlotRefeicao.almoco).comboId);
    expect(slotDe(d, SlotRefeicao.jantar).espelhoIntacto, isTrue);
  });

  test('o jantar de 2 porcoes dobra a quantidade do almoco', () async {
    final d = await repo.dia(sexta);
    final arrozAlmoco = slotDe(d, SlotRefeicao.almoco)
        .componentes
        .firstWhere((c) => c.nome == 'Arroz branco');
    final arrozJantar = slotDe(d, SlotRefeicao.jantar)
        .componentes
        .firstWhere((c) => c.nome == 'Arroz branco');

    final gAlmoco = arrozAlmoco.ingredientes
        .firstWhere((i) => i.nome == 'Arroz branco cozido')
        .quantidade;
    final gJantar = arrozJantar.ingredientes
        .firstWhere((i) => i.nome == 'Arroz branco cozido')
        .quantidade;

    expect(gJantar, gAlmoco * 2);
  });

  test('dente de alho arredonda para cima ao dobrar', () async {
    final d = await repo.dia(sexta);
    final arroz = slotDe(d, SlotRefeicao.jantar)
        .componentes
        .firstWhere((c) => c.nome == 'Arroz branco');
    final alho = arroz.ingredientes.firstWhere((i) => i.nome == 'Alho cru');
    expect(alho.quantidade, 2);
    expect(alho.unidade, Unidade.dente);
  });

  test('nutricao do dia soma as quatro refeicoes', () async {
    final d = await repo.dia(sexta);
    final soma = d.refeicoes
        .map((r) => r.nutrientes.kcal)
        .fold<double>(0, (a, b) => a + b);
    expect(d.total.kcal, closeTo(soma, 0.001));
    expect(d.total.kcal, greaterThan(0));
  });

  test('substituir o combo do almoco arrasta o jantar', () async {
    await repo.substituirCombo(
        data: sexta, slot: SlotRefeicao.almoco, comboId: 5);
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.almoco).comboId, 5);
    expect(slotDe(d, SlotRefeicao.jantar).comboId, 5);
  });

  test('substituir o jantar solta o espelho', () async {
    await repo.substituirCombo(
        data: sexta, slot: SlotRefeicao.jantar, comboId: 5);
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.almoco).comboId, 8);
    expect(slotDe(d, SlotRefeicao.jantar).comboId, 5);
    expect(slotDe(d, SlotRefeicao.jantar).espelhoIntacto, isFalse);
  });

  test('substituir um componente troca so ele', () async {
    await repo.substituirComponente(
        data: sexta,
        slot: SlotRefeicao.almoco,
        receitaOriginalId: 3,
        receitaNovaId: 22);
    final d = await repo.dia(sexta);
    final nomes =
        slotDe(d, SlotRefeicao.almoco).componentes.map((c) => c.nome);
    expect(nomes, contains('Frango grelhado simples'));
    expect(nomes, isNot(contains('Picadinho de carne com legumes')));
    expect(nomes, contains('Arroz branco'));
  });

  test('componente com destino nulo some do prato', () async {
    await repo.substituirComponente(
        data: sexta,
        slot: SlotRefeicao.almoco,
        receitaOriginalId: 5,
        receitaNovaId: null);
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.almoco).componentes, hasLength(4));
  });

  test('limparOverrides devolve o dia ao ciclo', () async {
    await repo.substituirCombo(
        data: sexta, slot: SlotRefeicao.jantar, comboId: 5);
    await repo.limparOverrides(sexta, SlotRefeicao.jantar);
    final d = await repo.dia(sexta);
    expect(slotDe(d, SlotRefeicao.jantar).comboId, 8);
    expect(slotDe(d, SlotRefeicao.jantar).espelhoIntacto, isTrue);
  });

  test('diasEditados lista so os dias com substituicao', () async {
    await repo.substituirCombo(
        data: sexta, slot: SlotRefeicao.almoco, comboId: 5);
    final editados = await repo.diasEditados(
        const DataPura('2026-09-01'), const DataPura('2026-09-30'));
    expect(editados, {sexta});
  });

  test('dia anterior ao inicio do ciclo resolve sem estourar', () async {
    final d = await repo.dia(const DataPura('2026-08-30'));
    expect(d.posicao, inInclusiveRange(1, 33));
    expect(d.refeicoes, hasLength(4));
  });
}
```

- [ ] **Step 4: Rodar e ver falhar, depois passar**

```bash
flutter test test/repo_plano_test.dart
```

Esperado: primeiro FAIL (arquivos ausentes), depois 14 testes passando.

O `setUp` já define `tamanho_ciclo = '4'`, porque a semente desta fase só tem 4
posições. Sem isso, **dois** testes estouram `StateError: ciclo sem combo`:
`sabado tem 2 porcoes em tudo` (2026-09-05 cai na posição 5) e
`dia anterior ao inicio do ciclo resolve sem estourar`.

- [ ] **Step 5: Escrever `RepoReceitas`**

`lib/data/repo_receitas.dart`:

```dart
import 'package:drift/drift.dart';

import '../domain/modelos.dart';
import 'app_database.dart';

class RepoReceitas {
  final AppDatabase db;
  const RepoReceitas(this.db);

  Future<List<Receita>> listar({
    CategoriaReceita? categoria,
    String? busca,
  }) {
    final q = db.select(db.receitas)..where((t) => t.ativa.equals(true));
    if (categoria != null) {
      q.where((t) => t.categoria.equalsValue(categoria));
    }
    if (busca != null && busca.trim().isNotEmpty) {
      q.where((t) => t.nome.lower().contains(busca.trim().toLowerCase()));
    }
    q.orderBy([(t) => OrderingTerm(expression: t.nome)]);
    return q.get();
  }

  Future<Receita?> porId(int id) =>
      (db.select(db.receitas)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<ReceitaIngrediente>> ingredientesDe(int receitaId) =>
      (db.select(db.receitaIngredientes)
            ..where((t) => t.receitaId.equals(receitaId))
            ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
          .get();

  /// Salva a receita e substitui a lista de ingredientes inteira.
  ///
  /// Toda escrita marca `origem = 'usuario'`: a partir daí a semente nunca
  /// mais sobrescreve esta linha (spec seção 12).
  Future<int> salvar({
    int? id,
    required String nome,
    required CategoriaReceita categoria,
    required int rendimentoPorcoes,
    required int tempoPreparoMin,
    required String modoPreparo,
    required List<({int alimentoId, double quantidade, Unidade unidade, String? observacao})>
        ingredientes,
  }) async {
    return db.transaction(() async {
      final companion = ReceitasCompanion(
        id: id == null ? const Value.absent() : Value(id),
        nome: Value(nome),
        categoria: Value(categoria),
        rendimentoPorcoes: Value(rendimentoPorcoes),
        tempoPreparoMin: Value(tempoPreparoMin),
        modoPreparo: Value(modoPreparo),
        origem: const Value('usuario'),
      );

      final receitaId = id == null
          ? await db.into(db.receitas).insert(companion)
          : await () async {
              await db.into(db.receitas).insertOnConflictUpdate(companion);
              return id;
            }();

      await (db.delete(db.receitaIngredientes)
            ..where((t) => t.receitaId.equals(receitaId)))
          .go();

      for (var i = 0; i < ingredientes.length; i++) {
        final ing = ingredientes[i];
        await db
            .into(db.receitaIngredientes)
            .insert(ReceitaIngredientesCompanion.insert(
              receitaId: receitaId,
              alimentoId: ing.alimentoId,
              ordem: i,
              quantidade: ing.quantidade,
              unidade: ing.unidade,
              observacao: Value(ing.observacao),
            ));
      }
      return receitaId;
    });
  }

  /// Desativa em vez de apagar: a receita pode estar em combo de dia passado.
  Future<void> excluir(int id) =>
      (db.update(db.receitas)..where((t) => t.id.equals(id)))
          .write(const ReceitasCompanion(ativa: Value(false)));

  Future<List<Combo>> combosDoTipo(TipoCombo tipo) =>
      (db.select(db.combos)
            ..where((t) => t.tipo.equalsValue(tipo) & t.ativo.equals(true))
            ..orderBy([(t) => OrderingTerm(expression: t.nome)]))
          .get();

  Future<List<Alimento>> alimentos() =>
      (db.select(db.alimentos)
            ..orderBy([(t) => OrderingTerm(expression: t.nome)]))
          .get();
}
```

- [ ] **Step 6: Escrever `RepoMercado`**

`lib/data/repo_mercado.dart`:

```dart
import 'package:drift/drift.dart';

import '../domain/mercado.dart';
import '../domain/modelos.dart';
import 'app_database.dart';
import 'repo_plano.dart';

class RepoMercado {
  final AppDatabase db;
  final RepoPlano plano;

  const RepoMercado(this.db, this.plano);

  /// Expande o intervalo dia a dia, agrega e congela a lista.
  ///
  /// Materializa de propósito (spec D6): ela marca itens dentro do mercado ao
  /// longo de minutos, e a lista não pode se mexer se o plano mudar no meio.
  Future<int> gerar(DataPura de, DataPura ate) async {
    final linhas = <LinhaIngrediente>[];

    var cursor = de.comoDateTime;
    final fim = ate.comoDateTime;
    while (!cursor.isAfter(fim)) {
      final dia = await plano.dia(DataPura.de(cursor));
      for (final refeicao in dia.refeicoes) {
        for (final componente in refeicao.componentes) {
          for (final ing in componente.ingredientes) {
            linhas.add(LinhaIngrediente(
              alimentoId: ing.alimentoId,
              unidade: ing.unidade,
              quantidade: ing.quantidade,
            ));
          }
        }
      }
      cursor = cursor.add(const Duration(days: 1));
    }

    final conversoes = <int, Map<Unidade, double>>{};
    for (final c in await db.select(db.conversoes).get()) {
      conversoes.putIfAbsent(c.alimentoId, () => {})[c.unidade] = c.gramas;
    }
    final alimentos = await db.select(db.alimentos).get();

    final itens = agregarMercado(
      linhas: linhas,
      conversoes: conversoes,
      secoes: {for (final a in alimentos) a.id: a.secaoMercado},
      unidadesCompra: {for (final a in alimentos) a.id: a.unidadeCompra},
    );

    return db.transaction(() async {
      final listaId = await db.into(db.listasCompra).insert(
          ListasCompraCompanion.insert(
              dataInicio: de, dataFim: ate, criadaEm: DateTime.now()));

      for (final i in itens) {
        await db.into(db.listaCompraItens).insert(
            ListaCompraItensCompanion.insert(
                listaId: listaId,
                alimentoId: i.alimentoId,
                quantidadeG: i.gramas));
      }
      return listaId;
    });
  }

  Future<ListaCompra?> ultimaLista() => (db.select(db.listasCompra)
        ..orderBy([
          (t) => OrderingTerm(expression: t.criadaEm, mode: OrderingMode.desc)
        ])
        ..limit(1))
      .getSingleOrNull();

  Future<List<ListaCompraItem>> itens(int listaId) =>
      (db.select(db.listaCompraItens)
            ..where((t) => t.listaId.equals(listaId)))
          .get();

  Future<void> marcar(int listaId, int alimentoId, bool marcado) =>
      (db.update(db.listaCompraItens)
            ..where((t) =>
                t.listaId.equals(listaId) & t.alimentoId.equals(alimentoId)))
          .write(ListaCompraItensCompanion(marcado: Value(marcado)));
}
```

- [ ] **Step 7: Escrever o teste de `RepoMercado`**

`test/repo_mercado_test.dart`:

```dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/repo_mercado.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/domain/modelos.dart';

String lerDoDisco(String nome) =>
    File('assets/semente/$nome').readAsStringSync();

void main() {
  late AppDatabase db;
  late RepoMercado mercado;

  setUp(() async {
    db = AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final config = RepoConfig(db);
    await config.definir('data_inicio_ciclo', '2026-09-01');
    await config.definir('tamanho_ciclo', '4');
    mercado = RepoMercado(db, RepoPlano(db, config));
  });
  tearDown(() async => db.close());

  test('gera lista de um dia com itens', () async {
    final id = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));
    final itens = await mercado.itens(id);
    expect(itens, isNotEmpty);
    expect(itens.every((i) => i.quantidadeG > 0), isTrue);
  });

  test('uma semana soma mais que um dia', () async {
    final umDia = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));
    final semana = await mercado.gerar(
        const DataPura('2026-09-01'), const DataPura('2026-09-07'));

    final gDia = (await mercado.itens(umDia))
        .fold<double>(0, (a, i) => a + i.quantidadeG);
    final gSemana = (await mercado.itens(semana))
        .fold<double>(0, (a, i) => a + i.quantidadeG);

    expect(gSemana, greaterThan(gDia));
  });

  test('cada alimento aparece uma vez so na lista', () async {
    final id = await mercado.gerar(
        const DataPura('2026-09-01'), const DataPura('2026-09-07'));
    final itens = await mercado.itens(id);
    final ids = itens.map((i) => i.alimentoId).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('sal a gosto nao entra na lista', () async {
    final id = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));
    final itens = await mercado.itens(id);
    final sal = (await db.select(db.alimentos).get())
        .firstWhere((a) => a.nome == 'Sal');
    expect(itens.any((i) => i.alimentoId == sal.id), isFalse);
  });

  test('marcar item persiste', () async {
    final id = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));
    final primeiro = (await mercado.itens(id)).first;

    await mercado.marcar(id, primeiro.alimentoId, true);

    final relido = (await mercado.itens(id))
        .firstWhere((i) => i.alimentoId == primeiro.alimentoId);
    expect(relido.marcado, isTrue);
  });

  test('gerar de novo cria lista nova, nao sobrescreve', () async {
    final a = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));
    final b = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));

    expect(a, isNot(b));
    expect(await db.select(db.listasCompra).get(), hasLength(2));
  });

  test('ultimaLista devolve a mais recente', () async {
    await mercado.gerar(
        const DataPura('2026-09-01'), const DataPura('2026-09-01'));
    final ultima = await mercado.gerar(
        const DataPura('2026-09-04'), const DataPura('2026-09-04'));

    expect((await mercado.ultimaLista())!.id, ultima);
  });
}
```

- [ ] **Step 8: Escrever os providers**

`lib/data/database_provider.dart`:

```dart
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'repo_config.dart';
import 'repo_mercado.dart';
import 'repo_plano.dart';
import 'repo_receitas.dart';
import 'semente.dart';

/// Versão da semente empacotada. Subir isto reimporta o conteúdo `seed`
/// e deixa intacto o que a usuária editou.
const int versaoSemente = 1;

final bancoProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.dispose);
  return db;
});

final repoConfigProvider =
    Provider<RepoConfig>((ref) => RepoConfig(ref.watch(bancoProvider)));

final repoPlanoProvider = Provider<RepoPlano>(
    (ref) => RepoPlano(ref.watch(bancoProvider), ref.watch(repoConfigProvider)));

final repoReceitasProvider =
    Provider<RepoReceitas>((ref) => RepoReceitas(ref.watch(bancoProvider)));

final repoMercadoProvider = Provider<RepoMercado>((ref) =>
    RepoMercado(ref.watch(bancoProvider), ref.watch(repoPlanoProvider)));

/// Roda a carga da semente uma vez, na abertura do app.
final semeaduraProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(bancoProvider);
  final atual = await RepoConfig(db).ler('seed_version');
  if (atual == '$versaoSemente') return;

  final cache = <String, String>{};
  for (final nome in const [
    'alimentos.json', 'conversoes.json', 'receitas.json',
    'combos.json', 'ciclo.json',
  ]) {
    cache[nome] = await rootBundle.loadString('assets/semente/$nome');
  }

  await carregarSemente(db,
      lerAsset: (nome) => cache[nome]!, versao: versaoSemente);
});
```

- [ ] **Step 9: Rodar tudo**

```bash
flutter test
flutter analyze
```

Esperado: verde. `repo_mercado_test.dart` com 7 testes, `repo_plano_test.dart`
com 14.

- [ ] **Step 10: Commit**

```bash
git add lib/data/ test/repo_plano_test.dart test/repo_mercado_test.dart
git commit -m "feat(data): repositorios de plano, receitas, mercado e config"
```

---

### Task 13: Backup

**Files:**
- Create: `lib/data/backup.dart`
- Create: `test/backup_test.dart`

**Interfaces:**
- Consumes: `AppDatabase`
- Produces: `Future<String> exportarJson(AppDatabase)`, `Future<void> importarJson(AppDatabase, String)`

- [ ] **Step 1: Escrever o teste que falha**

`test/backup_test.dart`:

```dart
import 'dart:convert';
import 'dart:io';

// `hide`: drift exporta `isNull`/`isNotNull` top-level deprecados que
// colidem com os matchers homonimos do package:matcher.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/backup.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/domain/modelos.dart';

String lerDoDisco(String nome) =>
    File('assets/semente/$nome').readAsStringSync();

AppDatabase novoBanco() => AppDatabase(DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ));

void main() {
  test('exporta json com cabecalho e tabelas', () async {
    final db = novoBanco();
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    final texto = await exportarJson(db);
    final mapa = jsonDecode(texto) as Map<String, dynamic>;

    expect(mapa['seed_version'], isNotNull);
    expect(mapa['exportado_em'], isNotNull);
    expect(mapa['tabelas'], isA<Map<String, dynamic>>());
    expect((mapa['tabelas'] as Map)['alimentos'], hasLength(40));

    await db.close();
  });

  test('exportar e importar devolve o mesmo estado', () async {
    final origem = novoBanco();
    await carregarSemente(origem, lerAsset: lerDoDisco, versao: 1);
    await RepoPlano(origem, RepoConfig(origem)).substituirCombo(
        data: const DataPura('2026-09-04'),
        slot: SlotRefeicao.almoco,
        comboId: 5);

    final texto = await exportarJson(origem);

    final destino = novoBanco();
    await importarJson(destino, texto);

    expect(await destino.select(destino.alimentos).get(), hasLength(40));
    expect(await destino.select(destino.receitas).get(), hasLength(24));

    final ov = await destino.select(destino.overridesCombo).getSingle();
    expect(ov.comboId, 5);
    expect(ov.data, const DataPura('2026-09-04'));

    await origem.close();
    await destino.close();
  });

  test('importar substitui o que estava la', () async {
    final db = novoBanco();
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);
    final texto = await exportarJson(db);

    await db.into(db.alimentos).insert(AlimentosCompanion.insert(
          nome: 'Alimento intruso',
          kcal100g: 1, carboidratoG: 1, proteinaG: 1,
          gorduraG: 1, fibraG: 1, sodioMg: 1,
          secaoMercado: SecaoMercado.mercearia,
          unidadeCompra: UnidadeCompra.kg,
        ));
    expect(await db.select(db.alimentos).get(), hasLength(41));

    await importarJson(db, texto);
    expect(await db.select(db.alimentos).get(), hasLength(40));

    await db.close();
  });

  test('json malformado estoura em vez de apagar tudo', () async {
    final db = novoBanco();
    await carregarSemente(db, lerAsset: lerDoDisco, versao: 1);

    await expectLater(
        importarJson(db, '{ nao e json valido'), throwsA(isA<Exception>()));
    expect(await db.select(db.alimentos).get(), hasLength(40));

    await db.close();
  });
}
```

- [ ] **Step 2: Rodar e ver falhar**

```bash
flutter test test/backup_test.dart
```

Esperado: FAIL — `lib/data/backup.dart` não existe.

- [ ] **Step 3: Implementar**

`lib/data/backup.dart`:

```dart
import 'dart:convert';

import 'package:drift/drift.dart';

import 'app_database.dart';

/// Formato do arquivo de backup. Subir só se o layout mudar de forma
/// incompatível.
const int formatoBackup = 1;

/// Serializa o banco inteiro num JSON legível.
Future<String> exportarJson(AppDatabase db) async {
  final tabelas = <String, List<Map<String, dynamic>>>{};

  for (final t in db.allTables) {
    final linhas = await db.customSelect('SELECT * FROM ${t.actualTableName}')
        .get();
    tabelas[t.actualTableName] =
        linhas.map((l) => Map<String, dynamic>.from(l.data)).toList();
  }

  final versao = tabelas['config']
      ?.firstWhere((l) => l['chave'] == 'seed_version',
          orElse: () => <String, dynamic>{'valor': null})['valor'];

  return const JsonEncoder.withIndent('  ').convert({
    'formato': formatoBackup,
    'seed_version': versao,
    'exportado_em': DateTime.now().toIso8601String(),
    'tabelas': tabelas,
  });
}

/// Substitui o conteúdo do aparelho pelo do arquivo.
///
/// Roda inteiro dentro de uma transação: JSON quebrado no meio não deixa o
/// banco pela metade.
Future<void> importarJson(AppDatabase db, String texto) async {
  final Map<String, dynamic> mapa;
  try {
    mapa = jsonDecode(texto) as Map<String, dynamic>;
  } on FormatException catch (e) {
    throw Exception('arquivo de backup invalido: ${e.message}');
  }

  final tabelas = mapa['tabelas'];
  if (tabelas is! Map<String, dynamic>) {
    throw Exception('arquivo de backup sem a secao "tabelas"');
  }

  await db.transaction(() async {
    await db.customStatement('PRAGMA foreign_keys = OFF');

    // Apaga na ordem inversa para não brigar com dependência.
    for (final t in db.allTables.toList().reversed) {
      await db.customStatement('DELETE FROM ${t.actualTableName}');
    }

    for (final t in db.allTables) {
      final linhas = tabelas[t.actualTableName];
      if (linhas is! List) continue;

      for (final raw in linhas) {
        final linha = Map<String, dynamic>.from(raw as Map);
        final colunas = linha.keys.toList();
        final marcadores = List.filled(colunas.length, '?').join(', ');

        await db.customInsert(
          'INSERT INTO ${t.actualTableName} '
          '(${colunas.join(', ')}) VALUES ($marcadores)',
          variables: colunas.map((c) => _variavel(linha[c])).toList(),
        );
      }
    }

    await db.customStatement('PRAGMA foreign_keys = ON');
  });
}

Variable<Object> _variavel(Object? v) => switch (v) {
      null => const Variable<String>(null),
      final int i => Variable<int>(i),
      final double d => Variable<double>(d),
      final bool b => Variable<bool>(b),
      final Uint8List u => Variable<Uint8List>(u),
      _ => Variable<String>(v.toString()),
    };
```

- [ ] **Step 4: Rodar e ver passar**

```bash
flutter test test/backup_test.dart
flutter analyze
```

Esperado: 4 testes passando.

- [ ] **Step 5: Fechar a fase**

```bash
flutter test
```

Esperado: Fases A e B verdes.

- [ ] **Step 6: Commit**

```bash
git add lib/data/backup.dart test/backup_test.dart
git commit -m "feat(data): export e import de backup json"
```

---

# Fase C — apresentação

Dez tarefas. Cada tela é uma tarefa, com teste de widget próprio. Nenhuma precisa de
emulador: `flutter test` roda widget test na Dart VM.

---

### Task 14: Tema Esmalte

**Files:**
- Create: `assets/fontes/` (quatro arquivos baixados)
- Create: `lib/presentation/tema/cores.dart`
- Create: `lib/presentation/tema/tipografia.dart`
- Create: `lib/presentation/tema/respingo.dart`
- Create: `lib/presentation/tema/tema.dart`
- Create: `test/tema_test.dart`
- Modify: `pubspec.yaml` (seções `assets:` e `fonts:`)

**Interfaces:**
- Consumes: nada do projeto
- Produces:
  - `class Esmalte` — tokens estáticos: `marinho`, `anil`, `aro`, `brasa`, e os pares claro/escuro
  - `class CoresEsmalte extends ThemeExtension<CoresEsmalte>` — `aro`, `marinho`, `brasa`, `superficie2`
  - `TextTheme textThemeEsmalte(Color cor)`
  - `class PinturaRespingo extends CustomPainter`
  - `ThemeData temaClaro()`, `ThemeData temaEscuro()`

- [ ] **Step 1: Baixar as fontes**

Manrope e Darker Grotesque são fontes variáveis — um arquivo cobre todos os pesos, e
o peso se escolhe por `fontVariations`, não por `fontWeight`. IBM Plex Mono vem em
arquivos estáticos.

```bash
mkdir -p assets/fontes
curl -L -o assets/fontes/DarkerGrotesque-var.ttf \
  "https://raw.githubusercontent.com/google/fonts/main/ofl/darkergrotesque/DarkerGrotesque%5Bwght%5D.ttf"
curl -L -o assets/fontes/Manrope-var.ttf \
  "https://raw.githubusercontent.com/google/fonts/main/ofl/manrope/Manrope%5Bwght%5D.ttf"
curl -L -o assets/fontes/IBMPlexMono-Regular.ttf \
  "https://raw.githubusercontent.com/google/fonts/main/ofl/ibmplexmono/IBMPlexMono-Regular.ttf"
curl -L -o assets/fontes/IBMPlexMono-Medium.ttf \
  "https://raw.githubusercontent.com/google/fonts/main/ofl/ibmplexmono/IBMPlexMono-Medium.ttf"
```

Confirmar os tamanhos — se algum vier com poucos bytes, o download falhou e virou
página de erro HTML:

```bash
ls -l assets/fontes/
```

Esperado, aproximadamente: DarkerGrotesque 91 KB, Manrope 165 KB, IBMPlexMono
135 KB e 136 KB.

- [ ] **Step 2: Declarar fontes e assets no pubspec**

Substituir a seção `flutter:` inteira de `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/semente/

  fonts:
    - family: DarkerGrotesque
      fonts:
        - asset: assets/fontes/DarkerGrotesque-var.ttf
    - family: Manrope
      fonts:
        - asset: assets/fontes/Manrope-var.ttf
    - family: IBMPlexMono
      fonts:
        - asset: assets/fontes/IBMPlexMono-Regular.ttf
        - asset: assets/fontes/IBMPlexMono-Medium.ttf
          weight: 500
```

Não declarar `weight` nos arquivos variáveis: um `weight` por arquivo faria o Flutter
tratar a fonte como estática naquele peso. O peso vem de `fontVariations`.

- [ ] **Step 3: Escrever os tokens de cor**

`lib/presentation/tema/cores.dart`:

```dart
import 'package:flutter/material.dart';

/// Tokens da direção Esmalte (spec seção 11.1). A panela de ágata: branco
/// esmaltado, marinho salpicado, aro escuro onde o esmalte termina.
abstract final class Esmalte {
  // invariantes
  static const marinho = Color(0xFF14263F);
  static const marinhoEscuro = Color(0xFF0B1927);
  static const aro = Color(0xFF0A1017);

  // claro
  static const anilClaro = Color(0xFF2C4A73);
  static const superficieClaro = Color(0xFFFFFFFF);
  static const fundoClaro = Color(0xFFE9EDF0);
  static const superficie2Claro = Color(0xFFF3F7F9);
  static const brasaClaro = Color(0xFFC7412B);
  static const inkClaro = Color(0xFF0E1519);
  static const ink2Claro = Color(0xFF3E4A55);
  static const ink3Claro = Color(0xFF7C8B98);
  static const linhaClaro = Color(0xFFD5DEE4);

  // escuro
  static const anilEscuro = Color(0xFF3C5F87);
  static const superficieEscuro = Color(0xFF16232F);
  static const fundoEscuro = Color(0xFF0E1720);
  static const superficie2Escuro = Color(0xFF1D2C3A);
  static const brasaEscuro = Color(0xFFE4694E);
  static const inkEscuro = Color(0xFFEAF0F4);
  static const ink2Escuro = Color(0xFFAAB9C6);
  static const ink3Escuro = Color(0xFF74889A);
  static const linhaEscuro = Color(0xFF25374A);
}

/// O que o Material não tem lugar para guardar: o aro do cartão, o campo
/// marinho do respingo e a brasa.
@immutable
class CoresEsmalte extends ThemeExtension<CoresEsmalte> {
  final Color aro;
  final Color marinho;
  final Color brasa;
  final Color superficie2;
  final Color linha;
  final Color ink2;
  final Color ink3;

  const CoresEsmalte({
    required this.aro,
    required this.marinho,
    required this.brasa,
    required this.superficie2,
    required this.linha,
    required this.ink2,
    required this.ink3,
  });

  static const claro = CoresEsmalte(
    aro: Esmalte.aro,
    marinho: Esmalte.marinho,
    brasa: Esmalte.brasaClaro,
    superficie2: Esmalte.superficie2Claro,
    linha: Esmalte.linhaClaro,
    ink2: Esmalte.ink2Claro,
    ink3: Esmalte.ink3Claro,
  );

  static const escuro = CoresEsmalte(
    aro: Esmalte.aro,
    marinho: Esmalte.marinhoEscuro,
    brasa: Esmalte.brasaEscuro,
    superficie2: Esmalte.superficie2Escuro,
    linha: Esmalte.linhaEscuro,
    ink2: Esmalte.ink2Escuro,
    ink3: Esmalte.ink3Escuro,
  );

  @override
  CoresEsmalte copyWith({
    Color? aro,
    Color? marinho,
    Color? brasa,
    Color? superficie2,
    Color? linha,
    Color? ink2,
    Color? ink3,
  }) =>
      CoresEsmalte(
        aro: aro ?? this.aro,
        marinho: marinho ?? this.marinho,
        brasa: brasa ?? this.brasa,
        superficie2: superficie2 ?? this.superficie2,
        linha: linha ?? this.linha,
        ink2: ink2 ?? this.ink2,
        ink3: ink3 ?? this.ink3,
      );

  @override
  CoresEsmalte lerp(ThemeExtension<CoresEsmalte>? outro, double t) {
    if (outro is! CoresEsmalte) return this;
    return CoresEsmalte(
      aro: Color.lerp(aro, outro.aro, t)!,
      marinho: Color.lerp(marinho, outro.marinho, t)!,
      brasa: Color.lerp(brasa, outro.brasa, t)!,
      superficie2: Color.lerp(superficie2, outro.superficie2, t)!,
      linha: Color.lerp(linha, outro.linha, t)!,
      ink2: Color.lerp(ink2, outro.ink2, t)!,
      ink3: Color.lerp(ink3, outro.ink3, t)!,
    );
  }
}

/// Atalho: `context.esmalte.brasa`.
extension EsmalteDoContexto on BuildContext {
  CoresEsmalte get esmalte =>
      Theme.of(this).extension<CoresEsmalte>() ?? CoresEsmalte.claro;
}
```

- [ ] **Step 4: Escrever a tipografia**

`lib/presentation/tema/tipografia.dart`:

```dart
import 'package:flutter/material.dart';

/// Peso em fonte variável: `fontWeight` sozinho não move o eixo `wght`.
List<FontVariation> _peso(double w) => [FontVariation('wght', w)];

/// Escala da spec 11.2.
///
/// `DarkerGrotesque` só entra em corpo ≥ 17 px — abaixo disso a família perde
/// legibilidade. Toda medida (grama, kcal, quantidade) usa `IBMPlexMono`, para
/// alinhar em coluna.
TextTheme textThemeEsmalte(Color ink) => TextTheme(
      // o número gigante do dia
      displayLarge: TextStyle(
        fontFamily: 'DarkerGrotesque',
        fontVariations: _peso(800),
        fontSize: 66,
        height: .78,
        letterSpacing: -3,
        color: ink,
      ),
      // título de tela
      displaySmall: TextStyle(
        fontFamily: 'DarkerGrotesque',
        fontVariations: _peso(800),
        fontSize: 33,
        height: .95,
        letterSpacing: -1.2,
        color: ink,
      ),
      // título de prato
      titleLarge: TextStyle(
        fontFamily: 'DarkerGrotesque',
        fontVariations: _peso(800),
        fontSize: 23,
        height: 1,
        letterSpacing: -.7,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontFamily: 'DarkerGrotesque',
        fontVariations: _peso(800),
        fontSize: 19,
        height: 1.05,
        letterSpacing: -.5,
        color: ink,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Manrope',
        fontVariations: _peso(500),
        fontSize: 13,
        height: 1.45,
        color: ink,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Manrope',
        fontVariations: _peso(500),
        fontSize: 11.5,
        height: 1.4,
        color: ink,
      ),
      // rótulo em caixa alta
      labelSmall: TextStyle(
        fontFamily: 'Manrope',
        fontVariations: _peso(800),
        fontSize: 10,
        letterSpacing: 1.6,
        color: ink,
      ),
      // medida
      labelMedium: const TextStyle(
        fontFamily: 'IBMPlexMono',
        fontSize: 10.5,
        height: 1.3,
      ).copyWith(color: ink),
    );
```

- [ ] **Step 5: Escrever o respingo**

`lib/presentation/tema/respingo.dart`:

```dart
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// O campo marinho salpicado — o elemento-assinatura da direção.
///
/// Semente fixa de propósito: o padrão precisa ser o mesmo em todo repaint e
/// em todo teste. Três camadas com raios e densidades diferentes, para não
/// parecer grade.
class PinturaRespingo extends CustomPainter {
  final Color base;

  const PinturaRespingo({required this.base});

  static const _camadas = [
    (passo: 37.0, raio: .9, opacidade: .80),
    (passo: 53.0, raio: .7, opacidade: .44),
    (passo: 71.0, raio: 1.3, opacidade: .26),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    final rnd = math.Random(7);
    for (final c in _camadas) {
      final tinta = Paint()..color = Colors.white.withValues(alpha: c.opacidade);
      final colunas = (size.width / c.passo).ceil() + 1;
      final linhas = (size.height / c.passo).ceil() + 1;

      for (var i = 0; i < colunas; i++) {
        for (var j = 0; j < linhas; j++) {
          final dx = (i + rnd.nextDouble()) * c.passo;
          final dy = (j + rnd.nextDouble()) * c.passo;
          canvas.drawCircle(Offset(dx, dy), c.raio, tinta);
        }
      }
    }
  }

  @override
  bool shouldRepaint(PinturaRespingo antigo) => antigo.base != base;
}

/// Envelope pronto: campo salpicado com conteúdo em branco por cima.
class CampoRespingo extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CampoRespingo({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 13, 16, 15),
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).extension<CoresEsmaltePlaceholder>();
    // ignore: unused_local_variable
    final _ = cores;
    return const SizedBox.shrink();
  }
}

/// Placeholder para o analisador não reclamar antes da Task 15 ligar o widget.
/// Removido no Step 7 desta tarefa.
class CoresEsmaltePlaceholder {}
```

**Nota:** `CampoRespingo` acima está incompleto de propósito para o passo seguinte
não misturar assuntos. O Step 7 substitui as duas últimas classes.

- [ ] **Step 6: Escrever o tema**

`lib/presentation/tema/tema.dart`:

```dart
import 'package:flutter/material.dart';

import 'cores.dart';
import 'tipografia.dart';

ThemeData temaClaro() => _montar(
      brilho: Brightness.light,
      fundo: Esmalte.fundoClaro,
      superficie: Esmalte.superficieClaro,
      ink: Esmalte.inkClaro,
      primaria: Esmalte.marinho,
      extensao: CoresEsmalte.claro,
    );

ThemeData temaEscuro() => _montar(
      brilho: Brightness.dark,
      fundo: Esmalte.fundoEscuro,
      superficie: Esmalte.superficieEscuro,
      ink: Esmalte.inkEscuro,
      primaria: Esmalte.anilEscuro,
      extensao: CoresEsmalte.escuro,
    );

ThemeData _montar({
  required Brightness brilho,
  required Color fundo,
  required Color superficie,
  required Color ink,
  required Color primaria,
  required CoresEsmalte extensao,
}) {
  final esquema = ColorScheme.fromSeed(
    seedColor: Esmalte.marinho,
    brightness: brilho,
  ).copyWith(
    primary: primaria,
    surface: superficie,
    onSurface: ink,
    error: extensao.brasa,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: fundo,
    textTheme: textThemeEsmalte(ink),
    fontFamily: 'Manrope',
    extensions: [extensao],
    dividerColor: extensao.linha,
    cardTheme: CardThemeData(
      color: superficie,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: extensao.linha),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: extensao.marinho,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: superficie,
      indicatorColor: Colors.transparent,
      height: 62,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );
}
```

- [ ] **Step 7: Consertar o respingo**

Substituir as duas últimas classes de `lib/presentation/tema/respingo.dart`
(`CampoRespingo` e `CoresEsmaltePlaceholder`) por:

```dart
/// Envelope pronto: campo salpicado com conteúdo em branco por cima.
class CampoRespingo extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CampoRespingo({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 13, 16, 15),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PinturaRespingo(base: context.esmalte.marinho),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.esmalte.aro, width: 2),
          ),
        ),
        child: DefaultTextStyle.merge(
          style: const TextStyle(color: Colors.white),
          child: IconTheme(
            data: const IconThemeData(color: Colors.white),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

E acrescentar no topo do arquivo:

```dart
import 'cores.dart';
```

- [ ] **Step 8: Escrever o teste**

`test/tema_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/presentation/tema/cores.dart';
import 'package:refeicoes_app/presentation/tema/respingo.dart';
import 'package:refeicoes_app/presentation/tema/tema.dart';

void main() {
  test('tema claro e escuro trazem a extensao Esmalte', () {
    expect(temaClaro().extension<CoresEsmalte>(), isNotNull);
    expect(temaEscuro().extension<CoresEsmalte>(), isNotNull);
  });

  test('a brasa muda entre claro e escuro; o aro nao', () {
    final claro = temaClaro().extension<CoresEsmalte>()!;
    final escuro = temaEscuro().extension<CoresEsmalte>()!;
    expect(claro.brasa, isNot(escuro.brasa));
    expect(claro.aro, escuro.aro);
  });

  test('o dia gigante usa DarkerGrotesque', () {
    final t = temaClaro().textTheme;
    expect(t.displayLarge!.fontFamily, 'DarkerGrotesque');
    expect(t.displayLarge!.fontSize, 66);
  });

  test('DarkerGrotesque nunca aparece abaixo de 17px', () {
    final t = temaClaro().textTheme;
    final estilos = [
      t.displayLarge, t.displaySmall, t.titleLarge, t.titleMedium,
      t.bodyMedium, t.bodySmall, t.labelSmall, t.labelMedium,
    ];
    for (final e in estilos) {
      if (e?.fontFamily == 'DarkerGrotesque') {
        expect(e!.fontSize, greaterThanOrEqualTo(17),
            reason: 'DarkerGrotesque em ${e.fontSize}px');
      }
    }
  });

  test('fonte variavel declara o eixo de peso', () {
    final t = temaClaro().textTheme;
    expect(t.displayLarge!.fontVariations, isNotEmpty);
    expect(t.displayLarge!.fontVariations!.first.axis, 'wght');
    expect(t.bodyMedium!.fontVariations, isNotEmpty);
  });

  test('medida usa monoespacada', () {
    expect(temaClaro().textTheme.labelMedium!.fontFamily, 'IBMPlexMono');
  });

  test('o respingo repinta so quando a base muda', () {
    const a = PinturaRespingo(base: Esmalte.marinho);
    const b = PinturaRespingo(base: Esmalte.marinhoEscuro);
    expect(a.shouldRepaint(a), isFalse);
    expect(b.shouldRepaint(a), isTrue);
  });

  testWidgets('CampoRespingo pinta e escreve em branco', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: temaClaro(),
      home: const Scaffold(
        body: CampoRespingo(child: Text('Setembro 2026')),
      ),
    ));

    expect(find.text('Setembro 2026'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);

    final texto = tester.widget<DefaultTextStyle>(
      find.descendant(
        of: find.byType(CampoRespingo),
        matching: find.byType(DefaultTextStyle),
      ).first,
    );
    expect(texto.style.color, Colors.white);
  });
}
```

- [ ] **Step 9: Rodar e ver passar**

```bash
flutter test test/tema_test.dart
flutter analyze
```

Esperado: 8 testes passando. O teste `DarkerGrotesque nunca aparece abaixo de 17px`
é o guarda-corpo da regra da spec 11.2 — ele quebra se alguém baixar um tamanho.

- [ ] **Step 10: Commit**

```bash
git add assets/fontes/ lib/presentation/tema/ test/tema_test.dart pubspec.yaml
git commit -m "feat(ui): tema Esmalte com tokens, escala tipografica e respingo"
```

---

### Task 15: Cartão com aro, formatação e casca de navegação

**Files:**
- Create: `lib/presentation/format.dart`
- Create: `lib/presentation/widgets/cartao_esmalte.dart`
- Create: `lib/app.dart`
- Create: `lib/main.dart` (substitui o gerado)
- Create: `test/util_teste.dart`
- Create: `test/format_test.dart`
- Create: `test/app_test.dart`

**Interfaces:**
- Consumes: tema da Task 14; `semeaduraProvider` da Task 12
- Produces:
  - `String qtd(double, Unidade)`, `String kcal(double)`, `String rotuloSlot(SlotRefeicao)`, `String porcoesTexto(int)`, `String dataLonga(DataPura)`
  - `class CartaoEsmalte extends StatelessWidget` — `aro`, `apagado`, `onTap`, `child`
  - `class AppRefeicoes extends ConsumerWidget` — MaterialApp com os dois temas
  - `class Casca extends StatefulWidget` — `NavigationBar` de 4 abas
  - `Widget envolver(Widget, {List<Override>})` em `test/util_teste.dart`

- [ ] **Step 1: Escrever a formatação**

`lib/presentation/format.dart`:

```dart
import '../domain/modelos.dart';

const _sufixo = {
  Unidade.g: 'g',
  Unidade.ml: 'ml',
  Unidade.unidade: 'un',
  Unidade.colherSopa: 'col. sopa',
  Unidade.colherCha: 'col. chá',
  Unidade.xicara: 'xíc.',
  Unidade.dente: 'dente',
  Unidade.fatia: 'fatia',
  Unidade.folha: 'folha',
};

/// Quantidade pronta para tela. Grama e mililitro viram inteiro; colher e
/// xícara arredondam para meio; discreta já vem inteira do escalonamento.
String qtd(double valor, Unidade unidade) {
  if (unidade == Unidade.aGosto) return 'a gosto';
  if (unidade == Unidade.pitada) return 'uma pitada';

  final sufixo = _sufixo[unidade] ?? '';

  if (unidade == Unidade.g || unidade == Unidade.ml) {
    return '${valor.round()} $sufixo';
  }

  final meio = (valor * 2).round() / 2;
  final texto = meio == meio.roundToDouble()
      ? '${meio.round()}'
      : meio.toString().replaceAll('.', ',');

  final plural = meio > 1 &&
      (unidade == Unidade.dente ||
          unidade == Unidade.fatia ||
          unidade == Unidade.folha);
  return '$texto ${plural ? '${sufixo}s' : sufixo}';
}

String kcal(double valor) => '${valor.round()} kcal';

String gramas(double valor) => '${valor.round()} g';

String rotuloSlot(SlotRefeicao slot) => switch (slot) {
      SlotRefeicao.cafeManha => 'Café da manhã',
      SlotRefeicao.almoco => 'Almoço',
      SlotRefeicao.cafeTarde => 'Café da tarde',
      SlotRefeicao.jantar => 'Jantar',
    };

String rotuloCategoria(CategoriaReceita c) => switch (c) {
      CategoriaReceita.base => 'Base',
      CategoriaReceita.proteina => 'Proteína',
      CategoriaReceita.leguminosa => 'Leguminosa',
      CategoriaReceita.vegetal => 'Legume',
      CategoriaReceita.salada => 'Salada',
      CategoriaReceita.molho => 'Molho',
      CategoriaReceita.bebida => 'Bebida',
      CategoriaReceita.pao => 'Pão',
      CategoriaReceita.fruta => 'Fruta',
    };

String rotuloSecao(SecaoMercado s) => switch (s) {
      SecaoMercado.hortifruti => 'Hortifrúti',
      SecaoMercado.acougue => 'Açougue',
      SecaoMercado.padaria => 'Padaria',
      SecaoMercado.laticinios => 'Laticínios',
      SecaoMercado.mercearia => 'Mercearia',
      SecaoMercado.congelados => 'Congelados',
      SecaoMercado.bebidas => 'Bebidas',
    };

String porcoesTexto(int n) => n == 1 ? '1 porção' : '$n porções';

const _diasSemana = [
  'segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado', 'domingo',
];
const _meses = [
  'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
  'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
];

String diaDaSemana(DataPura d) => _diasSemana[d.comoDateTime.weekday - 1];

String mesNome(int mes) => _meses[mes - 1];

/// "quarta, 4 de setembro"
String dataLonga(DataPura d) {
  final dt = d.comoDateTime;
  return '${diaDaSemana(d)}, ${dt.day} de ${mesNome(dt.month)}';
}
```

- [ ] **Step 2: Escrever o teste da formatação**

`test/format_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/format.dart';

void main() {
  group('qtd', () {
    test('grama arredonda para inteiro', () {
      expect(qtd(119.6, Unidade.g), '120 g');
      expect(qtd(240, Unidade.g), '240 g');
    });

    test('mililitro tambem', () {
      expect(qtd(200, Unidade.ml), '200 ml');
    });

    test('colher arredonda para meio', () {
      expect(qtd(1.5, Unidade.colherSopa), '1,5 col. sopa');
      expect(qtd(1.2, Unidade.colherSopa), '1 col. sopa');
      expect(qtd(1.8, Unidade.colherSopa), '2 col. sopa');
    });

    test('discreta pluraliza', () {
      expect(qtd(1, Unidade.dente), '1 dente');
      expect(qtd(2, Unidade.dente), '2 dentes');
      expect(qtd(5, Unidade.folha), '5 folhas');
    });

    test('unidade nao pluraliza a abreviacao', () {
      expect(qtd(2, Unidade.unidade), '2 un');
    });

    test('sem medida vira texto', () {
      expect(qtd(1, Unidade.aGosto), 'a gosto');
      expect(qtd(1, Unidade.pitada), 'uma pitada');
    });
  });

  test('kcal arredonda', () {
    expect(kcal(437.6), '438 kcal');
  });

  test('rotulos dos slots', () {
    expect(rotuloSlot(SlotRefeicao.cafeManha), 'Café da manhã');
    expect(rotuloSlot(SlotRefeicao.cafeTarde), 'Café da tarde');
  });

  test('vegetal aparece como Legume na tela', () {
    expect(rotuloCategoria(CategoriaReceita.vegetal), 'Legume');
  });

  test('porcoes no singular e no plural', () {
    expect(porcoesTexto(1), '1 porção');
    expect(porcoesTexto(2), '2 porções');
  });

  test('data longa em portugues', () {
    expect(dataLonga(const DataPura('2026-09-04')), 'sexta, 4 de setembro');
    expect(dataLonga(const DataPura('2026-09-05')), 'sábado, 5 de setembro');
  });
}
```

- [ ] **Step 3: Rodar e ver passar**

```bash
flutter test test/format_test.dart
```

Esperado: 11 testes passando. Se `data longa` falhar, checar a ordem de
`_diasSemana` — `DateTime.weekday` começa em 1 = segunda.

- [ ] **Step 4: Escrever o cartão com aro**

`lib/presentation/widgets/cartao_esmalte.dart`:

```dart
import 'package:flutter/material.dart';

import '../tema/cores.dart';

/// Cartão de esmalte branco com 2,5 px de marinho na borda de cima — a faixa
/// escura onde o esmalte termina e o aço aparece.
///
/// Com [apagado] em true o aro vira cinza e o fundo recua: é como uma refeição
/// espelhada se distingue de uma original sem ler uma palavra.
class CartaoEsmalte extends StatelessWidget {
  final Widget child;
  final bool apagado;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const CartaoEsmalte({
    super.key,
    required this.child,
    this.apagado = false,
    this.onTap,
    this.padding = const EdgeInsets.fromLTRB(14, 13, 14, 12),
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    final tema = Theme.of(context);
    final raio = BorderRadius.circular(12);

    final corpo = Container(
      decoration: BoxDecoration(
        color: apagado ? cores.superficie2 : tema.colorScheme.surface,
        borderRadius: raio,
        border: Border(
          top: BorderSide(
            color: apagado ? cores.linha : cores.marinho,
            width: 2.5,
          ),
          left: BorderSide(color: cores.linha),
          right: BorderSide(color: cores.linha),
          bottom: BorderSide(color: cores.linha),
        ),
      ),
      padding: padding,
      child: child,
    );

    if (onTap == null) return corpo;

    return Material(
      color: Colors.transparent,
      borderRadius: raio,
      child: InkWell(
        onTap: onTap,
        borderRadius: raio,
        child: corpo,
      ),
    );
  }
}
```

- [ ] **Step 5: Escrever a casca e o app**

`lib/app.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database_provider.dart';
import 'presentation/hoje/hoje_screen.dart';
import 'presentation/mercado/mercado_screen.dart';
import 'presentation/mes/mes_screen.dart';
import 'presentation/receitas/receitas_screen.dart';
import 'presentation/tema/tema.dart';

class AppRefeicoes extends ConsumerWidget {
  const AppRefeicoes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Refeições',
      debugShowCheckedModeBanner: false,
      theme: temaClaro(),
      darkTheme: temaEscuro(),
      home: const Casca(),
    );
  }
}

/// Quatro abas fixas, nada escondido em menu. Ajustes fica atrás do `⋯` da
/// barra superior de cada tela.
class Casca extends ConsumerStatefulWidget {
  const Casca({super.key});

  @override
  ConsumerState<Casca> createState() => _CascaState();
}

class _CascaState extends ConsumerState<Casca> {
  int _aba = 0;

  static const _telas = [
    HojeScreen(),
    MesScreen(),
    MercadoScreen(),
    ReceitasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final semeadura = ref.watch(semeaduraProvider);

    return semeadura.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Não foi possível preparar os dados.\n\n$e',
                textAlign: TextAlign.center),
          ),
        ),
      ),
      data: (_) => Scaffold(
        body: IndexedStack(index: _aba, children: _telas),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _aba,
          onDestinationSelected: (i) => setState(() => _aba = i),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.today_outlined),
                selectedIcon: Icon(Icons.today),
                label: 'Hoje'),
            NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month),
                label: 'Mês'),
            NavigationDestination(
                icon: Icon(Icons.checklist_outlined),
                selectedIcon: Icon(Icons.checklist),
                label: 'Mercado'),
            NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book),
                label: 'Receitas'),
          ],
        ),
      ),
    );
  }
}
```

`lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  runApp(const ProviderScope(child: AppRefeicoes()));
}
```

- [ ] **Step 6: Escrever o auxiliar de teste**

`test/util_teste.dart`:

```dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/database_provider.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/semente.dart';
import 'package:refeicoes_app/presentation/tema/tema.dart';

String lerSementeDoDisco(String nome) =>
    File('assets/semente/$nome').readAsStringSync();

/// Banco em memória já semeado, com o ciclo começando em 2026-09-01 e tamanho 4
/// (a semente desta fase só tem 4 dias).
Future<AppDatabase> bancoDeTeste() async {
  final db = AppDatabase(DatabaseConnection(
    NativeDatabase.memory(),
    closeStreamsSynchronously: true,
  ));
  await carregarSemente(db, lerAsset: lerSementeDoDisco, versao: 1);
  final config = RepoConfig(db);
  await config.definir('data_inicio_ciclo', '2026-09-01');
  await config.definir('tamanho_ciclo', '4');
  return db;
}

/// Envolve um widget com tema, ProviderScope e o banco de teste já pronto.
Widget envolver(
  Widget child, {
  required AppDatabase db,
  List<Override> overrides = const [],
  Brightness brilho = Brightness.light,
}) {
  return ProviderScope(
    overrides: [
      bancoProvider.overrideWithValue(db),
      semeaduraProvider.overrideWith((ref) async {}),
      ...overrides,
    ],
    child: MaterialApp(
      theme: brilho == Brightness.light ? temaClaro() : temaEscuro(),
      home: child,
    ),
  );
}
```

- [ ] **Step 7: Escrever o teste do cartão e da casca**

`test/app_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/presentation/tema/cores.dart';
import 'package:refeicoes_app/presentation/tema/tema.dart';
import 'package:refeicoes_app/presentation/widgets/cartao_esmalte.dart';

void main() {
  Widget comTema(Widget child) => MaterialApp(
        theme: temaClaro(),
        home: Scaffold(body: child),
      );

  testWidgets('cartao normal tem aro marinho no topo', (tester) async {
    await tester.pumpWidget(comTema(
      const CartaoEsmalte(child: Text('Almoço')),
    ));

    final container = tester.widget<Container>(find.descendant(
      of: find.byType(CartaoEsmalte),
      matching: find.byType(Container),
    ).first);
    final borda = (container.decoration as BoxDecoration).border as Border;

    expect(borda.top.color, Esmalte.marinho);
    expect(borda.top.width, 2.5);
  });

  testWidgets('cartao apagado perde o aro', (tester) async {
    await tester.pumpWidget(comTema(
      const CartaoEsmalte(apagado: true, child: Text('Jantar')),
    ));

    final container = tester.widget<Container>(find.descendant(
      of: find.byType(CartaoEsmalte),
      matching: find.byType(Container),
    ).first);
    final deco = container.decoration as BoxDecoration;
    final borda = deco.border as Border;

    expect(borda.top.color, Esmalte.linhaClaro);
    expect(deco.color, Esmalte.superficie2Claro);
  });

  testWidgets('cartao com onTap responde ao toque', (tester) async {
    var toques = 0;
    await tester.pumpWidget(comTema(
      CartaoEsmalte(onTap: () => toques++, child: const Text('Toca')),
    ));

    await tester.tap(find.text('Toca'));
    await tester.pumpAndSettle();
    expect(toques, 1);
  });

  testWidgets('cartao sem onTap nao cria area de toque', (tester) async {
    await tester.pumpWidget(comTema(
      const CartaoEsmalte(child: Text('Estatico')),
    ));
    expect(
      find.descendant(
          of: find.byType(CartaoEsmalte), matching: find.byType(InkWell)),
      findsNothing,
    );
  });
}
```

- [ ] **Step 8: Rodar e ver passar**

```bash
flutter test test/app_test.dart test/format_test.dart
flutter analyze
```

Esperado: 4 + 11 testes passando. `flutter analyze` vai reclamar de import de tela
inexistente em `lib/app.dart` — as quatro telas nascem nas Tasks 16, 18, 19 e 20.
Para manter a fase compilando, criar quatro arquivos-tronco agora:

```bash
for t in hoje mes mercado receitas; do mkdir -p lib/presentation/$t; done
```

E cada um com um esqueleto que a tarefa da tela substitui. Exemplo para
`lib/presentation/hoje/hoje_screen.dart`:

```dart
import 'package:flutter/material.dart';

class HojeScreen extends StatelessWidget {
  const HojeScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Hoje')));
}
```

Repetir trocando o nome para `MesScreen`, `MercadoScreen` e `ReceitasScreen` nos
arquivos `mes/mes_screen.dart`, `mercado/mercado_screen.dart` e
`receitas/receitas_screen.dart`.

- [ ] **Step 9: Rodar de novo e commitar**

```bash
flutter analyze
flutter test
git add lib/ test/util_teste.dart test/app_test.dart test/format_test.dart
git commit -m "feat(ui): cartao com aro, formatacao e casca de quatro abas"
```

- [ ] **Step 10: Checkpoint de APK — primeiro APK que vale abrir**

```bash
flutter analyze && flutter test && flutter build apk --release
```

Avisar o Isac. Mensagem:

> APK em `build/app/outputs/flutter-apk/app-release.apk`.
> **Olhe:** o app abre com as quatro abas embaixo (Hoje, Mês, Mercado, Receitas) e
> troca entre elas; o tema Esmalte já está aplicado — fundo louça, cartões brancos.
> **Ainda não funciona:** as quatro telas são placeholders com o nome escrito. A
> Task 16 põe conteúdo na Hoje.

---

### Task 16: Tela Hoje

**Files:**
- Create: `lib/presentation/hoje/hoje_provider.dart`
- Modify: `lib/presentation/hoje/hoje_screen.dart` (substitui o tronco da Task 15)
- Create: `test/hoje_screen_test.dart`

**Interfaces:**
- Consumes: `repoPlanoProvider`, `DiaResolvido`, `CartaoEsmalte`, `CampoRespingo`, `format.dart`
- Produces:
  - `final dataSelecionadaProvider = NotifierProvider<DataSelecionada, DataPura>`
  - `final diaProvider = FutureProvider<DiaResolvido>`
  - `class HojeScreen extends ConsumerWidget`
  - `class BlocoRefeicao extends StatelessWidget` — reusado na tela Mês

- [ ] **Step 1: Escrever os providers**

`lib/presentation/hoje/hoje_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import '../../data/repo_plano.dart';
import '../../domain/modelos.dart';

/// A data que as telas Hoje e Mês compartilham. Começa no dia de hoje.
class DataSelecionada extends Notifier<DataPura> {
  @override
  DataPura build() => DataPura.de(DateTime.now());

  void ir(DataPura d) => state = d;

  void avancar(int dias) =>
      state = DataPura.de(state.comoDateTime.add(Duration(days: dias)));

  void hoje() => state = DataPura.de(DateTime.now());
}

final dataSelecionadaProvider =
    NotifierProvider<DataSelecionada, DataPura>(DataSelecionada.new);

final diaProvider = FutureProvider<DiaResolvido>((ref) {
  final data = ref.watch(dataSelecionadaProvider);
  return ref.watch(repoPlanoProvider).dia(data);
});
```

- [ ] **Step 2: Escrever a tela**

`lib/presentation/hoje/hoje_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repo_plano.dart';
import '../../domain/modelos.dart';
import '../ajustes/ajustes_screen.dart';
import '../format.dart';
import '../receitas/receita_screen.dart';
import '../substituir/substituir_sheet.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import '../widgets/cartao_esmalte.dart';

class HojeScreen extends ConsumerWidget {
  const HojeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dia = ref.watch(diaProvider);
    final data = ref.watch(dataSelecionadaProvider);

    return Scaffold(
      body: dia.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('$e', textAlign: TextAlign.center),
          ),
        ),
        data: (d) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(diaProvider),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _Cabecalho(dia: d),
              Padding(
                padding: const EdgeInsets.fromLTRB(11, 13, 11, 24),
                child: Column(
                  children: [
                    for (final r in d.refeicoes)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: BlocoRefeicao(refeicao: r, data: data),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cabecalho extends ConsumerWidget {
  final DiaResolvido dia;
  const _Cabecalho({required this.dia});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final dt = dia.data.comoDateTime;

    return CampoRespingo(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${mesNome(dt.month)} ${dt.year}'.toUpperCase(),
                  style: t.labelSmall?.copyWith(color: Colors.white70),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                tooltip: 'Ajustes',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AjustesScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(dt.day.toString().padLeft(2, '0'),
                  style: t.displayLarge?.copyWith(color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(diaDaSemana(dia.data).toUpperCase(),
                          style:
                              t.labelSmall?.copyWith(color: Colors.white70)),
                      const SizedBox(height: 2),
                      Text('dia ${dia.posicao} de ${dia.tamanhoCiclo}',
                          style: t.labelMedium
                              ?.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${dia.total.kcal.round()}',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.white)),
                    Text('KCAL NO DIA',
                        style: t.labelSmall
                            ?.copyWith(color: Colors.white70, fontSize: 8.5)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Um dos quatro horários do dia. Espelhado vem apagado, sem aro e sem rodapé.
class BlocoRefeicao extends ConsumerWidget {
  final RefeicaoDoDia refeicao;
  final DataPura data;

  const BlocoRefeicao({
    super.key,
    required this.refeicao,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;
    final espelhado = refeicao.espelhoIntacto && ehEspelhadoSlot(refeicao.slot);

    return CartaoEsmalte(
      apagado: espelhado,
      onTap: refeicao.componentes.isEmpty
          ? null
          : () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ReceitaScreen(
                    receitaId: refeicao.componentes.first.receitaId),
              )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(rotuloSlot(refeicao.slot).toUpperCase(),
                    style: t.labelSmall?.copyWith(
                        color: espelhado
                            ? cores.ink3
                            : Theme.of(context).colorScheme.primary)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 2.5),
                decoration: BoxDecoration(
                  color: cores.superficie2,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: cores.linha),
                ),
                child: Text(porcoesTexto(refeicao.porcoes),
                    style: t.labelMedium?.copyWith(color: cores.ink2)),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(refeicao.comboNome,
              style: t.titleLarge
                  ?.copyWith(color: espelhado ? cores.ink3 : null)),
          const SizedBox(height: 9),
          if (espelhado)
            Text('repete ${rotuloSlot(slotBaseDe(refeicao.slot)).toLowerCase()},'
                ' em dobro',
                style: t.bodySmall
                    ?.copyWith(color: cores.ink3, fontStyle: FontStyle.italic))
          else ...[
            for (final c in refeicao.componentes)
              _LinhaComponente(componente: c),
            const SizedBox(height: 11),
            Divider(height: 1, color: cores.linha),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${refeicao.nutrientes.kcal.round()} kcal · '
                    '${refeicao.nutrientes.proteina.round()} g prot',
                    style: t.labelMedium?.copyWith(color: cores.ink3),
                  ),
                ),
                TextButton(
                  onPressed: () => abrirSubstituir(
                      context: context, data: data, refeicao: refeicao),
                  style: TextButton.styleFrom(
                    foregroundColor: cores.brasa,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    minimumSize: const Size(44, 44),
                  ),
                  child: Text('SUBSTITUIR',
                      style: t.labelSmall?.copyWith(color: cores.brasa)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LinhaComponente extends StatelessWidget {
  final ComponenteDoDia componente;
  const _LinhaComponente({required this.componente});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    // A medida principal do componente: o primeiro ingrediente com massa.
    final principal = componente.ingredientes.firstWhere(
      (i) => !unidadesSemMedida.contains(i.unidade),
      orElse: () => componente.ingredientes.isEmpty
          ? const IngredienteEscalado(
              alimentoId: 0, nome: '', quantidade: 0, unidade: Unidade.g)
          : componente.ingredientes.first,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:
                Text(componente.nome, style: t.bodyMedium?.copyWith(color: cores.ink2)),
          ),
          const SizedBox(width: 10),
          Text(qtd(principal.quantidade, principal.unidade),
              style: t.labelMedium?.copyWith(color: cores.ink3)),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Exportar os dois auxiliares do espelho**

`BlocoRefeicao` usa `ehEspelhadoSlot` e `slotBaseDe`, que são só apelidos para não
importar `domain/espelho.dart` direto na camada de apresentação com nome genérico.
Acrescentar ao fim de `lib/presentation/format.dart`:

```dart
// Reexporta o espelho com nome explícito para uso na apresentação.
bool ehEspelhadoSlot(SlotRefeicao s) => espelho.ehEspelhado(s);
SlotRefeicao slotBaseDe(SlotRefeicao s) => espelho.slotBase(s);
```

E no topo do mesmo arquivo:

```dart
import '../domain/espelho.dart' as espelho;
```

- [ ] **Step 4: Escrever o teste**

`test/hoje_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_provider.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_screen.dart';
import 'package:refeicoes_app/presentation/widgets/cartao_esmalte.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  /// Abre a tela numa data fixa: sexta, 4 de setembro de 2026 (posição 4).
  Future<void> abrir(WidgetTester tester,
      {String iso = '2026-09-04',
      Brightness brilho = Brightness.light}) async {
    await tester.pumpWidget(envolver(
      const HojeScreen(),
      db: db,
      brilho: brilho,
      overrides: [
        dataSelecionadaProvider.overrideWith(() => _DataFixa(DataPura(iso))),
      ],
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('mostra os quatro horarios', (tester) async {
    await abrir(tester);

    expect(find.text('CAFÉ DA MANHÃ'), findsOneWidget);
    expect(find.text('ALMOÇO'), findsOneWidget);
    expect(find.text('CAFÉ DA TARDE'), findsOneWidget);
    expect(find.text('JANTAR'), findsOneWidget);
    expect(find.byType(CartaoEsmalte), findsNWidgets(4));
  });

  testWidgets('cabecalho traz dia, posicao no ciclo e kcal', (tester) async {
    await abrir(tester);

    expect(find.text('04'), findsOneWidget);
    expect(find.text('SEXTA'), findsOneWidget);
    expect(find.text('dia 4 de 4'), findsOneWidget);
    expect(find.text('KCAL NO DIA'), findsOneWidget);
  });

  testWidgets('sexta mostra 1 porcao no almoco e 2 no jantar',
      (tester) async {
    await abrir(tester);
    expect(find.text('1 porção'), findsNWidgets(2)); // cafe da manha e almoco
    expect(find.text('2 porções'), findsNWidgets(2)); // cafe da tarde e jantar
  });

  testWidgets('sabado mostra 2 porcoes nos quatro', (tester) async {
    await abrir(tester, iso: '2026-09-05');
    expect(find.text('2 porções'), findsNWidgets(4));
    expect(find.text('1 porção'), findsNothing);
  });

  testWidgets('espelhado diz que repete e nao oferece substituir',
      (tester) async {
    await abrir(tester);

    expect(find.text('repete almoço, em dobro'), findsOneWidget);
    expect(find.text('repete café da manhã, em dobro'), findsOneWidget);
    // so os dois slots base tem botao
    expect(find.text('SUBSTITUIR'), findsNWidgets(2));
  });

  testWidgets('cartao espelhado fica apagado', (tester) async {
    await abrir(tester);

    final cartoes = tester
        .widgetList<CartaoEsmalte>(find.byType(CartaoEsmalte))
        .toList();
    expect(cartoes.where((c) => c.apagado), hasLength(2));
  });

  testWidgets('mostra a quantidade escalada de cada componente',
      (tester) async {
    await abrir(tester);
    // arroz do almoco: 120 g com 1 porcao
    expect(find.text('120 g'), findsWidgets);
    // arroz do jantar: 240 g com 2 porcoes
    expect(find.text('240 g'), findsWidgets);
  });

  testWidgets('abre a folha de substituicao', (tester) async {
    await abrir(tester);

    await tester.tap(find.text('SUBSTITUIR').last);
    await tester.pumpAndSettle();

    expect(find.text('Trocar a refeição inteira'), findsOneWidget);
  });

  testWidgets('renderiza no modo escuro sem estourar', (tester) async {
    await abrir(tester, brilho: Brightness.dark);
    expect(tester.takeException(), isNull);
    expect(find.byType(CartaoEsmalte), findsNWidgets(4));
  });
}

class _DataFixa extends DataSelecionada {
  final DataPura inicial;
  _DataFixa(this.inicial);

  @override
  DataPura build() => inicial;
}
```

- [ ] **Step 5: Rodar e ver falhar, depois passar**

```bash
flutter test test/hoje_screen_test.dart
```

Esperado: primeiro FAIL por `substituir_sheet.dart`, `receita_screen.dart` e
`ajustes_screen.dart` inexistentes. Criar troncos mínimos dos três para esta tarefa
fechar; as Tasks 17, 20 e 22 os substituem:

`lib/presentation/substituir/substituir_sheet.dart`:

```dart
import 'package:flutter/material.dart';

import '../../data/repo_plano.dart';
import '../../domain/modelos.dart';

Future<void> abrirSubstituir({
  required BuildContext context,
  required DataPura data,
  required RefeicaoDoDia refeicao,
}) =>
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Trocar a refeição inteira'),
      ),
    );
```

`lib/presentation/receitas/receita_screen.dart`:

```dart
import 'package:flutter/material.dart';

class ReceitaScreen extends StatelessWidget {
  final int receitaId;
  const ReceitaScreen({super.key, required this.receitaId});

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Receita $receitaId')));
}
```

`lib/presentation/ajustes/ajustes_screen.dart`:

```dart
import 'package:flutter/material.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Ajustes')));
}
```

Rodar de novo:

```bash
flutter test test/hoje_screen_test.dart
flutter analyze
```

Esperado: 9 testes passando.

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/ test/hoje_screen_test.dart
git commit -m "feat(ui): tela Hoje com quatro horarios, porcoes e espelho visivel"
```

- [ ] **Step 7: Checkpoint de APK**

```bash
flutter analyze && flutter test && flutter build apk --release
```

Avisar o Isac. Mensagem:

> APK em `build/app/outputs/flutter-apk/app-release.apk`.
> **Olhe:** a aba Hoje traz os quatro horários com o combo do dia, a quantidade de
> cada componente já escalada, e o número de porções. Café da tarde e jantar vêm
> **apagados, sem o aro marinho**, escrito "repete o almoço, em dobro". Se hoje for
> dia de semana: 1 porção no café e no almoço, 2 à tarde e à noite — confira se bate.
> **Ainda não funciona:** o botão Substituir abre uma folha vazia (Task 17), e tocar
> numa refeição abre uma tela crua (Task 20). Mês, Mercado e Receitas seguem placeholder.

---

### Task 17: Folha de substituição

**Files:**
- Modify: `lib/presentation/substituir/substituir_sheet.dart` (substitui o tronco)
- Create: `test/substituir_sheet_test.dart`

**Interfaces:**
- Consumes: `repoPlanoProvider`, `repoReceitasProvider`, `diaProvider`, `RefeicaoDoDia`
- Produces: `Future<void> abrirSubstituir({required BuildContext context, required DataPura data, required RefeicaoDoDia refeicao})` — mesma assinatura do tronco, para a Task 16 não mudar

- [ ] **Step 1: Escrever a folha**

`lib/presentation/substituir/substituir_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repo_plano.dart';
import '../../domain/espelho.dart';
import '../../domain/modelos.dart';
import '../format.dart';
import '../hoje/hoje_provider.dart';
import '../tema/cores.dart';

/// Abre a folha de substituição de uma refeição.
Future<void> abrirSubstituir({
  required BuildContext context,
  required DataPura data,
  required RefeicaoDoDia refeicao,
}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SubstituirSheet(data: data, refeicao: refeicao),
    );

class SubstituirSheet extends ConsumerWidget {
  final DataPura data;
  final RefeicaoDoDia refeicao;

  const SubstituirSheet({
    super.key,
    required this.data,
    required this.refeicao,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;
    final combos = ref.watch(_combosProvider(tipoDoSlot(refeicao.slot)));

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cores.marinho, width: 2.5)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .84,
      ),
      padding: const EdgeInsets.fromLTRB(15, 9, 15, 18),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 13),
                decoration: BoxDecoration(
                  color: cores.linha,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            Text('Substituir ${rotuloSlot(refeicao.slot).toLowerCase()}',
                style: t.titleLarge),
            const SizedBox(height: 3),
            Text(
              '${dataLonga(data)} · ${porcoesTexto(refeicao.porcoes)} · '
              'só neste dia',
              style: t.labelMedium?.copyWith(color: cores.ink3),
            ),
            const SizedBox(height: 16),

            _Rotulo('Trocar a refeição inteira'),
            combos.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('$e', style: t.bodySmall),
              data: (lista) => Column(
                children: [
                  for (final c in lista.where((c) => c.id != refeicao.comboId))
                    _Opcao(
                      titulo: c.nome,
                      subtitulo: 'combo ${c.id}',
                      onTap: () async {
                        await ref.read(repoPlanoProvider).substituirCombo(
                            data: data, slot: refeicao.slot, comboId: c.id);
                        ref.invalidate(diaProvider);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 6),
            _Rotulo('Ou trocar só um componente'),
            for (final comp in refeicao.componentes)
              _Opcao(
                titulo: comp.nome,
                subtitulo: rotuloCategoria(comp.categoria),
                onTap: () => _trocarComponente(context, ref, comp),
              ),

            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () async {
                await ref
                    .read(repoPlanoProvider)
                    .limparOverrides(data, refeicao.slot);
                ref.invalidate(diaProvider);
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Voltar ao plano original'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _trocarComponente(
    BuildContext context,
    WidgetRef ref,
    ComponenteDoDia comp,
  ) async {
    final alternativas = await ref
        .read(repoReceitasProvider)
        .listar(categoria: comp.categoria);

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15),
          children: [
            Text('Trocar ${comp.nome}',
                style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final r in alternativas.where((r) => r.id != comp.receitaId))
              ListTile(
                title: Text(r.nome),
                subtitle: Text('${r.tempoPreparoMin} min'),
                onTap: () async {
                  await ref.read(repoPlanoProvider).substituirComponente(
                        data: data,
                        slot: refeicao.slot,
                        receitaOriginalId: comp.receitaId,
                        receitaNovaId: r.id,
                      );
                  ref.invalidate(diaProvider);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: const Text('Tirar do prato hoje'),
              onTap: () async {
                await ref.read(repoPlanoProvider).substituirComponente(
                      data: data,
                      slot: refeicao.slot,
                      receitaOriginalId: comp.receitaId,
                      receitaNovaId: null,
                    );
                ref.invalidate(diaProvider);
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

final _combosProvider =
    FutureProvider.family<List<Combo>, TipoCombo>((ref, tipo) =>
        ref.watch(repoReceitasProvider).combosDoTipo(tipo));

class _Rotulo extends StatelessWidget {
  final String texto;
  const _Rotulo(this.texto);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text(texto,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary)),
      );
}

class _Opcao extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _Opcao({
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: cores.linha),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(titulo,
                    style: t.bodyMedium
                        ?.copyWith(fontVariations: const [
                      FontVariation('wght', 700)
                    ])),
                const SizedBox(height: 1),
                Text(subtitulo,
                    style: t.labelMedium?.copyWith(color: cores.ink3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Escrever o teste**

`test/substituir_sheet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_provider.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_screen.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;
  late RepoPlano plano;
  const sexta = DataPura('2026-09-04');

  setUp(() async {
    db = await bancoDeTeste();
    plano = RepoPlano(db, RepoConfig(db));
  });
  tearDown(() async => db.close());

  Future<void> abrirFolha(WidgetTester tester) async {
    await tester.pumpWidget(envolver(
      const HojeScreen(),
      db: db,
      overrides: [
        dataSelecionadaProvider.overrideWith(() => _DataFixa(sexta)),
      ],
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SUBSTITUIR').last);
    await tester.pumpAndSettle();
  }

  RefeicaoDoDia slot(DiaResolvido d, SlotRefeicao s) =>
      d.refeicoes.firstWhere((r) => r.slot == s);

  testWidgets('folha traz os dois niveis', (tester) async {
    await abrirFolha(tester);

    expect(find.text('Trocar a refeição inteira'), findsOneWidget);
    expect(find.text('Ou trocar só um componente'), findsOneWidget);
    expect(find.text('Substituir almoço'), findsOneWidget);
  });

  testWidgets('folha diz que a troca vale so neste dia', (tester) async {
    await abrirFolha(tester);
    expect(find.textContaining('só neste dia'), findsOneWidget);
    expect(find.textContaining('sexta, 4 de setembro'), findsOneWidget);
  });

  testWidgets('nao oferece o combo que ja esta no dia', (tester) async {
    final antes = await plano.dia(sexta);
    final atual = slot(antes, SlotRefeicao.almoco).comboNome;

    await abrirFolha(tester);

    // o nome aparece no cartao de tras, mas nao como opcao dentro da folha
    expect(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text(atual),
      ),
      findsNothing,
    );
  });

  testWidgets('escolher outro combo grava o override', (tester) async {
    await abrirFolha(tester);

    final combos = await db.select(db.combos).get();
    final outro = combos.firstWhere((c) =>
        c.tipo == TipoCombo.refeicao &&
        c.id != slot(await plano.dia(sexta), SlotRefeicao.almoco).comboId);

    await tester.tap(find.text(outro.nome));
    await tester.pumpAndSettle();

    final depois = await plano.dia(sexta);
    expect(slot(depois, SlotRefeicao.almoco).comboId, outro.id);
    // o espelho segue intacto: o jantar acompanha
    expect(slot(depois, SlotRefeicao.jantar).comboId, outro.id);
  });

  testWidgets('trocar componente abre a lista da mesma categoria',
      (tester) async {
    await abrirFolha(tester);

    await tester.tap(find.text('Picadinho de carne com legumes'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Trocar Picadinho'), findsOneWidget);
    expect(find.text('Frango grelhado simples'), findsOneWidget);
    expect(find.text('Tirar do prato hoje'), findsOneWidget);
    // nao oferece componente de outra categoria
    expect(find.text('Arroz branco'), findsNothing);
  });

  testWidgets('trocar componente grava e reflete no jantar', (tester) async {
    await abrirFolha(tester);
    await tester.tap(find.text('Picadinho de carne com legumes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Frango grelhado simples'));
    await tester.pumpAndSettle();

    final d = await plano.dia(sexta);
    expect(
      slot(d, SlotRefeicao.almoco).componentes.map((c) => c.nome),
      contains('Frango grelhado simples'),
    );
    expect(
      slot(d, SlotRefeicao.jantar).componentes.map((c) => c.nome),
      contains('Frango grelhado simples'),
    );
  });

  testWidgets('tirar do prato remove o componente', (tester) async {
    final antes =
        slot(await plano.dia(sexta), SlotRefeicao.almoco).componentes.length;

    await abrirFolha(tester);
    await tester.tap(find.text('Picadinho de carne com legumes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tirar do prato hoje'));
    await tester.pumpAndSettle();

    final depois =
        slot(await plano.dia(sexta), SlotRefeicao.almoco).componentes.length;
    expect(depois, antes - 1);
  });

  testWidgets('voltar ao plano original limpa os overrides', (tester) async {
    await plano.substituirCombo(
        data: sexta, slot: SlotRefeicao.almoco, comboId: 5);

    await abrirFolha(tester);
    await tester.tap(find.text('Voltar ao plano original'));
    await tester.pumpAndSettle();

    expect(await db.select(db.overridesCombo).get(), isEmpty);
  });
}

class _DataFixa extends DataSelecionada {
  final DataPura inicial;
  _DataFixa(this.inicial);

  @override
  DataPura build() => inicial;
}
```

- [ ] **Step 3: Rodar e ver passar**

```bash
flutter test test/substituir_sheet_test.dart
flutter analyze
```

Esperado: 8 testes passando. O teste
`escolher outro combo grava o override` é o que prova, na interface, que a regra do
espelho da spec 6.2 chegou até a tela.

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/substituir/ test/substituir_sheet_test.dart
git commit -m "feat(ui): folha de substituicao em dois niveis"
```

- [ ] **Step 5: Checkpoint de APK — o teste mais importante até aqui**

```bash
flutter analyze && flutter test && flutter build apk --release
```

Avisar o Isac. Mensagem:

> APK em `build/app/outputs/flutter-apk/app-release.apk`.
> **Olhe — nesta ordem, é a regra do espelho na mão:**
> 1. `Substituir` no **almoço**, escolha outro combo → **o jantar acompanha**.
> 2. `Substituir` no **jantar**, escolha outro → **o almoço NÃO muda**, e o jantar
>    perde o "repete o almoço".
> 3. `Substituir` no almoço → toque num componente (ex. a carne) → só aparecem
>    opções da **mesma categoria**, e trocar mantém arroz, feijão e salada.
> 4. `Tirar do prato hoje` remove só aquele componente.
> 5. `Voltar ao plano original` devolve o dia ao ciclo e restaura o espelho.
>
> Se o passo 2 mudar o almoço, é bug de verdade — é a regra da spec 6.3.
> **Ainda não funciona:** Mês, Mercado e Receitas.

---

### Task 18: Tela Mês

**Files:**
- Create: `lib/presentation/mes/mes_provider.dart`
- Modify: `lib/presentation/mes/mes_screen.dart` (substitui o tronco)
- Create: `test/mes_screen_test.dart`

**Interfaces:**
- Consumes: `dataSelecionadaProvider`, `diaProvider`, `repoPlanoProvider`, `CampoRespingo`
- Produces:
  - `final mesVisivelProvider = NotifierProvider<MesVisivel, ({int ano, int mes})>`
  - `final diasEditadosProvider = FutureProvider<Set<DataPura>>`
  - `class MesScreen extends ConsumerWidget`

- [ ] **Step 1: Escrever os providers**

`lib/presentation/mes/mes_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import '../../domain/modelos.dart';
import '../hoje/hoje_provider.dart';

/// O mês que a grade está mostrando. Independe da data selecionada: ela pode
/// folhear meses sem trocar o dia escolhido.
class MesVisivel extends Notifier<({int ano, int mes})> {
  @override
  ({int ano, int mes}) build() {
    final d = ref.watch(dataSelecionadaProvider).comoDateTime;
    return (ano: d.year, mes: d.month);
  }

  void avancar(int meses) {
    final atual = DateTime.utc(state.ano, state.mes + meses);
    state = (ano: atual.year, mes: atual.month);
  }
}

final mesVisivelProvider =
    NotifierProvider<MesVisivel, ({int ano, int mes})>(MesVisivel.new);

/// Quantos dias tem o mês visível.
int diasNoMes(int ano, int mes) => DateTime.utc(ano, mes + 1, 0).day;

/// Em que coluna cai o dia 1 (0 = domingo).
int primeiroDiaDaSemana(int ano, int mes) =>
    DateTime.utc(ano, mes, 1).weekday % 7;

/// Datas do mês visível com alguma substituição — alimenta o ponto de brasa.
final diasEditadosProvider = FutureProvider<Set<DataPura>>((ref) {
  final m = ref.watch(mesVisivelProvider);
  final de = DataPura.de(DateTime.utc(m.ano, m.mes, 1));
  final ate = DataPura.de(DateTime.utc(m.ano, m.mes, diasNoMes(m.ano, m.mes)));
  return ref.watch(repoPlanoProvider).diasEditados(de, ate);
});
```

- [ ] **Step 2: Escrever a tela**

`lib/presentation/mes/mes_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/modelos.dart';
import '../format.dart';
import '../hoje/hoje_provider.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import '../widgets/cartao_esmalte.dart';
import 'mes_provider.dart';

class MesScreen extends ConsumerWidget {
  const MesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = ref.watch(mesVisivelProvider);
    final selecionada = ref.watch(dataSelecionadaProvider);
    final editados = ref.watch(diasEditadosProvider).valueOrNull ?? const {};
    final dia = ref.watch(diaProvider);
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          CampoRespingo(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      tooltip: 'Mês anterior',
                      onPressed: () =>
                          ref.read(mesVisivelProvider.notifier).avancar(-1),
                    ),
                    Expanded(
                      child: Text(
                        '${mesNome(m.mes)} ${m.ano}'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: t.labelSmall?.copyWith(color: Colors.white70),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      tooltip: 'Mês seguinte',
                      onPressed: () =>
                          ref.read(mesVisivelProvider.notifier).avancar(1),
                    ),
                  ],
                ),
                Text('O mês',
                    style: t.displaySmall?.copyWith(color: Colors.white)),
              ],
            ),
          ),
          _Grade(
            ano: m.ano,
            mes: m.mes,
            selecionada: selecionada,
            editados: editados,
            onEscolher: (d) =>
                ref.read(dataSelecionadaProvider.notifier).ir(d),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 11, 15, 3),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                      color: cores.brasa, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text('dia que você trocou',
                    style: t.bodySmall?.copyWith(color: cores.ink3)),
                const Spacer(),
                Text('${editados.length} neste mês',
                    style: t.labelMedium?.copyWith(color: cores.ink3)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 9, 13, 24),
            child: dia.when(
              loading: () => const Center(
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator())),
              error: (e, _) => Text('$e', style: t.bodySmall),
              data: (d) => CartaoEsmalte(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataLonga(d.data).replaceFirstMapped(
                          RegExp(r'^\w'), (m) => m[0]!.toUpperCase()),
                      style: t.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'dia ${d.posicao} de ${d.tamanhoCiclo} · '
                      '${ehDiaUtilData(d.data) ? '1 porção no café e no almoço' : '2 porções o dia todo'}',
                      style: t.labelMedium?.copyWith(color: cores.ink3),
                    ),
                    const SizedBox(height: 10),
                    for (final r in d.refeicoes)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(rotuloSlot(r.slot),
                                  style: t.bodyMedium
                                      ?.copyWith(color: cores.ink2)),
                            ),
                            Text('${r.nutrientes.kcal.round()} kcal',
                                style: t.labelMedium
                                    ?.copyWith(color: cores.ink3)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    Container(height: 2, color: cores.marinho),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text('TOTAL DO DIA',
                              style: t.labelSmall?.copyWith(color: cores.ink3)),
                        ),
                        Text('${d.total.kcal.round()}',
                            style: t.titleLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Grade extends StatelessWidget {
  final int ano;
  final int mes;
  final DataPura selecionada;
  final Set<DataPura> editados;
  final ValueChanged<DataPura> onEscolher;

  const _Grade({
    required this.ano,
    required this.mes,
    required this.selecionada,
    required this.editados,
    required this.onEscolher,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    final t = Theme.of(context).textTheme;
    final total = diasNoMes(ano, mes);
    final vazias = primeiroDiaDaSemana(ano, mes);
    final hoje = DataPura.de(DateTime.now());

    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 0),
      child: Column(
        children: [
          Row(
            children: [
              for (final s in const ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'])
                Expanded(
                  child: Center(
                    child: Text(s,
                        style:
                            t.labelSmall?.copyWith(color: cores.ink3)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: vazias + total,
            itemBuilder: (context, i) {
              if (i < vazias) return const SizedBox.shrink();

              final numero = i - vazias + 1;
              final data = DataPura.de(DateTime.utc(ano, mes, numero));
              final ativa = data == selecionada;
              final editada = editados.contains(data);

              return Semantics(
                selected: ativa,
                button: true,
                label: '$numero de ${mesNome(mes)}'
                    '${editada ? ', substituído' : ''}',
                child: Material(
                  color: ativa ? cores.marinho : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(7),
                  child: InkWell(
                    onTap: () => onEscolher(data),
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: ativa ? cores.marinho : cores.linha,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              '$numero',
                              style: t.bodyMedium?.copyWith(
                                color: ativa ? Colors.white : cores.ink2,
                                fontVariations: [
                                  FontVariation('wght', ativa ? 800 : 500)
                                ],
                              ),
                            ),
                          ),
                          if (editada)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: ativa ? Colors.white : cores.brasa,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          if (data == hoje && !ativa)
                            Positioned(
                              bottom: 4,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: cores.brasa,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Acrescentar `ehDiaUtilData` à formatação**

Ao fim de `lib/presentation/format.dart`:

```dart
bool ehDiaUtilData(DataPura d) => porcoes.ehDiaUtil(d);
```

E no topo:

```dart
import '../domain/porcoes.dart' as porcoes;
```

- [ ] **Step 4: Escrever o teste**

`test/mes_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/data/repo_plano.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/hoje/hoje_provider.dart';
import 'package:refeicoes_app/presentation/mes/mes_provider.dart';
import 'package:refeicoes_app/presentation/mes/mes_screen.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;
  const sexta = DataPura('2026-09-04');

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  Future<void> abrir(WidgetTester tester) async {
    await tester.pumpWidget(envolver(
      const MesScreen(),
      db: db,
      overrides: [
        dataSelecionadaProvider.overrideWith(() => _DataFixa(sexta)),
      ],
    ));
    await tester.pumpAndSettle();
  }

  test('diasNoMes cobre mes curto, longo e bissexto', () {
    expect(diasNoMes(2026, 9), 30);
    expect(diasNoMes(2026, 10), 31);
    expect(diasNoMes(2026, 2), 28);
    expect(diasNoMes(2028, 2), 29);
  });

  test('primeiroDiaDaSemana devolve coluna de 0 a 6', () {
    // 2026-09-01 e uma terca -> coluna 2 (domingo = 0)
    expect(primeiroDiaDaSemana(2026, 9), 2);
    for (var m = 1; m <= 12; m++) {
      expect(primeiroDiaDaSemana(2026, m), inInclusiveRange(0, 6));
    }
  });

  testWidgets('mostra o mes e os trinta dias', (tester) async {
    await abrir(tester);

    expect(find.text('SETEMBRO 2026'), findsOneWidget);
    expect(find.text('O mês'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('31'), findsNothing);
  });

  testWidgets('resumo do dia selecionado aparece embaixo', (tester) async {
    await abrir(tester);

    expect(find.text('Sexta, 4 de setembro'), findsOneWidget);
    expect(find.textContaining('dia 4 de 4'), findsOneWidget);
    expect(find.textContaining('1 porção no café e no almoço'),
        findsOneWidget);
    expect(find.text('TOTAL DO DIA'), findsOneWidget);
  });

  testWidgets('escolher um sabado troca a regra de porcao', (tester) async {
    await abrir(tester);

    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();

    expect(find.text('Sábado, 5 de setembro'), findsOneWidget);
    expect(find.textContaining('2 porções o dia todo'), findsOneWidget);
  });

  testWidgets('folhear troca o mes sem mexer no dia escolhido',
      (tester) async {
    await abrir(tester);

    await tester.tap(find.byTooltip('Mês seguinte'));
    await tester.pumpAndSettle();

    expect(find.text('OUTUBRO 2026'), findsOneWidget);
    expect(find.text('31'), findsOneWidget);
    // o resumo continua no dia 4 de setembro
    expect(find.text('Sexta, 4 de setembro'), findsOneWidget);
  });

  testWidgets('dia sem substituicao nao tem contagem', (tester) async {
    await abrir(tester);
    expect(find.text('0 neste mês'), findsOneWidget);
  });

  testWidgets('dia substituido entra na contagem', (tester) async {
    await RepoPlano(db, RepoConfig(db)).substituirCombo(
        data: sexta, slot: SlotRefeicao.almoco, comboId: 5);

    await abrir(tester);
    expect(find.text('1 neste mês'), findsOneWidget);
  });

  testWidgets('cada dia e um botao acessivel', (tester) async {
    await abrir(tester);

    final semantica = tester.getSemantics(find.text('4').first);
    expect(semantica.label, contains('4 de setembro'));
  });
}

class _DataFixa extends DataSelecionada {
  final DataPura inicial;
  _DataFixa(this.inicial);

  @override
  DataPura build() => inicial;
}
```

- [ ] **Step 5: Rodar e ver passar**

```bash
flutter test test/mes_screen_test.dart
flutter analyze
```

Esperado: 10 testes passando. Se `primeiroDiaDaSemana` falhar em 2, conferir: 
`DateTime.weekday` devolve 2 para terça, e `2 % 7 == 2` — o `% 7` só serve para
mapear domingo (7) na coluna 0.

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/mes/ lib/presentation/format.dart test/mes_screen_test.dart
git commit -m "feat(ui): tela Mes com grade, dia editado e resumo do dia"
```

- [ ] **Step 7: Checkpoint de APK**

```bash
flutter analyze && flutter test && flutter build apk --release
```

Avisar o Isac. Mensagem:

> APK em `build/app/outputs/flutter-apk/app-release.apk`.
> **Olhe:**
> 1. Aba Mês: a grade do mês, hoje com ponto de brasa embaixo.
> 2. Toque num **sábado** → o resumo embaixo muda para "2 porções o dia todo".
>    Toque numa terça → volta para "1 porção no café e no almoço".
> 3. Volte para Hoje: **a data escolhida no Mês é a mesma** — as duas telas
>    compartilham a seleção.
> 4. Substitua algo num dia, volte ao Mês → aquele dia ganha **ponto de brasa no
>    canto** e o contador "N neste mês" sobe.
> 5. Folheie para outubro com a seta → 31 dias, e o resumo continua no dia escolhido.
>
> **Ainda não funciona:** Mercado e Receitas.

---

### Task 19: Tela Mercado

**Files:**
- Create: `lib/presentation/mercado/mercado_provider.dart`
- Modify: `lib/presentation/mercado/mercado_screen.dart` (substitui o tronco)
- Create: `test/mercado_screen_test.dart`

**Interfaces:**
- Consumes: `repoMercadoProvider`, `bancoProvider`, `formatarCompra`, `ordemSecoes`
- Produces:
  - `class ItemNaTela` — `alimentoId`, `nome`, `secao`, `valor`, `unidade`, `marcado`
  - `class ListaNaTela` — `listaId`, `de`, `ate`, `itens`, `feitos`, `total`
  - `final intervaloProvider = NotifierProvider<Intervalo, ({DataPura de, DataPura ate})>`
  - `final listaMercadoProvider = FutureProvider<ListaNaTela>`
  - `class MercadoScreen extends ConsumerWidget`

- [ ] **Step 1: Escrever os providers**

`lib/presentation/mercado/mercado_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import '../../domain/mercado.dart';
import '../../domain/modelos.dart';

class ItemNaTela {
  final int alimentoId;
  final String nome;
  final SecaoMercado secao;
  final double valor;
  final String unidade;
  final bool marcado;

  const ItemNaTela({
    required this.alimentoId,
    required this.nome,
    required this.secao,
    required this.valor,
    required this.unidade,
    required this.marcado,
  });
}

class ListaNaTela {
  final int listaId;
  final DataPura de;
  final DataPura ate;
  final List<ItemNaTela> itens;

  const ListaNaTela({
    required this.listaId,
    required this.de,
    required this.ate,
    required this.itens,
  });

  int get feitos => itens.where((i) => i.marcado).length;
  int get total => itens.length;
  double get progresso => total == 0 ? 0 : feitos / total;

  List<ItemNaTela> daSecao(SecaoMercado s) =>
      itens.where((i) => i.secao == s).toList();

  List<SecaoMercado> get secoes =>
      ordemSecoes.where((s) => daSecao(s).isNotEmpty).toList();
}

/// Segunda a domingo da semana corrente.
({DataPura de, DataPura ate}) semanaDe(DateTime agora) {
  final base = DateTime.utc(agora.year, agora.month, agora.day);
  final segunda = base.subtract(Duration(days: base.weekday - 1));
  return (
    de: DataPura.de(segunda),
    ate: DataPura.de(segunda.add(const Duration(days: 6))),
  );
}

({DataPura de, DataPura ate}) mesDe(DateTime agora) => (
      de: DataPura.de(DateTime.utc(agora.year, agora.month, 1)),
      ate: DataPura.de(DateTime.utc(agora.year, agora.month + 1, 0)),
    );

class Intervalo extends Notifier<({DataPura de, DataPura ate})> {
  @override
  ({DataPura de, DataPura ate}) build() => semanaDe(DateTime.now());

  void definir(DataPura de, DataPura ate) => state = (de: de, ate: ate);
  void semana() => state = semanaDe(DateTime.now());
  void mes() => state = mesDe(DateTime.now());
}

final intervaloProvider =
    NotifierProvider<Intervalo, ({DataPura de, DataPura ate})>(Intervalo.new);

/// Gera a lista do intervalo e devolve pronta para tela.
///
/// Gera de novo a cada mudança de intervalo — cada geração cria uma lista nova
/// no banco, e a anterior fica no histórico (spec seção 9).
final listaMercadoProvider = FutureProvider<ListaNaTela>((ref) async {
  final intervalo = ref.watch(intervaloProvider);
  final repo = ref.watch(repoMercadoProvider);
  final db = ref.watch(bancoProvider);

  final listaId = await repo.gerar(intervalo.de, intervalo.ate);
  final itens = await repo.itens(listaId);

  final alimentos = {
    for (final a in await db.select(db.alimentos).get()) a.id: a,
  };
  final gramasPorUnidade = <int, double>{};
  for (final c in await db.select(db.conversoes).get()) {
    if (c.unidade == Unidade.unidade) gramasPorUnidade[c.alimentoId] = c.gramas;
  }

  final naTela = <ItemNaTela>[];
  for (final s in ordemSecoes) {
    for (final i in itens) {
      final a = alimentos[i.alimentoId];
      if (a == null || a.secaoMercado != s) continue;

      final f = formatarCompra(
        gramas: i.quantidadeG,
        compra: a.unidadeCompra,
        gramasPorUnidade: gramasPorUnidade[a.id],
      );
      naTela.add(ItemNaTela(
        alimentoId: a.id,
        nome: a.nome,
        secao: a.secaoMercado,
        valor: f.valor,
        unidade: f.unidade,
        marcado: i.marcado,
      ));
    }
  }

  return ListaNaTela(
    listaId: listaId,
    de: intervalo.de,
    ate: intervalo.ate,
    itens: naTela,
  );
});
```

- [ ] **Step 2: Escrever a tela**

`lib/presentation/mercado/mercado_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import '../../domain/modelos.dart';
import '../format.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import 'mercado_provider.dart';

class MercadoScreen extends ConsumerWidget {
  const MercadoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista = ref.watch(listaMercadoProvider);
    final intervalo = ref.watch(intervaloProvider);
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          CampoRespingo(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LISTA DE MERCADO',
                    style: t.labelSmall?.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(
                  '${intervalo.de.comoDateTime.day} – '
                  '${intervalo.ate.comoDateTime.day} de '
                  '${mesNome(intervalo.ate.comoDateTime.month)}',
                  style: t.displaySmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  children: [
                    _Faixa(
                      texto: 'Esta semana',
                      ativa: intervalo == semanaDe(DateTime.now()),
                      onTap: () =>
                          ref.read(intervaloProvider.notifier).semana(),
                    ),
                    _Faixa(
                      texto: 'Este mês',
                      ativa: intervalo == mesDe(DateTime.now()),
                      onTap: () => ref.read(intervaloProvider.notifier).mes(),
                    ),
                    _Faixa(
                      texto: 'Escolher…',
                      ativa: false,
                      onTap: () => _escolherIntervalo(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                lista.maybeWhen(
                  data: (l) => Row(
                    children: [
                      Text('${l.feitos} de ${l.total}',
                          style: t.labelMedium?.copyWith(color: cores.ink3)),
                      const SizedBox(width: 9),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: l.progresso,
                            minHeight: 5,
                            backgroundColor: cores.superficie2,
                            valueColor:
                                AlwaysStoppedAnimation(cores.marinho),
                          ),
                        ),
                      ),
                    ],
                  ),
                  orElse: () => const SizedBox(height: 5),
                ),
              ],
            ),
          ),
          lista.when(
            loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator())),
            error: (e, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text('$e', style: t.bodySmall)),
            data: (l) => l.itens.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        'Nada a comprar neste intervalo.',
                        style: t.bodyMedium?.copyWith(color: cores.ink3),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      for (final s in l.secoes)
                        _Secao(secao: s, itens: l.daSecao(s), listaId: l.listaId),
                      const SizedBox(height: 22),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _escolherIntervalo(BuildContext context, WidgetRef ref) async {
    final agora = DateTime.now();
    final faixa = await showDateRangePicker(
      context: context,
      firstDate: DateTime(agora.year - 1),
      lastDate: DateTime(agora.year + 2),
      initialDateRange: DateTimeRange(
        start: ref.read(intervaloProvider).de.comoDateTime,
        end: ref.read(intervaloProvider).ate.comoDateTime,
      ),
    );
    if (faixa == null) return;
    ref
        .read(intervaloProvider.notifier)
        .definir(DataPura.de(faixa.start), DataPura.de(faixa.end));
  }
}

class _Faixa extends StatelessWidget {
  final String texto;
  final bool ativa;
  final VoidCallback onTap;

  const _Faixa({
    required this.texto,
    required this.ativa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    return ChoiceChip(
      label: Text(texto),
      selected: ativa,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: cores.marinho,
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: ativa ? Colors.white : cores.ink2),
      side: BorderSide(color: ativa ? cores.marinho : cores.linha),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}

class _Secao extends StatelessWidget {
  final SecaoMercado secao;
  final List<ItemNaTela> itens;
  final int listaId;

  const _Secao({
    required this.secao,
    required this.itens,
    required this.listaId,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(rotuloSecao(secao).toUpperCase(),
                      style: t.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                Text('${itens.length} itens',
                    style: t.labelMedium?.copyWith(color: cores.ink3)),
              ],
            ),
          ),
          for (final i in itens) _Item(item: i, listaId: listaId),
        ],
      ),
    );
  }
}

class _Item extends ConsumerWidget {
  final ItemNaTela item;
  final int listaId;

  const _Item({required this.item, required this.listaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: () async {
            await ref
                .read(repoMercadoProvider)
                .marcar(listaId, item.alimentoId, !item.marcado);
            ref.invalidate(listaMercadoProvider);
          },
          child: Opacity(
            opacity: item.marcado ? .42 : 1,
            child: Container(
              constraints: const BoxConstraints(minHeight: 46),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: cores.linha),
              ),
              child: Row(
                children: [
                  Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      color: item.marcado ? cores.marinho : null,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: item.marcado ? cores.marinho : cores.ink3,
                          width: 1.5),
                    ),
                    child: item.marcado
                        ? const Icon(Icons.check,
                            size: 12, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.nome,
                      style: t.bodyMedium?.copyWith(
                        decoration: item.marcado
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  Text(_medida(item),
                      style: t.labelMedium?.copyWith(color: cores.ink3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _medida(ItemNaTela i) {
    final v = i.valor;
    final texto = v == v.roundToDouble()
        ? '${v.round()}'
        : v.toStringAsFixed(1).replaceAll('.', ',');
    return '$texto ${i.unidade}';
  }
}
```

- [ ] **Step 3: Escrever o teste**

`test/mercado_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/domain/modelos.dart';
import 'package:refeicoes_app/presentation/mercado/mercado_provider.dart';
import 'package:refeicoes_app/presentation/mercado/mercado_screen.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  Future<void> abrir(WidgetTester tester) async {
    await tester.pumpWidget(envolver(
      const MercadoScreen(),
      db: db,
      overrides: [
        intervaloProvider.overrideWith(() => _IntervaloFixo(
            const DataPura('2026-09-01'), const DataPura('2026-09-07'))),
      ],
    ));
    await tester.pumpAndSettle();
  }

  test('semanaDe devolve segunda a domingo', () {
    // 2026-09-04 e sexta
    final s = semanaDe(DateTime(2026, 9, 4));
    expect(s.de.iso, '2026-08-31'); // segunda
    expect(s.ate.iso, '2026-09-06'); // domingo
  });

  test('semanaDe num domingo nao pula a semana', () {
    final s = semanaDe(DateTime(2026, 9, 6));
    expect(s.de.iso, '2026-08-31');
    expect(s.ate.iso, '2026-09-06');
  });

  test('mesDe pega o primeiro e o ultimo dia', () {
    final m = mesDe(DateTime(2026, 9, 15));
    expect(m.de.iso, '2026-09-01');
    expect(m.ate.iso, '2026-09-30');
  });

  testWidgets('mostra o intervalo e as secoes', (tester) async {
    await abrir(tester);

    expect(find.text('LISTA DE MERCADO'), findsOneWidget);
    expect(find.text('1 – 7 de setembro'), findsOneWidget);
    expect(find.text('HORTIFRÚTI'), findsOneWidget);
    expect(find.text('AÇOUGUE'), findsOneWidget);
  });

  testWidgets('secoes saem na ordem do percurso do mercado', (tester) async {
    await abrir(tester);

    final hortifruti = tester.getTopLeft(find.text('HORTIFRÚTI')).dy;
    final acougue = tester.getTopLeft(find.text('AÇOUGUE')).dy;
    final mercearia = tester.getTopLeft(find.text('MERCEARIA')).dy;

    expect(hortifruti, lessThan(acougue));
    expect(acougue, lessThan(mercearia));
  });

  testWidgets('quantidade vem convertida para unidade de compra',
      (tester) async {
    await abrir(tester);
    // arroz numa semana passa de 1 kg
    expect(find.textContaining('kg'), findsWidgets);
    // ovo e comprado por unidade
    expect(find.textContaining('un'), findsWidgets);
  });

  testWidgets('sal a gosto nao aparece na lista', (tester) async {
    await abrir(tester);
    expect(find.text('Sal'), findsNothing);
  });

  testWidgets('progresso comeca em zero', (tester) async {
    await abrir(tester);
    expect(find.textContaining(RegExp(r'^0 de \d+$')), findsOneWidget);
  });

  testWidgets('marcar item risca e move o progresso', (tester) async {
    await abrir(tester);

    final antes = find.textContaining(RegExp(r'^0 de \d+$'));
    expect(antes, findsOneWidget);

    await tester.tap(find.text('Batata-doce'));
    await tester.pumpAndSettle();

    expect(find.textContaining(RegExp(r'^1 de \d+$')), findsOneWidget);

    final texto = tester.widget<Text>(find.text('Batata-doce'));
    expect(texto.style?.decoration, TextDecoration.lineThrough);
  });

  testWidgets('marcar de novo desmarca', (tester) async {
    await abrir(tester);

    await tester.tap(find.text('Batata-doce'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Batata-doce'));
    await tester.pumpAndSettle();

    expect(find.textContaining(RegExp(r'^0 de \d+$')), findsOneWidget);
  });

  testWidgets('renderiza no escuro sem estourar', (tester) async {
    await tester.pumpWidget(envolver(
      const MercadoScreen(),
      db: db,
      brilho: Brightness.dark,
      overrides: [
        intervaloProvider.overrideWith(() => _IntervaloFixo(
            const DataPura('2026-09-01'), const DataPura('2026-09-07'))),
      ],
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

class _IntervaloFixo extends Intervalo {
  final DataPura de;
  final DataPura ate;
  _IntervaloFixo(this.de, this.ate);

  @override
  ({DataPura de, DataPura ate}) build() => (de: de, ate: ate);
}
```

- [ ] **Step 4: Rodar e ver passar**

```bash
flutter test test/mercado_screen_test.dart
flutter analyze
```

Esperado: 11 testes passando.

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/mercado/ test/mercado_screen_test.dart
git commit -m "feat(ui): tela Mercado por intervalo, agrupada por secao"
```

- [ ] **Step 6: Checkpoint de APK**

```bash
flutter analyze && flutter test && flutter build apk --release
```

Avisar o Isac. Mensagem:

> APK em `build/app/outputs/flutter-apk/app-release.apk`.
> **Olhe:**
> 1. Aba Mercado abre em "Esta semana" com a lista agrupada por seção, **na ordem do
>    percurso**: hortifrúti, açougue, padaria, laticínios, mercearia.
> 2. Quantidade convertida para unidade de compra: arroz em **kg**, ovo em **un**.
> 3. **Sal não aparece** na lista — é "a gosto".
> 4. Marque um item → risca, apaga, e a barra de progresso anda. Marque de novo → desmarca.
> 5. Troque para "Este mês" → a lista cresce.
> 6. "Escolher…" abre o seletor de intervalo.
>
> Vale conferir se as quantidades fazem sentido para você — é o primeiro momento em
> que dá para julgar se os números do seed estão plausíveis.
> **Ainda não funciona:** aba Receitas.

---

### Task 20: Catálogo e receita aberta

**Files:**
- Create: `lib/presentation/receitas/receitas_provider.dart`
- Modify: `lib/presentation/receitas/receitas_screen.dart` (substitui o tronco)
- Modify: `lib/presentation/receitas/receita_screen.dart` (substitui o tronco)
- Create: `test/receitas_screen_test.dart`

**Interfaces:**
- Consumes: `repoReceitasProvider`, `CampoRespingo`, `CartaoEsmalte`
- Produces:
  - `final filtroProvider = NotifierProvider<Filtro, ({CategoriaReceita? categoria, String busca})>`
  - `final catalogoProvider = FutureProvider<List<Receita>>`
  - `class DetalheReceita` — `receita`, `ingredientes` (`List<({String nome, double quantidade, Unidade unidade, String? observacao})>`), `nutrientes`, `temSemMedida`
  - `final detalheProvider = FutureProvider.family<DetalheReceita, int>`
  - `class ReceitasScreen`, `class ReceitaScreen`

- [ ] **Step 1: Escrever os providers**

`lib/presentation/receitas/receitas_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../domain/modelos.dart';
import '../../domain/nutricao.dart';

class Filtro extends Notifier<({CategoriaReceita? categoria, String busca})> {
  @override
  ({CategoriaReceita? categoria, String busca}) build() =>
      (categoria: null, busca: '');

  void categoria(CategoriaReceita? c) => state = (categoria: c, busca: state.busca);
  void buscar(String b) => state = (categoria: state.categoria, busca: b);
}

final filtroProvider =
    NotifierProvider<Filtro, ({CategoriaReceita? categoria, String busca})>(
        Filtro.new);

final catalogoProvider = FutureProvider<List<Receita>>((ref) {
  final f = ref.watch(filtroProvider);
  return ref
      .watch(repoReceitasProvider)
      .listar(categoria: f.categoria, busca: f.busca);
});

class IngredienteNaTela {
  final int alimentoId;
  final String nome;
  final double quantidade;
  final Unidade unidade;
  final String? observacao;

  const IngredienteNaTela({
    required this.alimentoId,
    required this.nome,
    required this.quantidade,
    required this.unidade,
    this.observacao,
  });
}

class DetalheReceita {
  final Receita receita;
  final List<IngredienteNaTela> ingredientes;
  final Nutrientes nutrientes;

  /// Verdadeiro quando algum ingrediente é `a gosto` ou `pitada` — a tela
  /// avisa que aquilo não entra na conta (spec 8.2).
  final bool temSemMedida;

  const DetalheReceita({
    required this.receita,
    required this.ingredientes,
    required this.nutrientes,
    required this.temSemMedida,
  });

  List<String> get passos => receita.modoPreparo
      .split('\n')
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();
}

/// Detalhe no rendimento nativo da receita, sem escalar por porção do dia.
final detalheProvider =
    FutureProvider.family<DetalheReceita, int>((ref, receitaId) async {
  final repo = ref.watch(repoReceitasProvider);
  final db = ref.watch(bancoProvider);

  final receita = await repo.porId(receitaId);
  if (receita == null) throw StateError('receita $receitaId nao existe');

  final ingredientes = await repo.ingredientesDe(receitaId);
  final alimentos = {
    for (final a in await db.select(db.alimentos).get()) a.id: a,
  };
  final conversoes = <int, Map<Unidade, double>>{};
  for (final c in await db.select(db.conversoes).get()) {
    conversoes.putIfAbsent(c.alimentoId, () => {})[c.unidade] = c.gramas;
  }

  final naTela = <IngredienteNaTela>[];
  var nutrientes = Nutrientes.zero;
  var semMedida = false;

  for (final i in ingredientes) {
    final a = alimentos[i.alimentoId];
    if (a == null) continue;

    if (unidadesSemMedida.contains(i.unidade)) semMedida = true;

    naTela.add(IngredienteNaTela(
      alimentoId: a.id,
      nome: a.nome,
      quantidade: i.quantidade,
      unidade: i.unidade,
      observacao: i.observacao,
    ));

    final gramas = emGramas(
      unidade: i.unidade,
      quantidade: i.quantidade,
      conversoes: conversoes[a.id] ?? const {},
      alimentoId: a.id,
    );
    nutrientes = nutrientes +
        nutrienteDe(
          por100g: Nutrientes(
            kcal: a.kcal100g,
            carboidrato: a.carboidratoG,
            proteina: a.proteinaG,
            gordura: a.gorduraG,
            fibra: a.fibraG,
            sodio: a.sodioMg,
          ),
          gramas: gramas,
        );
  }

  return DetalheReceita(
    receita: receita,
    ingredientes: naTela,
    nutrientes: nutrientes,
    temSemMedida: semMedida,
  );
});
```

- [ ] **Step 2: Escrever o catálogo**

`lib/presentation/receitas/receitas_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/modelos.dart';
import '../format.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import 'receita_form_screen.dart';
import 'receita_screen.dart';
import 'receitas_provider.dart';

class ReceitasScreen extends ConsumerWidget {
  const ReceitasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogo = ref.watch(catalogoProvider);
    final filtro = ref.watch(filtroProvider);
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova receita',
        backgroundColor: cores.marinho,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const ReceitaFormScreen(),
        )),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          CampoRespingo(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CATÁLOGO',
                    style: t.labelSmall?.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                catalogo.maybeWhen(
                  data: (l) => Text('${l.length} receitas',
                      style: t.displaySmall?.copyWith(color: Colors.white)),
                  orElse: () => Text('Receitas',
                      style: t.displaySmall?.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 0),
            child: TextField(
              onChanged: (v) => ref.read(filtroProvider.notifier).buscar(v),
              decoration: InputDecoration(
                hintText: 'Buscar receita',
                prefixIcon: const Icon(Icons.search, size: 19),
                isDense: true,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(99),
                  borderSide: BorderSide(color: cores.linha),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(99),
                  borderSide: BorderSide(color: cores.linha),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(13, 9, 13, 4),
              children: [
                _Filtro(
                  texto: 'Todas',
                  ativo: filtro.categoria == null,
                  onTap: () =>
                      ref.read(filtroProvider.notifier).categoria(null),
                ),
                for (final c in CategoriaReceita.values)
                  _Filtro(
                    texto: rotuloCategoria(c),
                    ativo: filtro.categoria == c,
                    onTap: () =>
                        ref.read(filtroProvider.notifier).categoria(c),
                  ),
              ],
            ),
          ),
          Expanded(
            child: catalogo.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e', style: t.bodySmall)),
              data: (lista) => lista.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text(
                          'Nenhuma receita com esse filtro.\n'
                          'Toque no + para criar uma.',
                          textAlign: TextAlign.center,
                          style: t.bodyMedium?.copyWith(color: cores.ink3),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(13, 7, 13, 88),
                      itemCount: lista.length,
                      itemBuilder: (context, i) {
                        final r = lista[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Material(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    ReceitaScreen(receitaId: r.id),
                              )),
                              child: Container(
                                constraints:
                                    const BoxConstraints(minHeight: 52),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: cores.linha),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(r.nome,
                                              style: t.titleMedium,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${rotuloCategoria(r.categoria)} · '
                                            '${r.tempoPreparoMin} min · '
                                            'rende ${r.rendimentoPorcoes}',
                                            style: t.labelMedium
                                                ?.copyWith(color: cores.ink3),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (r.origem == 'usuario')
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8),
                                        child: Icon(Icons.edit_outlined,
                                            size: 15, color: cores.ink3),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Filtro extends StatelessWidget {
  final String texto;
  final bool ativo;
  final VoidCallback onTap;

  const _Filtro({
    required this.texto,
    required this.ativo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: ChoiceChip(
        label: Text(texto),
        selected: ativo,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: cores.marinho,
        backgroundColor: Theme.of(context).colorScheme.surface,
        side: BorderSide(color: ativo ? cores.marinho : cores.linha),
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ativo ? Colors.white : cores.ink2),
      ),
    );
  }
}
```

- [ ] **Step 3: Escrever a receita aberta**

`lib/presentation/receitas/receita_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../format.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import 'receita_form_screen.dart';
import 'receitas_provider.dart';

class ReceitaScreen extends ConsumerWidget {
  final int receitaId;
  const ReceitaScreen({super.key, required this.receitaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalhe = ref.watch(detalheProvider(receitaId));
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Scaffold(
      body: detalhe.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('$e', textAlign: TextAlign.center),
          ),
        ),
        data: (d) => ListView(
          padding: EdgeInsets.zero,
          children: [
            CampoRespingo(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.chevron_left, size: 19),
                        label: const Text('Voltar'),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            minimumSize: const Size(44, 44)),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Editar',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              ReceitaFormScreen(receitaId: receitaId),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(d.receita.nome,
                      style: t.displaySmall?.copyWith(color: Colors.white)),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final f in [
                        '${d.receita.tempoPreparoMin} min',
                        'rende ${d.receita.rendimentoPorcoes}',
                        rotuloCategoria(d.receita.categoria),
                      ])
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(f,
                              style: t.labelMedium
                                  ?.copyWith(color: Colors.white)),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // --- macros calculados
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 13, 13, 0),
              child: Row(
                children: [
                  for (final n in [
                    (v: d.nutrientes.kcal, r: 'KCAL'),
                    (v: d.nutrientes.proteina, r: 'PROT G'),
                    (v: d.nutrientes.carboidrato, r: 'CARB G'),
                    (v: d.nutrientes.gordura, r: 'GORD G'),
                  ])
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(7),
                            border: Border(
                              top: BorderSide(
                                  color: cores.marinho, width: 2.5),
                              left: BorderSide(color: cores.linha),
                              right: BorderSide(color: cores.linha),
                              bottom: BorderSide(color: cores.linha),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text('${n.v.round()}', style: t.titleMedium),
                              Text(n.r,
                                  style: t.labelSmall?.copyWith(
                                      color: cores.ink3, fontSize: 8)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 8, 13, 0),
              child: Center(
                child: Text('calculado dos ingredientes · tabela TACO',
                    style: t.labelMedium?.copyWith(color: cores.ink3)),
              ),
            ),

            // --- ingredientes
            _Bloco(
              titulo: 'Ingredientes',
              nota: 'para ${porcoesTexto(d.receita.rendimentoPorcoes)}',
              child: Column(
                children: [
                  for (final i in d.ingredientes)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: cores.linha)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              i.observacao == null
                                  ? i.nome
                                  : '${i.nome} (${i.observacao})',
                              style:
                                  t.bodyMedium?.copyWith(color: cores.ink2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(qtd(i.quantidade, i.unidade),
                              style: t.labelMedium
                                  ?.copyWith(color: cores.ink3)),
                        ],
                      ),
                    ),
                  if (d.temSemMedida)
                    Padding(
                      padding: const EdgeInsets.only(top: 9),
                      child: Text(
                        'Sal e temperos a gosto não entram na conta.',
                        style: t.bodySmall?.copyWith(
                            color: cores.ink3, fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            ),

            // --- preparo
            _Bloco(
              titulo: 'Modo de preparo',
              nota: '${d.passos.length} passos',
              child: Column(
                children: [
                  for (var i = 0; i < d.passos.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                            child: Text('${i + 1}',
                                style: t.titleMedium
                                    ?.copyWith(color: cores.marinho)),
                          ),
                          Expanded(
                            child: Text(d.passos[i],
                                style:
                                    t.bodyMedium?.copyWith(color: cores.ink2)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }
}

class _Bloco extends StatelessWidget {
  final String titulo;
  final String nota;
  final Widget child;

  const _Bloco({
    required this.titulo,
    required this.nota,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 17, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(titulo.toUpperCase(),
                    style: t.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              ),
              Text(nota, style: t.labelMedium?.copyWith(color: cores.ink3)),
            ],
          ),
          const SizedBox(height: 9),
          child,
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Escrever o teste**

`test/receitas_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/presentation/receitas/receita_screen.dart';
import 'package:refeicoes_app/presentation/receitas/receitas_screen.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  Future<void> abrirCatalogo(WidgetTester tester) async {
    await tester.pumpWidget(envolver(const ReceitasScreen(), db: db));
    await tester.pumpAndSettle();
  }

  group('catalogo', () {
    testWidgets('lista as receitas da semente', (tester) async {
      await abrirCatalogo(tester);

      expect(find.text('CATÁLOGO'), findsOneWidget);
      expect(find.text('24 receitas'), findsOneWidget);
      expect(find.text('Arroz branco'), findsOneWidget);
    });

    testWidgets('filtrar por categoria reduz a lista', (tester) async {
      await abrirCatalogo(tester);

      await tester.tap(find.text('Proteína'));
      await tester.pumpAndSettle();

      expect(find.text('Frango grelhado simples'), findsOneWidget);
      expect(find.text('Arroz branco'), findsNothing);
    });

    testWidgets('legume aparece com o rotulo da tela', (tester) async {
      await abrirCatalogo(tester);
      expect(find.text('Legume'), findsWidgets);
      expect(find.text('Vegetal'), findsNothing);
    });

    testWidgets('buscar filtra por nome', (tester) async {
      await abrirCatalogo(tester);

      await tester.enterText(find.byType(TextField), 'tapioca');
      await tester.pumpAndSettle();

      expect(find.text('Tapioca com queijo coalho'), findsOneWidget);
      expect(find.text('Arroz branco'), findsNothing);
    });

    testWidgets('busca sem resultado mostra convite', (tester) async {
      await abrirCatalogo(tester);

      await tester.enterText(find.byType(TextField), 'zzzzz');
      await tester.pumpAndSettle();

      expect(find.textContaining('Nenhuma receita com esse filtro'),
          findsOneWidget);
    });

    testWidgets('tem botao de nova receita', (tester) async {
      await abrirCatalogo(tester);
      expect(find.byTooltip('Nova receita'), findsOneWidget);
    });
  });

  group('receita aberta', () {
    Future<void> abrirDetalhe(WidgetTester tester, int id) async {
      await tester.pumpWidget(envolver(ReceitaScreen(receitaId: id), db: db));
      await tester.pumpAndSettle();
    }

    testWidgets('mostra nome, tempo e rendimento', (tester) async {
      await abrirDetalhe(tester, 3);

      expect(find.text('Picadinho de carne com legumes'), findsOneWidget);
      expect(find.text('35 min'), findsOneWidget);
      expect(find.text('rende 1'), findsOneWidget);
      expect(find.text('Proteína'), findsOneWidget);
    });

    testWidgets('macros vem calculados e rotulados como tal', (tester) async {
      await abrirDetalhe(tester, 3);

      expect(find.text('KCAL'), findsOneWidget);
      expect(find.text('PROT G'), findsOneWidget);
      expect(find.text('calculado dos ingredientes · tabela TACO'),
          findsOneWidget);
    });

    testWidgets('lista ingredientes com quantidade e observacao',
        (tester) async {
      await abrirDetalhe(tester, 3);

      expect(find.text('Patinho cru'), findsOneWidget);
      expect(find.text('150 g'), findsWidgets);
      expect(find.text('Cebola crua (picada)'), findsOneWidget);
      expect(find.text('1 dente'), findsWidgets);
    });

    testWidgets('avisa sobre ingrediente a gosto', (tester) async {
      await abrirDetalhe(tester, 3);

      expect(find.text('a gosto'), findsWidgets);
      expect(find.text('Sal e temperos a gosto não entram na conta.'),
          findsOneWidget);
    });

    testWidgets('receita sem a gosto nao mostra o aviso', (tester) async {
      await abrirDetalhe(tester, 6); // tapioca com queijo

      expect(find.text('Sal e temperos a gosto não entram na conta.'),
          findsNothing);
    });

    testWidgets('numera os passos do preparo', (tester) async {
      await abrirDetalhe(tester, 3);

      expect(find.text('5 passos'), findsOneWidget);
      expect(find.text('1'), findsWidgets);
      expect(find.text('5'), findsWidgets);
      expect(
          find.textContaining('Tempere a carne com sal'), findsOneWidget);
    });

    testWidgets('receita inexistente mostra erro sem quebrar', (tester) async {
      await abrirDetalhe(tester, 9999);
      expect(find.textContaining('nao existe'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renderiza no escuro sem estourar', (tester) async {
      await tester.pumpWidget(envolver(const ReceitaScreen(receitaId: 3),
          db: db, brilho: Brightness.dark));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
```

- [ ] **Step 5: Rodar e ver passar**

```bash
flutter test test/receitas_screen_test.dart
flutter analyze
```

Esperado: 14 testes passando. `flutter analyze` reclama de `receita_form_screen.dart`
inexistente — criar o tronco que a Task 21 substitui:

`lib/presentation/receitas/receita_form_screen.dart`:

```dart
import 'package:flutter/material.dart';

class ReceitaFormScreen extends StatelessWidget {
  final int? receitaId;
  const ReceitaFormScreen({super.key, this.receitaId});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Editar receita')));
}
```

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/receitas/ test/receitas_screen_test.dart
git commit -m "feat(ui): catalogo de receitas e tela de receita aberta"
```

- [ ] **Step 7: Checkpoint de APK**

```bash
flutter analyze && flutter test && flutter build apk --release
```

Avisar o Isac. Mensagem:

> APK em `build/app/outputs/flutter-apk/app-release.apk`.
> **Olhe:**
> 1. Aba Receitas: 24 receitas, busca e filtro por categoria funcionando.
> 2. Filtre por Proteína → só as proteínas. Busque "tapioca" → uma só.
> 3. Abra uma receita: macros no topo, ingredientes com quantidade, preparo numerado.
> 4. Na receita com sal a gosto, o aviso *"Sal e temperos a gosto não entram na conta"*
>    aparece; na tapioca, não.
> 5. Na aba Hoje, tocar numa refeição também abre a receita.
>
> **Este é o checkpoint para julgar o conteúdo:** leia dois ou três modos de preparo e
> veja se batem com o jeito que a sua esposa cozinha. Se não baterem, é agora que sai
> mais barato descobrir — antes de gerar as outras 158 receitas.
> **Ainda não funciona:** criar e editar receita (Task 21), Ajustes (Task 22).

---

### Task 21: Editar receita

**Files:**
- Modify: `lib/presentation/receitas/receita_form_screen.dart` (substitui o tronco)
- Create: `test/receita_form_screen_test.dart`

**Interfaces:**
- Consumes: `repoReceitasProvider`, `detalheProvider`, `catalogoProvider`
- Produces: `class ReceitaFormScreen extends ConsumerStatefulWidget` — `receitaId` nulo cria, preenchido edita

O ponto de design desta tela: **o painel de macros é travado**, com a nota de que vem
da TACO. Ela nunca digita caloria.

- [ ] **Step 1: Escrever a tela**

`lib/presentation/receitas/receita_form_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../domain/modelos.dart';
import '../../domain/nutricao.dart';
import '../format.dart';
import '../hoje/hoje_provider.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import 'receitas_provider.dart';

/// Linha em edição. Mutável de propósito: é estado de formulário.
class _LinhaIng {
  int alimentoId;
  String nome;
  double quantidade;
  Unidade unidade;
  String? observacao;

  _LinhaIng({
    required this.alimentoId,
    required this.nome,
    required this.quantidade,
    required this.unidade,
    this.observacao,
  });
}

class ReceitaFormScreen extends ConsumerStatefulWidget {
  final int? receitaId;
  const ReceitaFormScreen({super.key, this.receitaId});

  @override
  ConsumerState<ReceitaFormScreen> createState() => _FormState();
}

class _FormState extends ConsumerState<ReceitaFormScreen> {
  final _nome = TextEditingController();
  final _preparo = TextEditingController();
  var _categoria = CategoriaReceita.proteina;
  var _rende = 1;
  var _tempo = 20;
  final _ingredientes = <_LinhaIng>[];
  var _carregado = false;
  var _salvando = false;

  bool get _novo => widget.receitaId == null;

  @override
  void dispose() {
    _nome.dispose();
    _preparo.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    if (_carregado || _novo) {
      _carregado = true;
      return;
    }
    final d = await ref.read(detalheProvider(widget.receitaId!).future);
    if (!mounted) return;
    setState(() {
      _nome.text = d.receita.nome;
      _preparo.text = d.receita.modoPreparo;
      _categoria = d.receita.categoria;
      _rende = d.receita.rendimentoPorcoes;
      _tempo = d.receita.tempoPreparoMin;
      _ingredientes
        ..clear()
        ..addAll(d.ingredientes.map((i) => _LinhaIng(
              alimentoId: i.alimentoId,
              nome: i.nome,
              quantidade: i.quantidade,
              unidade: i.unidade,
              observacao: i.observacao,
            )));
      _carregado = true;
    });
  }

  /// Nutrição recalculada na hora a partir das linhas em edição.
  Future<Nutrientes> _calcular() async {
    final db = ref.read(bancoProvider);
    final alimentos = {
      for (final a in await db.select(db.alimentos).get()) a.id: a,
    };
    final conversoes = <int, Map<Unidade, double>>{};
    for (final c in await db.select(db.conversoes).get()) {
      conversoes.putIfAbsent(c.alimentoId, () => {})[c.unidade] = c.gramas;
    }

    var n = Nutrientes.zero;
    for (final l in _ingredientes) {
      final a = alimentos[l.alimentoId];
      if (a == null) continue;
      final gramas = emGramas(
        unidade: l.unidade,
        quantidade: l.quantidade,
        conversoes: conversoes[a.id] ?? const {},
        alimentoId: a.id,
      );
      n = n +
          nutrienteDe(
            por100g: Nutrientes(
              kcal: a.kcal100g,
              carboidrato: a.carboidratoG,
              proteina: a.proteinaG,
              gordura: a.gorduraG,
              fibra: a.fibraG,
              sodio: a.sodioMg,
            ),
            gramas: gramas,
          );
    }
    return n;
  }

  Future<void> _salvar() async {
    if (_nome.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dê um nome à receita.')));
      return;
    }
    if (_ingredientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicione pelo menos um ingrediente.')));
      return;
    }

    setState(() => _salvando = true);
    await ref.read(repoReceitasProvider).salvar(
          id: widget.receitaId,
          nome: _nome.text.trim(),
          categoria: _categoria,
          rendimentoPorcoes: _rende,
          tempoPreparoMin: _tempo,
          modoPreparo: _preparo.text.trim(),
          ingredientes: _ingredientes
              .map((l) => (
                    alimentoId: l.alimentoId,
                    quantidade: l.quantidade,
                    unidade: l.unidade,
                    observacao: l.observacao,
                  ))
              .toList(),
        );

    ref.invalidate(catalogoProvider);
    ref.invalidate(diaProvider);
    if (widget.receitaId != null) {
      ref.invalidate(detalheProvider(widget.receitaId!));
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return FutureBuilder<void>(
      future: _carregar(),
      builder: (context, snap) {
        if (!_carregado) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              CampoRespingo(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              minimumSize: const Size(44, 44)),
                          child: const Text('Cancelar'),
                        ),
                        const Spacer(),
                        if (!_novo)
                          IconButton(
                            tooltip: 'Excluir',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: _confirmarExclusao,
                          ),
                      ],
                    ),
                    Text(_novo ? 'Nova receita' : 'Editar receita',
                        style: t.displaySmall?.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 13, 14, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _rotulo('Nome'),
                    TextField(
                      controller: _nome,
                      style: t.titleMedium,
                      decoration: _campo(context, 'Nome do prato'),
                    ),

                    _rotulo('Categoria'),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        for (final c in CategoriaReceita.values)
                          ChoiceChip(
                            label: Text(rotuloCategoria(c)),
                            selected: _categoria == c,
                            showCheckmark: false,
                            selectedColor: cores.marinho,
                            labelStyle: t.bodySmall?.copyWith(
                                color: _categoria == c
                                    ? Colors.white
                                    : cores.ink2),
                            onSelected: (_) =>
                                setState(() => _categoria = c),
                          ),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _rotulo('Rende'),
                              _Contador(
                                valor: '$_rende ${_rende == 1 ? 'porção' : 'porções'}',
                                onMenos: _rende > 1
                                    ? () => setState(() => _rende--)
                                    : null,
                                onMais: () => setState(() => _rende++),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _rotulo('Tempo'),
                              _Contador(
                                valor: '$_tempo min',
                                onMenos: _tempo > 5
                                    ? () => setState(() => _tempo -= 5)
                                    : null,
                                onMais: () => setState(() => _tempo += 5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    _rotulo('Ingredientes'),
                    for (var i = 0; i < _ingredientes.length; i++)
                      _linhaIngrediente(i),
                    OutlinedButton.icon(
                      onPressed: _adicionarIngrediente,
                      icon: const Icon(Icons.add, size: 17),
                      label: const Text('Adicionar ingrediente'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),

                    _rotulo('Modo de preparo'),
                    TextField(
                      controller: _preparo,
                      maxLines: null,
                      minLines: 4,
                      decoration: _campo(
                          context, 'Um passo por linha'),
                    ),

                    _rotulo('Valor nutricional'),
                    _PainelCalculado(calcular: _calcular),

                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: _salvando ? null : _salvar,
                      child: Text(_salvando ? 'Salvando…' : 'Salvar receita'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _rotulo(String texto) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 7),
        child: Text(texto.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary)),
      );

  InputDecoration _campo(BuildContext context, String dica) {
    final cores = context.esmalte;
    return InputDecoration(
      hintText: dica,
      isDense: true,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: cores.linha),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: cores.linha),
      ),
    );
  }

  Widget _linhaIngrediente(int i) {
    final l = _ingredientes[i];
    final cores = context.esmalte;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        constraints: const BoxConstraints(minHeight: 46),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: cores.linha),
        ),
        child: Row(
          children: [
            Expanded(child: Text(l.nome, style: t.bodyMedium)),
            Text(qtd(l.quantidade, l.unidade),
                style: t.labelMedium?.copyWith(color: cores.ink3)),
            IconButton(
              tooltip: 'Remover ${l.nome}',
              icon: const Icon(Icons.close, size: 17),
              onPressed: () => setState(() => _ingredientes.removeAt(i)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _adicionarIngrediente() async {
    final alimentos = await ref.read(repoReceitasProvider).alimentos();
    if (!mounted) return;

    final escolhido = await showModalBottomSheet<Alimento>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(ctx).size.height * .6,
          child: ListView.builder(
            itemCount: alimentos.length,
            itemBuilder: (ctx, i) => ListTile(
              title: Text(alimentos[i].nome),
              onTap: () => Navigator.of(ctx).pop(alimentos[i]),
            ),
          ),
        ),
      ),
    );
    if (escolhido == null || !mounted) return;

    setState(() => _ingredientes.add(_LinhaIng(
          alimentoId: escolhido.id,
          nome: escolhido.nome,
          quantidade: 100,
          unidade: Unidade.g,
        )));
  }

  Future<void> _confirmarExclusao() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir receita?'),
        content: const Text(
            'Ela sai do catálogo. Dias que já usaram a receita continuam '
            'como estão.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (ok != true) return;

    await ref.read(repoReceitasProvider).excluir(widget.receitaId!);
    ref.invalidate(catalogoProvider);
    if (mounted) Navigator.of(context).pop();
  }
}

class _Contador extends StatelessWidget {
  final String valor;
  final VoidCallback? onMenos;
  final VoidCallback? onMais;

  const _Contador({
    required this.valor,
    required this.onMenos,
    required this.onMais,
  });

  @override
  Widget build(BuildContext context) {
    final cores = context.esmalte;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: cores.linha),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(valor,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          IconButton(
              icon: const Icon(Icons.remove, size: 17),
              onPressed: onMenos,
              tooltip: 'Menos'),
          IconButton(
              icon: const Icon(Icons.add, size: 17),
              onPressed: onMais,
              tooltip: 'Mais'),
        ],
      ),
    );
  }
}

/// Painel travado. A nutrição não é campo de formulário: vem dos ingredientes.
class _PainelCalculado extends StatelessWidget {
  final Future<Nutrientes> Function() calcular;
  const _PainelCalculado({required this.calcular});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cores.superficie2,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: cores.linha),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculado dos ingredientes pela tabela TACO. Muda sozinho quando '
            'você edita a lista acima — não dá pra digitar à mão.',
            style: t.labelMedium?.copyWith(color: cores.ink3),
          ),
          const SizedBox(height: 10),
          FutureBuilder<Nutrientes>(
            future: calcular(),
            builder: (context, snap) {
              final n = snap.data ?? Nutrientes.zero;
              return Row(
                children: [
                  for (final v in [
                    (n.kcal, 'KCAL'),
                    (n.proteina, 'PROT G'),
                    (n.carboidrato, 'CARB G'),
                    (n.gordura, 'GORD G'),
                  ])
                    Expanded(
                      child: Column(
                        children: [
                          Text('${v.$1.round()}', style: t.titleMedium),
                          Text(v.$2,
                              style: t.labelSmall
                                  ?.copyWith(color: cores.ink3, fontSize: 7.5)),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Escrever o teste**

`test/receita_form_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/presentation/receitas/receita_form_screen.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  Future<void> abrir(WidgetTester tester, {int? id}) async {
    await tester.pumpWidget(
        envolver(ReceitaFormScreen(receitaId: id), db: db));
    await tester.pumpAndSettle();
  }

  testWidgets('novo comeca vazio e sem botao de excluir', (tester) async {
    await abrir(tester);

    expect(find.text('Nova receita'), findsOneWidget);
    expect(find.byTooltip('Excluir'), findsNothing);
    expect(find.text('Adicionar ingrediente'), findsOneWidget);
  });

  testWidgets('editar carrega os dados da receita', (tester) async {
    await abrir(tester, id: 3);

    expect(find.text('Editar receita'), findsOneWidget);
    expect(find.text('Picadinho de carne com legumes'), findsOneWidget);
    expect(find.text('35 min'), findsOneWidget);
    expect(find.text('1 porção'), findsOneWidget);
    expect(find.text('Patinho cru'), findsOneWidget);
    expect(find.byTooltip('Excluir'), findsOneWidget);
  });

  testWidgets('painel de nutricao e travado e explica de onde vem',
      (tester) async {
    await abrir(tester, id: 3);

    expect(
      find.textContaining('não dá pra digitar à mão'),
      findsOneWidget,
    );
    // nao existe campo de texto para caloria
    final campos = tester.widgetList<TextField>(find.byType(TextField));
    for (final c in campos) {
      expect(c.decoration?.hintText, isNot(contains('kcal')));
    }
  });

  testWidgets('contador de rendimento nao desce abaixo de 1', (tester) async {
    await abrir(tester, id: 3);

    expect(find.text('1 porção'), findsOneWidget);
    final menos = find.byTooltip('Menos').first;
    expect(tester.widget<IconButton>(menos).onPressed, isNull);
  });

  testWidgets('subir o rendimento muda o rotulo para plural', (tester) async {
    await abrir(tester, id: 3);

    await tester.tap(find.byTooltip('Mais').first);
    await tester.pumpAndSettle();
    expect(find.text('2 porções'), findsOneWidget);
  });

  testWidgets('remover ingrediente tira a linha', (tester) async {
    await abrir(tester, id: 3);

    expect(find.text('Patinho cru'), findsOneWidget);
    await tester.tap(find.byTooltip('Remover Patinho cru'));
    await tester.pumpAndSettle();
    expect(find.text('Patinho cru'), findsNothing);
  });

  testWidgets('salvar sem nome avisa e nao grava', (tester) async {
    await abrir(tester);

    await tester.tap(find.text('Salvar receita'));
    await tester.pumpAndSettle();

    expect(find.text('Dê um nome à receita.'), findsOneWidget);
    expect(await db.select(db.receitas).get(), hasLength(24));
  });

  testWidgets('salvar sem ingrediente avisa', (tester) async {
    await abrir(tester);

    await tester.enterText(find.byType(TextField).first, 'Omelete simples');
    await tester.tap(find.text('Salvar receita'));
    await tester.pumpAndSettle();

    expect(find.text('Adicione pelo menos um ingrediente.'), findsOneWidget);
  });

  testWidgets('criar receita nova grava com origem usuario', (tester) async {
    await abrir(tester);

    await tester.enterText(find.byType(TextField).first, 'Omelete simples');
    await tester.tap(find.text('Adicionar ingrediente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ovo de galinha cru').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar receita'));
    await tester.pumpAndSettle();

    final nova = (await db.select(db.receitas).get())
        .firstWhere((r) => r.nome == 'Omelete simples');
    expect(nova.origem, 'usuario');
    expect(await db.select(db.receitas).get(), hasLength(25));
  });

  testWidgets('editar receita de semente transfere a posse', (tester) async {
    await abrir(tester, id: 1);

    await tester.enterText(
        find.byType(TextField).first, 'Arroz do jeito dela');
    await tester.tap(find.text('Salvar receita'));
    await tester.pumpAndSettle();

    final r = await (db.select(db.receitas)..where((t) => t.id.equals(1)))
        .getSingle();
    expect(r.nome, 'Arroz do jeito dela');
    expect(r.origem, 'usuario');
  });

  testWidgets('excluir pede confirmacao e desativa', (tester) async {
    await abrir(tester, id: 22);

    await tester.tap(find.byTooltip('Excluir'));
    await tester.pumpAndSettle();
    expect(find.text('Excluir receita?'), findsOneWidget);

    await tester.tap(find.text('Excluir').last);
    await tester.pumpAndSettle();

    final r = await (db.select(db.receitas)..where((t) => t.id.equals(22)))
        .getSingle();
    expect(r.ativa, isFalse);
  });

  testWidgets('cancelar a exclusao nao mexe em nada', (tester) async {
    await abrir(tester, id: 22);

    await tester.tap(find.byTooltip('Excluir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar').last);
    await tester.pumpAndSettle();

    final r = await (db.select(db.receitas)..where((t) => t.id.equals(22)))
        .getSingle();
    expect(r.ativa, isTrue);
  });
}
```

- [ ] **Step 3: Rodar e ver passar**

```bash
flutter test test/receita_form_screen_test.dart
flutter analyze
```

Esperado: 12 testes passando. `editar receita de semente transfere a posse` é o que
prova, na interface, a decisão da spec seção 12.

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/receitas/receita_form_screen.dart test/receita_form_screen_test.dart
git commit -m "feat(ui): editar e criar receita com nutricao travada"
```

- [ ] **Step 5: Checkpoint de APK**

```bash
flutter analyze && flutter test && flutter build apk --release
```

Avisar o Isac. Mensagem:

> APK em `build/app/outputs/flutter-apk/app-release.apk`.
> **Olhe:**
> 1. Botão `+` na aba Receitas → formulário vazio. Dê nome, adicione um ingrediente,
>    salve → aparece no catálogo com um lápis ao lado.
> 2. Abra uma receita da semente, toque no lápis, mude o nome, salve → mudou, e agora
>    ela também tem o lápis (**virou dela**; atualização de conteúdo não sobrescreve mais).
> 3. **O painel de nutrição é cinza e não deixa digitar** — a nota explica que vem da
>    tabela TACO. Remova um ingrediente e veja os números mudarem sozinhos.
> 4. Salvar sem nome ou sem ingrediente avisa e não grava.
> 5. Excluir pede confirmação.
>
> **Este é o ponto em que o app passa a sobreviver sem você:** ela consegue corrigir
> qualquer receita que estiver errada, sozinha.
> **Ainda não funciona:** Ajustes (Task 22).

---

### Task 22: Ajustes, aparência e backup

**Files:**
- Create: `lib/presentation/ajustes/ajustes_provider.dart`
- Modify: `lib/presentation/ajustes/ajustes_screen.dart` (substitui o tronco)
- Modify: `lib/app.dart` (liga o modo de tema escolhido)
- Create: `test/ajustes_screen_test.dart`

**Interfaces:**
- Consumes: `repoConfigProvider`, `exportarJson`, `importarJson`, `share_plus`, `file_picker`
- Produces:
  - `final temaModoProvider = AsyncNotifierProvider<TemaModo, ThemeMode>`
  - `final resumoProvider = FutureProvider<({int receitas, int combos, int alimentos, String inicio, int tamanho})>`
  - `final regrasPorcaoProvider = FutureProvider<Map<(SlotRefeicao, bool), int>>`
  - `class AjustesScreen extends ConsumerWidget`

- [ ] **Step 1: Escrever os providers**

`lib/presentation/ajustes/ajustes_provider.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import '../../domain/modelos.dart';

/// Aparência: claro, escuro ou seguir o sistema. Persistida em `config.tema`.
class TemaModo extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final valor = await ref.watch(repoConfigProvider).ler('tema');
    return switch (valor) {
      'claro' => ThemeMode.light,
      'escuro' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> definir(ThemeMode modo) async {
    final texto = switch (modo) {
      ThemeMode.light => 'claro',
      ThemeMode.dark => 'escuro',
      ThemeMode.system => 'sistema',
    };
    await ref.read(repoConfigProvider).definir('tema', texto);
    state = AsyncData(modo);
  }
}

final temaModoProvider =
    AsyncNotifierProvider<TemaModo, ThemeMode>(TemaModo.new);

typedef Resumo = ({
  int receitas,
  int combos,
  int alimentos,
  String inicio,
  int tamanho,
});

final resumoProvider = FutureProvider<Resumo>((ref) async {
  final db = ref.watch(bancoProvider);
  final config = ref.watch(repoConfigProvider);

  return (
    receitas: (await db.select(db.receitas).get()).length,
    combos: (await db.select(db.combos).get()).length,
    alimentos: (await db.select(db.alimentos).get()).length,
    inicio: (await config.inicioCiclo()).iso,
    tamanho: await config.tamanhoCiclo(),
  );
});

final regrasPorcaoProvider =
    FutureProvider<Map<(SlotRefeicao, bool), int>>((ref) =>
        ref.watch(repoConfigProvider).regras());
```

- [ ] **Step 2: Escrever a tela**

`lib/presentation/ajustes/ajustes_screen.dart`:

```dart
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/backup.dart';
import '../../data/database_provider.dart';
import '../../domain/modelos.dart';
import '../format.dart';
import '../hoje/hoje_provider.dart';
import '../tema/cores.dart';
import '../tema/respingo.dart';
import 'ajustes_provider.dart';

class AjustesScreen extends ConsumerWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final resumo = ref.watch(resumoProvider);
    final regras = ref.watch(regrasPorcaoProvider);
    final modo = ref.watch(temaModoProvider).valueOrNull ?? ThemeMode.system;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          CampoRespingo(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.chevron_left, size: 19),
                      label: const Text('Voltar'),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          minimumSize: const Size(44, 44)),
                    ),
                  ],
                ),
                Text('Ajustes',
                    style: t.displaySmall?.copyWith(color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Grupo(titulo: 'O ciclo', children: [
                  resumo.maybeWhen(
                    data: (r) => _Linha(
                      titulo: 'Começou em',
                      nota: 'o dia 1 das receitas caiu aqui',
                      valor: DataPura(r.inicio).rotuloCurto,
                      onTap: () => _escolherInicio(context, ref, r.inicio),
                    ),
                    orElse: () => const _Linha(
                        titulo: 'Começou em', nota: '', valor: '…'),
                  ),
                  resumo.maybeWhen(
                    data: (r) => _Linha(
                      titulo: 'Tamanho do ciclo',
                      nota: 'volta pro dia 1 depois disso',
                      valor: '${r.tamanho} dias',
                    ),
                    orElse: () => const _Linha(
                        titulo: 'Tamanho do ciclo', nota: '', valor: '…'),
                  ),
                ]),

                _Grupo(titulo: 'Porções', children: [
                  regras.maybeWhen(
                    data: (m) => _TabelaPorcoes(regras: m),
                    orElse: () => const SizedBox(height: 40),
                  ),
                ]),

                _Grupo(titulo: 'Aparência', children: [
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                          value: ThemeMode.light, label: Text('Claro')),
                      ButtonSegment(
                          value: ThemeMode.dark, label: Text('Escuro')),
                      ButtonSegment(
                          value: ThemeMode.system, label: Text('Sistema')),
                    ],
                    selected: {modo},
                    onSelectionChanged: (s) =>
                        ref.read(temaModoProvider.notifier).definir(s.first),
                  ),
                ]),

                _Grupo(titulo: 'Seus dados', children: [
                  _Linha(
                    titulo: 'Exportar backup',
                    nota: 'um arquivo .json com tudo',
                    valor: '→',
                    onTap: () => _exportar(context, ref),
                  ),
                  _Linha(
                    titulo: 'Importar backup',
                    nota: 'substitui o que está no aparelho',
                    valor: '→',
                    onTap: () => _importar(context, ref),
                  ),
                ]),

                _Grupo(titulo: 'Sobre', children: [
                  resumo.maybeWhen(
                    data: (r) => _Linha(
                      titulo: 'No aparelho',
                      nota: '${r.receitas} receitas · ${r.combos} refeições · '
                          '${r.alimentos} alimentos',
                      valor: '',
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  const _Linha(
                    titulo: 'Funciona sem internet',
                    nota: 'nada sai do telefone',
                    valor: '✓',
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _escolherInicio(
      BuildContext context, WidgetRef ref, String atual) async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: DataPura(atual).comoDateTime,
      firstDate: DateTime.utc(2020),
      lastDate: DateTime.utc(2035),
      helpText: 'Quando o dia 1 do ciclo caiu',
    );
    if (escolhida == null) return;

    await ref
        .read(repoConfigProvider)
        .definir('data_inicio_ciclo', DataPura.de(escolhida).iso);
    ref.invalidate(resumoProvider);
    ref.invalidate(diaProvider);
  }

  Future<void> _exportar(BuildContext context, WidgetRef ref) async {
    final texto = await exportarJson(ref.read(bancoProvider));
    final pasta = await getTemporaryDirectory();
    final arquivo = File(p.join(pasta.path,
        'refeicoes-backup-${DataPura.de(DateTime.now()).iso}.json'));
    await arquivo.writeAsString(texto);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(arquivo.path)],
        text: 'Backup do app de refeições',
      ),
    );
  }

  Future<void> _importar(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Importar backup?'),
        content: const Text(
            'Tudo que está no aparelho é substituído pelo conteúdo do '
            'arquivo. Não tem como desfazer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Importar')),
        ],
      ),
    );
    if (ok != true) return;

    final escolha = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final caminho = escolha?.files.single.path;
    if (caminho == null) return;

    try {
      final texto = await File(caminho).readAsString();
      await importarJson(ref.read(bancoProvider), texto);
      ref.invalidate(resumoProvider);
      ref.invalidate(regrasPorcaoProvider);
      ref.invalidate(diaProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup importado.')));
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Não deu: $e')));
      }
    }
  }
}

class _Grupo extends StatelessWidget {
  final String titulo;
  final List<Widget> children;

  const _Grupo({required this.titulo, required this.children});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(titulo.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary)),
            ),
            ...children,
          ],
        ),
      );
}

class _Linha extends StatelessWidget {
  final String titulo;
  final String nota;
  final String valor;
  final VoidCallback? onTap;

  const _Linha({
    required this.titulo,
    required this.nota,
    required this.valor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    final corpo = Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: cores.linha),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(titulo,
                    style: t.bodyMedium?.copyWith(
                        fontVariations: const [FontVariation('wght', 700)])),
                if (nota.isNotEmpty)
                  Text(nota,
                      style: t.bodySmall?.copyWith(color: cores.ink3)),
              ],
            ),
          ),
          if (valor.isNotEmpty)
            Text(valor,
                style: t.labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );

    if (onTap == null) {
      return Padding(padding: const EdgeInsets.only(bottom: 5), child: corpo);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: corpo,
        ),
      ),
    );
  }
}

class _TabelaPorcoes extends StatelessWidget {
  final Map<(SlotRefeicao, bool), int> regras;
  const _TabelaPorcoes({required this.regras});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cores = context.esmalte;

    Widget celula(String texto, {bool cabecalho = false, Color? cor}) =>
        Expanded(
          child: Center(
            child: Text(
              texto,
              style: cabecalho
                  ? t.labelSmall?.copyWith(color: cores.ink3, fontSize: 8.5)
                  : t.titleMedium?.copyWith(color: cor),
            ),
          ),
        );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: cores.linha),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: cores.superficie2,
              border: Border(bottom: BorderSide(color: cores.linha)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('REFEIÇÃO',
                      style: t.labelSmall
                          ?.copyWith(color: cores.ink3, fontSize: 8.5)),
                ),
                celula('SEG–SEX', cabecalho: true),
                celula('SÁB–DOM', cabecalho: true),
              ],
            ),
          ),
          for (final slot in SlotRefeicao.values)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                border: slot == SlotRefeicao.jantar
                    ? null
                    : Border(bottom: BorderSide(color: cores.linha)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(rotuloSlot(slot),
                        style: t.bodyMedium?.copyWith(color: cores.ink2)),
                  ),
                  celula('${regras[(slot, true)] ?? 1}'),
                  celula('${regras[(slot, false)] ?? 1}', cor: cores.brasa),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Ligar o modo de tema no app**

Em `lib/app.dart`, dentro de `AppRefeicoes.build`, trocar o `MaterialApp` por:

```dart
    final modo = ref.watch(temaModoProvider).valueOrNull ?? ThemeMode.system;

    return MaterialApp(
      title: 'Refeições',
      debugShowCheckedModeBanner: false,
      theme: temaClaro(),
      darkTheme: temaEscuro(),
      themeMode: modo,
      home: const Casca(),
    );
```

E acrescentar o import:

```dart
import 'presentation/ajustes/ajustes_provider.dart';
```

- [ ] **Step 4: Escrever o teste**

`test/ajustes_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refeicoes_app/data/app_database.dart';
import 'package:refeicoes_app/data/repo_config.dart';
import 'package:refeicoes_app/presentation/ajustes/ajustes_provider.dart';
import 'package:refeicoes_app/presentation/ajustes/ajustes_screen.dart';

import 'util_teste.dart';

void main() {
  late AppDatabase db;

  setUp(() async => db = await bancoDeTeste());
  tearDown(() async => db.close());

  Future<void> abrir(WidgetTester tester) async {
    await tester.pumpWidget(envolver(const AjustesScreen(), db: db));
    await tester.pumpAndSettle();
  }

  testWidgets('mostra os quatro grupos', (tester) async {
    await abrir(tester);

    expect(find.text('O CICLO'), findsOneWidget);
    expect(find.text('PORÇÕES'), findsOneWidget);
    expect(find.text('APARÊNCIA'), findsOneWidget);
    expect(find.text('SEUS DADOS'), findsOneWidget);
    expect(find.text('SOBRE'), findsOneWidget);
  });

  testWidgets('tabela de porcoes traz os quatro horarios e as duas colunas',
      (tester) async {
    await abrir(tester);

    expect(find.text('SEG–SEX'), findsOneWidget);
    expect(find.text('SÁB–DOM'), findsOneWidget);
    expect(find.text('Café da manhã'), findsOneWidget);
    expect(find.text('Jantar'), findsOneWidget);
  });

  testWidgets('mostra o resumo do que esta no aparelho', (tester) async {
    await abrir(tester);

    expect(find.textContaining('24 receitas'), findsOneWidget);
    expect(find.textContaining('8 refeições'), findsOneWidget);
    expect(find.textContaining('40 alimentos'), findsOneWidget);
  });

  testWidgets('diz que funciona sem internet', (tester) async {
    await abrir(tester);
    expect(find.text('Funciona sem internet'), findsOneWidget);
    expect(find.text('nada sai do telefone'), findsOneWidget);
  });

  testWidgets('mostra o inicio e o tamanho do ciclo', (tester) async {
    await abrir(tester);

    expect(find.text('Começou em'), findsOneWidget);
    expect(find.text('01/09'), findsOneWidget);
    expect(find.text('4 dias'), findsOneWidget);
  });

  testWidgets('trocar aparencia persiste em config', (tester) async {
    await abrir(tester);

    await tester.tap(find.text('Escuro'));
    await tester.pumpAndSettle();

    expect(await RepoConfig(db).ler('tema'), 'escuro');
  });

  testWidgets('aparencia salva volta selecionada', (tester) async {
    await RepoConfig(db).definir('tema', 'claro');
    await abrir(tester);

    final botao = tester.widget<SegmentedButton<ThemeMode>>(
        find.byType(SegmentedButton<ThemeMode>));
    expect(botao.selected, {ThemeMode.light});
  });

  testWidgets('importar pede confirmacao antes de qualquer coisa',
      (tester) async {
    await abrir(tester);

    await tester.tap(find.text('Importar backup'));
    await tester.pumpAndSettle();

    expect(find.text('Importar backup?'), findsOneWidget);
    expect(find.textContaining('Não tem como desfazer'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(await db.select(db.alimentos).get(), hasLength(40));
  });

  testWidgets('renderiza no escuro sem estourar', (tester) async {
    await tester.pumpWidget(
        envolver(const AjustesScreen(), db: db, brilho: Brightness.dark));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
```

- [ ] **Step 5: Rodar e ver passar**

```bash
flutter test test/ajustes_screen_test.dart
flutter analyze
```

Esperado: 9 testes passando. Exportar não é testado por widget test — depende de
`share_plus` com canal de plataforma, que não existe na Dart VM. É verificado na
Task 23, no aparelho.

- [ ] **Step 6: Rodar a suíte inteira**

```bash
flutter test
flutter analyze
```

Esperado: tudo verde — aproximadamente 160 testes entre domínio, dados e widgets.

- [ ] **Step 7: Commit**

```bash
git add lib/presentation/ajustes/ lib/app.dart test/ajustes_screen_test.dart
git commit -m "feat(ui): tela de ajustes com porcoes, aparencia e backup"
```

- [ ] **Step 8: Checkpoint de APK — app funcionalmente completo**

```bash
flutter analyze && flutter test && flutter build apk --release
```

Avisar o Isac. Mensagem:

> APK em `build/app/outputs/flutter-apk/app-release.apk`. **Todas as 8 telas estão de pé.**
> **Olhe:**
> 1. `⋯` no canto de qualquer tela → Ajustes.
> 2. Tabela de porções: os quatro horários × dia útil / fim de semana, o fim de semana
>    em brasa. É a regra que você me passou, escrita na tela.
> 3. `Começou em` → mude a data de início do ciclo e volte para Hoje: **o dia do ciclo
>    inteiro recalcula**, sem migração e sem regenerar nada.
> 4. Aparência → **Escuro**. Tudo tem que continuar legível, inclusive o respingo do
>    cabeçalho. Feche e abra o app: a escolha persiste.
> 5. `Exportar backup` → o seletor do Android abre e o `.json` sai. Mande para você mesmo.
> 6. `Importar backup` pede confirmação **antes** de abrir o seletor.
>
> Estes dois são os que só dão para testar no aparelho, porque dependem de canal de
> plataforma — o teste de widget não os cobre.
> **Falta só:** o polimento de release da Task 23 (ícone, auditoria de permissão, e o
> roteiro de 12 verificações incluindo modo avião).

---

### Task 23: Polimento de release e verificação final

A assinatura, a keystore e o rótulo já foram feitos na **Task 1** (Steps 7–9), para
que os checkpoints de APK existissem desde a Task 15. Esta tarefa é só o que sobra:
ícone, auditoria de permissão e o roteiro completo no aparelho.

**Files:**
- Create: `assets/icone/icone.png` (1024×1024)
- Modify: `pubspec.yaml` (`flutter_launcher_icons`)
- Modify: `android/app/src/main/AndroidManifest.xml` (auditoria)

**Interfaces:**
- Consumes: todo o app
- Produces: `build/app/outputs/flutter-apk/app-release.apk` final, com ícone próprio

- [ ] **Step 1: Auditar o manifesto**

Confirmar, no `android/app/src/main/AndroidManifest.xml` de produção:

```bash
grep -n "uses-permission" android/app/src/main/AndroidManifest.xml
```

Esperado: **nenhuma linha**, ou só as que o Android exige implicitamente. Se houver
`android.permission.INTERNET` fora do bloco de debug, remover — o app não usa rede, e
permissão declarada que não se usa é mentira para quem instala.

Confirmar também que o rótulo ficou `android:label="Refeições"` desde a Task 1.

- [ ] **Step 2: Ícone próprio**

Sem ícone, o app fica com o Flutter azul na gaveta do celular dela — e ela vai abrir
isso todo dia. Gerar um PNG 1024×1024 na paleta Esmalte (campo marinho salpicado,
como o cabeçalho do app) em `assets/icone/icone.png`.

Em `pubspec.yaml`, na seção `dev_dependencies`, acrescentar:

```yaml
  flutter_launcher_icons: ^0.14.4
```

E no fim do arquivo, fora de `flutter:`:

```yaml
flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/icone/icone.png"
  adaptive_icon_background: "#14263F"
  adaptive_icon_foreground: "assets/icone/icone.png"
```

Gerar:

```bash
flutter pub get
dart run flutter_launcher_icons
```

- [ ] **Step 3: Build final limpo**

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build apk --release
```

Esperado: `Built build/app/outputs/flutter-apk/app-release.apk`. Se o Gradle
reclamar de versão de Java, o problema é o Java 8 no PATH — o Gradle precisa de
JDK 17+. Apontar para o JDK do Android Studio:

```bash
flutter config --jdk-dir "C:/Program Files/Android/Android Studio/jbr"
```

- [ ] **Step 4: Confirmar que a assinatura pegou**

```bash
"$ANDROID_HOME/build-tools/36.0.0/apksigner" verify --print-certs \
  build/app/outputs/flutter-apk/app-release.apk
```

Esperado: certificado listado, sem aviso de debug. Se apontar chave de debug, o
`key.properties` não foi lido — conferir o caminho de `storeFile`.

- [ ] **Step 5: Verificação final no aparelho**

Instalar no celular por USB ou copiando o APK. Roteiro mínimo, na ordem:

1. Abre no dia de hoje, com os quatro horários.
2. Café da tarde e jantar aparecem apagados, escrito "repete …, em dobro".
3. As porções batem: se hoje é dia de semana, 1 no café e no almoço, 2 à tarde e à noite.
4. Toca numa refeição: abre a receita com ingredientes, preparo e macros.
5. `Substituir` no almoço, escolhe outro combo: o jantar acompanha.
6. `Substituir` no jantar, escolhe outro: o almoço **não** muda.
7. Aba Mês: os dias trocados aparecem com ponto de brasa.
8. Aba Mercado: "esta semana" gera lista agrupada; marcar item risca e move a barra.
9. Aba Receitas: cria uma receita nova, salva, ela aparece no catálogo.
10. Ajustes → Exportar backup: o seletor do Android abre e o `.json` sai.
11. Ajustes → Aparência → Escuro: a tela vira e continua legível.
12. **Modo avião ligado, fecha e abre o app:** tudo funciona igual. Nenhuma tela de
    carregando infinito, nenhum erro de rede.

- [ ] **Step 6: Commit**

```bash
git add android/ assets/icone/ pubspec.yaml
git commit -m "chore(android): icone proprio e auditoria de permissoes"
```

Confirmar de novo que nenhum segredo entrou em nenhum commit do histórico:

```bash
git log --all --name-only --format= | sort -u | grep -E "key\.properties|\.jks|\.keystore" | wc -l
```

Esperado: `0`.

- [ ] **Step 7: Fechar as notas do vault**

Marcar as fases como concluídas em `~/obsidian/refeicoes-app/Roadmap.md` e criar a nota
de run em `~/obsidian/refeicoes-app/Runs/`, com o que quebrou no caminho e como foi
resolvido. É o que vai valer daqui a seis meses.

---

## Auto-revisão do plano

**1. Cobertura da spec.** Cada seção tem tarefa:

| Spec | Tarefa |
|---|---|
| 4 Arquitetura em três camadas | 1 (teste de trilhos vigia a fronteira) |
| 5.1 Alimentos e conversões | 10, 11 |
| 5.2 Receitas | 10, 11, 12 |
| 5.3 Combos e ciclo | 10, 11 |
| 5.4 Config e exceções | 10, 11, 12 |
| 5.5 Lista de mercado | 10, 12 |
| 6.1 Posição no ciclo | 3 |
| 6.2 Resolução do combo | 8 |
| 6.3 Resolução dos componentes | 8 |
| 6.4 Porções | 5 |
| 7 Escalonamento e arredondamento | 6 |
| 8 Nutrição, TACO, `a gosto` | 7, 11, 20 |
| 9 Lista de mercado | 9, 12, 19 |
| 10 Oito telas | 15–22 |
| 11 Sistema visual Esmalte | 14, 15 |
| 12 Semente e proteção do que ela editou | 11, 12, 21 |
| 13 Backup | 13, 22 |
| 14 Testes | todas (TDD) |
| 15 Distribuição | 23 |

**2. Varredura de lacunas.** Nenhum "TBD" ou "implementar depois". Três pontos onde
o plano manda criar tronco temporário (Tasks 15, 16, 20) declaram explicitamente
qual tarefa substitui cada um.

**3. Consistência de tipos.** Verificado nome a nome: `posicaoNoCiclo`,
`slotBase`/`tipoDoSlot`, `porcoesDoSlot`/`regrasPadrao`, `escalarQuantidade`,
`emGramas`/`nutrienteDe`/`ConversaoAusente`, `resolverRefeicao`,
`agregarMercado`/`formatarCompra`/`ordemSecoes`, `carregarSemente`,
`RepoPlano.dia`/`substituirCombo`/`substituirComponente`/`limparOverrides`/`diasEditados`,
`RepoReceitas.listar`/`porId`/`ingredientesDe`/`salvar`/`excluir`/`combosDoTipo`/`alimentos`,
`RepoMercado.gerar`/`itens`/`marcar`/`ultimaLista`, `exportarJson`/`importarJson`,
`CartaoEsmalte`, `CampoRespingo`, `abrirSubstituir`. Todos usados com a mesma
assinatura em que foram definidos.

**Duas correções aplicadas durante a revisão:**

- `conversoes.json` da Task 11 trazia `concha`, que não existe no enum `Unidade`. A
  tarefa manda apagar a linha em vez de inflar o enum — feijão se mede em grama.
- `RepoPlano.dia` da Task 12 dependia de posições do ciclo que a semente reduzida não
  tem. O teste do dia anterior ao início agora sobrescreve `tamanho_ciclo` para 4, e
  `util_teste.dart` faz o mesmo para todos os testes de widget.

---

## Plano 2 — o conteúdo completo

Fica de fora deste plano de propósito, e é o maior custo do projeto (spec seção 18).

Ao fim das 23 tarefas o app funciona de ponta a ponta com **4 dias** de ciclo. Para
chegar aos 33 falta produzir:

| Arquivo | Da Fase B | Alvo |
|---|---|---|
| `alimentos.json` | 40 | ~214 |
| `conversoes.json` | ~74 | ~120 |
| `receitas.json` | 24 | ~182 |
| `combos.json` | 8 | 66 |
| `ciclo.json` | 8 | 66 |

O caminho: mesmo formato, mesma carga idempotente, `versaoSemente` sobe para 2, e o
que ela já editou fica intacto. Nada de código novo — só conteúdo, mais os testes de
integridade que a Task 11 já escreveu (todo alimento com conversão de grama, todo
alimento por unidade com massa por unidade, todo JSON válido).

**Antes de gerar os 33 dias, vale sua esposa revisar os 4 primeiros no aparelho.** Se
o jeito dela de medir arroz ou temperar carne for diferente do meu chute, é mais
barato descobrir em 24 receitas do que em 182.

---

## Handoff de execução

Plano completo e salvo em `docs/superpowers/plans/2026-08-26-app-refeicoes.md`.
23 tarefas: 9 de domínio puro, 4 de dados, 9 de tela, 1 de build.
