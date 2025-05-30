<?php
define("CACHE_PLACE_PATH", "/var/lib/freshrss");
# Don't particularly care about auth here, this is behind TS anyways.
define("ACCESS_TOKEN", "your_access_token");
# Also possible:
# define("CACHE_PLACE_PATH", "C:\\your\\Directory");
# define("CACHE_PLACE_PATH", "/var/www/html/directory");
# Remember to set correct privileges allowing PHP access.
function join_paths(...$paths)
{
    return preg_replace('~[/\\\\]+~', DIRECTORY_SEPARATOR, implode(DIRECTORY_SEPARATOR, $paths));
}

;

function get_name($url)
{
    $tmp_path = join_paths(CACHE_PLACE_PATH, "piccache");
    if (!file_exists($tmp_path)) mkdir(join_paths($tmp_path), 0777);
    return join_paths($tmp_path, hash('sha256', $url));
}

function is_strict_url($url)
{
    $valid = filter_var($url, FILTER_VALIDATE_URL);
    if ($valid === false) return false;

    $parsed_url = parse_url($url);
    // Must be http or https
    if (!in_array($parsed_url['scheme'], array('http', 'https'))) return false;

    return true;
}

function get($url)
{
    return file_exists(get_name($url)) ? get_name($url) : null;
}

function set($url)
{
    $file_name = get_name($url);
    $content = file_get_contents($url);
    file_put_contents($file_name, $content);
    return $file_name;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $post = json_decode(file_get_contents('php://input'), true);
    if (!$post || !array_key_exists("url", $post) || !array_key_exists("access_token", $post)) {
        http_response_code(400);
        exit();
    }
    if ($post['access_token'] !== ACCESS_TOKEN) {
        http_response_code(403);
        exit();
    }
    if (!is_strict_url($post['url'])) {
        http_response_code(400);
        exit();
    }
    set($post['url']);
    header('Content-Type: application/json; charset=utf-8');
    echo '{"status": "OK"}' . PHP_EOL;
    exit();
} elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $url = $_GET['url'];
    if (!$url || !is_strict_url($url)) {
        http_response_code(400);
        exit();
    }
    $file = get($url);
    header("X-Piccache-Status: " . ($file ? "HIT" : "MISS"));
    if (!$file) $file = set($url);
    $finfo = finfo_open(FILEINFO_MIME);
    header('Content-Type: ' . finfo_file($finfo, $file));
    finfo_close($finfo);
    header('Content-Length: ' . filesize($file));
    $fp = fopen($file, 'rb');
    fpassthru($fp);
    exit();
} else {
    http_response_code(405);
    exit();
}
?>
