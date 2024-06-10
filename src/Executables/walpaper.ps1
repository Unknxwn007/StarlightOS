$imgPath = "wallpapers\starlight-4k.png"

if (Test-Path $imgPath) {
    $code = @'
    using System.Runtime.InteropServices; 
    namespace Win32{ 
        public class Wallpaper{ 
            [DllImport("user32.dll", CharSet=CharSet.Auto)] 
            static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni) ; 
 
            public static void SetWallpaper(string thePath){ 
                SystemParametersInfo(20,0,thePath,3); 
            }
        }
    } 
'@

    add-type $code 

    #Apply the Change on the system 
    [Win32.Wallpaper]::SetWallpaper((Get-Item $imgPath).FullName)
} else {
    Write-Host "Image file not found in: $(Split-Path $imgPath -Parent)"
}