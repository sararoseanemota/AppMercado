//controlar as rotas de usuários
import { Router } from "express";
import db from "../config/database.js";

const controllerMercados = Router();

//rotas - Query Params (/clientes?ordem=nome&top=100)...

//listar mercados
controllerMercados.get("/mercados", function(request, response){
    //padrão rest
    let filtro = []
    let ssql = "select * from mercado " 
    ssql = ssql + "where id_mercado > 0"

    if (request.query.busca){
        ssql = ssql + "and nome =? "
        filtro.push(request.query.busca) //acessando e inserindo os dados na array filtro
    }

    if (request.query.ind_entrega){
        ssql = ssql + "and ind_entrega =? "
        filtro.push(request.query.ind_entrega) //acessando e inserindo os dados na array filtro
    }

    if (request.query.ind_retira){
        ssql = ssql + "and ind_retira =? "
        filtro.push(request.query.ind_retira) //acessando e inserindo os dados na array filtro
    }

    db.query(ssql,filtro, function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(result.length > 0 ? 200 : 404).json(result[0]);
            //404 não encontrado o pedido solicitado
        }
    });
});

//listando dados do mercado
controllerMercados.get("/mercados/:id_mercado", function(request, response){
    
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



//exportar o módulo padrão controle de usuários para ter acesso
export default controllerMercados;