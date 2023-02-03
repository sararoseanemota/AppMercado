//controlar as rotas de mercados
import { Router } from "express";
import db from "../config/database.js";

const controllerMercados = Router();

//listando dados de um mercado
controllerMercados.get("/mercados/:id_mercado", function(request, response){
    
    let ssql = "select * from mercado where id_mercado = ?" 
    db.query(ssql,[request.params.id_mercado], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(result.length > 0 ? 200 : 404).json(result[0]);
        }
    });
});

//listar mercados
controllerMercados.get("/mercados", function(request, response){
    //padrão rest
    let filtro = []
    let ssql = "select * from mercado" 
    ssql = ssql + " where id_mercado > 0"

    if (request.query.busca){
        ssql = ssql + " and nome like ? "
        filtro.push('%'+ request.query.busca + '%') //acessando e inserindo os dados na array filtro
    }

    if (request.query.ind_entrega){
        ssql = ssql + " and ind_entrega =?"
        filtro.push(request.query.ind_entrega) //acessando e inserindo os dados na array filtro
    }

    if (request.query.ind_retira){
        ssql = ssql + " and ind_retira =?"
        filtro.push(request.query.ind_retira) //acessando e inserindo os dados na array filtro
    }

    db.query(ssql,filtro, function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(200).json(result);
        }
    });
});

//listar categorias de um mercado
controllerMercados.get("/mercados/:id_mercado/categorias", function(request, response){
    
    let ssql = "select distinct c.id_categoria, c.descricao ";
    ssql += "from produto_categoria c "; 
    ssql += "join produto p on (p.id_categoria = c.id_categoria) ";
    ssql += "where p.id_mercado = ? ";
    //ssql += "order by c.ordem ";

    db.query(ssql,[request.params.id_mercado], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(200).json(result);
        }
    });
});

//listar produtos de um mercado
controllerMercados.get("/mercados/:id_mercado/produtos", function(request, response){
    let filtro = [];

    let ssql = "select p.* ";
    ssql+= "from produto p ";
    ssql+= "where p.id_mercado = ? ";

    filtro.push(request.params.id_mercado);

    if (request.query.busca){
        ssql+= "and p.nome like ? ";
        filtro.push('%'+ request.query.busca + '%') //acessando e inserindo os dados na array filtro
    }
    
    if (request.query.id_categoria){
        ssql+= "and p.id_categoria = ?"; 
        filtro.push(request.query.id_categoria) //acessando e inserindo os dados na array filtro
    }
  

    db.query(ssql,filtro, function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(200).json(result);
        }
    });
});

//exportar o módulo padrão controle de mercados para ter acesso
export default controllerMercados;

