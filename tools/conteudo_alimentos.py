# -*- coding: utf-8 -*-
"""Alimentos novos da semente 3. Valores por 100 g, convencao da tabela TACO.

Nomes sem acento e com sufixo de estado (cru/cozido) igual aos 40 primeiros —
TACO trata "Cenoura crua" e "Cenoura cozida" como entradas distintas, e a lista
de mercado mostra esse nome. Ver a pendencia 3 do COMO-TESTAR.md.

`taco` e o codigo quando conhecido, senao None. Valor sem codigo e estimativa
informada e entra na revisao de conteudo com ela.
"""

# nome, taco, kcal, carb, prot, gord, fibra, sodio, secao, compra
NOVOS = [
    # ---------------------------------------------------------- hortifruti
    ("Manga palmer",              "C0158",  72,  19.2,  0.4,   0.2,  1.6,    1, "hortifruti", "kg"),
    ("Abacate",                   "C0111",  96,   6.0,  1.2,   8.4,  6.3,    1, "hortifruti", "kg"),
    ("Beterraba crua",            "C0181",  49,  11.1,  1.9,   0.1,  3.4,   33, "hortifruti", "kg"),
    ("Brocolis cru",              "C0187",  25,   4.4,  3.6,   0.3,  2.9,    6, "hortifruti", "kg"),
    ("Couve-flor crua",           "C0201",  23,   4.5,  1.9,   0.2,  2.4,    6, "hortifruti", "unidade"),
    ("Couve manteiga crua",       "C0199",  27,   4.3,  2.9,   0.5,  3.1,   10, "hortifruti", "unidade"),
    ("Espinafre cru",             "C0210",  16,   2.6,  2.0,   0.3,  2.1,   60, "hortifruti", "unidade"),
    ("Repolho branco cru",        "C0221",  25,   5.8,  1.0,   0.1,  1.9,    6, "hortifruti", "unidade"),
    ("Repolho roxo cru",          "C0222",  31,   7.2,  1.5,   0.2,  2.0,   12, "hortifruti", "unidade"),
    ("Abacaxi",                   "C0107",  48,  12.3,  0.9,   0.1,  1.0,    1, "hortifruti", "unidade"),
    ("Pera williams",             "C0166",  53,  14.0,  0.6,   0.1,  3.0,    1, "hortifruti", "kg"),
    ("Maca fuji",                 "C0155",  56,  15.2,  0.3,   0.0,  1.3,    1, "hortifruti", "kg"),
    ("Morango",                   "C0161",  30,   6.8,  0.9,   0.3,  1.7,    1, "hortifruti", "kg"),
    ("Abobora cabotia crua",      "C0179",  48,  12.9,  1.4,   0.1,  2.5,    1, "hortifruti", "kg"),
    ("Pimentao verde cru",        "C0218",  21,   4.9,  1.1,   0.2,  2.6,    2, "hortifruti", "kg"),
    ("Cheiro-verde",              None,     32,   5.6,  2.6,   0.4,  3.3,   34, "hortifruti", "unidade"),
    ("Manjericao fresco",         None,     23,   2.6,  3.2,   0.6,  1.6,    4, "hortifruti", "unidade"),
    ("Cebola roxa crua",          "C0196",  39,   8.9,  1.7,   0.1,  2.2,    1, "hortifruti", "kg"),
    ("Tomate italiano cru",       "C0229",  15,   3.1,  1.1,   0.2,  1.2,    1, "hortifruti", "kg"),
    ("Mix de folhas",             None,     17,   2.9,  1.4,   0.3,  1.8,   12, "hortifruti", "unidade"),
    ("Alface crespa crua",        "C0175",  11,   1.7,  1.3,   0.2,  1.8,    7, "hortifruti", "unidade"),

    # ------------------------------------------------------------- acougue
    ("Coxao mole cru",            "C0044", 132,   0.0, 21.4,   4.5,  0.0,   51, "acougue", "kg"),
    ("Acem cru",                  "C0035", 155,   0.0, 20.0,   7.7,  0.0,   55, "acougue", "kg"),
    ("Musculo cru",               "C0060", 120,   0.0, 21.0,   3.4,  0.0,   50, "acougue", "kg"),
    ("Peito de frango cru",       "C0086", 159,   0.0, 21.5,   7.6,  0.0,   51, "acougue", "kg"),
    ("Coxa de frango crua",       "C0083", 120,   0.0, 17.1,   5.4,  0.0,   78, "acougue", "kg"),
    ("Carne moida patinho crua",  "C0064", 133,   0.0, 21.6,   4.5,  0.0,   51, "acougue", "kg"),
    ("Atum em conserva",          "C0100", 166,   0.0, 26.0,   6.3,  0.0,  320, "mercearia", "unidade"),

    # ---------------------------------------------------------- laticinios
    ("Queijo mucarela",           "C0402", 330,   3.0, 25.0,  25.0,  0.0,  580, "laticinios", "kg"),
    ("Requeijao cremoso",         "C0405", 257,   3.0,  9.6,  23.0,  0.0,  500, "laticinios", "kg"),
    ("Cream cheese",              None,    253,   4.1,  5.9,  24.0,  0.0,  380, "laticinios", "kg"),
    ("Queijo processado fatiado", None,    290,   4.0, 17.0,  23.0,  0.0,  900, "laticinios", "unidade"),
    ("Queijo gorgonzola",         None,    353,   2.3, 21.4,  28.7,  0.0, 1395, "laticinios", "kg"),
    ("Ricota",                    "C0406", 140,   3.8, 12.6,   8.1,  0.0,   62, "laticinios", "kg"),
    ("Creme de leite",            "C0389", 214,   4.4,  2.3,  21.0,  0.0,   30, "laticinios", "unidade"),
    ("Queijo parmesao ralado",    None,    453,   1.7, 35.6,  33.5,  0.0, 1800, "laticinios", "kg"),

    # ------------------------------------------------------------- padaria
    ("Pao sirio",                 None,    275,  55.0,  9.1,   1.2,  2.2,  536, "padaria", "unidade"),
    ("Pao de queijo cru",         None,    315,  38.0,  5.5,  15.0,  0.8,  480, "congelados", "kg"),
    ("Pao caseiro",               None,    282,  53.0,  8.5,   3.4,  2.4,  480, "padaria", "unidade"),
    ("Pao de forma integral",     "C0313", 253,  49.9,  9.4,   3.7,  6.9,  505, "padaria", "unidade"),

    # ----------------------------------------------------------- mercearia
    ("Macarrao parafuso cru",     "C0292", 371,  77.9, 10.0,   1.3,  2.9,    5, "mercearia", "kg"),
    ("Macarrao espaguete cru",    "C0291", 371,  77.9, 10.0,   1.3,  2.9,    5, "mercearia", "kg"),
    ("Farinha de trigo",          "C0286", 360,  75.1,  9.8,   1.4,  2.3,    1, "mercearia", "kg"),
    ("Fuba de milho",             "C0263", 353,  78.9,  7.2,   1.5,  5.5,    1, "mercearia", "kg"),
    ("Aveia em flocos",           "C0255", 394,  66.6, 13.9,   8.5,  9.1,    5, "mercearia", "kg"),
    ("Quinoa em graos crua",      None,    368,  64.2, 14.1,   6.1,  7.0,    5, "mercearia", "kg"),
    ("Lentilha crua",             "C0140", 339,  62.0, 23.0,   0.8, 10.7,    6, "mercearia", "kg"),
    ("Grao-de-bico cru",          "C0138", 355,  57.9, 21.2,   5.4, 12.4,   24, "mercearia", "kg"),
    ("Trigo para quibe",          "C0301", 360,  74.0, 11.9,   1.5,  8.0,    2, "mercearia", "kg"),
    ("Molho de tomate pronto",    None,     45,   8.0,  1.3,   0.9,  1.4,  480, "mercearia", "unidade"),
    ("Molho pesto",               None,    420,   6.0,  5.0,  42.0,  2.0,  900, "mercearia", "unidade"),
    ("Molho shoyu",               None,     53,   4.9,  6.0,   0.1,  0.8, 5500, "mercearia", "litro"),
    ("Vinagre de maca",           None,     21,   0.9,  0.0,   0.0,  0.0,    5, "mercearia", "litro"),
    ("Vinagre de alcool",         None,     18,   0.6,  0.0,   0.0,  0.0,    2, "mercearia", "litro"),
    ("Acucar refinado",           "C0308", 387,  99.5,  0.0,   0.0,  0.0,    1, "mercearia", "kg"),
    ("Oleo de soja",              "C0270", 884,   0.0,  0.0, 100.0,  0.0,    0, "mercearia", "litro"),
    ("Gergelim em graos",         "C0136", 584,  21.6, 21.2,  50.4, 11.9,   11, "mercearia", "kg"),
    ("Castanha de caju",          "C0124", 570,  29.1, 18.5,  46.3,  3.7,   16, "mercearia", "kg"),
    ("Nozes",                     "C0130", 620,  18.4, 14.0,  59.4,  6.7,    2, "mercearia", "kg"),
    ("Amendoas",                  "C0117", 581,  19.5, 21.6,  47.3, 11.6,    1, "mercearia", "kg"),
    ("Uva passa",                 "C0172", 299,  79.5,  3.1,   0.5,  3.7,   11, "mercearia", "kg"),
    ("Geleia de morango",         None,    257,  63.0,  0.4,   0.1,  0.8,   30, "mercearia", "unidade"),
    ("Farinha de rosca",          None,    366,  72.0, 12.0,   4.0,  4.0,  700, "mercearia", "kg"),
    ("Fermento em po",            None,    100,  25.0,  0.0,   0.0,  0.0, 8000, "mercearia", "kg"),
    ("Creme de cebola em po",     None,    320,  55.0,  8.0,   7.0,  3.0, 6500, "mercearia", "unidade"),
    ("Paprica doce",              None,    282,  54.0, 14.1,  12.9, 34.9,   68, "mercearia", "kg"),
    ("Oregano seco",              None,    306,  64.4,  9.0,  10.3, 42.5,   15, "mercearia", "kg"),
    ("Croutons",                  None,    407,  73.0, 11.0,   7.0,  4.0,  700, "mercearia", "unidade"),
    ("Maionese",                  None,    680,   1.5,  1.0,  75.0,  0.0,  640, "mercearia", "unidade"),

    # ------------------------------------------------------------- bebidas
    ("Suco de laranja integral",  "C0159",  37,   8.7,  0.7,   0.1,  0.2,    1, "bebidas", "litro"),
]
