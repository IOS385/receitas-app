# -*- coding: utf-8 -*-
"""Gera os cinco JSONs de `assets/semente/` para os 33 dias do plano dela.

Os JSONs sao a fonte de verdade do app; este script existe para o mapeamento
"texto original dela -> combos" ficar auditavel, e para poder regerar quando o
plano dela mudar. Rodar:

    python tools/gerar_semente.py

O que ele preserva do que ja existe:

- **ids de alimento e receita** dos 40/24 primeiros. Id que muda apaga o vinculo
  com o que ela editou no app (`origem = 'usuario'`).
- **conversoes ja gravadas**, com o valor que estao. Inclusive o azeite com 8 g
  por colher de sopa, que e decisao de conteudo pendente dele — este script nao
  a toma por conta.

Depois de rodar: **suba `versaoSemente`** em `lib/data/database_provider.dart` e
registre a impressao nova em `test/semente_versao_test.dart`, senao o app dela
nunca recarrega. Ver Bugs/foto-nao-aparece-em-app-atualizado no vault.
"""
import json
import os
import sys
import unicodedata

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SEM = os.path.join(RAIZ, 'assets', 'semente')
sys.path.insert(0, os.path.join(RAIZ, 'tools'))

from conteudo_alimentos import NOVOS as ALIMENTOS_NOVOS          # noqa: E402
from conteudo_receitas_cafe import CAFE                          # noqa: E402
from conteudo_receitas_proteina import PROTEINA                  # noqa: E402
from conteudo_receitas_vegetal import VEGETAL, SALADA            # noqa: E402

RECEITAS_NOVAS = CAFE + PROTEINA + VEGETAL + SALADA


# --------------------------------------------------------------- os 66 combos
#
# Escrito por extenso, um combo por linha, na ordem dos dias dela. Nome de
# receita, nunca id — id errado passa calado.
#
# Onde ela escreveu duas coisas que se comem juntas ("Pao francês + manteiga"),
# vale o agrupamento que a semente 1 ja usava: uma receita so. Onde o
# acompanhante e um item quente separado ("Pao caseiro + omelete simples"), sao
# duas receitas.

CAFES = {
    1:  ["Pao frances com manteiga", "Leite com achocolatado", "Banana"],
    2:  ["Pao de forma com ovo mexido", "Suco de laranja"],
    3:  ["Cuscuz com ovo cozido", "Leite com achocolatado"],
    4:  ["Tapioca com queijo coalho", "Mamao", "Suco de uva"],
    5:  ["Pao de queijo", "Iogurte natural", "Maca"],
    6:  ["Panqueca de banana", "Suco natural"],
    7:  ["Pao caseiro", "Omelete simples", "Suco natural"],
    8:  ["Torrada com abacate", "Ovo cozido"],
    9:  ["Bolo de milho", "Fruta picada", "Suco natural"],
    10: ["Crepioca com queijo", "Suco natural"],
    11: ["Vitamina de banana com aveia", "Torrada com requeijao"],
    12: ["Tapioca com frango desfiado", "Suco natural"],
    13: ["Pao sirio com queijo", "Iogurte natural"],
    14: ["Ovos mexidos", "Batata-doce cozida e amassada", "Leite com achocolatado"],
    15: ["Waffle com mel", "Fruta picada"],
    16: ["Pao frances com requeijao", "Leite com achocolatado"],
    17: ["Cuscuz com queijo coalho", "Suco natural"],
    18: ["Panqueca americana", "Fruta picada"],
    19: ["Torrada com geleia", "Iogurte natural"],
    20: ["Tapioca com ovo", "Fruta picada"],
    21: ["Pao de forma com queijo", "Leite com achocolatado"],
    22: ["Sanduiche natural", "Suco natural"],
    23: ["Crepioca de frango", "Suco natural"],
    24: ["Pao caseiro com polenguinho", "Fruta picada"],
    25: ["Pao de queijo", "Leite com achocolatado"],
    26: ["Pao frances", "Omelete de queijo"],
    27: ["Torrada com cream cheese", "Leite com achocolatado"],
    28: ["Pao de forma", "Ovo frito", "Leite com achocolatado"],
    29: ["Sanduiche de pate de atum", "Suco natural"],
    30: ["Ovos mexidos", "Pao sirio"],
    31: ["Cuscuz com manteiga", "Suco natural"],
    32: ["Torrada com queijo", "Fruta picada"],
    33: ["Pao frances na chapa", "Fruta picada", "Leite com achocolatado"],
}

# Nome curto do combo, para o cartao. O nome longo dela nao cabe em 282 dp.
NOMES_CAFE = {
    1: "Pao frances, manteiga, leite com achocolatado e banana",
    2: "Pao de forma com ovo mexido e suco de laranja",
    3: "Cuscuz com ovo cozido e leite com achocolatado",
    4: "Tapioca com queijo, mamao e suco de uva",
    5: "Pao de queijo, iogurte natural e maca",
    6: "Panqueca de banana com suco",
    7: "Pao caseiro, omelete simples e suco",
    8: "Torrada com abacate e ovo cozido",
    9: "Bolo de milho, fruta e suco",
    10: "Crepioca com queijo e suco",
    11: "Vitamina de banana com aveia e torrada com requeijao",
    12: "Tapioca com frango desfiado e suco",
    13: "Pao sirio com queijo e iogurte",
    14: "Ovos mexidos, batata-doce e leite com achocolatado",
    15: "Waffle com mel e frutas",
    16: "Pao frances com requeijao e achocolatado",
    17: "Cuscuz com queijo coalho e suco",
    18: "Panqueca americana com frutas",
    19: "Torrada com geleia e iogurte",
    20: "Tapioca com ovo e fruta",
    21: "Pao de forma com queijo e leite com achocolatado",
    22: "Sanduiche natural com suco",
    23: "Crepioca de frango com suco",
    24: "Pao caseiro com polenguinho e frutas",
    25: "Pao de queijo com leite com achocolatado",
    26: "Pao frances com omelete de queijo",
    27: "Torrada com cream cheese e leite com achocolatado",
    28: "Pao de forma, ovo frito e leite com achocolatado",
    29: "Sanduiche de pate de atum com suco",
    30: "Ovos mexidos com pao sirio",
    31: "Cuscuz com manteiga e suco",
    32: "Torrada com queijo e fruta",
    33: "Pao frances na chapa, fruta e leite com achocolatado",
}

ARROZ, FEIJAO, PRETO = "Arroz branco", "Feijao carioca", "Feijao preto"

REFEICOES = {
    1:  [ARROZ, FEIJAO, "Bife acebolado", "Cenoura cozida com manteiga",
         "Alface, tomate e cebola roxa com molho de azeite e limao"],
    2:  [ARROZ, "Carne moida refogada tradicional", PRETO,
         "Abobrinha refogada com alho",
         "Alface, cenoura ralada e milho com molho de iogurte"],
    3:  [ARROZ, FEIJAO, "Frango grelhado simples", "Chuchu refogado com cebola",
         "Rucula, tomate-cereja e parmesao com molho balsamico"],
    4:  [ARROZ, FEIJAO, "Picadinho de carne com legumes",
         "Batata-doce cozida e amassada",
         "Alface americana e pepino com molho de mostarda e mel"],
    5:  ["Macarrao a bolonhesa", "Abobora cabotia cozida com sal",
         "Repolho roxo, cenoura e maca com molho de iogurte e mel"],
    6:  [ARROZ, FEIJAO, "Frango desfiado temperado", "Brocolis cozido com azeite",
         "Mix de folhas e manga com molho de laranja"],
    7:  [ARROZ, FEIJAO, "Carne com molho de alho",
         "Couve-flor cozida e temperada com limao",
         "Alface, beterraba ralada e nozes com molho de limao e azeite"],
    8:  [ARROZ, FEIJAO, "Almondegas no molho", "Beterraba cozida em cubos",
         "Rucula, pera e gorgonzola com molho balsamico e mel"],
    9:  [ARROZ, FEIJAO, "Frango refogado com legumes",
         "Grao-de-bico, tomate e cebola com molho de limao, azeite e alho"],
    10: ["Carne de panela com batata", "Macarrao com molho branco",
         "Milho refogado com cebola",
         "Lentilha, cenoura e cheiro-verde com vinagrete"],
    11: [ARROZ, "Quibe assado", PRETO, "Legumes assados no forno",
         "Quinoa, pepino e tomate com molho de limao siciliano"],
    12: [ARROZ, FEIJAO, "Frango acebolado", "Abobora assada com alho",
         "Alface e milho com molho caesar light"],
    13: [ARROZ, FEIJAO, "Strogonoff de carne", "Batata-doce assada em palitos",
         "Alface, atum e cebola com molho de limao e azeite"],
    14: [ARROZ, FEIJAO, "Panqueca de carne", "Abobrinha assada com queijo",
         "Espinafre, ovo cozido e tomate com molho de mostarda"],
    15: ["Frango cozido com batata", "Macarrao alho e oleo",
         "Couve-flor assada com paprica",
         "Couve crua, laranja e castanha com molho citrico"],
    16: [ARROZ, FEIJAO, "Bife a parmegiana", "Tomate cereja assado com oregano",
         "Repolho branco, pepino e gergelim com molho shoyu"],
    17: [ARROZ, FEIJAO, "Torta salgada de carne", "Pimentao assado com cebola",
         "Alface e manga com molho de mostarda e mel"],
    18: [ARROZ, FEIJAO, "Fricasse de frango", "Pure de batata com cenoura",
         "Rucula, tomate cereja e mucarela com molho pesto"],
    19: [ARROZ, "Carne desfiada na pressao", PRETO, "Creme de abobora",
         "Tomate, cebola e pepino com vinagrete tradicional"],
    20: ["Rocambole de carne moida", "Macarrao com molho pesto",
         "Cenoura cozida com manteiga", "Caprese com azeite e balsamico"],
    21: [ARROZ, FEIJAO, "Lasanha de frango", "Abobrinha refogada com alho",
         "Alface, abacate e tomate com molho de limao"],
    22: [ARROZ, FEIJAO, "Iscas de carne com alho e manteiga",
         "Chuchu refogado com cebola",
         "Espinafre, morango e amendoas com molho balsamico"],
    23: [ARROZ, FEIJAO, "Pastel de carne", "Batata-doce cozida e amassada",
         "Beterraba cozida e cebola roxa com molho de vinagre de maca"],
    24: [ARROZ, FEIJAO, "Frango assado com batata",
         "Abobora cabotia cozida com sal",
         "Cenoura ralada e passas com molho de limao e mel"],
    25: ["Carne empanada", "Macarrao com molho de alho",
         "Brocolis cozido com azeite",
         "Pepino agridoce com molho de vinagre e acucar"],
    26: ["Hamburguer caseiro",
         "Alface, tomate e pepino com molho de azeite, limao e ervas"],
    27: [ARROZ, FEIJAO, "Frango com creme de milho",
         "Couve-flor cozida e temperada com limao",
         "Alface, cenoura e beterraba com molho rose light"],
    # Ela escreveu feijao E feijao preto no mesmo prato. Mantido fiel ao texto
    # dela e ao nome da foto; ela tira o componente no app se foi engano.
    28: [ARROZ, FEIJAO, "Carne com creme de cebola", PRETO,
         "Beterraba cozida em cubos",
         "Rucula, abacate e tomate com molho de limao siciliano"],
    29: [ARROZ, FEIJAO, "Panqueca de frango", "Milho refogado com cebola",
         "Repolho roxo e abacaxi com molho agridoce"],
    30: ["Carne com molho de mostarda", "Macarrao vermelho",
         "Tomate cereja assado com oregano",
         "Alface, manga e abacate com molho citrico"],
    31: [ARROZ, FEIJAO, "Empadao de frango", "Legumes assados no forno",
         "Tomate assado e ricota com molho de ervas"],
    32: [ARROZ, FEIJAO, "Carne oriental estilo yakisoba",
         "Abobora assada com alho",
         "Cenoura, pepino e gergelim com molho oriental"],
    33: [ARROZ, FEIJAO, "Frango com mostarda e mel",
         "Batata-doce assada em palitos",
         "Alface e croutons com molho caesar"],
}

NOMES_REFEICAO = {
    1: "Bife acebolado com arroz, feijao, cenoura e salada",
    2: "Carne moida com arroz, feijao preto, abobrinha e salada",
    3: "Frango grelhado com arroz, feijao, chuchu e rucula",
    4: "Picadinho de carne com arroz, feijao, batata-doce e salada",
    5: "Macarrao a bolonhesa com abobora e salada de repolho",
    6: "Frango desfiado com arroz, feijao, brocolis e salada de manga",
    7: "Carne ao alho com arroz, feijao, couve-flor e salada",
    8: "Almondegas com arroz, feijao, beterraba e salada de pera",
    9: "Frango com legumes, arroz, feijao e salada de grao-de-bico",
    10: "Carne de panela com macarrao branco, milho e salada de lentilha",
    11: "Quibe assado com arroz, feijao preto, legumes e salada de quinoa",
    12: "Frango acebolado com arroz, feijao, abobora e salada",
    13: "Strogonoff com arroz, feijao, batata-doce e salada de atum",
    14: "Panqueca de carne com arroz, feijao, abobrinha e salada",
    15: "Frango com batata, macarrao alho e oleo, couve-flor e salada de couve",
    16: "Bife a parmegiana com arroz, feijao, tomate assado e salada",
    17: "Torta de carne com arroz, feijao, pimentao e salada de manga",
    18: "Fricasse de frango com arroz, feijao, pure e salada",
    19: "Carne desfiada com arroz, feijao preto, creme de abobora e vinagrete",
    20: "Rocambole com macarrao ao pesto, cenoura e caprese",
    21: "Lasanha de frango com arroz, feijao, abobrinha e salada",
    22: "Iscas de carne com arroz, feijao, chuchu e salada de morango",
    23: "Pastel de carne com arroz, feijao, batata-doce e beterraba",
    24: "Frango assado com arroz, feijao, abobora e salada de cenoura",
    25: "Carne empanada com macarrao ao alho, brocolis e pepino agridoce",
    26: "Hamburguer caseiro com salada",
    27: "Frango com creme de milho, arroz, feijao, couve-flor e salada",
    28: "Carne ao creme de cebola com arroz, feijoes, beterraba e salada",
    29: "Panqueca de frango com arroz, feijao, milho e salada de abacaxi",
    30: "Carne a mostarda com macarrao vermelho, tomate assado e salada",
    31: "Empadao de frango com arroz, feijao, legumes e tomate com ricota",
    32: "Carne oriental com arroz, feijao, abobora e salada de gergelim",
    33: "Frango com mostarda e mel, arroz, feijao, batata-doce e caesar",
}


# ------------------------------------------------------------------ conversoes
#
# Gramas por colher de sopa. `colherCha` sai daqui dividido por 3 quando nao
# tiver valor proprio. Pares ja gravados em conversoes.json nao sao tocados —
# inclusive o azeite com 8 g, que e decisao de conteudo dele.

COLHER_SOPA = {
    "Manteiga com sal": 14, "Requeijao cremoso": 20, "Cream cheese": 15,
    "Geleia de morango": 20, "Mostarda": 16, "Molho pesto": 16,
    "Molho shoyu": 16, "Vinagre de alcool": 15, "Vinagre de maca": 15,
    "Vinagre balsamico": 16, "Farinha de trigo": 9, "Farinha de rosca": 12,
    "Aveia em flocos": 9, "Acucar refinado": 12, "Oleo de soja": 13,
    "Fermento em po": 12, "Amido de milho": 9, "Extrato de tomate": 17,
    "Queijo parmesao ralado": 6, "Iogurte natural integral": 18,
    "Cheiro-verde": 4, "Manjericao fresco": 3, "Limao taiti": 15,
    "Suco de laranja integral": 15, "Maionese": 14, "Gergelim em graos": 9,
    "Paprica doce": 7, "Oregano seco": 2, "Mel": 21, "Azeite de oliva": 8,
}

UNIDADE_G = {
    "Pao frances": 50, "Pao sirio": 60, "Ovo de galinha cru": 50,
    "Banana prata": 90, "Queijo processado fatiado": 17,
}

FATIA_G = {
    "Pao de forma": 25, "Pao de forma integral": 25, "Pao caseiro": 35,
}

DENTE_G = {"Alho cru": 3}
PITADA_G = {"Sal": 0.4, "Oregano seco": 0.2}

# Gramas de UM item comprado, para alimento com `compra = unidade`. E o que a
# lista de mercado usa para dizer "2 un" em vez de "480 g" — sem isto ela cai
# para grama e a lista fica inutil na feira. Um pao de forma sao 400 g: o pacote
# inteiro, nao a fatia.
COMPRA_UNIDADE_G = {
    "Couve-flor crua": 600, "Couve manteiga crua": 250, "Espinafre cru": 200,
    "Repolho branco cru": 900, "Repolho roxo cru": 800, "Abacaxi": 1200,
    "Cheiro-verde": 60, "Manjericao fresco": 30, "Mix de folhas": 150,
    "Alface crespa crua": 300, "Atum em conserva": 170, "Creme de leite": 200,
    "Pao caseiro": 500, "Pao de forma integral": 400,
    "Molho de tomate pronto": 340, "Molho pesto": 190,
    "Geleia de morango": 300, "Creme de cebola em po": 68,
    "Croutons": 100, "Maionese": 500,
}


def ascii_puro(s):
    return unicodedata.normalize('NFKD', s).encode('ascii', 'ignore').decode()


def carregar(nome):
    with open(os.path.join(SEM, nome), encoding='utf-8') as f:
        return json.load(f)


def gravar(nome, dados):
    with open(os.path.join(SEM, nome), 'w', encoding='utf-8', newline='\n') as f:
        f.write(json.dumps(dados, ensure_ascii=False, indent=2) + '\n')


def main():
    erros = []

    # ---------------------------------------------------------- alimentos
    alimentos = carregar('alimentos.json')
    por_nome = {a['nome']: a['id'] for a in alimentos}
    proximo = max(a['id'] for a in alimentos) + 1

    for (nome, taco, kcal, carb, prot, gord, fibra, sodio, secao, compra) \
            in ALIMENTOS_NOVOS:
        if nome in por_nome:
            continue
        alimentos.append({
            'id': proximo, 'nome': nome, 'taco': taco, 'kcal': kcal,
            'carb': carb, 'prot': prot, 'gord': gord, 'fibra': fibra,
            'sodio': sodio, 'secao': secao, 'compra': compra,
        })
        por_nome[nome] = proximo
        proximo += 1

    # ---------------------------------------------------------- receitas
    receitas = carregar('receitas.json')
    rec_por_nome = {r['nome']: r['id'] for r in receitas}
    proximo_r = max(r['id'] for r in receitas) + 1

    for (nome, cat, rende, tempo, preparo, ings) in RECEITAS_NOVAS:
        if nome in rec_por_nome:
            erros.append(f'receita duplicada: {nome}')
            continue
        linhas = []
        for (al, qtd, un) in ings:
            if al not in por_nome:
                erros.append(f'receita "{nome}": alimento desconhecido "{al}"')
                continue
            linhas.append({'alimento': por_nome[al], 'quantidade': qtd,
                           'unidade': un})
        receitas.append({
            'id': proximo_r, 'nome': nome, 'categoria': cat, 'rende': rende,
            'tempo': tempo, 'preparo': preparo, 'ingredientes': linhas,
        })
        rec_por_nome[nome] = proximo_r
        proximo_r += 1

    # ---------------------------------------------------------- conversoes
    conversoes = carregar('conversoes.json')
    ja = {(c['alimento'], c['unidade']) for c in conversoes}

    usadas = set()
    for r in receitas:
        for i in r['ingredientes']:
            usadas.add((i['alimento'], i['unidade']))

    # Dois pares que NENHUMA receita pede, e que o app precisa de todo jeito:
    #
    # - `g` para todo alimento, senao a nutricao dele sai zero calada. Ja houve
    #   um bug assim ("painel de macros mostrava zero em silencio").
    # - `unidade` para todo alimento comprado por unidade, senao a lista de
    #   mercado cai para grama e ela nao sabe quantos comprar.
    #
    # A semente 3 nasceu violando os dois; os testes de integridade pegaram.
    for a in alimentos:
        usadas.add((a['id'], 'g'))
        if a['compra'] == 'litro':
            usadas.add((a['id'], 'ml'))
        if a['compra'] == 'unidade':
            usadas.add((a['id'], 'unidade'))

    id_para_nome = {a['id']: a['nome'] for a in alimentos}
    for (aid, un) in sorted(usadas):
        if (aid, un) in ja:
            continue                       # valor existente nao se mexe
        nome = id_para_nome[aid]
        if un in ('g', 'ml'):
            g = 1.0
        elif un == 'aGosto':
            g = 0.0
        elif un == 'pitada':
            g = PITADA_G.get(nome, 0.4)
        elif un == 'dente':
            g = DENTE_G.get(nome)
        elif un == 'fatia':
            g = FATIA_G.get(nome)
        elif un == 'unidade':
            g = UNIDADE_G.get(nome) or COMPRA_UNIDADE_G.get(nome)
        elif un == 'colherSopa':
            g = COLHER_SOPA.get(nome)
        elif un == 'colherCha':
            g = COLHER_SOPA.get(nome)
            g = round(g / 3, 1) if g else None
        else:
            g = None
        if g is None:
            erros.append(f'sem conversao para ({nome}, {un})')
            continue
        conversoes.append({'alimento': aid, 'unidade': un, 'gramas': g})
        ja.add((aid, un))

    # ---------------------------------------------------------- combos e ciclo
    combos, ciclo = [], []
    cid = 0
    for tipo, mapa, nomes in (('cafe', CAFES, NOMES_CAFE),
                              ('refeicao', REFEICOES, NOMES_REFEICAO)):
        for pos in range(1, 34):
            cid += 1
            faltando = [n for n in mapa[pos] if n not in rec_por_nome]
            for n in faltando:
                erros.append(f'combo {tipo}-{pos}: receita inexistente "{n}"')
            combos.append({
                'id': cid,
                'nome': ascii_puro(nomes[pos]),
                'tipo': tipo,
                'foto': f'assets/pratos/combo-{cid:02d}.jpg',
                'receitas': [rec_por_nome[n] for n in mapa[pos]
                             if n in rec_por_nome],
            })
            ciclo.append({'posicao': pos, 'tipo': tipo, 'combo': cid})

    usados_por_receita = {i['alimento'] for r in receitas
                          for i in r['ingredientes']}
    orfaos = [a['nome'] for a in alimentos
              if a['id'] not in usados_por_receita]
    if orfaos:
        erros.append(f'{len(orfaos)} alimento(s) que nenhuma receita usa, '
                     f'peso morto na lista dela: {", ".join(orfaos)}')

    if erros:
        print(f'{len(erros)} ERRO(S) — nada foi gravado:')
        for e in erros[:40]:
            print(f'  {e}')
        return 1

    gravar('alimentos.json', alimentos)
    gravar('receitas.json', receitas)
    gravar('conversoes.json', conversoes)
    gravar('combos.json', combos)
    gravar('ciclo.json', ciclo)

    print(f'alimentos  {len(alimentos)}')
    print(f'receitas   {len(receitas)}')
    print(f'conversoes {len(conversoes)}')
    print(f'combos     {len(combos)}')
    print(f'ciclo      {len(ciclo)}  ({len(ciclo)//2} posicoes x 2 tipos)')
    print()
    print('AGORA: suba versaoSemente e registre a impressao nova no teste.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
