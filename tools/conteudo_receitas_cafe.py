# -*- coding: utf-8 -*-
"""Receitas dos 33 cafes da manha.

Ingrediente referencia o alimento **por nome**, nunca por id — id errado passa
calado, nome errado estoura na geracao.

Agrupamento (a semente 1 ja tinha estabelecido isto em r9/r15/r21/r6): pao +
recheio viram UMA receita quando o recheio e o unico acompanhante; pao entra
sozinho quando ela o combina com um item quente separado. "Uma receita de cream
cheese" nao existe na cozinha dela.

Porcao base: 1 pessoa. O app escala para 2 no fim de semana.
"""

# nome, categoria, rende, tempo_min, preparo, [(alimento, qtd, unidade)]
CAFE = [
    # ------------------------------------------------------------- paes
    ("Pao frances", "pao", 1, 2,
     "Corte o pao ao meio.\nSirva ainda morno.",
     [("Pao frances", 1, "unidade")]),

    ("Pao frances na chapa", "pao", 1, 6,
     "Corte o pao ao meio e passe manteiga nas duas faces.\n"
     "Aqueca a frigideira e prense o pao com a face da manteiga para baixo.\n"
     "Tire quando estiver dourado e crocante.",
     [("Pao frances", 1, "unidade"), ("Manteiga com sal", 1, "colherCha")]),

    ("Pao frances com requeijao", "pao", 1, 3,
     "Corte o pao ao meio.\nEspalhe o requeijao ainda com o pao morno.",
     [("Pao frances", 1, "unidade"), ("Requeijao cremoso", 1, "colherSopa")]),

    ("Pao de forma", "pao", 1, 1,
     "Sirva as fatias como estao, ou passe rapidamente na chapa.",
     [("Pao de forma", 2, "fatia")]),

    ("Pao de forma com queijo", "pao", 1, 5,
     "Monte o sanduiche com o queijo entre as fatias.\n"
     "Aqueca na frigideira ou na sanduicheira ate o queijo derreter.",
     [("Pao de forma", 2, "fatia"), ("Queijo mucarela", 30, "g")]),

    ("Pao caseiro", "pao", 1, 2,
     "Corte duas fatias generosas.\nSirva com o miolo ainda macio.",
     [("Pao caseiro", 2, "fatia")]),

    ("Pao caseiro com polenguinho", "pao", 1, 3,
     "Corte as fatias e espalhe o queijo cremoso enquanto o pao esta morno.",
     [("Pao caseiro", 2, "fatia"), ("Queijo processado fatiado", 1, "unidade")]),

    ("Pao sirio", "pao", 1, 3,
     "Aqueca o pao sirio rapidamente na frigideira seca, so para amaciar.\n"
     "Corte em triangulos.",
     [("Pao sirio", 1, "unidade")]),

    ("Pao sirio com queijo", "pao", 1, 6,
     "Abra o pao sirio, ponha o queijo dentro.\n"
     "Aqueca na frigideira dos dois lados ate derreter.",
     [("Pao sirio", 1, "unidade"), ("Queijo mucarela", 40, "g")]),

    ("Pao de queijo", "pao", 1, 25,
     "Ponha os pes de queijo congelados em assadeira, sem untar.\n"
     "Asse em forno a 200 C por cerca de 25 minutos, ate crescerem e dourarem.\n"
     "Sirva quentes — frio ele endurece.",
     [("Pao de queijo cru", 100, "g")]),

    ("Torrada", "pao", 1, 4,
     "Torre as fatias na frigideira seca ou na torradeira, ate ficarem firmes.",
     [("Pao de forma", 2, "fatia")]),

    ("Torrada com requeijao", "pao", 1, 5,
     "Torre as fatias.\nEspalhe o requeijao com a torrada ainda quente.",
     [("Pao de forma", 2, "fatia"), ("Requeijao cremoso", 1, "colherSopa")]),

    ("Torrada com cream cheese", "pao", 1, 5,
     "Torre as fatias e deixe amornar um pouco.\n"
     "Espalhe o cream cheese — em torrada muito quente ele escorre.",
     [("Pao de forma", 2, "fatia"), ("Cream cheese", 30, "g")]),

    ("Torrada com geleia", "pao", 1, 5,
     "Torre as fatias.\nEspalhe a geleia por cima.",
     [("Pao de forma", 2, "fatia"), ("Geleia de morango", 1, "colherSopa")]),

    ("Torrada com queijo", "pao", 1, 6,
     "Torre as fatias.\nPonha o queijo por cima e volte ao fogo baixo, tampado, "
     "so ate derreter.",
     [("Pao de forma", 2, "fatia"), ("Queijo mucarela", 30, "g")]),

    ("Torrada com abacate", "pao", 1, 6,
     "Torre as fatias.\n"
     "Amasse o abacate com o garfo, tempere com sal e limao, e espalhe.",
     [("Pao de forma", 2, "fatia"), ("Abacate", 60, "g"),
      ("Limao taiti", 1, "colherCha"), ("Sal", 1, "pitada")]),

    # --------------------------------------------------------- bases e massas
    ("Cuscuz com manteiga", "base", 1, 12,
     "Umedeca o flocao com agua e sal e deixe descansar 10 minutos.\n"
     "Cozinhe na cuscuzeira por 8 minutos.\n"
     "Solte com o garfo e ponha a manteiga ainda quente.",
     [("Cuscuz de milho", 60, "g"), ("Manteiga com sal", 1, "colherCha"),
      ("Sal", 1, "pitada")]),

    ("Cuscuz com queijo coalho", "base", 1, 15,
     "Umedeca o flocao com agua e sal e deixe descansar 10 minutos.\n"
     "Cozinhe na cuscuzeira por 8 minutos.\n"
     "Grelhe o queijo coalho na frigideira e sirva sobre o cuscuz.",
     [("Cuscuz de milho", 60, "g"), ("Queijo coalho", 50, "g"),
      ("Sal", 1, "pitada")]),

    ("Tapioca com ovo", "base", 1, 8,
     "Espalhe a goma na frigideira quente e deixe firmar.\n"
     "Frite o ovo mexido a parte, tempere com sal.\n"
     "Ponha o ovo na tapioca e dobre.",
     [("Goma de tapioca", 60, "g"), ("Ovo de galinha cru", 1, "unidade"),
      ("Sal", 1, "pitada")]),

    ("Tapioca com frango desfiado", "base", 1, 10,
     "Espalhe a goma na frigideira quente e deixe firmar.\n"
     "Aqueca o frango ja cozido e desfiado com um fio de azeite.\n"
     "Recheie a tapioca e dobre.",
     [("Goma de tapioca", 60, "g"), ("Peito de frango cru", 70, "g"),
      ("Azeite de oliva", 1, "colherCha"), ("Sal", 1, "pitada")]),

    ("Crepioca com queijo", "base", 1, 8,
     "Bata o ovo com a goma e uma pitada de sal.\n"
     "Despeje na frigideira antiaderente quente e deixe firmar.\n"
     "Ponha o queijo, dobre e espere derreter.",
     [("Ovo de galinha cru", 1, "unidade"), ("Goma de tapioca", 30, "g"),
      ("Queijo mucarela", 30, "g"), ("Sal", 1, "pitada")]),

    ("Crepioca de frango", "base", 1, 12,
     "Bata o ovo com a goma e sal e faca a crepioca na frigideira.\n"
     "Recheie com o frango cozido e desfiado, temperado.\n"
     "Dobre e sirva quente.",
     [("Ovo de galinha cru", 1, "unidade"), ("Goma de tapioca", 30, "g"),
      ("Peito de frango cru", 70, "g"), ("Sal", 1, "pitada")]),

    ("Panqueca de banana", "base", 1, 12,
     "Amasse a banana e misture com o ovo e a aveia ate ficar homogeneo.\n"
     "Faca discos na frigideira antiaderente em fogo baixo.\n"
     "Vire quando soltar sozinho da frigideira.",
     [("Banana prata", 1, "unidade"), ("Ovo de galinha cru", 1, "unidade"),
      ("Aveia em flocos", 2, "colherSopa")]),

    ("Panqueca americana", "base", 1, 15,
     "Misture a farinha, o fermento, o acucar, o ovo e o leite ate ficar liso.\n"
     "Faca discos na frigideira untada, em fogo baixo.\n"
     "Vire quando aparecerem bolhas na superficie.",
     [("Farinha de trigo", 60, "g"), ("Leite integral", 80, "ml"),
      ("Ovo de galinha cru", 1, "unidade"), ("Acucar refinado", 1, "colherSopa"),
      ("Fermento em po", 1, "colherCha")]),

    ("Waffle com mel", "base", 1, 15,
     "Misture farinha, fermento, ovo, leite e manteiga derretida.\n"
     "Asse na maquina de waffle ate dourar.\n"
     "Regue com mel na hora de servir.",
     [("Farinha de trigo", 60, "g"), ("Leite integral", 80, "ml"),
      ("Ovo de galinha cru", 1, "unidade"), ("Manteiga com sal", 1, "colherSopa"),
      ("Fermento em po", 1, "colherCha"), ("Mel", 1, "colherSopa")]),

    ("Bolo de milho", "base", 6, 45,
     "Bata no liquidificador o fuba, o leite, os ovos, o acucar e o oleo.\n"
     "Junte o fermento por ultimo, misturando devagar.\n"
     "Asse em forma untada a 180 C por cerca de 40 minutos.",
     [("Fuba de milho", 200, "g"), ("Leite integral", 200, "ml"),
      ("Ovo de galinha cru", 3, "unidade"), ("Acucar refinado", 150, "g"),
      ("Oleo de soja", 80, "ml"), ("Fermento em po", 1, "colherSopa")]),

    # ---------------------------------------------------------- ovos
    ("Ovos mexidos", "proteina", 1, 6,
     "Bata os ovos com sal.\n"
     "Leve a frigideira com um fio de azeite em fogo baixo.\n"
     "Mexa devagar e desligue antes de secar — ovo mexido termina de cozinhar "
     "fora do fogo.",
     [("Ovo de galinha cru", 2, "unidade"), ("Azeite de oliva", 1, "colherCha"),
      ("Sal", 1, "pitada")]),

    ("Ovo cozido", "proteina", 1, 10,
     "Ponha o ovo em agua fria e leve ao fogo.\n"
     "Conte 8 minutos depois que a agua ferver.\n"
     "Passe em agua fria antes de descascar.",
     [("Ovo de galinha cru", 1, "unidade")]),

    ("Ovo frito", "proteina", 1, 5,
     "Aqueca a frigideira com um fio de azeite.\n"
     "Quebre o ovo e tempere com sal.\n"
     "Deixe a clara firmar mantendo a gema mole.",
     [("Ovo de galinha cru", 1, "unidade"), ("Azeite de oliva", 1, "colherCha"),
      ("Sal", 1, "pitada")]),

    ("Omelete simples", "proteina", 1, 8,
     "Bata os ovos com sal e cheiro-verde picado.\n"
     "Despeje na frigideira quente e untada.\n"
     "Quando firmar embaixo, dobre ao meio e desligue.",
     [("Ovo de galinha cru", 2, "unidade"), ("Azeite de oliva", 1, "colherCha"),
      ("Cheiro-verde", 1, "colherSopa"), ("Sal", 1, "pitada")]),

    ("Omelete de queijo", "proteina", 1, 9,
     "Bata os ovos com sal.\n"
     "Na frigideira untada, deixe firmar embaixo e espalhe o queijo.\n"
     "Dobre e espere o queijo derreter com o fogo desligado.",
     [("Ovo de galinha cru", 2, "unidade"), ("Queijo mucarela", 40, "g"),
      ("Azeite de oliva", 1, "colherCha"), ("Sal", 1, "pitada")]),

    # ---------------------------------------------------------- sanduiches
    ("Sanduiche natural", "pao", 1, 10,
     "Misture o frango desfiado com requeijao, cenoura ralada e milho.\n"
     "Tempere com sal e recheie as fatias de pao.\n"
     "Embale apertado se for levar — o recheio assenta e corta melhor.",
     [("Pao de forma integral", 2, "fatia"), ("Peito de frango cru", 60, "g"),
      ("Requeijao cremoso", 1, "colherSopa"), ("Cenoura crua", 30, "g"),
      ("Milho verde em conserva", 20, "g"), ("Sal", 1, "pitada")]),

    ("Sanduiche de pate de atum", "pao", 1, 8,
     "Escorra bem o atum e amasse com o garfo.\n"
     "Misture com maionese, cebola picada miuda e limao.\n"
     "Recheie as fatias de pao.",
     [("Pao de forma", 2, "fatia"), ("Atum em conserva", 60, "g"),
      ("Maionese", 1, "colherSopa"), ("Cebola crua", 20, "g"),
      ("Limao taiti", 1, "colherCha"), ("Sal", 1, "pitada")]),

    # ---------------------------------------------------------- bebidas
    ("Vitamina de banana com aveia", "bebida", 1, 5,
     "Bata no liquidificador a banana, o leite e a aveia.\n"
     "Sirva na hora — a aveia engrossa se esperar.",
     [("Banana prata", 1, "unidade"), ("Leite integral", 200, "ml"),
      ("Aveia em flocos", 2, "colherSopa")]),

    ("Suco natural", "bebida", 1, 5,
     "Bata a fruta com agua gelada e coe se preferir.\n"
     "Adoce so se precisar.",
     [("Suco de laranja integral", 200, "ml")]),

    # ---------------------------------------------------------- frutas e laticinios
    ("Maca", "fruta", 1, 1,
     "Lave bem e sirva inteira, ou em fatias com casca.",
     [("Maca fuji", 130, "g")]),

    ("Fruta picada", "fruta", 1, 5,
     "Corte as frutas em cubos e sirva geladas.\n"
     "Um fio de limao segura a cor da banana.",
     [("Maca fuji", 80, "g"), ("Banana prata", 1, "unidade"),
      ("Limao taiti", 1, "colherCha")]),

    ("Iogurte natural", "bebida", 1, 1,
     "Sirva gelado. Se quiser, um fio de mel por cima.",
     [("Iogurte natural integral", 170, "g")]),
]
