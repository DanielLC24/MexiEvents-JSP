<?php
class sql {
    public $conn;

    public function __construct(){
        $user = "root";
        $pass = "";
        $serv = "localhost";
        $db = "base2025";

        $this->conn = new mysqli($serv, $user, $pass, $db);

        // Comprobar conexión
        if ($this->conn->connect_error) {
            die("Conexión fallida: " . $this->conn->connect_error);
        }
    }
    
    // Para SELECT
    public function select($sql){
        $result = $this->conn->query($sql);
        return $result;
    }

    // Para UPDATE, DELETE, INSERT
    public function execute($sql){
        if ($this->conn->query($sql) === TRUE) {
            return true;
        } else {
            return "Error: " . $this->conn->error;
        }
    }
}
?>
