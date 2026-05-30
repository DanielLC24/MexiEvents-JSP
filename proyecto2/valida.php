<?php
include "lib/sql.php";
$usuario = isset($_POST["usuario"])?$_POST["usuario"]:"";
$pass = isset($_POST["pass"])?$_POST["pass"]:"";

//echo "<br>usuario:" .$usuario;
//echo "<br>pass:" .$pass;
session_start();
$conn = new sql();
$roll = "";
$pass2 = "";
$result = $conn->select("SELECT * FROM usuario where nom='".$usuario."'");
if($result->num_rows > 0){
    while($row = $result->fetch_assoc()){
        $pass2 = $row["pass"];
        $roll = $row["roll"];
    }
}

if ($pass2 != "" && $pass === $pass2) {
    $_SESSION["nom"] = $usuario;
    $_SESSION["roll"] = $roll;
    header("Location: index.php");
}
else{
    header("Location: login.php");
}