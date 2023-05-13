<?php

//Cargamos variables para entablar conexion con mysql
$dbhost = "localhost";
$dbuser = "jaime";
$dbpass = "";
$dbname = "irac";

//Trataremos la conexion con mysql como una variable: conn
$conn = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);

//Si por alguna razon no entabla conexion, nos lo indica con el error en concreto
if (!$conn) 
{
	die("No hay conexión: ".mysqli_connect_error());
}

//Cargamos variables del form del login para realizar las consultas a la BD
$user_login = $_POST["user_login"];
$pass_login = $_POST["password_login"];
$decoder        = $_POST["decoder"];
$user_signup = $_POST["user_signup"];
$pass_signup = $_POST["pass_signup"];
$nombre        = $_POST["nombre"];
$apellido = $_POST["apellido"];


//Realizamos consultas a la BD
if ($user_login != null && $pass_login != null) {

$query = mysqli_query($conn,"SELECT * FROM usuarios WHERE user = '".$user_login."' and password = '".$pass_login."'");
$nr = mysqli_num_rows($query);
}
else if ($user_login == null && $user_signup != null) {
$query = mysqli_query($conn,"INSERT INTO usuarios (nombre, apellido, user, password) VALUES ('".$nombre."', '".$apellido."', '".$user_signup."', '".$pass_signup."')");
$nr = 0;
}

//En caso de login exitoso
if($nr == 1)
{
    setcookie("decoder", $user_login, time()+3600, "/"); // suponiendo que el nombre de la cookie es "decoder" y se establece por una hora, es la clave del usuario
	header("Location: index.html");
	
}
//En caso de login no exitoso
else if ($nr == 0) 
{
	header("Location: login.html");
}
	
?>
