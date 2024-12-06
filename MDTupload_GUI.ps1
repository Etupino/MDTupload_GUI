Add-type -AssemblyName System.Windows.Forms

$sharedFolder = '\\config-nas03-16\backup$\SHI_DEV'

if(-not (Test-Path $sharedFolder)){
    [System.Windows.Forms.MessageBox]::Show("the folder path $sharedFolder is not accessible")
    exit
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "MDT Uploads Select from the Dropdown Menu"
$form.Size = New-Object System.Drawing.Size (700, 200)

$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point (20,20)
$comboBox.Size = New-Object System.Drawing.Size (620, 10)


$scripts = Get-ChildItem -Path $sharedFolder -filter "*.ps1" | ForEach-Object {$_.FullName}
$comboBox.Items.AddRange($scripts)

$runButton = New-Object System.Windows.Forms.Button
$runButton.Text = "Run Script"
$runButton.Location = New-Object System.Drawing.Point (20,70)
$runButton.Size = New-Object System.Drawing.Size (100, 30)


$runButton.Add_Click({
    $selectedScript = $comboBox.SelectedItem
    if ($null -ne $selectedScript) {
        try{
            Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy', 'Bypass', '-File', $selectedScript -Wait
            [System.Windows.Forms.MessageBox]::Show("Finish running the selected script!")
        }catch{
            [System.Windows.Forms.MessageBox]::Show("An error occurred while running the selected script! : S_")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a script")
    
        
    }
})

$form.Controls.Add($comboBox)
$form.Controls.Add($runButton)

$form.Add_Shown({$form.Activate()})
[void] [System.Windows.Forms.Application]:: Run($form)
