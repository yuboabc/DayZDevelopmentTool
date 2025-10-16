# 强制终止进程（仅存在时操作）
"DayZ_x64", "DayZServer_x64", "DayZDiag_x64", "DayZDiag_x64-Server" | ForEach-Object {
    if (Get-Process $_ -ErrorAction SilentlyContinue) {
        Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue
    }
}



## 联动虚拟机调试，发送终止信号
# $ip = "192.168.31.154"
# $port = 5000
# $url = "http://$($ip):$port/kill/dayz_x64.exe"

# function Test-Port {
#     param($ip, $port, $timeout=500)
#     try {
#         $tcpClient = New-Object System.Net.Sockets.TcpClient
#         $connectTask = $tcpClient.ConnectAsync($ip, $port)
#         if ($connectTask.Wait($timeout)) {
#             return $tcpClient.Connected
#         } else {
#             return $false
#         }
#     } catch {
#         return $false
#     } finally {
#         if ($tcpClient -ne $null) {
#             $tcpClient.Dispose()
#         }
#     }
# }

# if (Test-Port -ip $ip -port $port -timeout 500) {
#     try {
#         $response = Invoke-WebRequest -Uri $url -TimeoutSec 2 -ErrorAction Stop
#         Write-Output "请求成功：状态码 $($response.StatusCode)"
#     } catch [System.Net.WebException] {
#         Write-Output "HTTP请求失败：$($_.Exception.Message)"
#     } catch {
#         Write-Output "其他错误：$($_.Exception.Message)"
#     }
# } else {
#     Write-Output "端口未开放"
# }