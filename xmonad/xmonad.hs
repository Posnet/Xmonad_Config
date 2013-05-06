import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageHelpers (composeOne, isFullscreen, isDialog,  doFullFloat, doCenterFloat)
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Layout.PerWorkspace
import XMonad.ManageHook
import Control.Monad (liftM,liftM2, zipWithM_)
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicHooks
import qualified Data.Map as M
import qualified XMonad.StackSet as W

main = do
        xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobar/.xmobarrc"
        xmonad $ defaultConfig
                { borderWidth           = 5
                , terminal              = "xterm"
                , normalBorderColor     =  "#201030" --"#cccccc"
                , focusedBorderColor    =  "#5f5fee" -- "#306EFF"
                , manageHook            = myManageHook <+> manageDocks <+> dynamicMasterHook
                , layoutHook            = avoidStruts  $  layoutHook defaultConfig
                , logHook = dynamicLogWithPP xmobarPP
                                { ppOutput = hPutStrLn xmproc
                                , ppTitle = xmobarColor "#F88017" "" . shorten 50
                                }
                , workspaces = myWorkspaces
                --, modMask    = mod4Mask -- rebind Mod to Windows Key
                }
                `additionalKeys`
                [ --(( mod4Mask .|. shiftMask, xK_z), spawn "slimlock"),
                  (( controlMask, xK_Print ), spawn "sleep .2 scrot -s")
                , (( 0, xK_Print), spawn "scrot")
                , (( controlMask, xK_F11), spawn "amixer  set Master 2dB-")
                , (( controlMask, xK_F12), spawn "amixer  set Master 2dB+")
                , (( controlMask .|. mod4Mask, xK_l), spawn "xautolock -locknow")
                , (( mod1Mask, xK_f), spawn "pcmanfm")
                , (( controlMask .|. shiftMask, xK_F9), spawn "~/.scripts/fan_decrease.sh")
                , (( controlMask .|. shiftMask, xK_F10), spawn "~/.scripts/fan_increase.sh")
                --, (( controlMask, xK_l, xK_p), spawn "xautolock -toggle")
                -- media control keys
                , (( controlMask .|. shiftMask, xK_period), spawn "mocp -f")
                , (( controlMask .|. shiftMask, xK_comma), spawn "mocp -r")
                , (( controlMask .|. shiftMask, xK_space), spawn "mocp -G")
                , (( controlMask .|. shiftMask, xK_e), spawn "eject")
                , (( mod1Mask, xK_0), withNthWorkspace W.greedyView 9)
                , (( mod1Mask .|. shiftMask, xK_0), withNthWorkspace W.shift 9)
                ]

browser = "google-chrome"
myWorkspaces = ["1:General", "2:Web", "3:Files", "4:Media", "5:Dev", "6:Text", "7:Comms","8:Social","9:Music","0:Misc"]



myManageHook = composeAll . concat $
    [ [isDialog --> doFloat]
    , [className =? c --> doFloat | c <- myCFloats]
    , [title =? t --> doFloat | t <- myTFloats]
    , [resource =? r --> doFloat | r <- myRFloats]
    , [ className =? c --> doCenterFloat| c <- floats]
    , [ resource =? r --> doIgnore | r <- ignore]
    , [ resource =? "gecko" --> doF (W.shift "net") ]
    , [ isFullscreen --> doFullFloat]
    , [ isDialog --> doCenterFloat]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "1:General" | x <- my1Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "2:Web" | x <- my2Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "3:Files" | x <- my3Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "4:Media" | x <- my4Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "5:Dev" | x <- my5Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "6:IRC" | x <- my6Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "7:Comms" | x <- my7Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "8:Social" | x <- my8Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "9:Music" | x <- my9Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "0:Misc" | x <- my0Shifts]
    ]
    where
    doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    myCFloats = ["MPlayer", "Nvidia-settings", "Sysinfo", "XCalc", "XFontSel"]
    myTFloats = ["Downloads", "Iceweasel Preferences", "Save As..."]
    myRFloats = []
    my1Shifts = []
    my2Shifts = ["google-chrome"]
    my3Shifts = ["dolphin"]
    my4Shifts = ["Vlc"]
    my5Shifts = ["Subl"]
    my6Shifts = ["Irssi"]
    my7Shifts = ["Skype"]
    my8Shifts = ["Firefox"]
    my9Shifts = ["Alsamixer","Mocp"]
    my0Shifts = ["bitcoin-qt"]
    floats = ["sdlpal", "MPlayer", "Gimp", "qemu-system-x86_64", "Gnome-typing-monitor", "Vlc", "Dia", "DDMS", "Audacious", "Wine"]
    ignore = []
