#########################################################################
# Author:  Kevin RAHETILAHY                                             #
# e-mail: kevin.rhtl@gmail.com                                          #
#########################################################################

#########################################################################
#                        Add shared_assemblies                          #
#########################################################################

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  | out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null
[System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')      | out-null


#########################################################################
#                        Load Main Panel                                #
#########################################################################



function LoadXaml ($filename){
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

$Global:my_application_path= split-path -parent $MyInvocation.MyCommand.Definition

$XamlMainWindow=LoadXaml($my_application_path+"\myForm.xaml")
$reader = (New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Script:Form = [Windows.Markup.XamlReader]::Load($reader)


#########################################################################
#                        Load Progressbar                               #
#########################################################################
."$my_application_path\progressbar.ps1"                                 #
#########################################################################


#########################################################################
#                        Action Button                                  #
#########################################################################
$CloseWindow    = $Form.Findname("CloseWindow")

$CloseWindow.Add_Click({
    $Form.close()
})

$LaunchButton    = $Form.Findname("LaunchButton")

$LaunchButton.Add_Click({
    # open the modal window
    Launch_progress_modal

    # pass the value
    for($i=0; $i -le 100; $i++){
        show_Progress -label "my command progress" -progress $i
    }

    # if you want an inderterminate progressbar, just add the inderteminate attribut
    # show_Progress -label "Please wait " -indeterminate $True 
})



#########################################################################
#                        Show Dialog                                    #
#########################################################################

$Form.add_MouseLeftButtonDown({
   $_.handled=$true
   $this.DragMove()

   # update window location
   $Global:syncProgress.WindowTop = $Form.Top
   $Global:syncProgress.WindowLeft = $Form.Left
})
     

$Form.ShowDialog() | Out-Null
  
