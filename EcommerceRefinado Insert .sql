-- BANCO DE DADOS E-COMMERCE

DROP DATABASE IF EXISTS ecommerceRefinado;
CREATE DATABASE ecommerceRefinado;
USE ecommerceRefinado;


-- CLIENTES

CREATE TABLE Clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Minit CHAR(3),
    Lname VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20)
);

-- Cliente Pessoa Física
CREATE TABLE ClientPF (
    idClientPF INT PRIMARY KEY,
    CPF CHAR(11) UNIQUE NOT NULL,
    FOREIGN KEY (idClientPF) REFERENCES Clients(idClient)
);

-- Cliente Pessoa Jurídica
CREATE TABLE ClientPJ (
    idClientPJ INT PRIMARY KEY,
    CNPJ CHAR(14) UNIQUE NOT NULL,
    RazaoSocial VARCHAR(100) NOT NULL,
    FOREIGN KEY (idClientPJ) REFERENCES Clients(idClient)
);

 -- Validação se existe cadastro do cliente PF | PJ
DELIMITER //

CREATE TRIGGER trg_before_insert_ClientPF
BEFORE INSERT ON ClientPF
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM ClientPJ
    WHERE idClientPJ = NEW.idClientPF
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Este cliente já está cadastrado como PJ.';
  END IF;
END;
//

CREATE TRIGGER trg_before_insert_ClientPJ
BEFORE INSERT ON ClientPJ
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM ClientPF
    WHERE idClientPF = NEW.idClientPJ
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Este cliente já está cadastrado como PF.';
  END IF;
END;
//

DELIMITER ;

-- Endereços de Clientes
CREATE TABLE AddressClient (
    idAddress INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    address VARCHAR(100) NOT NULL,
    numero INT,
    complemento VARCHAR(50),
    bairro VARCHAR(50),
    CEP CHAR(8),
    city VARCHAR(50),
    Estado CHAR(2),
    FOREIGN KEY (idClient) REFERENCES Clients(idClient)
);


-- PRODUTOS

CREATE TABLE Product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(50) NOT NULL,
    classification_kids BOOLEAN DEFAULT FALSE,
    category ENUM('Eletronico','Vestimenta','Brinquedos','Alimentos','Moveis') NOT NULL,
    avaliacao FLOAT DEFAULT 0,
    size VARCHAR(20)
);

-- Estoque
CREATE TABLE ProductStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- Ligação Produto | Estoque (N:N)
CREATE TABLE StorageLocation (
    idLProduct INT,
    idLStorage INT,
    location VARCHAR(255),
    PRIMARY KEY (idLProduct, idLStorage),
    FOREIGN KEY (idLProduct) REFERENCES Product(idProduct),
    FOREIGN KEY (idLStorage) REFERENCES ProductStorage(idProdStorage)
);


-- FORNECEDOR

CREATE TABLE Supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact VARCHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- Ligação Produto ↔ Fornecedor (N:N)
CREATE TABLE ProductSupplier (
    idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    FOREIGN KEY (idPsSupplier) REFERENCES Supplier(idSupplier),
    FOREIGN KEY (idPsProduct) REFERENCES Product(idProduct)
);


-- VENDEDOR

CREATE TABLE Seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    abstName VARCHAR(255),
    CNPJ CHAR(14),
    CPF CHAR(11),
    location VARCHAR(255),
    contact VARCHAR(11) NOT NULL,
    CONSTRAINT unique_CNPJ_seller UNIQUE (CNPJ),
    CONSTRAINT unique_CPF_seller UNIQUE (CPF)
);

-- Ligação Produto ↔ Vendedor (N:N)
CREATE TABLE ProductSeller (
    idSeller INT,
    idProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idSeller, idProduct),
    FOREIGN KEY (idSeller) REFERENCES Seller(idSeller),
    FOREIGN KEY (idProduct) REFERENCES Product(idProduct)
);


-- PEDIDOS

CREATE TABLE Orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    orderStatus ENUM('Cancelado','Confirmado','Em_Processamento') DEFAULT 'Em_Processamento',
    orderDescription VARCHAR(255),
    sendValue DECIMAL(10,2) DEFAULT 10.00,
    FOREIGN KEY (idClient) REFERENCES Clients(idClient)
);

-- Produtos em Pedidos (N:N)
CREATE TABLE ProductOrder (
    idProduct INT,
    idOrder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponivel','Indisponivel','Cancelado') DEFAULT 'Disponivel',
    PRIMARY KEY (idProduct, idOrder),
    FOREIGN KEY (idProduct) REFERENCES Product(idProduct),
    FOREIGN KEY (idOrder) REFERENCES Orders(idOrder)
);

-- Tabela ClientPayment (adicionada para resolver o erro de referência)
CREATE TABLE ClientPayment (
    idClientPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    typePayment ENUM('Cartao','Pix','Boleto') NOT NULL,
    paymentDetails VARCHAR(255),
    FOREIGN KEY (idClient) REFERENCES Clients(idClient)
);

-- PAGAMENTOS (vários por pedido)
CREATE TABLE Payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL,
    idClientPayment INT NOT NULL,
    idClient INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    paymentStatus ENUM('Pendente','Aprovado','Recusado','Estornado') DEFAULT 'Pendente',
    FOREIGN KEY (idOrder) REFERENCES Orders(idOrder),
    FOREIGN KEY (idClientPayment) REFERENCES ClientPayment(idClientPayment),
    FOREIGN KEY (idClient) REFERENCES Clients(idClient)
);

-- ENTREGA

CREATE TABLE Delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL,
    statusEntrega ENUM('Aguardando envio','Em transporte','Entregue','Cancelado') NOT NULL,
    codigoRastreio VARCHAR(50),
    FOREIGN KEY (idOrder) REFERENCES Orders(idOrder)
);

show tables;

-- CLIENTES (PF e PJ)

INSERT INTO Clients (Fname, Minit, Lname, email, telefone)
VALUES 
('Gabriel', 'M', 'Antunes', 'gabriel@email.com', '11988887777'),
('Maria', 'A', 'Silva', 'maria@email.com', '11977776666'),
('João', 'B', 'Oliveira', 'joao@email.com', '21955554444'),
('Tech', NULL, 'Solutions', 'contato@techsolutions.com', '1133332222'),
('Super', NULL, 'Mercado LTDA', 'suporte@supermercado.com', '1132323232'),
('Carla', 'P', 'Mendes', 'carla@email.com', '11966665555'),
('Ricardo', 'S', 'Lopes', 'ricardo@email.com', '11944443333'),
('Fernanda', 'R', 'Souza', 'fernanda@email.com', '21922221111'),
('Global', NULL, 'Tech SA', 'contato@globaltech.com', '1130303030'),
('Construtora', NULL, 'Alpha LTDA', 'contato@alpha.com', '1140404040');

-- PF
INSERT INTO ClientPF (idClientPF, CPF)
VALUES
(1, '12345678901'),
(2, '98765432100'),
(3, '45612378999'),
(6, '11223344556'),
(7, '22334455667'),
(8, '33445566778');

-- PJ
INSERT INTO ClientPJ (idClientPJ, CNPJ, RazaoSocial)
VALUES
(4, '12345678000199', 'Tech Solutions Ltda'),
(5, '98765432000155', 'Super Mercado LTDA'),
(9, '55566677000199', 'Global Tech SA'),
(10, '66677788000155', 'Construtora Alpha LTDA');

-- Endereços
INSERT INTO AddressClient (idClient, address, numero, bairro, CEP, city, Estado)
VALUES
(1, 'Rua das Flores', 100, 'Centro', '01001000', 'São Paulo', 'SP'),
(2, 'Av Paulista', 1500, 'Bela Vista', '01311000', 'São Paulo', 'SP'),
(3, 'Rua Rio Branco', 200, 'Centro', '20040002', 'Rio de Janeiro', 'RJ'),
(4, 'Av Faria Lima', 4000, 'Itaim Bibi', '04538132', 'São Paulo', 'SP'),
(5, 'Rua Marechal Deodoro', 250, 'Centro', '80020000', 'Curitiba', 'PR'),
(6, 'Rua Bahia', 123, 'Centro', '30160010', 'Belo Horizonte', 'MG'),
(7, 'Av Atlântica', 4000, 'Copacabana', '22070002', 'Rio de Janeiro', 'RJ'),
(8, 'Rua das Palmeiras', 55, 'Jardim Paulista', '01423001', 'São Paulo', 'SP'),
(9, 'Av Brasil', 999, 'Industrial', '90880000', 'Porto Alegre', 'RS'),
(10, 'Rua XV de Novembro', 800, 'Centro', '80020010', 'Curitiba', 'PR');


-- FORNECEDORES

INSERT INTO Supplier (socialName, CNPJ, contact)
VALUES
('Dell Computadores', '11111111000111', '11999998888'),
('Nike do Brasil', '22222222000122', '11988887777'),
('Lacta Alimentos', '33333333000133', '1133332222'),
('Samsung Eletronicos', '44444444000144', '11912121212'),
('Adidas Brasil', '55555555000155', '11923232323'),
('Construtora Alpha LTDA','66677788000155','11944662256'),
('Nestle SA', '66666666000166', '1134343434'),
('TechFornecedor MEI', '88888888000188', '11999990000');


-- PRODUTOS

INSERT INTO Product (Pname, classification_kids, category, avaliacao, size)
VALUES
('Notebook Dell', FALSE, 'Eletronico', 4.8, '15 polegadas'),
('Camiseta Nike', FALSE, 'Vestimenta', 4.5, 'M'),
('Boneca Barbie', TRUE, 'Brinquedos', 4.7, 'Único'),
('Chocolate Lacta', TRUE, 'Alimentos', 4.3, '100g'),
('Mesa de Escritório', FALSE, 'Moveis', 4.1, '120x60cm'),
('Smartphone Samsung', FALSE, 'Eletronico', 4.9, '6.5 polegadas'),
('Tênis Adidas', FALSE, 'Vestimenta', 4.6, '42'),
('Lego Star Wars', TRUE, 'Brinquedos', 4.8, '500 peças'),
('Chocolate Nestle', TRUE, 'Alimentos', 4.4, '90g'),
('Cadeira Gamer', FALSE, 'Moveis', 4.7, '120x70cm'),
('Mouse Gamer', FALSE, 'Eletronico', 4.5, 'Médio'),
('Teclado Mecânico', FALSE, 'Eletronico', 4.7, 'Padrão');

-- Produto | Fornecedor
INSERT INTO ProductSupplier (idPsSupplier, idPsProduct, quantity)
VALUES
(1,1,50), -- Dell fornece Notebook
(2,2,200), -- Nike fornece Camisetas
(2,3,150), -- Nike fornece Bonecas (ex fictício)
(3,4,500), -- Lacta fornece Chocolates
(1,5,20),  -- Dell fornece Mesas
(4,6,100), -- Samsung fornece Smartphone
(5,7,250), -- Adidas fornece Tênis
(5,8,80),  -- Adidas fornece Lego
(6,9,600), -- Nestle fornece Chocolate
(4,10,30), -- Samsung fornece Cadeira Gamer
(8, 11, 100),  -- TechFornecedor fornece Mouse Gamer
(8, 12, 80);   -- TechFornecedor fornece Teclado Mecânico

-- VENDEDORES

INSERT INTO Seller (socialName, abstName, CNPJ, CPF, location, contact)
VALUES
('Gabriel Vendas MEI', 'Gabriel Vendas', NULL, '55566677788', 'São Paulo', '11911112222'),
('Nike Oficial', 'Nike', '22222222000122', NULL, 'São Paulo', '11922223333'),
('Lojas Brasil LTDA', 'Lojas Brasil', '44444444000144', NULL, 'Rio de Janeiro', '2133334444'),
('Fernanda MEI', 'Fernanda Store', NULL, '11122233344', 'Belo Horizonte', '31955556666'),
('Adidas Oficial', 'Adidas', '55555555000155', NULL, 'São Paulo', '11910101010'),
('MegaTech LTDA', 'MegaTech', '77777777000177', NULL, 'Curitiba', '41920202020'),
('TechFornecedor MEI', 'TechFornecedor', '88888888000188', NULL, 'São Paulo', '11999990000');

-- Produto do Vendedor
INSERT INTO ProductSeller (idSeller, idProduct, prodQuantity)
VALUES
(1,1,5),   
(1,4,10),  
(2,2,100), 
(2,3,80),  
(3,5,5),   
(4,6,20),  
(4,9,50),  
(5,7,120), 
(5,8,40),  
(6,10,15),
(7, 11, 30),
(7, 12, 25);

-- PEDIDOS

INSERT INTO Orders (idClient, orderStatus, orderDescription, sendValue)
VALUES
(1, 'Confirmado', 'Compra de Notebook', 20.00),
(2, 'Confirmado', 'Compra de Camisetas e Chocolates', 15.00),
(4, 'Em_Processamento', 'Compra corporativa de Mesas', 50.00),
(6, 'Confirmado', 'Compra de Smartphone', 25.00),
(7, 'Confirmado', 'Compra de Tênis e Lego', 18.00),
(9, 'Em_Processamento', 'Compra corporativa de Cadeiras Gamer', 60.00),
(8, 'Confirmado', 'Compra de Chocolate Nestle', 10.00),
(10, 'Cancelado', 'Compra de Smartphones e Tênis', 0.00);

-- Produtos nos Pedidos
INSERT INTO ProductOrder (idProduct, idOrder, poQuantity, poStatus)
VALUES
(1,1,1,'Disponivel'),
(2,2,2,'Disponivel'),
(4,2,5,'Disponivel'),
(5,3,3,'Disponivel'),
(6,4,1,'Disponivel'),
(7,5,1,'Disponivel'),
(8,5,2,'Disponivel'),
(10,6,4,'Disponivel'),
(9,7,10,'Disponivel'),
(6,8,2,'Cancelado'),
(7,8,3,'Cancelado');

-- Inserções para ClientPayment (adicionadas para resolver o erro)
INSERT INTO ClientPayment (idClient, typePayment, paymentDetails)
VALUES
(1, 'Cartao', 'Cartão Visa final 1234'),
(2, 'Pix', 'Chave PIX: 11977776666'),
(2, 'Cartao', 'Cartão Mastercard final 5678'),
(3, 'Boleto', 'Boleto bancário'),
(4, 'Cartao', 'Cartão corporativo final 9012'),
(5, 'Pix', 'Chave PIX: contato@supermercado.com'),
(5, 'Cartao', 'Cartão final 3456'),
(6, 'Boleto', 'Boleto bancário'),
(7, 'Pix', 'Chave PIX: 11944443333'),
(8, 'Cartao', 'Cartão final 7890');

-- PAGAMENTOS
INSERT INTO Payments (idOrder, idClientPayment, idClient, amount, paymentStatus)
VALUES
(1, 1, 1, 3000.00, 'Aprovado'),
(2, 2, 2, 200.00, 'Aprovado'),
(2, 3, 2, 150.00, 'Aprovado'),
(3, 4, 4, 1200.00, 'Pendente'),
(4, 5, 6, 3500.00, 'Aprovado'),
(5, 6, 7, 600.00, 'Aprovado'),
(5, 7, 7, 150.00, 'Aprovado'),
(6, 8, 9, 4800.00, 'Pendente'),
(7, 9, 8, 50.00, 'Aprovado'),
(8, 10, 10, 0.00, 'Recusado');

-- ENTREGA

INSERT INTO Delivery (idOrder, statusEntrega, codigoRastreio)
VALUES
(1,'Em transporte','BR123456789SP'),
(2,'Entregue','BR987654321SP'),
(3,'Aguardando envio','BR555444333SP'),
(4,'Em transporte','BR111222333MG'),
(5,'Entregue','BR444555666RJ'),
(6,'Aguardando envio','BR777888999RS'),
(7,'Entregue','BR000111222SP'),
(8,'Cancelado','CANCEL000CUR');