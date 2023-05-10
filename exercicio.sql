-- Active: 1683657116431@@127.0.0.1@3306@db_loja

-- 1 Todos os produtos comprados com quantidade maior que 12.

SELECT
    DISTINCT produto.descricao
FROM produto, item
WHERE
    produto.codigo = item.codProduto
    AND item.quantidade > 12;

-- 2 Nome dos clientes que compraram mais de 23 peças de queijo.

SELECT DISTINCT cliente.nome
FROM
    cliente,
    compra,
    item,
    produto
WHERE
    cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND produto.descricao LIKE '%queijo%'
    AND item.quantidade > 23;

-- 3 Cidade onde moram as pessoas que compram produtos com validade sempre menor que 3 meses.

SELECT DISTINCT endereco.cidade
FROM
    endereco,
    cliente,
    compra,
    item,
    produto,
    lote
WHERE
    endereco.cep = cliente.cep
    AND cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND produto.codLote = lote.codigo
    AND DATEDIFF(
        lote.dataFab,
        lote.dataValidade
    ) < 90;

-- 4 Todos os clientes cuja cidade é “Guarapuava” e sexo masculino.

SELECT DISTINCT cliente.nome
FROM cliente, endereco
WHERE
    cliente.cep = endereco.cep
    AND cliente.sexo = 'M'
    AND endereco.cidade = 'Guarapuava';

-- 5 Sexo das pessoas que moram na cidade que começa com a letra “G” e com a letra “C”.

SELECT
    endereco.cidade,
    cliente.sexo,
    cliente.nome
FROM endereco, cliente
WHERE
    cliente.cep = endereco.cep
    AND (
        endereco.cidade LIKE 'G%'
        OR endereco.cidade LIKE 'C%'
    )
ORDER BY
    endereco.cidade,
    cliente.sexo;

-- 6 Quantidade total de produtos adquiridos com preço maior que R$ 10,00.

SELECT
    SUM(quantidade) as 'Produtos Total'
FROM produto, item
WHERE
    produto.codigo = item.codProduto
    AND produto.preco > 10;

-- 7 Nome das pessoas que compraram mais de 5 peças de queijo e mais de 3 litros de leite.

SELECT DISTINCT leite.nome
FROM (
        SELECT
            DISTINCT cliente.nome
        FROM
            cliente,
            compra,
            item,
            produto
        WHERE
            cliente.cpf = compra.cpfCliente
            AND compra.codigo = item.codCompra
            AND item.codProduto = produto.codigo
            AND produto.descricao LIKE '%queijo%'
        GROUP BY cliente.nome
        HAVING
            sum(item.quantidade) > 5
    ) as queijo, (
        SELECT
            DISTINCT cliente.nome
        FROM
            cliente,
            compra,
            item,
            produto
        WHERE
            cliente.cpf = compra.cpfCliente
            AND compra.codigo = item.codCompra
            AND item.codProduto = produto.codigo
            AND produto.descricao LIKE '%leite%'
        GROUP BY cliente.nome
        HAVING
            sum( (
                    item.quantidade * produto.volume
                )
            ) > 3
    ) as leite
WHERE queijo.nome = leite.nome;

-- 8 Cidade onde moram os clientes, em ordem alfabética crescente.

SELECT DISTINCT endereco.cidade
FROM endereco, cliente
WHERE
    endereco.cep = cliente.cep
ORDER BY endereco.cidade ASC;

-- 9 Profissão de todos os clientes que são professores, engenheiros, ou gestores.

SELECT DISTINCT nome, profissao
FROM cliente
WHERE
    profissao LIKE '%professor%'
    OR profissao LIKE '%engenheiro%'
    OR profissao LIKE '%gestor%';

-- 10 Nome da rua dos clientes que compram queijo com valor maior que R$ 5,00 e menor que R$ 25,00.

SELECT
    DISTINCT endereco.logradouro
FROM
    endereco,
    cliente,
    compra,
    item,
    produto
WHERE
    endereco.cep = cliente.cep
    AND cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND produto.descricao LIKE '%queijo%'
    AND produto.preco BETWEEN 5 AND 25;

-- 11 Nome, Profissão e Sexo dos clientes que compram mais de 4 litros de leite cujo valor esteja entre R$ 1,00 e R$ 1,80.

SELECT
    cliente.nome,
    cliente.profissao,
    cliente.sexo
FROM
    cliente,
    compra,
    item,
    produto
WHERE
    cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND produto.descricao LIKE '%leite%'
    AND produto.preco BETWEEN 1 AND 1.8 --group
GROUP BY cliente.nome
HAVING
    sum( (
            item.quantidade * produto.volume
        )
    ) > 4;

-- 12 Nome, Profissão e Sexo dos clientes que compram mais de 4 litros de leite cujo valor esteja entre R$ 1,00 e R$ 1,80, ordenados pelo sexo.

SELECT
    cliente.nome,
    cliente.profissao,
    cliente.sexo
FROM
    cliente,
    compra,
    item,
    produto
WHERE
    cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND produto.descricao LIKE '%leite%'
    AND produto.preco BETWEEN 1 AND 1.8 --group
GROUP BY cliente.nome
HAVING
    sum( (
            item.quantidade * produto.volume
        )
    ) > 4
ORDER BY cliente.sexo ASC;

-- 13 Profissão dos clientes que compram leite e queijo, ordenado pelo Nome em ordem crescente.

SELECT
    DISTINCT cliente.nome,
    cliente.profissao
FROM
    cliente,
    compra,
    item,
    produto
WHERE
    cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND (
        produto.descricao LIKE '%leite%'
        OR produto.descricao LIKE '%queijo%'
    )
ORDER BY cliente.nome ASC;

-- 14 Produtos comprados pelos clientes que moram em Curitiba e que compram em quantidade maior que 5 unidades.

SELECT
    DISTINCT produto.descricao
FROM
    endereco,
    cliente,
    compra,
    item,
    produto
WHERE
    endereco.cep = cliente.cep
    and cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND endereco.cidade = 'Curitiba'
    AND item.quantidade > 5;

-- 15 Soma de todas as compras realizadas pelos clientes que moram em Curitiba.

SELECT
    COUNT(DISTINCT compra.codigo) as 'Quantidade Total de Compras',
    SUM(
        item.quantidade * produto.preco
    ) as 'Valor Total de Compras'
FROM
    endereco,
    cliente,
    compra,
    item,
    produto
WHERE
    endereco.cep = cliente.cep
    and cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND endereco.cidade = 'Curitiba';

-- 16 Lote dos produtos comprados pelos clientes cuja profissão seja professor.

SELECT DISTINCT produto.codLote
FROM
    cliente,
    compra,
    item,
    produto
WHERE
    cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND cliente.profissao LIKE '%professor%';

-- 17 Validade dos lotes cuja venda foi realizada para a cidade de Guarapuava.

SELECT
    DISTINCT lote.codigo,
    DATE_FORMAT(lote.dataValidade, '%d/%m/%Y') as 'Data de Validade'
FROM
    endereco,
    cliente,
    compra,
    item,
    produto,
    lote
WHERE
    endereco.cep = cliente.cep
    AND cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND produto.codLote = lote.codigo
    AND endereco.cidade = 'Guarapuava';

-- 18 Todos os lotes de todos os produtos.

SELECT produto.descricao, produto.codLote FROM produto;

-- 19 As quantidades de queijo compradas pelos clientes de Guarapuava

-- 20 A data e a quantidade de leite compradas pelos clientes que moram em Curitiba ou em Guarapuava.

SELECT
    cliente.nome,
    DATE_FORMAT(compra.dataCompra, '%d/%m/%Y') as 'Data da Compra',
    SUM(
        item.quantidade * produto.volume
    ) as 'Quantidade de Leite'
FROM
    endereco,
    cliente,
    compra,
    item,
    produto
WHERE
    endereco.cep = cliente.cep
    AND cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND (
        endereco.cidade = 'Curitiba'
        OR endereco.cidade = 'Guarapuava'
    )
    AND produto.descricao LIKE '%leite%'
GROUP BY
    cliente.nome,
    compra.dataCompra
ORDER BY 
    compra.dataCompra ASC;

-- 21 – Nome dos clientes que compraram queijo, bem como a data da compra e quantidade.

SELECT
    cliente.nome,
    DATE_FORMAT(compra.dataCompra, '%d/%m/%Y') as 'Data da Compra',
    item.quantidade
FROM
    cliente,
    compra,
    item,
    produto
WHERE
    cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
    AND produto.descricao LIKE '%queijo%'
ORDER BY cliente.nome ASC;

-- 22 Nome e cidade dos clientes, data da compra e tipo de pagamento, quantidade comprada e descrição dos produtos.

SELECT
    cliente.nome,
    endereco.cidade,
    DATE_FORMAT(compra.dataCompra, '%d/%m/%Y') as 'Data da Compra',
    compra.tipoPagamento,
    item.quantidade,
    produto.descricao
FROM
    endereco,
    cliente,
    compra,
    item,
    produto
WHERE
    endereco.cep = cliente.cep
    AND cliente.cpf = compra.cpfCliente
    AND compra.codigo = item.codCompra
    AND item.codProduto = produto.codigo
ORDER BY cliente.nome ASC;

-- 23 Compras efetuadas no segundo trimestre do ano.

SELECT * FROM compra WHERE MONTH(dataCompra) BETWEEN 4 AND 6;

-- 24 Nome e lote de todos os produtos que foram comprados com quantidade maior que 6.

SELECT
    DISTINCT produto.descricao,
    produto.codLote
FROM produto, item
WHERE
    produto.codigo = item.codProduto
    AND item.quantidade > 6;

-- 25 Lote, validade e descrição dos produtos que não foram comprados.

SELECT
    DISTINCT lote.codigo,
    DATE_FORMAT(lote.dataValidade, '%d/%m/%Y') as 'Data de Validade',
    produto.descricao
FROM produto, lote
WHERE
    produto.codLote = lote.codigo
    AND produto.codigo NOT IN (
        SELECT
            DISTINCT codProduto
        FROM item
    );