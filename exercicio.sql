-- Active: 1683657116431@@127.0.0.1@3306@db_loja
-- 1 Todos os produtos comprados com quantidade maior que 12.
SELECT DISTINCT 
    produto.descricao 
FROM produto, item 
--joins
WHERE produto.codigo = item.codProduto 
--filters
AND item.quantidade > 12;

-- 2 Nome dos clientes que compraram mais de 23 peças de queijo.
SELECT DISTINCT 
    cliente.nome 
FROM cliente, compra, item, produto 
--joins
WHERE cliente.cpf = compra.cpfCliente 
AND compra.codigo = item.codCompra 
AND item.codProduto = produto.codigo
--filters
AND produto.descricao LIKE '%queijo%'
AND item.quantidade > 23;

-- 3 Cidade onde moram as pessoas que compram produtos com validade sempre menor que 3 meses.
SELECT DISTINCT 
    endereco.cidade
FROM endereco, cliente, compra, item, produto, lote
--joins
WHERE endereco.cep = cliente.cep
AND cliente.cpf = compra.cpfCliente 
AND compra.codigo = item.codCompra
AND item.codProduto = produto.codigo
AND produto.codLote = lote.codigo
--filters
AND DATEDIFF(lote.dataFab,lote.dataValidade) < 90;

-- 4 Todos os clientes cuja cidade é “Guarapuava” e sexo masculino.
SELECT DISTINCT 
    cliente.nome
FROM cliente, endereco
--joins
WHERE cliente.cep = endereco.cep
--filters
AND cliente.sexo = 'M'
AND endereco.cidade = 'Guarapuava';

-- 5 Sexo das pessoas que moram na cidade que começa com a letra “G” e com a letra “C”.
SELECT 
    endereco.cidade, 
    cliente.sexo, 
    cliente.nome 
FROM endereco, cliente
--joins
WHERE cliente.cep = endereco.cep
--filters
AND (endereco.cidade LIKE 'G%'
OR endereco.cidade LIKE 'C%')
--order
ORDER BY endereco.cidade, cliente.sexo;

-- 6 Quantidade total de produtos adquiridos com preço maior que R$ 10,00.
SELECT 
    SUM(quantidade) as 'Produtos Total' 
FROM produto, item
--joins
WHERE produto.codigo = item.codProduto
--filters
AND produto.preco > 10;

-- 7 Nome das pessoas que compraram mais de 5 peças de queijo e mais de 3 litros de leite.
SELECT DISTINCT 
    leite.nome 
FROM (
        SELECT 
            DISTINCT cliente.nome
        FROM cliente, compra, item, produto
        --joins
        WHERE cliente.cpf = compra.cpfCliente
        AND compra.codigo = item.codCompra
        AND item.codProduto = produto.codigo
        --filters
        AND produto.descricao LIKE '%queijo%'
        GROUP BY cliente.nome
        HAVING sum(item.quantidade) > 5
    ) 
    as queijo,
    
    (
        SELECT 
            DISTINCT cliente.nome
        FROM cliente, compra, item, produto
        --joins
        WHERE cliente.cpf = compra.cpfCliente
        AND compra.codigo = item.codCompra
        AND item.codProduto = produto.codigo
        --filters
        AND produto.descricao LIKE '%leite%'
        GROUP BY cliente.nome
        HAVING sum((item.quantidade*produto.volume)) > 3
    ) 
    as leite 

WHERE queijo.nome = leite.nome;

-- 8 Cidade onde moram os clientes, em ordem alfabética crescente.
SELECT DISTINCT 
    endereco.cidade 
FROM endereco, cliente
--joins
WHERE endereco.cep = cliente.cep
--order
ORDER BY endereco.cidade;

-- 9 Profissão de todos os clientes que são professores, engenheiros, ou gestores.
SELECT DISTINCT
    nome, 
    profissao
FROM cliente
--filters
WHERE profissao LIKE '%professor%' 
OR profissao LIKE '%engenheiro%' 
OR profissao LIKE '%gestor%';

-- 10 Nome da rua dos clientes que compram queijo com valor maior que R$ 5,00 e menor que R$ 25,00.

-- 11 Nome, Profissão e Sexo dos clientes que compram mais de 4 litros de leite cujo valor esteja entre R$ 1,00 e R$ 1,80.

-- 12 Nome, Profissão e Sexo dos clientes que compram mais de 4 litros de leite cujo valor esteja entre R$ 1,00 e R$ 1,80, ordenados pelo sexo.

-- 13 Profissão dos clientes que compram leite e queijo, ordenado pelo Nome em ordem crescente.

-- 14 Produtos comprados pelos clientes que moram em Curitiba e que compram em quantidade maior que 5 unidades.

-- 15 Soma de todas as compras realizadas pelos clientes que moram em Curitiba.

-- 16 Lote dos produtos comprados pelos clientes cuja profissão seja professor.

-- 17 Validade dos lotes cuja venda foi realizada para a cidade de Guarapuava.

-- 18 Todos os lotes de todos os produtos.

-- 19 As quantidades de queijo compradas pelos clientes de Guarapuava

-- 20 A data e a quantidade de leite compradas pelos clientes que moram em Curitiba ou em Guarapuava.21 – Nome dos clientes que compraram queijo, bem como a data da compra e quantidade.

-- 22 Nome e cidade dos clientes, data da compra e tipo de pagamento, quantidade comprada e descrição dos produtos.

-- 23 Compras efetuadas no segundo trimestre do ano.

-- 24 Nome e lote de todos os produtos que foram comprados com quantidade maior que 6.

-- 25 Lote, validade e descrição dos produtos que não foram comprados.