$story = @{ 
    type="video" 
    contentUrl="https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4" 
    author="Debugger" 
    caption="Verifying Video Playback (Trusted URL)" 
    hashtags=@("debug", "test") 
}

try {
    $body = $story | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "http://localhost:5000/api/feed" -Method Post -ContentType "application/json" -Body $body
    Write-Host "Uploaded Debug Video Story"
} catch {
    Write-Host "Failed to upload: $_"
}
