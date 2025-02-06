# Function - Converts a string to a valid file name, replacing forbidden characters with alternative, visually similar ones.
Function ConvertTo-ValidFileName {
    Param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateLength(1, 32767)]
        [Alias('Input','InputString','Text','InputText','FileName','FullName','LiteralPath','Path','BaseName','Extension')]
        [String]$String,

        [Switch]$IsPath, # Do not replace backslashes

        [Switch]$TrimStart,

        [Switch]$TrimBackslash
    )

    Begin {
        $ControlCodesReplacement = ' ☺☻♥♦♣♠•◘○◙♂♀♪♫☼►◄↕‼¶§▬↨↑↓→←∟↔▲▼'.ToCharArray()
        $ReplacementCharacters = @{}
        For ($Index = 1; $Index -le 31; $Index ++) {
            $ReplacementCharacters[[Char]$Index] = $ControlCodesReplacement[$Index]
        }
        $ReplacementCharacters += @{
            [Char]'"' = '“';
            [Char]'*' = '﹡';
            [Char]'/' = '⧸';
            [Char]'<' = '﹤';
            [Char]'>' = '﹥';
            [Char]'?' = '？';
            [Char]'|' = '｜'
        }
    }

    Process {
        If (($TrimStart.IsPresent) -and ($String.Length -gt 1)) {
            $String = $String.TrimStart()
        }

        $String = $String.TrimEnd()
        If ($String.Length -eq 0) {
            Throw 'Invalid input (zero length file name after trimming).'
        }

        If (($TrimBackslash.IsPresent) -and ($String.Length -gt 1)) {
            $String = $String.Trim('\').TrimEnd()
            If ($String.Length -eq 0) {
                Throw 'Invalid input (zero length file name after trimming).'
            }
        }

        $Extension = If (($String.Contains('.')) -and ($String[-1] -ne '.') -and ((-not $IsPath.IsPresent) -or (($IsPath.IsPresent) -and ($String.LastIndexOf('.') -gt $String.LastIndexOf('\'))))) {
            $String.Substring($String.LastIndexOf('.'))
        }
        Else {
            $Null
        }
        $BaseName = $String.Substring(0, ($String.Length - $Extension.Length))

        $BaseName = $BaseName.Replace(':','：')
        If ($IsPath.IsPresent) {
            If (($BaseName.Length -ge 3) -and ($BaseName[0] -match '[A-z]') -and ($BaseName[1] -eq '：') -and ($BaseName[2] -eq '\')) {
                $BaseName = $BaseName.Remove(1,1).Insert(1,':')
            }
        }
        Else {
            $BaseName = $BaseName.Replace('\','⧹')
        }
        $BaseName = $BaseName -replace '\.{3,}','…'

        If ($Null -ne $Extension) {
            $Extension = $Extension.Replace(':','：').Replace('\','⧹')
        }

        $FileNameCharArray = @(
            ForEach ($Character in "$BaseName$Extension".ToCharArray()) {
                $ReplacementCharacters[$Character] ?? $Character
            }
        )
        If ($FileNameCharArray[-1] -eq '.') {
            $FileNameCharArray[-1] = '．'
        }

        [String]::New($FileNameCharArray)
    }
}
