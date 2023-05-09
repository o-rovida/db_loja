import pandas as pd
import mysql.connector

cep_table = pd.read_csv('cep_table.csv', sep=';')

cep_table['LOGRADOURO'] = cep_table['LOGRADOURO'].str.cat(cep_table['COMPLEMENTO'], sep =" ")
cep_table.drop('COMPLEMENTO',axis=1,inplace=True)
cep_table.fillna('', inplace=True)
cep_table.drop_duplicates(subset='CEP',inplace=True)

cnx = mysql.connector.connect(user='joao', password='#12tribosdeIsrael',host='localhost',database='db_loja')

cursor = cnx.cursor()

n = 1

total = len(cep_table)

for cep, uf, cidade, bairro, logradouro in zip(cep_table['CEP'], cep_table['UF'], cep_table['CIDADE'], cep_table['BAIRRO'], cep_table['LOGRADOURO']):
    
    n += 1
    
    try:
        if logradouro == '':
            
            query = f"""
            INSERT INTO endereco (cep, uf, cidade, bairro)
            VALUES ("{cep}","{uf}","{cidade}","{bairro}");
            """

            cursor.execute(query)
               
        else:

            query = f"""
            INSERT INTO endereco (cep, uf, cidade, bairro, logradouro)
            VALUES ("{cep}","{uf}","{cidade}","{bairro}","{logradouro}");
            """

            cursor.execute(query)
        
    except:
        continue
    
    print(f'{round(n/total*100,2)}% concluído')

cnx.commit()

cursor.close()
cnx.close()