# Decisões de design do protótipo, por heurística

Este documento registra, tela a tela, o que o protótipo manteve, alterou ou removeu em relação ao aplicativo original da Shein e qual heurística de Nielsen (1994) justifica cada decisão. A base de comparação são as capturas de tela em `prints/` (home, card de produto, compra rápida, produto, comentários, carrinho e verificações). As telas do protótipo estão em `docs/telas/`.

## Critério geral

A aparência do original foi preservada: fundo branco sobre cinza claro, texto preto, preço em laranja com centavos menores, verde para frete e segurança, botões pretos retangulares, busca com botão preto, categorias em círculos, seções em blocos e navegação inferior.

O que mudou foi a quantidade e a organização dos elementos. Um elemento permaneceu quando ajuda o usuário a concluir a tarefa da tela. Foi alterado quando ajudava, mas violava uma heurística na forma como aparecia. Foi removido quando competia pela atenção sem contribuir para a tarefa.

Seguindo Cheng e Nielsen (2016) e Liu (2020), os sinais de confiança valorizados no design de alto contexto não foram eliminados. Avaliações, política de devolução, pagamento seguro e descontos continuam presentes, em menor número e com hierarquia definida.

## As dez heurísticas

| Sigla | Heurística |
|---|---|
| H1 | Visibilidade do status do sistema |
| H2 | Correspondência entre o sistema e o mundo real |
| H3 | Controle e liberdade do usuário |
| H4 | Consistência e padrões |
| H5 | Prevenção de erros |
| H6 | Reconhecimento em vez de memorização |
| H7 | Flexibilidade e eficiência de uso |
| H8 | Estética e design minimalista |
| H9 | Ajudar o usuário a reconhecer, diagnosticar e recuperar-se de erros |
| H10 | Ajuda e documentação |

## Página inicial

| Elemento no original | Decisão | Heurística | Justificativa |
|---|---|---|---|
| Campo de busca com botão preto | Mantido | H7 | É o caminho mais rápido para quem já sabe o que procura. |
| Termo sugerido dentro da busca ("Moletom Masculino", com ícone de fogo) | Substituído por "Buscar produtos" | H2, H5 | O termo parece uma busca já digitada e leva a resultados que o usuário não pediu. |
| Ícone de mensagens à esquerda da busca, com ponto vermelho | Mantido no mesmo lugar, sem o ponto vermelho | H4, H8 | Quem vem do app original encontra as mensagens onde espera. O ponto só faria sentido com mensagem não lida. |
| Ícone de check-in diário, com ponto vermelho | Removido | H8 | Não pertence à tarefa de compra e o ponto vermelho disputa a atenção. |
| Busca por foto | Removida | H8 | Função secundária dentro do campo mais usado da tela. |
| Favoritos (coração) | Mantido | H6 | Permite reencontrar produtos sem lembrar o nome. |
| Abas com seis ou mais itens em rolagem, incluindo "Envio Nacional" | Reduzidas a quatro departamentos visíveis | H4, H6 | "Envio Nacional" é um filtro misturado a departamentos. Com quatro abas, todas ficam visíveis sem rolar. |
| Carrossel de banners com troca automática | Mantido, com três banners, troca a cada 5 segundos e pontos indicadores | H3, H1 | A troca para enquanto o usuário toca ou arrasta e respeita a opção do sistema de reduzir animações. Os pontos mostram quantos banners há e qual está à vista. |
| Imagem do carrossel até o topo da tela, por trás do cabeçalho | Mantida, com o topo escurecido e a imagem desfocada preenchendo o fundo | H8, H4 | O destaque ocupa a faixa de baixo e nenhum texto do banner fica sob a busca. |
| Ícones e abas brancos sobre a imagem, pretos ao rolar | Mantido, com transição gradual | H1, H4 | O cabeçalho continua legível nos dois estados e volta à aparência das outras telas quando a imagem sai. |
| Duas faixas de atalhos ("Loja de Tendências", "Novo Em" e "Casual", "Rua") | Removidas | H8 | Repetem a função das categorias em outro formato. |
| Quinze ou mais categorias em três linhas com rolagem lateral | Oito categorias em duas linhas, com "Ver tudo" | H8, H6 | Oito grupos ficam dentro do limite de 7±2 de Miller (1956) e cabem na tela sem rolagem lateral. |
| Rótulos "Partes de baixo" e "Roupa de exterior" | "Calças" e "Jaquetas" | H2 | São traduções literais que o usuário brasileiro não usa. |
| Botão flutuante "LIVE ON" sobre as categorias | Removido | H8, H3 | Cobre conteúdo e não tem relação com a tarefa. |
| "Super Ofertas" | Mantida | H8 | É uma seção promocional única, com título claro. |
| "Promoção masculina" e "Itens mais vendidos" lado a lado | Unificadas em "Mais vendidos" | H8, H4 | Duas vitrines pequenas com o mesmo formato dividiam a largura da tela. |
| Filtros da listagem em quatro ordenações e uma segunda linha de menus ("Categoria", "Tamanho", "Cor", "Decote") | Uma linha de filtros em "Mais vendidos": Todos, Em oferta, Envio nacional e categorias | H7, H8, H4 | Um toque refina a vitrine sem abrir menus. A faixa é a mesma da busca e do carrinho. |
| Cards só com preço | Card com nome, preço e desconto | H6 | Sem o nome, o usuário precisa abrir o produto para saber o que é. |
| "1,1k+ vendido" junto de nota, posição em ranking e "Dizem ótima qualidade" | Uma linha "+1 mil vendidos" | H8, H2 | Um sinal de prova social por card, escrito por extenso. A nota fica na compra rápida e na tela de produto. |
| Bandeira do Brasil sobre a foto e "Envio Nacional" com prazo no rodapé do card | Legenda "Envio nacional" em verde, abaixo do preço | H2, H6, H8 | A bandeira exige interpretação e cobre a foto. A legenda diz o que significa, e o prazo aparece na tela de produto. |
| Faixas "SHEIN 10.10" e "Economize R$110,00" sobre a foto, "Últimas 5 hrs" ao lado do preço | Removidas | H8 | Urgência e promoção repetem o desconto, que já está ao lado do preço. |
| Mini carrinho no canto inferior direito do card | Mantido, no mesmo lugar | H7, H4 | Atalho para comprar sem sair da lista. A posição é a mesma em todos os cards. |
| "Oferta Relâmpago" em um card e "30% OFF" nos demais | Sempre "X% OFF" | H4 | A mesma informação aparece no mesmo formato. |
| Navegação inferior com cinco itens e ponto vermelho | Quatro itens: Loja, Categorias, Carrinho, Perfil | H4, H8 | "Tendências" repete o conteúdo da Loja. |
| Contador no ícone do carrinho | Mantido | H1 | Mostra quantos itens há no carrinho em qualquer tela. |

## Listagem e busca

A tela de listagem não consta nos prints. Foi construída com os mesmos componentes da página inicial.

| Elemento | Heurística | Justificativa |
|---|---|---|
| Contagem de resultados ("5 produtos") | H1 | Informa o resultado da busca ou do filtro. |
| Filtro por categoria e ordenação por preço ou desconto | H7 | Atalhos para quem quer refinar, sem ocupar a tela de quem não quer. |
| Botão de limpar no campo de busca | H3 | Desfaz a busca com um toque. |
| Mensagem de busca sem resultado, com sugestão e botão para limpar filtros | H9 | Explica o que houve e oferece a saída. |

## Compra rápida

O painel abre pelo mini carrinho do card e sobe sobre a lista. Os prints de referência estão em `prints/produtoBox/` e `prints/comentarios/`.

| Elemento no original | Decisão | Heurística | Justificativa |
|---|---|---|---|
| Painel que sobe da base, com a lista visível ao fundo | Mantido | H1, H3 | A animação mostra de onde o painel veio, e a lista ao fundo indica que o usuário não saiu dela. |
| Botão de fechar | Mantido, com toque fora e arrastar para baixo | H3 | Três saídas para uma ação iniciada por engano. |
| Galeria de fotos em rolagem lateral | Uma foto ao lado do resumo | H8 | Há uma foto por produto. Ao lado do texto, ela deixa cor e tamanho visíveis sem rolar. |
| Selos "Envio Nacional" e "Mercado" antes do título cortado | Nome completo em até duas linhas e legenda "Envio nacional" | H2, H8 | "Mercado" não se explica, e o título cortado esconde o nome. |
| Preço, selo de desconto e preço anterior | Mantidos | H1, H4 | Mesma apresentação da tela de produto. |
| "Últimas 5 horas" | Removido | H8 | Urgência sem relação com a escolha de cor e tamanho. |
| Sem nota nem vendidos | Nota e vendidos em uma linha | H6 | O sinal de confiança acompanha a decisão, sem exigir abrir o produto. |
| Sem escolha de cor | Cor e tamanho, com os controles da tela de produto | H4, H6 | A mesma escolha tem a mesma forma nos dois lugares. A cor da foto já vem selecionada. |
| "Tamanho BR >" e tamanho indisponível em cinza | "Tamanho" com P, M, G, GG | H2, H8 | O protótipo não simula estoque. |
| "Todos os tamanhos são elegíveis para Entrega em 4-7 dias" e "Para denunciar este vendedor" | Removidos | H8 | Prazo e denúncia ficam na tela de produto. |
| Link "Detalhes" | "Ver detalhes" | H7, H3 | Caminho para a tela completa a partir do painel. |
| Botão "58% DE DESCONTO Últimas 5 h! ADICIONAR AO CARRINHO" | "ADICIONAR AO CARRINHO" | H4, H8 | Mesmo rótulo da tela de produto. |
| Tocar em adicionar sem escolher tamanho | Mensagem junto aos tamanhos, com destaque no campo | H5, H9 | Mesmo tratamento da tela de produto. |
| Ao adicionar | O painel fecha e a lista mostra a confirmação com "Ver carrinho" | H1 | O usuário volta para onde estava, com a ação confirmada. |

## Página de produto

| Elemento no original | Decisão | Heurística | Justificativa |
|---|---|---|---|
| Campo de busca preenchido no cabeçalho | Trocado por ícone de busca | H8 | O campo ocupa o cabeçalho com um termo que o usuário não digitou. |
| Carrinho com contador | Mantido | H1 | Confirma o estado do carrinho. |
| Compartilhar e menu de três pontos | Reunidos em um menu | H8 | São ações raras. |
| Faixa "Tendências / Moda para todos" | Removida | H8 | Elemento promocional entre a imagem e o preço. |
| Preço, selo de desconto e preço anterior | Mantidos | H1 | Informação central da decisão de compra. |
| Linha de cupons cortada ("R$10,00 Cupom de frete Para pedidos R$0,01+, Desconto aleatório R$...") | Removida | H8, H2 | Texto truncado e com termos que não se explicam. O cupom passa a ser tratado na finalização. |
| Título longo, com palavras-chave em sequência | Marca e nome curto | H2, H8 | O título original foi escrito para mecanismos de busca e não para leitura. |
| Avaliações em etiquetas ("ótima qualidade (42K+)") | Nota média, número de avaliações e vendidos | H8 | Mantém os sinais de confiança em uma linha. |
| Aba "Comentários" no topo | Removida. Tocar no número de avaliações rola até a seção | H7, H8 | O atalho continua sem ocupar uma faixa fixa. |
| Sem escolha de cor ao lado dos tamanhos | Cor e tamanho no mesmo bloco, com o nome da cor escrito | H6, H4 | As duas variações são escolhidas juntas. O nome evita depender só da amostra. |
| Cor sem seleção inicial | A cor da foto vem selecionada | H5 | Evita um segundo erro de campo vazio. O tamanho continua sem padrão por não haver um valor seguro. |
| Tamanhos S, M, L, XL | P, M, G, GG | H2 | Padrão usado no Brasil. |
| "Guia de tamanhos" e "Verifique meu tamanho" | Apenas "Guia de tamanhos" | H10, H4 | Duas entradas para a mesma ajuda. |
| "60% de probabilidade de entrega em até 13 dias" | "Chega entre 17 e 25 de outubro" | H2 | O usuário pensa em datas e não em probabilidade. |
| Devolução gratuita e pagamento seguro | Mantidos | H1 | Sinais de confiança relevantes antes da compra. |
| "Para denunciar este vendedor e/ou produto" na lista de garantias | Movido para o menu | H8 | Ação rara, colocada entre informações de entrega. |
| Nota "4,72" com estrelas e "(100+)" | Nota com estrelas e o total no título da seção | H1, H4 | A nota usa o mesmo formato do topo da tela. |
| Três barras "Pequeno 3%, Fiel ao tamanho 87%, Grande 10%" | Uma frase: "87% acharam o tamanho fiel" | H5, H8 | A informação ajuda a acertar o tamanho. Em frase, dispensa a leitura de três barras. |
| Etiquetas "recompraria (3)", "logística veloz (3)", "sem odores (5)", "igual a foto (24)" | Removidas | H8, H2 | Contagens pequenas e termos de tradução literal. |
| Comentário com usuário, estrelas, cor e tamanho comprados | Mantido | H6 | A variação comprada dá contexto ao comentário. |
| Ícone de tradução antes de cada comentário | Removido | H8 | Ruído repetido em todas as linhas. |
| "Útil (n)" | Mantido, com mudança de estado ao tocar | H1 | A ação tem resposta visível. |
| Menu "..." em cada comentário | Removido | H8 | Ação rara repetida em todas as linhas. |
| "Ver mais" das avaliações | "Ver mais avaliações", abrindo na própria tela | H3, H4 | Mesmo padrão dos detalhes, sem trocar de tela. |
| Detalhes com "Ver mais" | Mantido | H8 | Mostra o essencial e deixa o restante a um toque. |
| Bloco da loja com "j***r seguido 2 horas atrás", "700K clientes recorrentes", "1.3M vendidos" | Removido | H8 | Prova social que não informa sobre o produto em vista. A marca permanece acima do nome. |
| "Você também pode gostar" com filtros por categoria | Uma linha de quatro produtos | H8 | Mantém a descoberta sem abrir uma segunda listagem na mesma tela. |
| Abas "Produto" e "Recomendar" | Removidas | H8 | A tela tem uma única tarefa. |
| Botão "25% DE DESCONTO! ADICIONAR AO CARRINHO" | "ADICIONAR AO CARRINHO" | H4, H8 | O rótulo de um botão descreve a ação. O desconto já aparece junto ao preço. |
| Ícone de loja ao lado do coração | Removido | H8 | Terceira ação na barra inferior, sem relação com a compra. |
| Tocar em adicionar sem escolher tamanho | Mensagem junto aos tamanhos, com destaque no campo | H5, H9 | O erro é apontado onde pode ser corrigido. |
| Confirmação ao adicionar | Mensagem com atalho "Ver carrinho" | H1 | Confirma a ação e oferece o passo seguinte. |

## Carrinho

| Elemento no original | Decisão | Heurística | Justificativa |
|---|---|---|---|
| Itens desmarcados por padrão, com total em R$ 0,00 | Itens entram selecionados | H5 | O estado inicial do original leva o usuário a finalizar sem nada selecionado. |
| Seleção por item e "Tudo" | Mantidos, com rótulo "Selecionar tudo" | H3, H2 | Preserva a função de comprar parte do carrinho. |
| Endereço no cabeçalho do carrinho | Removido | H8 | O endereço é tratado na finalização. |
| Filtros "Todos", "Quase fora do estoque", "Por Categoria" | "Todos" e "Em oferta", a partir de dois itens no carrinho | H7, H8 | Com um item não há o que filtrar. "Quase fora do estoque" é urgência, e categoria pouco ajuda em uma lista curta. |
| Filtro sem explicação do critério | Aviso "Itens com 30% OFF ou mais" e selo de desconto nesses itens | H1, H6 | O usuário vê por que cada item entrou no filtro. |
| Total com filtro ativo | O total continua somando todos os selecionados, e o aviso diz isso | H1, H5 | Filtrar a lista não muda o que será comprado. |
| Filtro sem resultado | Mensagem com "Ver todos os itens" | H9, H3 | Explica o estado e oferece a saída. |
| Variação do item ("Preto / S") | "Preto · Tamanho M" | H1, H2 | Cor e tamanho escolhidos aparecem no carrinho e na finalização. |
| Agrupamento "Internacional" e por loja | Removido | H2 | É uma divisão logística da empresa e não do usuário. |
| Duas faixas promocionais (frete e "Gaste R$29 para obter 20% OFF") | Uma mensagem de frete com barra de progresso | H1, H8 | Uma única meta, com o progresso visível. |
| "100+ visualizando agora", "8 restantes", "Último dia", "Economias Aleatórias", "Est. -44%" | Removidos | H8, H2 | Elementos de urgência que competem com nome, preço e quantidade. |
| Quantidade em lista suspensa | Botões de menos e mais | H4 | O original usa lista suspensa no carrinho e botões na finalização. O protótipo usa o mesmo controle nas duas telas. |
| Remover item dentro do menu de três pontos | Ícone de lixeira visível, com "Desfazer" | H6, H3, H5 | A ação fica visível e o erro é reversível. |
| Botão "FINALIZAR" | "FINALIZAR (n)", desativado sem seleção com o texto "SELECIONE UM ITEM" | H1, H5 | Mostra quantos itens seguem para a compra e impede um pedido vazio. |
| Carrinho vazio | Mensagem com botão "Ver produtos" | H1, H9 | Explica o estado e indica o próximo passo. |

## Finalização

A finalização permanece em uma única tela, como no original, dividida em cinco blocos: endereço, itens, envio, forma de pagamento e resumo.

| Elemento no original | Decisão | Heurística | Justificativa |
|---|---|---|---|
| Faixa de benefícios em rolagem automática | Uma linha fixa ao final | H3, H8 | Texto em movimento não pode ser lido no ritmo do usuário. |
| Dois avisos sobre data de nascimento, sem botão | Um aviso com o botão "Adicionar" | H4, H9 | O aviso original informa o problema e não oferece a solução na tela. |
| Tentar avançar sem a data | O aviso é destacado e a tela volta até ele | H5, H9 | A pendência é apontada onde pode ser resolvida. |
| "8 restantes" e "Última chance!" sobre o item | Removidos | H8 | Urgência em uma etapa em que a decisão já foi tomada. |
| "Free Shipping" em inglês | "Frete grátis" | H2, H4 | O restante da interface está em português. |
| "Taxa mínima de envio", "Taxa de entrega" e "Entrega a tempo" em três linhas | Um bloco "Envio" com prazo e garantia | H8 | Três linhas para uma única opção de envio. |
| Cinco formas de pagamento, com o mesmo cartão e o Pix repetidos | Três formas distintas: Pix, cartão de crédito e PayPal | H4, H8 | O parcelamento vira um detalhe do cartão. |
| "Carteira indisponível" | Removida | H8 | Opção que não pode ser usada. |
| Cupom, pontos e cartão de presente em três linhas | Uma linha de cupom | H8 | Pontos e cartão de presente ficam fora do escopo do fluxo avaliado. |
| Cupom inválido | Mensagem com o código digitado e a orientação para conferir | H9 | Linguagem simples e ação seguinte clara. |
| Resumo com onze linhas | Quatro linhas (produtos, descontos, frete, total), com "Ver detalhes do valor" | H8, H6 | Agrupamento conforme Miller (1956). O detalhamento continua disponível. |
| Bloco "Compre de forma segura e sustentável" com quatro ícones | Uma linha sobre pagamento seguro e devolução | H8 | Mantém o sinal de confiança sem empurrar o total para fora da tela. |
| Botão "CONTINUAR COMPRA", com "1 item(ns) 8 restantes" | "IR PARA PAGAMENTO" | H2 | O rótulo informa o que acontece a seguir. |

O fluxo termina ao tocar em "IR PARA PAGAMENTO", no passo imediatamente anterior ao pagamento, conforme a tarefa padronizada da metodologia.

## Perfil e ajuda

O perfil reúne os favoritos e uma tela de ajuda com cinco perguntas sobre tamanho, frete, devolução, data de nascimento e remoção de itens (H10).

## Limites do protótipo

- As imagens de produto foram recortadas dos prints e têm baixa resolução. Cada produto tem uma imagem, e por isso não há galeria.
- O catálogo tem 16 produtos do departamento Masculino. As abas "Feminino" e "Esporte" informam que não fazem parte do protótipo.
- Nome, telefone e endereço da finalização são fictícios.
- Preços e descontos seguem os prints quando visíveis. Os demais valores, as notas, o número de avaliações e de vendidos e a marcação de envio nacional são ilustrativos.
- As cores são as mesmas três para todos os produtos e não trocam a foto. Os comentários e os percentuais de ajuste são fictícios e iguais em todos os produtos.
- Compartilhar e denunciar apenas exibem uma confirmação.

## Como gerar as telas

```
flutter test --dart-define=SHOTS=true --update-goldens
```

O comando percorre o fluxo de compra e grava as imagens em `docs/telas/`.
