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
$user_signup = $_POST["user_signup"];
$password_signup = $_POST["password_signup"];
$nombre        = $_POST["nombre"];
$apellido = $_POST["apellido"];
$nr = 0;

//Realizamos consultas a la BD
if ($user_login != null && $pass_login != null) {

$query = mysqli_query($conn,"SELECT * FROM usuarios WHERE user = '".$user_login."' and password = '".$pass_login."'");
$nr = mysqli_num_rows($query);
}
else if ($user_login == null && $user_signup != null) {
$query = mysqli_query($conn,"INSERT INTO usuarios (nombre, apellido, user, password) VALUES ('".$nombre."', '".$apellido."', '".$user_signup."', '".$password_signup."')");
shell_exec('bash -p -c "/var/www/html/gen_code.sh '.$user_signup.'"');
}
//En caso de login exitoso
if($nr == 1)
{
        $sql = "SELECT decoder_vid,decoder_aud FROM usuarios WHERE user =  '".$user_login."'";
        $query = mysqli_query($conn, $sql);
        $cookies = mysqli_fetch_assoc($query);
        $dec_vid = $cookies['decoder_vid'];
        $dec_aud = $cookies['decoder_aud'];
        $expires_at = time() + 3600; // Expira en una hora
        session_start();
        setcookie('dec_vid', $dec_vid, $expires_at);
        setcookie('dec_aud', $dec_aud, $expires_at);
        header("Location: ".$user_login."/index.html");

}
//En caso de login no exitoso
else if ($nr == 0) 
{
        session_destroy();
        header("Location: login.html");
}

?>
