import mysql from "mysql";

//conexão com o banco 
const db = mysql.createPool({
    host:  "localhost",
    user: "root",
    password: "12345",
    database: "meu_mercado"
});

//exportar módulo padrão 
export default db;