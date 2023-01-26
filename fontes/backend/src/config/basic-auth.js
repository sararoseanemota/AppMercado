import auth from "basic-auth";

function BasicAuth(req, res, next){
    const user= auth(req); //chamar o auth e passar na requisição o parametro que está chegando
    const username = "nutrifit";
    const password = "123456";

    if (user && user.name.toLowerCase() === username.toLowerCase() &&
        user.pass === password){ //verificar os parametros definidos
            next();
        }else{
            res.status(401).send("Acesso negado");
        }
}

export default BasicAuth;