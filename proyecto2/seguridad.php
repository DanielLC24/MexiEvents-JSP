<?php 
session_start();
if(isset($_SESSION["roll"])){
    if ($_SESSION["roll"] == "admin"){
        //echo "Bienvenido: " . $_SESSION["nom"];
    }else{
        header("Location: login.php");
    }
}else{
    header("Location: login.php");
}
?>