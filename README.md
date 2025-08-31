# Ecommerce - SQL Ecommerce Refinado

# 📋 Descrição do Projeto

# Este projeto consiste em um banco de dados SQL refinado para um sistema de e-commerce, desenvolvido como parte do desafio da Digital Innovation One (DIO). O modelo foi aprimorado com diversas melhorias de normalização e funcionalidades para tornar o sistema mais robusto e eficiente.

# 

# 🚀 Melhorias Implementadas

# ✅ Separação do Endereço do Cliente

# Antes: O campo Address estava diretamente na tabela Clients.

# 

# Agora: Criada a tabela AddressClient relacionada via chave estrangeira com Clients, normalizando e estruturando cada campo com seu respectivo tipo de dado.

# 

# Benefício: Melhora a normalização e permite que um cliente tenha múltiplos endereços, além de facilitar futuras análises geográficas.

# 

# ✅ Restrição de Unicidade em Documentos

# Antes: Campos como CPF e CNPJ podiam ser repetidos, sem validação.

# 

# Agora: Definidas constraints UNIQUE em CPF (tabela ClientPF) e CNPJ (tabelas Supplier, Seller e ClientPJ), além de triggers que impedem o cadastro do mesmo cliente como PF e PJ simultaneamente.

# 

# Benefício: Garante integridade e evita duplicidade de registros sensíveis.

# 

# ✅ Estrutura de Pedidos mais Detalhada

# Antes: Pedido tinha apenas cliente e valor fixo de envio.

# 

# Agora:

# 

# Campo orderStatus com opções controladas por ENUM

# 

# Implementada relação com múltiplos produtos via ProductOrder

# 

# Sistema de pagamentos flexível com múltiplas formas por pedido

# 

# Benefício: Facilita o acompanhamento do ciclo de vida do pedido e permite métricas financeiras mais detalhadas.

# 

# ✅ Sistema de Pagamentos Avançado

# Implementação: Tabela Payments permite múltiplas formas de pagamento para o mesmo pedido, com status individual para cada transação.

# 

# Benefício: Flexibilidade para o cliente utilizar diferentes métodos de pagamento em uma mesma compra.

# 

# 🗄️ Estrutura do Banco de Dados

# Principais Tabelas:

# Clients - Cadastro geral de clientes

# 

# ClientPF - Clientes pessoa física (com CPF)

# 

# ClientPJ - Clientes pessoa jurídica (com CNPJ)

# 

# AddressClient - Endereços dos clientes

# 

# Product - Catálogo de produtos

# 

# Supplier - Fornecedores

# 

# Seller - Vendedores

# 

# Orders - Pedidos

# 

# Payments - Transações de pagamento

# 

# Delivery - Rastreamento de entregas

# 

# 🔄 Relacionamentos Chave

# Um cliente pode ser PF OU PJ (não ambos)

# 

# Um cliente pode ter múltiplos endereços

# 

# Um pedido pode ter múltiplos produtos

# 

# Um pedido pode ter múltiplos pagamentos

# 

# Vendedores também podem ser fornecedores

