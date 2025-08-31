USE ecommerceRefinado;
-- Pedidos por cliente?
SELECT c.idClient,
       CONCAT(c.Fname, ' ', c.Lname) AS NomeCliente,
       COUNT(o.idOrder) AS TotalPedidos
FROM Clients c
LEFT JOIN Orders o ON c.idClient = o.idClient
GROUP BY c.idClient, NomeCliente;

-- Vendedor também é um fornecedor?
SELECT 
    s.idSeller,
    s.socialName as NomeVendedor,
    s.CNPJ as CNPJ_Vendedor,
    sup.idSupplier,
    sup.socialName as NomeFornecedor,
    sup.CNPJ as CNPJ_Fornecedor,
    s.contact as Contato
FROM Seller s
INNER JOIN Supplier sup ON s.CNPJ = sup.CNPJ
WHERE s.CNPJ IS NOT NULL;
 
 -- Estoque, produtos e fornecedores
SELECT p.Pname AS Produto,
       s.socialName AS Fornecedor,
       ps.quantity AS Estoque
FROM Product p
INNER JOIN ProductSupplier ps 
       ON p.idProduct = ps.idPsProduct
INNER JOIN Supplier s 
       ON ps.idPsSupplier = s.idSupplier;

-- Nome dos forncedores com nome dos produtos
SELECT s.socialName AS Fornecedor,
       p.Pname AS Produto
FROM Supplier s
INNER JOIN ProductSupplier ps 
       ON s.idSupplier = ps.idPsSupplier
INNER JOIN Product p 
       ON ps.idPsProduct = p.idProduct
ORDER BY s.socialName, p.Pname;

-- cliente = fornecedor
SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS NomeCliente,
    pj.CNPJ AS Documento,
    s.idSupplier,
    s.socialName AS NomeFornecedor
FROM Clients c
INNER JOIN ClientPJ pj 
    ON c.idClient = pj.idClientPJ
INNER JOIN Supplier s
    ON pj.CNPJ = s.CNPJ;
    
-- valor gasto por cliente?
SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS NomeCliente,
    COALESCE(SUM(o.sendValue), 0) AS ValorGasto
FROM Clients c
LEFT JOIN Orders o 
    ON o.idClient = c.idClient
GROUP BY c.idClient, NomeCliente
ORDER BY ValorGasto DESC;

-- Total
SELECT 
    SUM(o.sendValue) AS ValorTotalGasto,
    count(idOrder) AS TotalVendas
FROM Orders o;

SELECT 
    ac.Estado,
    SUM(po.poQuantity) as QuantidadeTotalComprada,
    COUNT(DISTINCT o.idOrder) as TotalPedidos,
    COUNT(DISTINCT o.idClient) as TotalClientes
FROM ProductOrder po
INNER JOIN Orders o ON po.idOrder = o.idOrder
INNER JOIN AddressClient ac ON o.idClient = ac.idClient
WHERE po.poStatus != 'Cancelado'
GROUP BY ac.Estado
ORDER BY QuantidadeTotalComprada DESC;

