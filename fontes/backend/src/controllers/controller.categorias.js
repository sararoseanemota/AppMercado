//controlar as rotas de categorias
import { Router } from "express";
import db from "../config/database.js";

const controllerCategorias = Router();

//listar categorias
controllerCategorias.get("/categorias", function(request, response){
    
    let ssql = "select * from produto_categoria where id_categoria > 0" 
    db.query(ssql,[request.params.id_mercado], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(result.length > 0 ? 200 : 404).json(result[0]);
        }
    });
});

//exportar o módulo padrão controle de usuários para ter acesso
export default controllerCategorias;