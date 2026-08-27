# -*- coding: utf-8 -*-
"""Proteinas e massas das 33 refeicoes.

Porcao base: 1 pessoa. Carne e frango ficam em 120 g crus por porcao — rende
cerca de 90 g depois de cozidos, que e a porcao que ela come.

Massa em 80 g crua por porcao. Prato onde a massa substitui o arroz (refeicoes
5, 10, 15, 20, 25, 30) leva 100 g.
"""

# nome, categoria, rende, tempo_min, preparo, [(alimento, qtd, unidade)]
PROTEINA = [
    # ------------------------------------------------------------ carne
    ("Carne com molho de alho", "proteina", 1, 20,
     "Corte a carne em tiras e tempere com sal.\n"
     "Sele em fogo alto, sem mexer, para dourar.\n"
     "Baixe o fogo, junte o alho fatiado e deixe perfumar sem queimar.",
     [("Coxao mole cru", 120, "g"), ("Alho cru", 3, "dente"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Almondegas no molho", "proteina", 1, 35,
     "Misture a carne moida com ovo, farinha de rosca, cebola e sal.\n"
     "Enrole bolinhas e doure na frigideira.\n"
     "Junte o molho de tomate e cozinhe tampado por 15 minutos.",
     [("Carne moida acem crua", 120, "g"), ("Ovo de galinha cru", 1, "unidade"),
      ("Farinha de rosca", 2, "colherSopa"), ("Cebola crua", 40, "g"),
      ("Molho de tomate pronto", 100, "g"), ("Sal", 1, "aGosto")]),

    ("Carne de panela com batata", "proteina", 1, 70,
     "Sele a carne em cubos na panela de pressao, em fogo alto.\n"
     "Junte cebola, alho, sal e agua ate cobrir; cozinhe 25 minutos na pressao.\n"
     "Abra, ponha a batata em cubos e cozinhe mais 10 minutos sem pressao.",
     [("Musculo cru", 120, "g"), ("Batata inglesa crua", 150, "g"),
      ("Cebola crua", 50, "g"), ("Alho cru", 2, "dente"),
      ("Oleo de soja", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Quibe assado", "proteina", 1, 50,
     "Hidrate o trigo em agua por 30 minutos e esprema bem.\n"
     "Misture com a carne moida, cebola, hortela e sal.\n"
     "Espalhe na assadeira, risque em losangos, regue com azeite e asse a "
     "200 C por 35 minutos.",
     [("Trigo para quibe", 60, "g"), ("Carne moida acem crua", 120, "g"),
      ("Cebola crua", 40, "g"), ("Azeite de oliva", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Strogonoff de carne", "proteina", 1, 25,
     "Sele a carne em tiras em fogo alto e reserve.\n"
     "Refogue cebola, junte o extrato de tomate e a mostarda.\n"
     "Volte a carne, desligue o fogo e so entao misture o creme de leite — "
     "fervendo, ele talha.",
     [("Patinho cru", 120, "g"), ("Creme de leite", 60, "g"),
      ("Extrato de tomate", 1, "colherSopa"), ("Mostarda", 1, "colherCha"),
      ("Cebola crua", 40, "g"), ("Sal", 1, "aGosto")]),

    ("Panqueca de carne", "proteina", 1, 30,
     "Bata a massa com farinha, leite, ovo e sal e faca os discos finos.\n"
     "Refogue a carne moida com cebola e extrato de tomate.\n"
     "Recheie, enrole e cubra com molho de tomate.",
     [("Farinha de trigo", 50, "g"), ("Leite integral", 100, "ml"),
      ("Ovo de galinha cru", 1, "unidade"),
      ("Carne moida acem crua", 100, "g"), ("Cebola crua", 30, "g"),
      ("Molho de tomate pronto", 80, "g"), ("Sal", 1, "aGosto")]),

    ("Bife a parmegiana", "proteina", 1, 30,
     "Tempere o bife, passe na farinha, no ovo e na farinha de rosca.\n"
     "Frite em oleo quente ate dourar dos dois lados.\n"
     "Cubra com molho de tomate e queijo e leve ao forno so ate gratinar.",
     [("Patinho cru", 120, "g"), ("Ovo de galinha cru", 1, "unidade"),
      ("Farinha de rosca", 3, "colherSopa"), ("Farinha de trigo", 1, "colherSopa"),
      ("Molho de tomate pronto", 80, "g"), ("Queijo mucarela", 40, "g"),
      ("Oleo de soja", 2, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Torta salgada de carne", "proteina", 1, 55,
     "Refogue a carne moida com cebola, alho e extrato de tomate e deixe esfriar.\n"
     "Bata no liquidificador leite, oleo, ovos, farinha e fermento.\n"
     "Ponha metade da massa, o recheio, o resto da massa, e asse a 180 C por "
     "40 minutos.",
     [("Carne moida acem crua", 100, "g"), ("Farinha de trigo", 80, "g"),
      ("Leite integral", 100, "ml"), ("Ovo de galinha cru", 1, "unidade"),
      ("Oleo de soja", 2, "colherSopa"), ("Cebola crua", 30, "g"),
      ("Fermento em po", 1, "colherCha"), ("Sal", 1, "aGosto")]),

    ("Carne desfiada na pressao", "proteina", 1, 50,
     "Sele a carne inteira na pressao com um fio de oleo.\n"
     "Junte cebola, alho, sal e agua pela metade; 30 minutos na pressao.\n"
     "Desfie com dois garfos ainda quente e volte ao caldo para pegar gosto.",
     [("Acem cru", 120, "g"), ("Cebola crua", 40, "g"),
      ("Alho cru", 2, "dente"), ("Oleo de soja", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Rocambole de carne moida", "proteina", 1, 55,
     "Misture a carne moida com ovo, farinha de rosca e sal e abra num retangulo.\n"
     "Distribua o queijo, enrole com ajuda do papel e sele as pontas.\n"
     "Asse a 200 C por 40 minutos, regando com o proprio caldo.",
     [("Carne moida acem crua", 120, "g"), ("Ovo de galinha cru", 1, "unidade"),
      ("Farinha de rosca", 2, "colherSopa"), ("Queijo mucarela", 40, "g"),
      ("Sal", 1, "aGosto")]),

    ("Iscas de carne com alho e manteiga", "proteina", 1, 18,
     "Corte a carne em iscas finas e seque com papel — carne umida cozinha em "
     "vez de dourar.\n"
     "Sele em fogo alto na manteiga, em duas etapas para nao esfriar a panela.\n"
     "Junte o alho no fim e desligue.",
     [("Coxao mole cru", 120, "g"), ("Manteiga com sal", 1, "colherSopa"),
      ("Alho cru", 3, "dente"), ("Sal", 1, "aGosto")]),

    ("Pastel de carne", "proteina", 1, 35,
     "Refogue a carne moida com cebola, alho e sal, e deixe esfriar.\n"
     "Recheie os discos de massa e feche apertando com o garfo.\n"
     "Frite em oleo quente ate dourar, ou asse a 200 C por 20 minutos.",
     [("Carne moida acem crua", 100, "g"), ("Farinha de trigo", 80, "g"),
      ("Cebola crua", 30, "g"), ("Alho cru", 1, "dente"),
      ("Oleo de soja", 3, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Carne empanada", "proteina", 1, 25,
     "Tempere a carne em bifes finos com sal e limao.\n"
     "Passe na farinha, no ovo batido e na farinha de rosca, apertando bem.\n"
     "Frite em oleo quente — oleo morno encharca o empanado.",
     [("Patinho cru", 120, "g"), ("Ovo de galinha cru", 1, "unidade"),
      ("Farinha de rosca", 3, "colherSopa"), ("Farinha de trigo", 1, "colherSopa"),
      ("Oleo de soja", 3, "colherSopa"), ("Limao taiti", 1, "colherCha"),
      ("Sal", 1, "aGosto")]),

    ("Hamburguer caseiro", "proteina", 1, 20,
     "Tempere a carne moida so com sal e modele o disco sem apertar demais.\n"
     "Grelhe em fogo alto 3 minutos de cada lado, prensando so na primeira "
     "virada.\n"
     "Monte no pao com o queijo por cima da carne quente.",
     [("Carne moida patinho crua", 130, "g"), ("Pao de forma", 2, "fatia"),
      ("Queijo mucarela", 30, "g"), ("Sal", 1, "aGosto")]),

    ("Carne com creme de cebola", "proteina", 1, 30,
     "Sele a carne em cubos e reserve.\n"
     "Dissolva o creme de cebola em agua morna e leve a panela com a carne.\n"
     "Cozinhe tampado em fogo baixo ate engrossar.",
     [("Patinho cru", 120, "g"), ("Creme de cebola em po", 20, "g"),
      ("Oleo de soja", 1, "colherSopa")]),

    ("Carne com molho de mostarda", "proteina", 1, 25,
     "Sele a carne em medalhoes e reserve.\n"
     "Na mesma panela, junte mostarda, creme de leite e um pouco de agua.\n"
     "Volte a carne e cozinhe em fogo baixo por 10 minutos.",
     [("Coxao mole cru", 120, "g"), ("Mostarda", 1, "colherSopa"),
      ("Creme de leite", 50, "g"), ("Azeite de oliva", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Carne oriental estilo yakisoba", "proteina", 1, 25,
     "Corte a carne em tiras finas e marine no shoyu com alho por 15 minutos.\n"
     "Sele em fogo bem alto, em pouca quantidade por vez.\n"
     "Junte cenoura e repolho em tiras e mexa so 2 minutos — o legume fica "
     "crocante.",
     [("Coxao mole cru", 120, "g"), ("Molho shoyu", 2, "colherSopa"),
      ("Cenoura crua", 50, "g"), ("Repolho branco cru", 60, "g"),
      ("Alho cru", 2, "dente"), ("Oleo de soja", 1, "colherSopa")]),

    # ------------------------------------------------------------ frango
    ("Frango desfiado temperado", "proteina", 1, 35,
     "Cozinhe o peito com sal, alho e cebola por 25 minutos.\n"
     "Desfie ainda quente.\n"
     "Volte a frigideira com um pouco do caldo e extrato de tomate.",
     [("Peito de frango cru", 120, "g"), ("Cebola crua", 40, "g"),
      ("Alho cru", 2, "dente"), ("Extrato de tomate", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Frango refogado com legumes", "proteina", 1, 30,
     "Corte o frango em cubos e sele com alho.\n"
     "Junte batata e cenoura em cubos e agua ate a metade.\n"
     "Cozinhe tampado ate o legume ficar macio e o caldo encorpar.",
     [("Peito de frango cru", 120, "g"), ("Batata inglesa crua", 120, "g"),
      ("Cenoura crua", 60, "g"), ("Alho cru", 2, "dente"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Frango acebolado", "proteina", 1, 22,
     "Tempere o file com sal e limao e grelhe dos dois lados.\n"
     "Retire o frango e refogue a cebola em rodelas na mesma frigideira.\n"
     "Devolva o frango e cubra com a cebola.",
     [("File de frango cru", 120, "g"), ("Cebola crua", 60, "g"),
      ("Limao taiti", 1, "colherCha"), ("Azeite de oliva", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Frango cozido com batata", "proteina", 1, 40,
     "Doure as coxas com sal e alho.\n"
     "Junte agua e cozinhe tampado por 20 minutos.\n"
     "Ponha a batata em cubos e cozinhe mais 15 minutos, destampado no fim "
     "para reduzir o caldo.",
     [("Coxa de frango crua", 130, "g"), ("Batata inglesa crua", 150, "g"),
      ("Alho cru", 2, "dente"), ("Cebola crua", 40, "g"),
      ("Oleo de soja", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Fricasse de frango", "proteina", 1, 35,
     "Refogue o frango desfiado com cebola e alho.\n"
     "Misture creme de leite, milho e requeijao e leve ao refratario.\n"
     "Cubra com queijo e batata palha e gratine a 200 C por 15 minutos.",
     [("Peito de frango cru", 120, "g"), ("Creme de leite", 60, "g"),
      ("Milho verde em conserva", 40, "g"), ("Requeijao cremoso", 1, "colherSopa"),
      ("Queijo mucarela", 40, "g"), ("Cebola crua", 30, "g"),
      ("Sal", 1, "aGosto")]),

    ("Lasanha de frango", "proteina", 1, 55,
     "Refogue o frango desfiado com molho de tomate.\n"
     "Monte camadas de massa, frango, requeijao e queijo.\n"
     "Cubra com papel e asse a 180 C por 35 minutos; tire o papel nos ultimos "
     "10 para dourar.",
     [("Peito de frango cru", 110, "g"), ("Macarrao parafuso cru", 70, "g"),
      ("Molho de tomate pronto", 120, "g"), ("Queijo mucarela", 50, "g"),
      ("Requeijao cremoso", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Frango assado com batata", "proteina", 1, 55,
     "Tempere as coxas com sal, alho e limao e deixe 20 minutos.\n"
     "Ponha na assadeira com a batata em cubos e regue com azeite.\n"
     "Asse a 200 C por 40 minutos, virando na metade.",
     [("Coxa de frango crua", 130, "g"), ("Batata inglesa crua", 150, "g"),
      ("Alho cru", 3, "dente"), ("Limao taiti", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Frango com creme de milho", "proteina", 1, 30,
     "Sele o frango em cubos com alho e sal.\n"
     "Bata metade do milho com o leite e junte a panela.\n"
     "Ponha o resto do milho inteiro e cozinhe ate engrossar.",
     [("Peito de frango cru", 120, "g"), ("Milho verde em conserva", 100, "g"),
      ("Leite integral", 80, "ml"), ("Alho cru", 2, "dente"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Panqueca de frango", "proteina", 1, 30,
     "Faca os discos de massa com farinha, leite, ovo e sal.\n"
     "Recheie com frango desfiado refogado com requeijao.\n"
     "Enrole e cubra com molho de tomate.",
     [("Farinha de trigo", 50, "g"), ("Leite integral", 100, "ml"),
      ("Ovo de galinha cru", 1, "unidade"), ("Peito de frango cru", 100, "g"),
      ("Requeijao cremoso", 1, "colherSopa"),
      ("Molho de tomate pronto", 80, "g"), ("Sal", 1, "aGosto")]),

    ("Empadao de frango", "proteina", 1, 60,
     "Faca a massa com farinha, manteiga, ovo e sal e leve a geladeira.\n"
     "Refogue o frango desfiado com cebola, milho e requeijao.\n"
     "Forre a forma, recheie, cubra com massa e asse a 190 C por 40 minutos.",
     [("Farinha de trigo", 100, "g"), ("Manteiga com sal", 2, "colherSopa"),
      ("Ovo de galinha cru", 1, "unidade"), ("Peito de frango cru", 110, "g"),
      ("Milho verde em conserva", 40, "g"), ("Requeijao cremoso", 1, "colherSopa"),
      ("Cebola crua", 30, "g"), ("Sal", 1, "aGosto")]),

    ("Frango com mostarda e mel", "proteina", 1, 30,
     "Tempere o file com sal e grelhe dos dois lados.\n"
     "Misture mostarda, mel e um pouco de agua e ponha na frigideira.\n"
     "Deixe reduzir virando o frango, ate o molho brilhar e agarrar na carne.",
     [("File de frango cru", 120, "g"), ("Mostarda", 1, "colherSopa"),
      ("Mel", 1, "colherSopa"), ("Azeite de oliva", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    # ------------------------------------------------------------ massas
    ("Macarrao a bolonhesa", "base", 1, 30,
     "Refogue a carne moida com cebola e alho ate secar a agua.\n"
     "Junte o molho de tomate e cozinhe 15 minutos em fogo baixo.\n"
     "Cozinhe a massa al dente e misture com o molho na propria panela.",
     [("Macarrao espaguete cru", 100, "g"), ("Carne moida acem crua", 100, "g"),
      ("Molho de tomate pronto", 150, "g"), ("Cebola crua", 40, "g"),
      ("Alho cru", 2, "dente"), ("Azeite de oliva", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Macarrao com molho branco", "base", 1, 25,
     "Derreta a manteiga, junte a farinha e mexa 1 minuto.\n"
     "Acrescente o leite frio de uma vez, mexendo sem parar ate engrossar.\n"
     "Tempere com sal e misture a massa cozida.",
     [("Macarrao parafuso cru", 100, "g"), ("Leite integral", 200, "ml"),
      ("Manteiga com sal", 1, "colherSopa"), ("Farinha de trigo", 1, "colherSopa"),
      ("Queijo parmesao ralado", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Macarrao alho e oleo", "base", 1, 20,
     "Doure o alho fatiado no azeite em fogo baixo — alho queimado amarga o "
     "prato todo.\n"
     "Reserve um pouco da agua do cozimento.\n"
     "Misture a massa com o azeite e um pouco dessa agua, que liga o molho.",
     [("Macarrao espaguete cru", 100, "g"), ("Alho cru", 4, "dente"),
      ("Azeite de oliva", 2, "colherSopa"), ("Cheiro-verde", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Macarrao com molho pesto", "base", 1, 18,
     "Cozinhe a massa al dente e reserve um pouco da agua.\n"
     "Misture o pesto fora do fogo, com a massa ainda quente.\n"
     "Ajuste com a agua do cozimento ate ficar cremoso.",
     [("Macarrao parafuso cru", 100, "g"), ("Molho pesto", 2, "colherSopa"),
      ("Queijo parmesao ralado", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Macarrao com molho de alho", "base", 1, 20,
     "Doure bastante alho no azeite com a manteiga, em fogo baixo.\n"
     "Junte a massa cozida e a agua do cozimento.\n"
     "Finalize com parmesao fora do fogo.",
     [("Macarrao parafuso cru", 100, "g"), ("Alho cru", 5, "dente"),
      ("Azeite de oliva", 1, "colherSopa"), ("Manteiga com sal", 1, "colherSopa"),
      ("Queijo parmesao ralado", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Macarrao vermelho", "base", 1, 22,
     "Refogue alho e cebola no azeite.\n"
     "Junte o molho de tomate e deixe apurar 10 minutos.\n"
     "Misture a massa cozida e finalize com manjericao.",
     [("Macarrao parafuso cru", 100, "g"), ("Molho de tomate pronto", 150, "g"),
      ("Alho cru", 2, "dente"), ("Cebola crua", 30, "g"),
      ("Azeite de oliva", 1, "colherSopa"), ("Manjericao fresco", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),
]
