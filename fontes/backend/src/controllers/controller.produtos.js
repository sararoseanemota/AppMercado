//controlar as rotas de produtos
import { Router } from "express";
import db from "../config/database.js";

const controllerProdutos = Router();

//listar produtos
controllerProdutos.get("/produtos/:id_produto", function(request, response){
    
    let ssql = "select * from produto where id_produto = ? " 
    db.query(ssql,[request.params.id_produto], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(result.length > 0 ? 200 : 404).json(result[0]);
        }
    });
});

//exportar o módulo padrão controle de produtos para ter acesso
export default controllerProdutos;