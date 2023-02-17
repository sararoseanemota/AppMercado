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

controllerPedidos.post("/pedidos", function(req, res){
    

    db.getConnection(function(err, conn){

        conn.beginTransaction(function(err){

            //desestruturação
            const {id_mercado, id_usuario, dt_pedido, vl_subtotal, vl_entrega, vl_total, endereco, bairro, cidade, uf, cep} = req.body;

            let ssql = "insert into pedido (id_mercado, id_usuario, dt_pedido, vl_subtotal, vl_entrega,  "
            ssql += " vl_total, endereco, bairro, cidade, uf, cep)"; 
            ssql += "values(?, ?, current_timestamp(), ?, ?, ?, ?, ?, ?, ?, ?) ";

            conn.query(ssql,[id_mercado, id_usuario, vl_subtotal, vl_entrega, vl_total, 
                            endereco, bairro, cidade, uf, cep], function(err, result){
                if (err){
                    conn.rollback(); //fechar a transação
                    return res.status(500).send(err);
                }else{
                    let id_pedido = result.insertId;

                    ssql = "insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total)"
                    ssql += "values (?, ?, ?, ?, ?)"

                    //itens do pedido...
                    req.body.itens.map(function(item){
                        conn.query(ssql, [], function(err, result){

                        })


                    });



                    conn.commit(); // salvar no banco 
                    return res.status(201).json({id_pedido}); //"id_pedido" : 123456
                }
            });

        });

    });



   
    
});

//exportar o módulo padrão controle de pedidos para ter acesso
export default controllerPedidos;