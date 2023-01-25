//importando o package express
import express from "express";
import cors from "cors";
import controllerUsuarios from "./controllers/controller.usuarios.js";


//não modificar a variavel e instanciando a variável e recebendo o package express
const app = express();

//Middleware JSON
app.use(express.json());

//Middleware CORS
app.use(cors());

//Controllers
app.use(controllerUsuarios);

//método para criar a lista na porta 
app.listen(3000, function(){
    console.log('Servidor no ar.');
});





