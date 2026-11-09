# Alterações no carrinho e na finalização

Este documento registra as alterações feitas no carrinho e na finalização do protótipo em novembro de 2026, com a heurística de Nielsen (1994) que justifica cada uma. Ele complementa o [decisoes_heuristicas.md](decisoes_heuristicas.md), que usa as mesmas siglas (H1 a H10).

## Resumo

| Alteração | Tela | Heurísticas |
|---|---|---|
| Edição do endereço de entrega | Finalização e nova tela de endereço | H3, H4 |
| Verificação dos dados do endereço | Tela de endereço | H5, H9 |
| Seta de voltar | Carrinho | H3, H4 |
| Opção de entrega agendada | Finalização | H7, H4, H1 |
| Confirmação ao remover item | Carrinho | H5, H3 |
| Novo estilo das notificações | Todo o app | H4, H1 |
| Link para a ajuda | Finalização | H10 |

## Endereço de entrega

| Elemento | Decisão | Heurística | Justificativa |
|---|---|---|---|
| Endereço fixo, sem como alterar | Botão "Alterar" ao lado do endereço | H3, H4 | O usuário pode corrigir o endereço sem sair da compra. O botão repete o "Alterar" da data de nascimento, na mesma seção. |
| Edição do endereço | Nova tela com os campos já preenchidos | H6 | O usuário edita só o que mudou, sem redigitar o endereço inteiro. |
| Salvar | Botão "SALVAR ENDEREÇO" fixo no rodapé e aviso "Endereço salvo" | H1 | O usuário vê que a alteração foi aplicada. Voltar sem salvar mantém o endereço anterior. |

### Verificação dos dados

A tela confere o formato de cada campo antes de salvar. O erro aparece embaixo do campo enquanto o usuário digita, com a forma correta de preencher (H5, H9).

| Campo | Aceita | Mensagem de erro |
|---|---|---|
| Nome completo | Só letras, com nome e sobrenome | "Use apenas letras no nome" ou "Informe nome e sobrenome" |
| Telefone | DDD + número, 10 ou 11 dígitos | "Telefone inválido. Use DDD + número, ex.: (41) 99999-0000" |
| CEP | 8 números, com ou sem hífen | "CEP inválido. Use 8 números, ex.: 80000-000" |
| Rua | Pelo menos 3 caracteres | "Rua muito curta" |
| Número | Números, com uma letra opcional no fim, ou "S/N" | "Use números ou S/N" |
| Complemento | Opcional, sem verificação | — |
| Cidade | Só letras | "Cidade inválida" |
| UF | Uma das 27 siglas de estado | "UF inválida" |

Campos obrigatórios vazios mostram "Preencha o campo …". O CEP é salvo sempre no formato 00000-000. A verificação é só de formato: o protótipo não consulta se o CEP existe.

## Carrinho

| Elemento | Decisão | Heurística | Justificativa |
|---|---|---|---|
| Carrinho sem seta de voltar | Seta de voltar no topo, com o carrinho vazio ou cheio | H3, H4 | O carrinho é uma aba, mas também é aberto pelo ícone de outras telas. A seta volta para a aba de onde o usuário veio, ou para a Loja se não houver aba anterior. |
| Remoção direta pela lixeira | Janela de confirmação com foto, nome e variação do item | H5 | Evita remover um item por toque acidental e mostra qual item vai sair. |
| Desfazer a remoção | Mantido depois da confirmação | H3 | Mesmo confirmada, a remoção pode ser revertida pela notificação. |

A janela de confirmação segue o visual do app: fundo branco, cantos de 4 px, botão "CANCELAR" com contorno e botão "REMOVER" preto. O componente fica em `lib/widgets.dart` e pode ser usado em outras ações de excluir.

## Finalização

| Elemento | Decisão | Heurística | Justificativa |
|---|---|---|---|
| Uma única forma de envio | Duas opções selecionáveis: entrega padrão e entrega agendada | H7 | Quem precisa receber em um dia certo pode escolher a data. Quem não precisa mantém a padrão, que vem marcada. |
| Controle da escolha de frete | Mesmo botão de seleção da forma de pagamento | H4 | As duas escolhas da tela funcionam do mesmo jeito. |
| Dia da entrega agendada | Três dias para escolher, visíveis só quando a agendada está marcada | H8 | A escolha do dia não ocupa a tela de quem fica com a entrega padrão. |
| Valor do frete no resumo | Atualiza conforme a opção e passa a se chamar "Frete agendado" | H1 | O total mostrado é sempre o que será cobrado. |
| Ajuda | Link "Dúvidas sobre o pedido? Fale com a ajuda" abaixo de "Ver detalhes do valor" | H10 | A ajuda fica a um toque no momento de decidir a compra. Abre a mesma tela de Ajuda do Perfil. |

A entrega padrão continua grátis acima de R$ 199,00 e custa R$ 12,00 abaixo disso. A entrega agendada custa R$ 19,90 em qualquer valor de compra, das 8h às 18h. Os dias disponíveis (20, 21 e 22 de outubro) são fixos, como as datas da entrega padrão.

## Notificações

| Elemento | Decisão | Heurística | Justificativa |
|---|---|---|---|
| Notificação no estilo padrão do sistema | Fundo preto do app, cantos de 4 px e ação em branco e caixa alta | H4 | A notificação segue os mesmos botões e cores do restante do app. |
| Item adicionado ao carrinho | Ícone de check verde e ação "VER CARRINHO" | H1 | O ícone confirma a adição antes da leitura do texto. |
| Item removido do carrinho | Ícone de lixeira e ação "DESFAZER" | H1, H3 | O ícone indica a remoção e a ação permite revertê-la. |

O novo estilo vale para todas as notificações do app. Só as do carrinho têm ícone.

## Figuras

As telas da segunda versão ficam em `docs/telas/v2/`. As da primeira versão continuam em `docs/telas/`, para comparação. A numeração segue a da primeira versão: as figuras de 1 a 12 mostram as mesmas telas, agora com as alterações, e as de 13 a 18 são novas.

| Figura | Tela | O que mostra |
|---|---|---|
| `5_carrinho.png` | Carrinho | Seta de voltar no topo |
| `6_finalizar.png` | Finalização | Botão "Alterar" do endereço e as duas opções de frete |
| `7_finalizar_resumo.png` | Finalização | Resumo com o link para a ajuda |
| `13_produto_adicionado.png` | Produto | Notificação de item adicionado no novo estilo |
| `14_carrinho_confirmar_remocao.png` | Carrinho | Janela de confirmação ao remover um item |
| `15_carrinho_removido.png` | Carrinho vazio | Notificação de item removido, com "DESFAZER", e seta de voltar |
| `16_endereco.png` | Endereço | Tela de edição com os dados atuais |
| `17_endereco_erros.png` | Endereço | Mensagens de erro de telefone, CEP, número e UF |
| `18_finalizar_entrega_agendada.png` | Finalização | Entrega agendada escolhida, com os dias disponíveis |

As figuras são geradas pelo teste de fluxo (`test/flow_test.dart`), que também verifica cada alteração:

```
flutter test --dart-define=SHOTS=true --update-goldens
```

## Resultado do teste de fluxo

Executado em 9 de novembro de 2026 com Flutter 3.47.7 (canal stable), pelo comando `flutter test`.

```
00:00 +0: fluxo de compra até o passo anterior ao pagamento
00:03 +1: All tests passed!
```

O teste passou (código de saída 0). Além do fluxo da primeira versão, ele verifica:

| Verificação | Resultado esperado |
|---|---|
| Item adicionado ao carrinho | Notificação "Adicionado ao carrinho" com ícone de check |
| Seta de voltar do carrinho | Volta para a aba Loja |
| Lixeira, depois "CANCELAR" | Janela "Remover este item?" fecha e o item continua no carrinho |
| Lixeira, depois "REMOVER" | Carrinho vazio, notificação "Item removido do carrinho" e seta de voltar visível |
| "DESFAZER" | O item volta ao carrinho |
| Endereço com telefone, CEP, número e UF inválidos | As quatro mensagens de erro aparecem e a tela não fecha |
| Endereço corrigido | Volta à finalização com o novo endereço e o CEP no formato 81200-100 |
| Entrega agendada | Os dias aparecem só com a opção marcada e o resumo mostra "Frete agendado" |
| Volta para a entrega padrão | Os dias somem |
| Link "Dúvidas sobre o pedido? Fale com a ajuda" | Abre a tela de Ajuda, e a seta volta para a finalização |
| "IR PARA PAGAMENTO" com a data de nascimento preenchida | Mostra "Fim do protótipo" |

## Arquivos alterados

| Arquivo | Alteração |
|---|---|
| `lib/screens/address_screen.dart` | Novo: tela de edição e verificação do endereço |
| `lib/screens/checkout_screen.dart` | Botão de alterar endereço, opções de frete e link para a ajuda |
| `lib/screens/cart_screen.dart` | Seta de voltar e confirmação ao remover item |
| `lib/widgets.dart` | Novo estilo da notificação e janela de confirmação |
| `lib/data.dart` | Registro da aba anterior, usado pela seta de voltar do carrinho |
| `lib/screens/product_screen.dart` | Ícone na notificação de item adicionado |
| `lib/screens/quick_view.dart` | Ícone na notificação de item adicionado |
| `test/flow_test.dart` | Fluxo cobrindo as alterações e figuras gravadas em `docs/telas/v2/` |
