-- BD Ecommerce
DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

-- Clientes
CREATE TABLE Clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Minit CHAR(3),
    Lname VARCHAR(50) NOT NULL,
    CPF CHAR(11) NOT NULL,
    CONSTRAINT unique_cpf_client UNIQUE (CPF)
);
alter table Clients auto_increment=1;

-- Endereços
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
    CONSTRAINT fk_address_client FOREIGN KEY (idClient) REFERENCES Clients(idClient)
);

-- Produtos
CREATE TABLE Product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(50),
    classification_kids BOOLEAN DEFAULT FALSE,
    category ENUM('Eletronico','Vestimenta','Brinquedos','Alimentos','Moveis') NOT NULL,
    avaliacao FLOAT DEFAULT 0,
    size VARCHAR(20)
);

-- Pagamentos
CREATE TABLE Payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    typePayment ENUM('Boleto','Cartao','Dois_cartoes','Pix') NOT NULL,
    limitAvailable DECIMAL(10,2),
    CONSTRAINT fk_payment_client FOREIGN KEY (idClient) REFERENCES Clients(idClient)
);

-- Pedidos
CREATE TABLE Orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT NOT NULL,
    orderStatus ENUM('Cancelado','Confirmado','Em_Processamento') DEFAULT 'Em_Processamento',
    orderDescription VARCHAR(255),
    sendValue DECIMAL(10,2) DEFAULT 10.00,
    idPayment INT NOT NULL,
    paymentCash BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES Clients(idClient),
    CONSTRAINT fk_orders_payment FOREIGN KEY (idPayment) REFERENCES Payments(idPayment)
		on update cascade
);

-- Estoque
CREATE TABLE ProductStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- Fornecedor
CREATE TABLE Supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact VARCHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- Vendedor
CREATE TABLE Seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    abstName VARCHAR(255),
    CNPJ CHAR(14) NOT NULL,
    CPF CHAR(11),
    location VARCHAR(255),
    contact VARCHAR(11) NOT NULL,
    CONSTRAINT unique_CNPJ_seller UNIQUE (CNPJ),
    CONSTRAINT unique_CPF_seller UNIQUE (CPF)
);

-- Produtos / Vendedores (N:N)
CREATE TABLE ProductSeller (
    idPSeller INT,
    idPProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPSeller, idPProduct),
    CONSTRAINT fk_ps_seller FOREIGN KEY (idPSeller) REFERENCES Seller(idSeller),
    CONSTRAINT fk_ps_product FOREIGN KEY (idPProduct) REFERENCES Product(idProduct)
);

-- Produtos / Pedidos (N:N)
CREATE TABLE ProductOrder (
    idPOProduct INT,
    idPOOrder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponivel','Sem_estoque') DEFAULT 'Disponivel',
    PRIMARY KEY (idPOProduct, idPOOrder),
    CONSTRAINT fk_po_product FOREIGN KEY (idPOProduct) REFERENCES Product(idProduct),
    CONSTRAINT fk_po_order FOREIGN KEY (idPOOrder) REFERENCES Orders(idOrder)
);

desc ProductSeller;

-- Local de armazenamento
CREATE TABLE StorageLocation (
    idLProduct INT,
    idLStorage INT,
    location VARCHAR(255),
    PRIMARY KEY (idLProduct, idLStorage),
    CONSTRAINT fk_sl_product FOREIGN KEY (idLProduct) REFERENCES Product(idProduct),
    CONSTRAINT fk_sl_storage FOREIGN KEY (idLStorage) REFERENCES ProductStorage(idProdStorage)
);

create TABLE productSupplier(
idPsSupplier int,
idPsproduct int,
quantity int not null,
primary key (idPsSupplier, idPsproduct),
constraint fk_product_supplier foreign key (idPsSupplier) references Supplier (idSupplier),
constraint fk_product_product foreign key (idPsproduct) references Product (idProduct)
);

show tables;
