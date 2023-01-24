//importando o package express
import express from 'express';
import cors from 'cors';
import mysql from 'mysql';

//não modificar a variavel e instanciando a variável e recebendo o package express
const app = express();

//conexão com o banco 
const db = mysql.createPool({
    host:  "localhost",
    user: "root",
    password: "123456",
    database: "meu_mercado"
});

//Middleware JSON
app.use(express.json());

//Middleware CORS
app.use(cors());

//executar requisição com get, vai retornar a função
/*
    Verbos HTTP
    --------------------
    GET -> Retornar dados
    POST -> Cadastrar dados
    PUT -> Editar dados de todos os registros
    PATCH -> Editar dados de alguns registros
    DELETE -> Excluir dados
*/

//rotas - Query Params (/clientes?ordem=nome&top=100)...
app.get("/usuarios", function(request, response){
    
    let ssql = "select * from usuario" 
    db.query(ssql, function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(200).json(result);
        }
    })
});

// URI Params...(/clientes/123) Parametros de identificação de recursos 
app.get("/clientes/:id", function(request, response){
    return response.send("Listando somente o cliente: " + request.params.id);
});

app.post("/clientes", function(request, response){
    //acessando o corpo da requisição e inserindo na variavel
    const body = request.body;
    return response.send("Cadastrando um cliente: " +  body.nome + ' - ' + body.email);
});

app.put("/clientes", function(request, response){
    return response.send("Alterando um cliente com o PUT");
});

app.patch("/clientes", function(request, response){
    return response.send("Alterando um cliente com o PATCH");
});

app.delete("/clientes", function(request, response){
    return response.send("Excluindo clientes");
});

app.get("/produtos", function(request, response){
    return response.send("Listando todos os produtos...");
});

//método para criar a lista na porta 
app.listen(3000, function(){
    console.log('Servidor no ar.');
});

//compilar automaticamente nodemon



