//controlar as rotas de pedidos
import { Router } from "express";
import db from "../config/database.js";

const controllerPedidos = Router();

//listando dados de um pedido
controllerPedidos.get("/pedidos/:id_pedido", function(request, response){
    
    let ssql = "select * from pedido where id_pedido = ?" 
    db.query(ssql,[request.params.id_pedido], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(200).json(result[0]);
        }
    });
});

controllerPedidos.post("/pedidos", function(request, response){
    

    db.getConnection(function(err, conn){
        conn.beginTransactions;
    });



    let ssql = "select * from pedido where id_pedido = ?" 
    db.query(ssql,[request.params.id_pedido], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(200).json(result[0]);
        }
    });
});

//exportar o módulo padrão controle de pedidos para ter acesso
export default controllerPedidos;