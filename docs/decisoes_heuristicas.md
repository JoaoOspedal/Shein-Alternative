# Decisões de design do protótipo, por heurística

Este documento registra, tela a tela, o que o protótipo manteve, alterou ou removeu em relação ao aplicativo original da Shein e qual heurística de Nielsen (1994) justifica cada decisão. A base de comparação são as capturas de tela em `prints/` (home, produto, carrinho e verificações). As telas do protótipo estão em `docs/telas/`.

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
| Ícones de mensagens e de check-in diário, com pontos vermelhos | Removidos | H8 | Não pertencem à tarefa de compra e os pontos vermelhos disputam a atenção. |
| Busca por foto | Removida | H8 | Função secundária dentro do campo mais usado da tela. |
| Favoritos (coração) | Mantido | H6 | Permite reencontrar produtos sem lembrar o nome. |
| Abas com seis ou mais itens em rolagem, incluindo "Envio Nacional" | Reduzidas a quatro departamentos visíveis | H4, H6 | "Envio Nacional" é um filtro misturado a departamentos. Com quatro abas, todas ficam visíveis sem rolar. |
| Carrossel de banners com troca automática | Um banner fixo | H3, H8 | A troca automática tira do usuário o controle sobre o que está lendo. |
| Duas faixas de atalhos ("Loja de Tendências", "Novo Em" e "Casual", "Rua") | Removidas | H8 | Repetem a função das categorias em outro formato. |
| Quinze ou mais categorias em três linhas com rolagem lateral | Oito categorias em duas linhas, com "Ver tudo" | H8, H6 | Oito grupos ficam dentro do limite de 7±2 de Miller (1956) e cabem na tela sem rolagem lateral. |
| Rótulos "Partes de baixo" e "Roupa de exterior" | "Calças" e "Jaquetas" | H2 | São traduções literais que o usuário brasileiro não usa. |
| Botão flutuante "LIVE ON" sobre as categorias | Removido | H8, H3 | Cobre conteúdo e não tem relação com a tarefa. |
| "Super Ofertas" | Mantida | H8 | É uma seção promocional única, com título claro. |
| "Promoção masculina" e "Itens mais vendidos" lado a lado | Unificadas em "Mais vendidos" | H8, H4 | Duas vitrines pequenas com o mesmo formato dividiam a largura da tela. |
| Cards só com preço | Card com nome, preço e desconto | H6 | Sem o nome, o usuário precisa abrir o produto para saber o que é. |
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
| Avaliações em etiquetas ("ótima qualidade (42K+)") | Nota média e número de avaliações | H8 | Mantém o sinal de confiança em uma linha. |
| Tamanhos S, M, L, XL | P, M, G, GG | H2 | Padrão usado no Brasil. |
| "Guia de tamanhos" e "Verifique meu tamanho" | Apenas "Guia de tamanhos" | H10, H4 | Duas entradas para a mesma ajuda. |
| "60% de probabilidade de entrega em até 13 dias" | "Chega entre 17 e 25 de outubro" | H2 | O usuário pensa em datas e não em probabilidade. |
| Devolução gratuita e pagamento seguro | Mantidos | H1 | Sinais de confiança relevantes antes da compra. |
| "Para denunciar este vendedor e/ou produto" na lista de garantias | Movido para o menu | H8 | Ação rara, colocada entre informações de entrega. |
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
| Filtros "Todos", "Quase fora do estoque", "Por Categoria" | Removidos | H8 | Um carrinho raramente tem itens suficientes para exigir filtro. |
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
- Preços e descontos seguem os prints quando visíveis. Os demais valores, as notas e o número de avaliações são ilustrativos.
- Compartilhar e denunciar apenas exibem uma confirmação.

## Como gerar as telas

```
flutter test --dart-define=SHOTS=true --update-goldens
```

O comando percorre o fluxo de compra e grava as imagens em `docs/telas/`.
