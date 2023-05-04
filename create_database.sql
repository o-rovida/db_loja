CREATE DATABASE db_loja;

USE db_loja;

CREATE TABLE endereco (
	cep CHAR(8) PRIMARY KEY,
	uf CHAR (2),
	cidade VARCHAR (255),
	bairro VARCHAR(255),
	logradouro VARCHAR (255)
);



CREATE TABLE cliente (
	cpf CHAR(11) PRIMARY KEY,
	cep CHAR(8), FOREIGN KEY (cep) REFERENCES endereco(cep),
	complemento VARCHAR (255),
	nome VARCHAR (255),
	dataNasc DATE,
	profissao VARCHAR (255),
	email VARCHAR (255) UNIQUE,
	telefone VARCHAR (255) UNIQUE,
	sexo CHAR (1)
);

CREATE TABLE compra (
	codigo SMALLINT AUTO_INCREMENT PRIMARY KEY,
	cpfCliente CHAR(11), FOREIGN KEY (cpfCliente) REFERENCES cliente(cpf),
	dataCompra DATE
);

CREATE TABLE lote (
	codigo SMALLINT PRIMARY KEY,
	dataFab DATE,
	dataValidade DATE);

CREATE TABLE produto (
	codigo SMALLINT AUTO_INCREMENT PRIMARY KEY,
	codLote SMALLINT, FOREIGN KEY (codLote) REFERENCES lote(codigo),
	peso FLOAT(6,4),
	volume FLOAT (6,4),
	preco FLOAT (4,2)
);

CREATE TABLE item (
	codigo SMALLINT AUTO_INCREMENT PRIMARY KEY,
	codCompra SMALLINT, FOREIGN KEY (codCompra) REFERENCES compra(codigo),
	codProduto SMALLINT, FOREIGN KEY (codProduto) REFERENCES produto(codigo),
	quantidade SMALLINT(4));