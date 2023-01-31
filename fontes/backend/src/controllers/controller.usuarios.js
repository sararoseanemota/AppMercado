//controlar as rotas de usuários
import { Router } from "express";
import db from "../config/database.js";

const controllerUsuarios = Router();

//validação de login 
controllerUsuarios.post("/usuarios/login", function(request, response){
    //body corpo da requisição
    let ssql = "select id_usuario, nome, email, endereco, bairro, cidade, uf, cep, date_format(dt_cadastro, '%d/%m/%Y %H:%i:%s') as dt_cadastro from usuario where email=? and senha=?"
    db.query(ssql,[request.body.email, request.body.senha], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(result.length > 0 ? 200 : 401).json(result[0]);
            // 401 não autorizado
        }
    });
});

//cadastro de usuario
controllerUsuarios.post("/usuarios/cadastro", function(request, response){
    //body corpo da requisição
    let ssql = "insert into usuario (nome, email, senha, endereco, bairro, cidade, uf, cep, dt_cadastro) values (?, ?, ?, ?, ?, ?, ?, ?, current_timestamp())"
    db.query(ssql,[request.body.nome, 
                   request.body.email,
                   request.body.senha,
                   request.body.endereco,
                   request.body.bairro,
                   request.body.cidade,
                   request.body.uf,
                   request.body.cep], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            //return response.status(201).json(result);
            return response.status(201).json({id_usuario: result.insertId});//o id do usuario gerado automaticamente 
        }
    });
});

//listando dados de um usuário
controllerUsuarios.get("/usuarios/:id_usuario", function(request, response){
    
    let ssql = "select * from usuario where id_usuario = ?" 
    db.query(ssql,[request.params.id_usuario], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(result.length > 0 ? 200 : 404).json(result[0]);
            //404 não encontrado o pedido solicitado
        }
    });
});

//alterar usuario
controllerUsuarios.put("/usuarios/:id_usuario", function(request, response){
    let ssql = "update usuario set nome=?, email=?, senha=?, endereco=?, bairro=?, " 
    ssql = ssql + " cidade=?, uf=?, cep=? where id_usuario=?" 
    db.query(ssql,[request.body.nome, 
                   request.body.email,
                   request.body.senha,
                   request.body.endereco,
                   request.body.bairro,
                   request.body.cidade,
                   request.body.uf,
                   request.body.cep,
                   request.params.id_usuario], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(200).json({id_usuario: request.params.id_usuario});
        }
    });
});

//listando dados de um pedido
controllerUsuarios.get("/usuarios/:id_usuario/pedidos", function(request, response){
    let filtro = []
    let ssql = "select * from pedido where id_usuario = ? " 

    filtro.push(request.params.id_usuario)

    if (request.query.id_pedido){
        ssql+= "and id_pedido = ? ";
        filtro.push(request.query.id_pedido) //acessando e inserindo os dados na array filtro
    }

    db.query(ssql,filtro, function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(result.length > 0 ? 200 : 404).json(result);
        }
    });
});


//TAREFAS........
//POST -> "/usuarios/cadastro"
//PUT -> "/usuarios/:id"
//DELETE -> "/usuarios/:id"

//exportar o módulo padrão controle de usuários para ter acesso
export default controllerUsuarios;