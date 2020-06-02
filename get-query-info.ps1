$langs = @('cpp', 'java', 'javascript', 'csharp', 'python', 'go')
$suites = @('code-scanning', 'security-and-quality', 'security-extended')
Write-Output "File, Suite, Query name, Query ID, Kind, Severity, Precision"
foreach ($suite in $suites) {
  foreach ($lang in $langs) { 
    
    $searchPath = ".:../codeql-go"

    $temp = codeql resolve queries $lang-$suite.qls --search-path $searchPath
    
    foreach ($file in $temp) {
      $metadata = ConvertFrom-Json (codeql resolve metadata $file | out-string)

      $currentDirectory = (Get-Location).Path
      $file = $file.Replace($currentDirectory, "github/codeql");
      $line = "$file, $suite, $($metadata.name), $($metadata.id), $($metadata.kind), $($metadata.'problem.severity'), $($metadata.precision)"
      Write-Output $line
    }
  }  
}

