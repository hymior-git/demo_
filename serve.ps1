# File khởi động máy chủ phục vụ web trên mạng Wi-Fi nội bộ
$port = 8080
$prefix = "http://*:$port/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
} catch {
    # Nếu cần quyền admin cho *, đổi sang localhost
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://localhost:$port/")
    $listener.Start()
}

$localIp = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null }).IPv4Address.IPAddress
Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  MÁY CHỦ WEB ĐÃ KHỞI CHẠY THÀNH CÔNG!" -ForegroundColor Yellow
Write-Host "  - Trên máy tính mở: http://localhost:$port" -ForegroundColor Cyan
if ($localIp) {
    Write-Host "  - Trên iPhone (cùng mạng Wi-Fi) mở Safari: http://$($localIp):$port" -ForegroundColor Green
}
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "Nhấn Ctrl + C để dừng máy chủ."
Write-Host ""

$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    
    $rawPath = $request.Url.LocalPath.TrimStart('/')
    if ([string]::IsNullOrEmpty($rawPath) -or $rawPath -eq "/") {
        $rawPath = "index.html"
    }
    
    $filePath = Join-Path $baseDir $rawPath
    
    if (Test-Path $filePath -PathType Leaf) {
        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
        $contentType = switch ($ext) {
            ".html" { "text/html; charset=utf-8" }
            ".css"  { "text/css" }
            ".js"   { "application/javascript" }
            ".json" { "application/json" }
            ".jpg"  { "image/jpeg" }
            ".jpeg" { "image/jpeg" }
            ".png"  { "image/png" }
            ".ipa"  { "application/octet-stream" }
            default { "application/octet-stream" }
        }
        
        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentType = $contentType
        $response.ContentLength64 = $bytes.Length
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $response.StatusCode = 404
        $notFoundMsg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
        $response.OutputStream.Write($notFoundMsg, 0, $notFoundMsg.Length)
    }
    $response.Close()
}
