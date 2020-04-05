import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.Spacing
import XMonad.Hooks.FadeInactive
import XMonad.Layout.NoBorders
import System.IO
import XMonad.Actions.Plane
import XMonad.Hooks.SetWMName

import qualified Data.Map as M         -- haskell modules
import qualified XMonad.StackSet as W  -- xmonad core
import XMonad.Actions.FloatKeys        -- actions (keyResizeWindow)
import XMonad.Actions.FloatSnap        -- actions (snapMove)

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    spawn "xscreensaver -no-splash"
    spawn "xcompmgr"

    xmonad $ docks $ defaultConfig
        {
        --manageHook = manageDocks <+> manageHook defaultConfig
        manageHook = manageHook def
            <+> manageDocks
            <+> composeAll myManagementHooks

        , layoutHook = smartBorders $
                       avoidStruts $
                       smartSpacing 10 $
                       Tall 1 (3/100) (1/2)
                       ||| Mirror (Tall 1 (3/100) (1/2))
                       ||| Full
        , logHook = do --fadeInactiveLogHook 0.9
                       dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , startupHook = myStartupHook
        , mouseBindings = myMouseBindings
        , workspaces = myWorkspaces
        } `additionalKeys` myKeys

myStartupHook = do
                spawn "~/.xmonad/startup.sh"
                spawn "feh --bg-scale ~/Pictures/Wallpapers"
                spawn "xsetroot -cursor_name left_ptr"
                setWMName "LG3D" -- Java hack

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Sink the window back to the grid.
    , ((modm, button2), (\w -> withFocused $ windows . W.sink))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

myManagementHooks :: [ManageHook]
myManagementHooks = [
  resource =? "synapse" --> doIgnore
  , resource =? "stalonetray" --> doIgnore
  , className =? "zoom" --> doFloat
  , className =? "Zeal" --> doFloat
  , className =? "Zenity" --> doFloat
  , className =? "Xfce4-power-manager-settings" --> doFloat
  , className =? "Gnome-calculator" --> doFloat
  , className =? "Pavucontrol" --> doFloat
  , className =? "Gnome-dictionary" --> doFloat
  , className =? "Evolution-alarm-notify" --> doFloat
  , className =? "Gsimplecal" --> doFloat
  , className =? "systemsettings" --> doFloat
  , (className =? "Slack") --> doF (W.shift "Slack")
  ]

myWorkspaces =
  [
    "1:Office",  "2:Browser", "3:Misc",
    "4:Dev",   "5:Dev", "6:Dev",
    "7:Debug",  "8:Debug", "9:Debug",
    "0:VM",    "Music", "Slack"
  ]

workspaceKeys =
  [
    xK_1, xK_2, xK_3,
    xK_4, xK_5, xK_6,
    xK_7, xK_8, xK_9,
    xK_0, xK_minus, xK_equal
  ]

myKeyBindings =
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((mod4Mask .|. shiftMask, xK_t), sendMessage ToggleStruts)
        , ((mod4Mask .|. shiftMask, xK_d), spawn "gsimplecal")
        , ((mod4Mask .|. shiftMask, xK_o), spawn "amixer -D pulse sset Master 5%+")
        , ((mod4Mask .|. shiftMask, xK_p), spawn "amixer -D pulse sset Master 5%-")
        , ((mod4Mask .|. shiftMask .|. controlMask, xK_o), spawn "xbacklight -inc 10")
        , ((mod4Mask .|. shiftMask .|. controlMask, xK_p), spawn "xbacklight -dec 10")
        , ((0, 0x1008ff59), spawn "xrandr --output eDP-1 --auto --rate 60 --below DP-1 --output DP-1 --auto")
        , ((mod4Mask .|. controlMask, xK_n), spawn "google-chrome")
        , ((mod4Mask .|. shiftMask .|. controlMask, xK_n), spawn "google-chrome --incognito")
        , ((mod4Mask, 0xff61), spawn "xfce4-screenshooter -r -s ~/Pictures/screenshots/screen-$(date +'%Y%m%d-%H%M').png")
        , ((myModMask, xK_backslash), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
        ]


myKeys = myKeyBindings ++
    [
    ((m .|. myModMask, k), windows $ f i)
    | (i, k) <- zip myWorkspaces workspaceKeys
    --, (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ] ++
    M.toList (planeKeys myModMask (Lines 4) Finite) ++
    [
        ((m .|. myModMask, key), screenWorkspace sc
         >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [1,0,2]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    ]


myModMask = mod4Mask
