# -*- coding: utf-8 -*-
"""Gera `assets/pratos/combo-NN.jpg` a partir das fotos originais de `imagens/`.

Os 66 nomes de arquivo que ela gerou sao as descricoes originais do plano dela —
uma segunda copia, independente do texto do WhatsApp. Este script casa cada
combo com a sua foto por **sobreposicao de palavras** e exige atribuicao 1:1:
cada foto serve exatamente um combo. Se sobrar ou faltar, ele reprova em vez de
adivinhar.

Saida: 900x506 (16:9), qualidade 80, progressivo. O recorte e decidido aqui, uma
vez, e registrado em PROCEDENCIA.json com quanto cada foto perdeu.

Rodar depois de `gerar_semente.py`:

    python tools/gerar_fotos.py
"""
import json
import os
import re
import sys
import unicodedata

from PIL import Image

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ORIGEM = os.path.join(RAIZ, 'imagens')
DESTINO = os.path.join(RAIZ, 'assets', 'pratos')
SEM = os.path.join(RAIZ, 'assets', 'semente')

LARGURA, ALVO, QUALIDADE = 900, 16 / 9, 80

# Palavras que aparecem em quase todo prato e nao ajudam a distinguir.
RUIDO = {
    'com', 'de', 'da', 'do', 'e', 'em', 'no', 'na', 'ao', 'a', 'o', 'os', 'as',
    'molho', 'suco', 'sal', 'simples', 'tradicional', 'natural', 'jpeg', 'jpg',
}


def fichas(texto):
    t = unicodedata.normalize('NFKD', texto.lower()).encode('ascii', 'ignore').decode()
    t = re.sub(r'[^a-z0-9]+', ' ', t)
    return {p for p in t.split() if len(p) > 2 and p not in RUIDO}


def main():
    dias = json.load(open(os.path.join(RAIZ, 'tools', 'plano_dela.json'),
                         encoding='utf-8'))
    fotos = sorted(f for f in os.listdir(ORIGEM) if f.lower().endswith('.jpeg'))

    # combo id -> texto original dela (1..33 cafe, 34..66 refeicao)
    alvos = {}
    for pos in range(1, 34):
        alvos[pos] = dias[str(pos)]['cafe da manha']
        alvos[33 + pos] = dias[str(pos)]['almoco']

    fichas_foto = {f: fichas(f) for f in fotos}
    fichas_alvo = {c: fichas(t) for c, t in alvos.items()}

    # matriz de pontos: interseccao sobre uniao, para nao premiar nome comprido
    pontos = []
    for cid, fa in fichas_alvo.items():
        for f, ff in fichas_foto.items():
            inter = len(fa & ff)
            if not inter:
                continue
            pontos.append((inter / len(fa | ff), inter, cid, f))
    pontos.sort(reverse=True)

    escolha, usada = {}, set()
    for (_, _, cid, f) in pontos:
        if cid in escolha or f in usada:
            continue
        escolha[cid] = f
        usada.add(f)

    faltando = [c for c in alvos if c not in escolha]
    sobrando = [f for f in fotos if f not in usada]
    if faltando or sobrando:
        print('ATRIBUICAO NAO FECHOU 1:1 — nada foi gravado.')
        for c in faltando:
            print(f'  combo {c} sem foto: {alvos[c][:70]}')
        for f in sobrando:
            print(f'  foto sem combo: {f[:70]}')
        return 1

    os.makedirs(DESTINO, exist_ok=True)
    for antigo in os.listdir(DESTINO):
        if antigo.endswith('.jpg'):
            os.remove(os.path.join(DESTINO, antigo))

    manifesto, fortes = {}, []
    for cid in sorted(escolha):
        arq = escolha[cid]
        im = Image.open(os.path.join(ORIGEM, arq)).convert('RGB')
        w, h = im.size
        if w / h > ALVO:                      # larga demais: corta os lados
            nw = int(round(h * ALVO)); x = (w - nw) // 2
            im = im.crop((x, 0, x + nw, h)); perda = 1 - nw / w; eixo = 'lados'
        else:                                 # alta demais: corta topo e base
            nh = int(round(w / ALVO)); y = (h - nh) // 2
            im = im.crop((0, y, w, y + nh)); perda = 1 - nh / h; eixo = 'topo/base'
        im = im.resize((LARGURA, int(round(LARGURA / ALVO))), Image.LANCZOS)
        nome = f'combo-{cid:02d}.jpg'
        im.save(os.path.join(DESTINO, nome), 'JPEG', quality=QUALIDADE,
                optimize=True, progressive=True)
        manifesto[nome] = {'origem': arq, 'original': f'{w}x{h}',
                           'recorte': f'{perda:.0%} em {eixo}'}
        if perda > 0.10:
            fortes.append((nome, arq, perda))

    json.dump(manifesto, open(os.path.join(DESTINO, 'PROCEDENCIA.json'), 'w',
                              encoding='utf-8'), ensure_ascii=False, indent=1)

    total = sum(os.path.getsize(os.path.join(DESTINO, f))
                for f in os.listdir(DESTINO) if f.endswith('.jpg'))
    print(f'{len(manifesto)} fotos, {total // 1024} KB '
          f'({total / 1048576:.1f} MB) em assets/pratos/')
    if fortes:
        print(f'\n{len(fortes)} com recorte acima de 10% — conferir:')
        for nome, arq, p in fortes:
            print(f'  {nome}  perdeu {p:.0%}  <- {arq[:56]}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
