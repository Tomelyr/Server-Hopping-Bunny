<?php
$response = array();
include "./SourceQuery/SourceQuery.class.php";
header("Content-type: application/json");

function checkmap($url){
	$ch = curl_init($url);
	curl_setopt($ch, CURLOPT_NOBODY, true);
	curl_exec($ch);
	$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);

	if ($code == 200) {
		$status = true;
	} else {
		$status = false;
	}

	curl_close($ch);
	return $status;
}

if (isset($_GET["ip"]) && isset($_GET["port"])) {
	$ip = $_GET["ip"];
	$port = $_GET["port"];

	//SourceQuery
	define("SQ_SERVER_ADDR", $ip);
	define("SQ_SERVER_PORT", $port);
	define("SQ_TIMEOUT",     1);
	define("SQ_ENGINE",      SourceQuery :: SOURCE);

	//Grab the info
	$Query = new SourceQuery();

	try {
		$Query->Connect(SQ_SERVER_ADDR, SQ_SERVER_PORT, SQ_TIMEOUT, SQ_ENGINE);

		//$players = $Query->GetPlayers();
		$info = $Query->GetInfo();
		$map = $info["Map"];
		$players = $info["Players"];
		$maxplayers = $info["MaxPlayers"];
		$url = "http://image.www.gametracker.com/images/maps/160x120/garrysmod/" . $info["Map"] . ".jpg";

		$response["mapurl"] = checkmap($url);
		$response["success"] = true;
		$response["players"] = $players;
		$response["map"] = $map;
		$response["maxplayers"] = $maxplayers;
		$response["name"] = $info["HostName"];

		$json = json_encode($response);
		echo $json;
	}
	catch (Exception $e) {
		$response["success"] = false;
		$response["error"] = $e->getMessage();
		$json = json_encode($response);
		echo $json;
	}
	$Query->Disconnect();
}
?>
