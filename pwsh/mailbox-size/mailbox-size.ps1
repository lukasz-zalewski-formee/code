# Connect-ExchangeOnline 

$output = @()

$pattern = "\((.*?)\)"

Get-Mailbox | Select-Object PrimarySmtpAddress | ForEach-Object {
    $user = $_.PrimarySmtpAddress

    $size = (Get-MailboxFolderStatistics $user | Where-Object {$_.FolderType -eq "Inbox"}).FolderSize

    $size = [Regex]::Matches($size, $pattern).Value
    $size = [long]($size -replace "bytes","" -replace "[\(*\)]","" -replace ",","" -replace " ", "")

    $size /= 1GB

    $output += [PSCustomObject]@{
        User = $user
        Size = $size
    }
}

$output = $output | Sort-Object Size -Descending

$output | ForEach-Object {$_.Size = "$($_.Size) GB"}






