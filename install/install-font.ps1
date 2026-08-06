#setting font
$fontName = "MesloLGL Nerd Font"
oh-my-posh font install meslo | Invoke-Expression

$fontInput = '{ "face":"FONT_NAME" }';
$fontInput = $fontInput.Replace('FONT_NAME', $fontName)

$fontConfig = $fontInput | ConvertFrom-Json

if($null -ne $terminalSettings.profiles.defaults.font) {
    $terminalSettings.profiles.defaults.font = '{}' | ConvertFrom-Json
}

if($null -eq $terminalSettings.profiles.defaults.font) {
    $terminalSettings.profiles.defaults | add-member -Name "font" -value ($fontConfig) -MemberType NoteProperty
} else {
    if($null -eq $terminalSettings.profiles.defaults.font.face) {
        $terminalSettings.profiles.defaults.font | add-member -Name "face" -value ($fontName) -MemberType NoteProperty
    } else {
        $terminalSettings.profiles.defaults.font.face = $fontName
    }
}
