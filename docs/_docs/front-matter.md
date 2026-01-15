<!DOCTYPE html>
<html lang="ca">
<head>
<meta charset="UTF-8">
<title>Escape Room Banc Central</title>

<style>
body {
  margin: 0;
  background: #0e0e0e;
  color: white;
  font-family: Arial, sans-serif;
}

#game {
  max-width: 700px;
  margin: auto;
  padding: 20px;
  text-align: center;
}

h1 {
  color: gold;
}

input {
  padding: 10px;
  font-size: 16px;
  margin-top: 10px;
  width: 80%;
}

button {
  padding: 10px 20px;
  margin-top: 15px;
  font-size: 16px;
  cursor: pointer;
}

#msg {
  margin-top: 15px;
  font-weight: bold;
}

.ok { color: #00ff99; }
.no { color: #ff5555; }

#timer {
  font-size: 18px;
  margin-bottom: 10px;
  color: orange;
}
</style>
</head>

<body>

<div id="game">
  <h1>🏦 Escape Room</h1>
  <p>La cambra acorazada del Banc Central de Barcelona</p>
  <div id="timer">⏱ 60:00</div>

  <h2 id="title">Missió 1</h2>
  <p id="text">
    Desactiva les càmeres trobant la paraula secreta entre les lletres.
  </p>

  <input id="answer" placeholder="Resposta">
  <br>
  <button onclick="check()">Confirmar</button>
  <div id="msg"></div>
</div>

<script>
let m = 1;
let time = 3600;

const data = {
  1:["Missió 1","Paraula secreta per desactivar alarmes","CUIRASSADA"],
  2:["Missió 2","PIN de l’ascensor a la planta -2","1782"],
  3:["Missió 3","Contrasenya de l’ordinador del director","CLAUER"],
  4:["Missió 4","Endevinalla: lleugera i llegida per màquines","TARGETA"],
  5:["Missió 5","Números dins la guixeta","1069"],
  6:["Missió 6","Número de la clau del clauer","8"],
  7:["Missió 7","Codi de sortida. Pista: XI futbol","4231"],
  8:["Missió 8","Endevinalla del botí","BOTI"],
  9:["Missió 9","Codi final","7117"]
};

function load(){
  document.getElementById("title").innerText=data[m][0];
  document.getElementById("text").innerText=data[m][1];
  document.getElementById("answer").value="";
  document.getElementById("msg").innerText="";
}

function check(){
  let a=document.getElementById("answer").value.toUpperCase();
  if(a===data[m][2]){
    document.getElementById("msg").innerText="✔ Correcte";
    document.getElementById("msg").className="ok";
    m++;
    if(m>9){
      document.getElementById("game").innerHTML=
      "<h1>💰 BOTÍ ACONSEGUIT</h1><p>Heu escapat abans que arribi la policia!</p>";
    } else {
      setTimeout(load,800);
    }
  } else {
    document.getElementById("msg").innerText="❌ Incorrecte";
    document.getElementById("msg").className="no";
  }
}

setInterval(()=>{
  let min=Math.floor(time/60);
  let sec=time%60;
  document.getElementById("timer").innerText=
    "⏱ "+min+":"+sec.toString().padStart(2,"0");
  if(time<=0){
    document.body.innerHTML="<h1 style='color:red;text-align:center'>🚔 POLICIA ARRIBADA 🚔</h1>";
  }
  time--;
},1000);
</script>

</body>
</html>
