# Lógica do Carrinho de Compras

Este projeto tem como objetivo implementar a lógica de um carrinho de compras

## Funcionalidades

- Adicionar itens ao carrinho.
- Remover itens do carrinho.
- Atualizar a quantidade de itens no carrinho.
- Calcular o total do carrinho.
- Marcar carrinho como abandonado após 3 horas sem alteração.
- Descartar carrinho abandonado após 7 dias.

## Tecnologias Utilizadas

- **Ruby**: Linguagem principal.
- **Rails**: Framework para o backend.
- **PostgreSQL**: Banco de dados.
- **Redis**: Suporte ao processamento em background com **Sidekiq**.
- **Sidekiq**: Gerenciador de jobs em background.
- **RSpec**: Framework de testes.
- **Docker**: Para facilitar o ambiente de desenvolvimento.

## Como Rodar o Projeto

### Com Docker

1. **Construa e inicie os containers:**

   ```bash
   make build
   make start
