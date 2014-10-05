<?php
$response = array();
include './SourceQuery/SourceQuery.class.php';
header('Content-type: application/json');

if (isset($_GET["ip"]) && isset($_GET["port"]))
{
	$ip = $_GET['ip'];
	$port = $_GET['port'];

	//SourceQuery
	
	define( 'SQ_SERVER_ADDR', $ip )
	define( 'SQ_SERVER_PORT', $port );
	define( 'SQ_TIMEOUT',     1 );
	define( 'SQ_ENGINE',      SourceQuery :: SOURCE );
	
	//Grab the info
	$Query = new SourceQuery( );
	
	try
	{
		$Query->Connect( SQ_SERVER_ADDR, SQ_SERVER_PORT, SQ_TIMEOUT, SQ_ENGINE );
		
		//$players = $Query->GetPlayers( );
		$info = $Query->GetInfo( );
		$map = $info["Map"];
		$players = $info["Players"];
		$maxplayers = $info["MaxPlayers"];
		
		$response["succes"] = 1;
		$response["players"] = $players;
		$response["map"] = $map;
		$response["maxplayers"] = $maxplayers;
		
		$json = json_encode($response);
		echo $json;
		
		
	}
	catch( Exception $e )
	{
		$response["succes"] = 0;
		$response["error"] = $e->getMessage( );
		$json = json_encode($response);
		echo $json;
	}
	$Query->Disconnect( );
}
?>