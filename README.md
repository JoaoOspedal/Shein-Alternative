# Shein-Alternative

Protótipo em Flutter de uma versão adaptada do aplicativo da Shein para o usuário ocidental. É o produto do TCC "Interfaces mobile de alto contexto cultural e seus impactos na experiência do usuário ocidental" (Ciência da Computação, Universidade Tuiuti do Paraná, 2026).

O protótipo mantém a aparência do aplicativo original e usa as dez heurísticas de usabilidade de Nielsen para decidir o que permanece, o que muda e o que sai de cada tela. As decisões estão registradas em [docs/decisoes_heuristicas.md](docs/decisoes_heuristicas.md).

## O que o protótipo cobre

O fluxo de compra completo, até o passo imediatamente anterior ao pagamento:

- página inicial
- categorias, listagem e busca de produtos
- página de produto
- carrinho
- finalização (endereço, itens, envio, forma de pagamento e resumo)
- favoritos, perfil e ajuda

Os dados são fictícios e ficam em memória. Não há servidor, login nem pagamento real.

## Requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) 3.44 ou mais recente (Dart 3.12 ou mais recente)
- Para rodar no navegador: Google Chrome
- Para rodar no Android: Android Studio com o Android SDK e um emulador ou aparelho com depuração USB ativada

Confira a instalação com:

```
flutter doctor
```

## Como rodar

Clone o repositório e baixe as dependências:

```
git clone <url-do-repositório>
cd Shein-Alternative
flutter pub get
```

No navegador:

```
flutter run -d chrome
```

No Android, com um emulador aberto ou um aparelho conectado:

```
flutter devices
flutter run
```

No navegador, o protótipo fica mais próximo do uso real com a janela em formato de celular (F12 e, em seguida, o modo de dispositivo do Chrome).

## Como gerar um instalável

APK para Android, gravado em `build/app/outputs/flutter-apk/app-release.apk`:

```
flutter build apk
```

Versão web, gravada em `build/web`:

```
flutter build web
```

## Testes

O teste percorre o fluxo de compra do início ao fim:

```
flutter test
```

Para também gravar as capturas de tela do protótipo em `docs/telas/`:

```
flutter test --dart-define=SHOTS=true --update-goldens
```

## Estrutura

| Caminho | Conteúdo |
|---|---|
| `lib/main.dart` | Tema e navegação inferior |
| `lib/data.dart` | Produtos, categorias, carrinho e favoritos |
| `lib/widgets.dart` | Cores e componentes compartilhados |
| `lib/screens/` | Uma tela por arquivo |
| `assets/images/` | Imagens de produtos, categorias e banner |
| `docs/decisoes_heuristicas.md` | Decisões de design por tela e por heurística |
| `docs/telas/` | Capturas de tela do protótipo |
| `test/flow_test.dart` | Teste do fluxo de compra |

## Aviso

Projeto acadêmico, sem fins comerciais e sem vínculo com a Shein. As imagens de produtos foram recortadas de capturas de tela do aplicativo original e pertencem aos seus respectivos donos.
