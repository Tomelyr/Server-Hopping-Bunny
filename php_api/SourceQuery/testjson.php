<?php
$response = array();
require './SourceQuery/SourceQuery.class.php';

if (isset($_GET["ip"]) && isset($_GET["port"]))
{
	$ip = $_GET['ip'];
	$port = $_GET['port'];
	
	//JSON Header
	header('Content-Type: application/json');
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
		
		echo json_encode($response, JSON_PRETTY_PRINT);
		echo "test";
		
		
	}
	catch( Exception $e )
	{
		$response["succes"] = 0;
		$response["error"] = $e->getMessage( );
		echo "jsonerror";
		echo json_encode($response, JSON_PRETTY_PRINT);
	}
	$Query->Disconnect( );
}
?>