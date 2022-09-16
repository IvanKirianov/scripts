### Install Module yaml
Write-Host "Install Module yaml" -ForegroundColor Green
Install-Module powershell-yaml -Repository PSGallery -Scope CurrentUser -Force
$envFilePath = "./folder/env.yaml"
$valuesFilePath = "./folder/values.template.app.yaml"
$additionalJsonConfigFiles = @("./folder/template.json")

$variables = get-content $envFilePath

foreach ($file in $additionalJsonConfigFiles) {
    $fileContent = Get-Content $file
    foreach ($setting in $variables.GetEnumerator()) {
        ####Replace In Addition Config Files
        $setting = $setting -split ": "
        $fileContent = $fileContent -replace (('\${' + $setting[0] + '}'), $setting[1])
    }

    $fileContent | Out-File -Encoding utf8  $file -Force
}

$valuesContent = Get-Content $valuesFilePath
foreach ($setting in $variables.GetEnumerator()) {
    $setting = $setting -split ": "
    $valuesContent = $valuesContent -replace (('\${' + $setting[0] + '}'), $setting[1])
}
Write-Host $valuesContent
$valuesContent | Out-File $valuesFilePath