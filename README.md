# Aplicativo Coma Bem
## Sobre o Projeto
O **Coma Bem** é um aplicativo mobile desenvolvido para conectar amantes da culinária a bons restaurantes locais. Este projeto foi construído como
parte da unidade curricular de Banco de Dados Mobile e foca na estruturação segura e eficiente de dados.
## Tecnologias Utilizadas
* **Linguagem:** Dart
* **Framework:** Flutter
* **Banco de Dados:** Sqlite
* **Padrões de Projeto:** Orientação a Objetos, DAO (Data Access Object)
## Modelagem do Banco de Dados
O banco de dados relacional foi construído respeitando as regras de normalização (1FN, 2FN e 3FN) para evitar redundância.
As tabelas principais do sistema são:
1. Usuario
2. Restaurante
3. Prato
4. Avaliação
## Arquitetura e Orientação a Objetos
O sistema foi desenhado utilizando os pilares da Orientação a Objetos:
**Encapsulamento:** Todos os atributos das classes de modelo (como senha do usuário) são privados (`_`), sendo acessados apenas de forma segura
através de `getters` e `setters` com validação de dados.
* **Herança:** Criação de perfis especializados (`Cliente`, `Administrador`, `DonoRestaurante`) que herdam características de uma classe base
abstrata `Usuario`.
**Polimorfismo:** Implementação de menus e permissões dinâmicas. O método `exibirMenu()` adapta-se automaticamente dependendo de qual perfil de
usuário está logado no sistema.
## Transações e Regras de Negócio (CRUD)
A classe `DatabaseHelper` centraliza a conexão com o banco de dados físico no dispositivo móvel. As rotinas implementadas possuem tratamento de
erros (`try-catch`) e proteção contra injeção de SQL (`SQL Injection`).
## Como Executar o Projeto
1. Clone este repositório.
2. 2. Abra o projeto no VS Code.
3. 3. Certifique-se de ter um Emulador Android configurado.
4. 4. Execute o comando `flutter pub get` no terminal para baixar as dependências (`sqflite` e `path`).
5. 5. Pressione `F5` para compilar e testar o aplicativo no emulador.
--- *Desenvolvido por João Gaspar*