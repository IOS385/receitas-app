# -*- coding: utf-8 -*-
"""Vegetais e saladas das 33 refeicoes.

Cada salada e UMA receita, com o molho dentro dela — foi como ela escreveu
("Alface, tomate e cebola roxa - molho de azeite, limao e sal") e e como se come.
Molho separado obrigaria a compor dois componentes para cada salada, dobrando a
lista sem ganho nenhum.

Porcao base: 1 pessoa.
"""

# nome, categoria, rende, tempo_min, preparo, [(alimento, qtd, unidade)]
VEGETAL = [
    ("Abobora cabotia cozida com sal", "vegetal", 1, 20,
     "Corte a abobora em cubos grandes, com casca.\n"
     "Cozinhe em agua com sal por 15 minutos, ate o garfo entrar sem esforco.\n"
     "Escorra bem — abobora guarda agua e aguada o prato.",
     [("Abobora cabotia crua", 150, "g"), ("Sal", 1, "aGosto")]),

    ("Brocolis cozido com azeite", "vegetal", 1, 12,
     "Separe os buques e cozinhe em agua com sal por 5 minutos.\n"
     "Passe em agua fria na hora — e o que mantem o verde.\n"
     "Tempere com azeite e alho fatiado.",
     [("Brocolis cru", 120, "g"), ("Azeite de oliva", 1, "colherSopa"),
      ("Alho cru", 1, "dente"), ("Sal", 1, "aGosto")]),

    ("Couve-flor cozida e temperada com limao", "vegetal", 1, 15,
     "Cozinhe os buques em agua com sal por 8 minutos.\n"
     "Escorra e tempere ainda quente com azeite, limao e sal.",
     [("Couve-flor crua", 130, "g"), ("Limao taiti", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Couve-flor assada com paprica", "vegetal", 1, 35,
     "Corte a couve-flor em fatias grossas e seque bem.\n"
     "Tempere com azeite, paprica e sal e espalhe na assadeira sem empilhar.\n"
     "Asse a 210 C por 25 minutos, virando na metade.",
     [("Couve-flor crua", 130, "g"), ("Paprica doce", 1, "colherCha"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Beterraba cozida em cubos", "vegetal", 1, 40,
     "Cozinhe a beterraba inteira com casca por 30 minutos.\n"
     "Descasque morna — a casca sai com a mao.\n"
     "Corte em cubos e tempere com azeite e sal.",
     [("Beterraba crua", 130, "g"), ("Azeite de oliva", 1, "colherCha"),
      ("Sal", 1, "aGosto")]),

    ("Milho refogado com cebola", "vegetal", 1, 12,
     "Escorra o milho.\n"
     "Refogue a cebola picada na manteiga ate ficar transparente.\n"
     "Junte o milho e deixe pegar cor, mexendo pouco.",
     [("Milho verde em conserva", 130, "g"), ("Cebola crua", 40, "g"),
      ("Manteiga com sal", 1, "colherCha"), ("Sal", 1, "aGosto")]),

    ("Legumes assados no forno", "vegetal", 1, 45,
     "Corte batata, cenoura e cebola em pedacos parecidos — tamanho desigual "
     "assa desigual.\n"
     "Tempere com azeite, sal e alho e espalhe em camada unica.\n"
     "Asse a 200 C por 35 minutos, mexendo uma vez.",
     [("Batata inglesa crua", 120, "g"), ("Cenoura crua", 80, "g"),
      ("Cebola crua", 60, "g"), ("Alho cru", 2, "dente"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Abobora assada com alho", "vegetal", 1, 40,
     "Corte a abobora em fatias e disponha na assadeira.\n"
     "Regue com azeite e espalhe o alho picado e o sal.\n"
     "Asse a 200 C por 30 minutos, ate as bordas caramelizarem.",
     [("Abobora cabotia crua", 150, "g"), ("Alho cru", 2, "dente"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Batata-doce assada em palitos", "vegetal", 1, 40,
     "Corte em palitos de espessura parecida e seque com papel.\n"
     "Misture com azeite e sal e espalhe sem encostar um no outro.\n"
     "Asse a 210 C por 30 minutos, virando na metade.",
     [("Batata-doce crua", 150, "g"), ("Azeite de oliva", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Abobrinha assada com queijo", "vegetal", 1, 30,
     "Corte a abobrinha em rodelas grossas e tempere com azeite e sal.\n"
     "Asse a 200 C por 20 minutos.\n"
     "Ponha o queijo por cima e volte ao forno so ate gratinar.",
     [("Abobrinha italiana crua", 140, "g"), ("Queijo mucarela", 40, "g"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Tomate cereja assado com oregano", "vegetal", 1, 25,
     "Espalhe os tomates inteiros na assadeira.\n"
     "Regue com azeite e polvilhe oregano e sal.\n"
     "Asse a 200 C por 18 minutos, ate a pele estourar.",
     [("Tomate cereja", 130, "g"), ("Oregano seco", 1, "colherCha"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Pimentao assado com cebola", "vegetal", 1, 35,
     "Corte pimentao e cebola em tiras largas.\n"
     "Tempere com azeite e sal e espalhe na assadeira.\n"
     "Asse a 210 C por 25 minutos, ate as pontas escurecerem.",
     [("Pimentao verde cru", 120, "g"), ("Cebola crua", 60, "g"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Creme de abobora", "vegetal", 1, 30,
     "Cozinhe a abobora com cebola e alho em agua que cubra pela metade.\n"
     "Bata com o proprio caldo ate ficar liso.\n"
     "Volte ao fogo, ajuste o sal e termine com um fio de azeite.",
     [("Abobora cabotia crua", 180, "g"), ("Cebola crua", 40, "g"),
      ("Alho cru", 1, "dente"), ("Azeite de oliva", 1, "colherCha"),
      ("Sal", 1, "aGosto")]),

    ("Pure de batata com cenoura", "vegetal", 1, 30,
     "Cozinhe batata e cenoura em agua com sal ate ficarem bem macias.\n"
     "Amasse ainda quentes, sem processador — batido demais vira cola.\n"
     "Junte leite e manteiga aos poucos, ate o ponto.",
     [("Batata inglesa crua", 150, "g"), ("Cenoura crua", 60, "g"),
      ("Leite integral", 60, "ml"), ("Manteiga com sal", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),
]

SALADA = [
    ("Repolho roxo, cenoura e maca com molho de iogurte e mel", "salada", 1, 12,
     "Fatie o repolho bem fino e rale a cenoura.\n"
     "Corte a maca em cubos e misture com limao para nao escurecer.\n"
     "Misture o iogurte com mel e sal e tempere na hora de servir.",
     [("Repolho roxo cru", 80, "g"), ("Cenoura crua", 50, "g"),
      ("Maca fuji", 60, "g"), ("Iogurte natural integral", 2, "colherSopa"),
      ("Mel", 1, "colherCha"), ("Limao taiti", 1, "colherCha"),
      ("Sal", 1, "aGosto")]),

    ("Mix de folhas e manga com molho de laranja", "salada", 1, 10,
     "Lave e seque bem as folhas — folha molhada nao pega molho.\n"
     "Corte a manga em cubos.\n"
     "Bata o suco de laranja com azeite e sal e regue no prato.",
     [("Mix de folhas", 60, "g"), ("Manga palmer", 80, "g"),
      ("Suco de laranja integral", 2, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Alface, beterraba ralada e nozes com molho de limao e azeite", "salada", 1, 12,
     "Rale a beterraba crua na parte grossa do ralador.\n"
     "Monte sobre a alface rasgada e espalhe as nozes picadas.\n"
     "Tempere com limao, azeite e sal.",
     [("Alface crespa crua", 60, "g"), ("Beterraba crua", 60, "g"),
      ("Nozes", 15, "g"), ("Limao taiti", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Rucula, pera e gorgonzola com molho balsamico e mel", "salada", 1, 10,
     "Corte a pera em fatias finas, com casca.\n"
     "Monte a rucula, a pera e o gorgonzola esfarelado.\n"
     "Misture balsamico com mel e azeite e regue por cima.",
     [("Rucula crua", 50, "g"), ("Pera williams", 80, "g"),
      ("Queijo gorgonzola", 25, "g"), ("Vinagre balsamico", 1, "colherSopa"),
      ("Mel", 1, "colherCha"), ("Azeite de oliva", 1, "colherSopa")]),

    ("Grao-de-bico, tomate e cebola com molho de limao, azeite e alho", "salada", 1, 15,
     "Use o grao-de-bico ja cozido e bem escorrido.\n"
     "Misture com tomate e cebola picados miudos.\n"
     "Tempere com alho amassado, limao, azeite e sal e deixe 10 minutos "
     "pegando gosto.",
     [("Grao-de-bico cru", 50, "g"), ("Tomate italiano cru", 70, "g"),
      ("Cebola crua", 30, "g"), ("Alho cru", 1, "dente"),
      ("Limao taiti", 1, "colherSopa"), ("Azeite de oliva", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Lentilha, cenoura e cheiro-verde com vinagrete", "salada", 1, 15,
     "Use a lentilha cozida al dente e fria.\n"
     "Junte cenoura em cubinhos e bastante cheiro-verde picado.\n"
     "Tempere com vinagre, azeite, cebola picada e sal.",
     [("Lentilha crua", 50, "g"), ("Cenoura crua", 50, "g"),
      ("Cheiro-verde", 2, "colherSopa"), ("Cebola crua", 25, "g"),
      ("Vinagre de alcool", 1, "colherSopa"), ("Azeite de oliva", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Quinoa, pepino e tomate com molho de limao siciliano", "salada", 1, 15,
     "Use a quinoa cozida e fria, bem soltinha.\n"
     "Misture pepino e tomate em cubinhos.\n"
     "Tempere com limao, azeite e sal.",
     [("Quinoa em graos crua", 45, "g"), ("Pepino cru", 70, "g"),
      ("Tomate italiano cru", 70, "g"), ("Limao taiti", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Alface e milho com molho caesar light", "salada", 1, 10,
     "Rasgue a alface com a mao e escorra o milho.\n"
     "Misture iogurte, mostarda, parmesao e limao para o molho.\n"
     "Tempere so na hora de servir.",
     [("Alface americana crua", 70, "g"), ("Milho verde em conserva", 50, "g"),
      ("Iogurte natural integral", 2, "colherSopa"), ("Mostarda", 1, "colherCha"),
      ("Queijo parmesao ralado", 1, "colherSopa"), ("Limao taiti", 1, "colherCha"),
      ("Sal", 1, "aGosto")]),

    ("Alface, atum e cebola com molho de limao e azeite", "salada", 1, 10,
     "Escorra bem o atum e solte com o garfo.\n"
     "Monte sobre a alface com cebola em rodelas finas.\n"
     "Tempere com limao, azeite e sal.",
     [("Alface americana crua", 70, "g"), ("Atum em conserva", 60, "g"),
      ("Cebola roxa crua", 30, "g"), ("Limao taiti", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Espinafre, ovo cozido e tomate com molho de mostarda", "salada", 1, 15,
     "Use as folhas de espinafre cruas e bem secas.\n"
     "Corte o ovo cozido em rodelas e o tomate em cubos.\n"
     "Bata mostarda, azeite, limao e sal e regue por cima.",
     [("Espinafre cru", 60, "g"), ("Ovo de galinha cru", 1, "unidade"),
      ("Tomate italiano cru", 70, "g"), ("Mostarda", 1, "colherCha"),
      ("Azeite de oliva", 1, "colherSopa"), ("Limao taiti", 1, "colherCha"),
      ("Sal", 1, "aGosto")]),

    ("Couve crua, laranja e castanha com molho citrico", "salada", 1, 12,
     "Corte a couve em tiras muito finas e amasse de leve com sal — ela "
     "amacia.\n"
     "Junte gomos de laranja sem pele e castanha picada.\n"
     "Tempere com suco de laranja, azeite e sal.",
     [("Couve manteiga crua", 60, "g"), ("Laranja pera", 100, "g"),
      ("Castanha de caju", 15, "g"), ("Azeite de oliva", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Repolho branco, pepino e gergelim com molho shoyu", "salada", 1, 12,
     "Fatie o repolho fino e o pepino em meia-lua.\n"
     "Toste o gergelim rapidamente na frigideira seca.\n"
     "Tempere com shoyu, azeite e um fio de vinagre.",
     [("Repolho branco cru", 80, "g"), ("Pepino cru", 70, "g"),
      ("Gergelim em graos", 1, "colherCha"), ("Molho shoyu", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherCha"),
      ("Vinagre de alcool", 1, "colherCha")]),

    ("Alface e manga com molho de mostarda e mel", "salada", 1, 10,
     "Rasgue a alface e corte a manga em tiras.\n"
     "Misture mostarda, mel, azeite e limao.\n"
     "Regue na hora de servir.",
     [("Alface americana crua", 70, "g"), ("Manga palmer", 80, "g"),
      ("Mostarda", 1, "colherCha"), ("Mel", 1, "colherCha"),
      ("Azeite de oliva", 1, "colherSopa"), ("Limao taiti", 1, "colherCha")]),

    ("Rucula, tomate cereja e mucarela com molho pesto", "salada", 1, 10,
     "Corte os tomates ao meio e a mucarela em cubos.\n"
     "Monte sobre a rucula.\n"
     "Dilua o pesto com azeite e regue.",
     [("Rucula crua", 50, "g"), ("Tomate cereja", 80, "g"),
      ("Queijo mucarela", 40, "g"), ("Molho pesto", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherCha")]),

    ("Tomate, cebola e pepino com vinagrete tradicional", "salada", 1, 12,
     "Corte tudo em cubos do mesmo tamanho.\n"
     "Tempere com vinagre, azeite, sal e cheiro-verde.\n"
     "Deixe 10 minutos na geladeira antes de servir.",
     [("Tomate italiano cru", 90, "g"), ("Cebola crua", 40, "g"),
      ("Pepino cru", 70, "g"), ("Vinagre de alcool", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Cheiro-verde", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Caprese com azeite e balsamico", "salada", 1, 8,
     "Corte tomate e mucarela em rodelas da mesma espessura.\n"
     "Intercale no prato com as folhas de manjericao.\n"
     "Regue com azeite e balsamico e ponha sal so na hora.",
     [("Tomate italiano cru", 100, "g"), ("Queijo mucarela", 50, "g"),
      ("Manjericao fresco", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"),
      ("Vinagre balsamico", 1, "colherCha"), ("Sal", 1, "aGosto")]),

    ("Alface, abacate e tomate com molho de limao", "salada", 1, 10,
     "Corte o abacate em cubos e regue com limao na hora.\n"
     "Monte com a alface rasgada e o tomate.\n"
     "Tempere com azeite e sal.",
     [("Alface americana crua", 70, "g"), ("Abacate", 70, "g"),
      ("Tomate italiano cru", 70, "g"), ("Limao taiti", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Espinafre, morango e amendoas com molho balsamico", "salada", 1, 10,
     "Lave e seque o espinafre.\n"
     "Corte os morangos em fatias e lamine as amendoas.\n"
     "Tempere com balsamico, azeite e sal.",
     [("Espinafre cru", 60, "g"), ("Morango", 80, "g"),
      ("Amendoas", 15, "g"), ("Vinagre balsamico", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Beterraba cozida e cebola roxa com molho de vinagre de maca", "salada", 1, 40,
     "Cozinhe a beterraba com casca e corte em cubos depois de morna.\n"
     "Junte a cebola roxa em fatias finas.\n"
     "Tempere com vinagre de maca, azeite e sal e deixe descansar.",
     [("Beterraba crua", 120, "g"), ("Cebola roxa crua", 40, "g"),
      ("Vinagre de maca", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Cenoura ralada e passas com molho de limao e mel", "salada", 1, 10,
     "Rale a cenoura na parte grossa.\n"
     "Misture as passas e deixe hidratar no molho.\n"
     "Tempere com limao, mel, azeite e sal.",
     [("Cenoura crua", 110, "g"), ("Uva passa", 20, "g"),
      ("Limao taiti", 1, "colherSopa"), ("Mel", 1, "colherCha"),
      ("Azeite de oliva", 1, "colherCha"), ("Sal", 1, "aGosto")]),

    ("Pepino agridoce com molho de vinagre e acucar", "salada", 1, 15,
     "Corte o pepino em rodelas finas e salgue por 10 minutos; esprema a agua.\n"
     "Dissolva o acucar no vinagre.\n"
     "Misture e sirva bem gelado.",
     [("Pepino cru", 150, "g"), ("Vinagre de alcool", 1, "colherSopa"),
      ("Acucar refinado", 1, "colherCha"), ("Sal", 1, "aGosto")]),

    ("Alface, tomate e pepino com molho de azeite, limao e ervas", "salada", 1, 10,
     "Rasgue a alface e corte tomate e pepino em cubos.\n"
     "Misture azeite, limao, oregano e sal.\n"
     "Tempere na hora de servir.",
     [("Alface americana crua", 70, "g"), ("Tomate italiano cru", 70, "g"),
      ("Pepino cru", 60, "g"), ("Azeite de oliva", 1, "colherSopa"),
      ("Limao taiti", 1, "colherSopa"), ("Oregano seco", 1, "pitada"),
      ("Sal", 1, "aGosto")]),

    ("Alface, cenoura e beterraba com molho rose light", "salada", 1, 12,
     "Rale cenoura e beterraba cruas.\n"
     "Monte sobre a alface, em faixas separadas — beterraba tinge tudo se "
     "misturar.\n"
     "Misture iogurte com extrato de tomate e sal para o molho.",
     [("Alface americana crua", 70, "g"), ("Cenoura crua", 50, "g"),
      ("Beterraba crua", 50, "g"), ("Iogurte natural integral", 2, "colherSopa"),
      ("Extrato de tomate", 1, "colherCha"), ("Sal", 1, "aGosto")]),

    ("Rucula, abacate e tomate com molho de limao siciliano", "salada", 1, 10,
     "Corte o abacate em cubos e regue com limao logo.\n"
     "Monte com a rucula e o tomate.\n"
     "Tempere com azeite e sal.",
     [("Rucula crua", 50, "g"), ("Abacate", 70, "g"),
      ("Tomate cereja", 70, "g"), ("Limao taiti", 1, "colherSopa"),
      ("Azeite de oliva", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Repolho roxo e abacaxi com molho agridoce", "salada", 1, 12,
     "Fatie o repolho bem fino.\n"
     "Corte o abacaxi em cubos pequenos.\n"
     "Tempere com vinagre, acucar, azeite e sal e deixe gelar.",
     [("Repolho roxo cru", 90, "g"), ("Abacaxi", 80, "g"),
      ("Vinagre de maca", 1, "colherSopa"), ("Acucar refinado", 1, "colherCha"),
      ("Azeite de oliva", 1, "colherCha"), ("Sal", 1, "aGosto")]),

    ("Alface, manga e abacate com molho citrico", "salada", 1, 12,
     "Corte manga e abacate em cubos e regue o abacate com limao.\n"
     "Monte sobre a alface rasgada.\n"
     "Tempere com suco de laranja, azeite e sal.",
     [("Alface americana crua", 60, "g"), ("Manga palmer", 70, "g"),
      ("Abacate", 60, "g"), ("Suco de laranja integral", 2, "colherSopa"),
      ("Limao taiti", 1, "colherCha"), ("Azeite de oliva", 1, "colherSopa"),
      ("Sal", 1, "aGosto")]),

    ("Tomate assado e ricota com molho de ervas", "salada", 1, 25,
     "Asse os tomates em metades com azeite e sal a 200 C por 18 minutos.\n"
     "Deixe amornar e esfarele a ricota por cima.\n"
     "Regue com azeite batido com oregano e manjericao.",
     [("Tomate italiano cru", 120, "g"), ("Ricota", 50, "g"),
      ("Azeite de oliva", 1, "colherSopa"), ("Oregano seco", 1, "pitada"),
      ("Manjericao fresco", 1, "colherSopa"), ("Sal", 1, "aGosto")]),

    ("Cenoura, pepino e gergelim com molho oriental", "salada", 1, 12,
     "Corte cenoura e pepino em tiras finas.\n"
     "Toste o gergelim na frigideira seca.\n"
     "Tempere com shoyu, vinagre e um fio de azeite.",
     [("Cenoura crua", 70, "g"), ("Pepino cru", 80, "g"),
      ("Gergelim em graos", 1, "colherCha"), ("Molho shoyu", 1, "colherSopa"),
      ("Vinagre de alcool", 1, "colherCha"),
      ("Azeite de oliva", 1, "colherCha")]),

    ("Alface e croutons com molho caesar", "salada", 1, 10,
     "Rasgue a alface e mantenha bem gelada.\n"
     "Misture maionese, parmesao, mostarda e limao para o molho.\n"
     "Ponha os croutons por ultimo, senao amolecem.",
     [("Alface americana crua", 80, "g"), ("Croutons", 25, "g"),
      ("Maionese", 1, "colherSopa"), ("Queijo parmesao ralado", 1, "colherSopa"),
      ("Mostarda", 1, "colherCha"), ("Limao taiti", 1, "colherCha"),
      ("Sal", 1, "aGosto")]),
]
