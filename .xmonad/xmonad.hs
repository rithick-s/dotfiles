-- XMonad
import XMonad
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Data
import qualified Data.Map as M
--import Data.Char (toUpper)
import Data.Tree

import XMonad.Actions.CycleWS

-- XMonad Hooks
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Hooks.EwmhDesktops (ewmh)

-- XMonad.Layout
import XMonad.Layout.ResizableTile

-- XMonad.Layout Modifier libs
import XMonad.Layout.Magnifier
import XMonad.Layout.Renamed
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing

-- XMonad Actions
import qualified XMonad.Actions.TreeSelect as TS

-- XMonad Util
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Cursor

-- XMonad.Prompt
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Shell

-- Control
import Control.Arrow (first)

quoted :: String -> String
quoted str = "\"" ++ str ++ "\""

sendNotification :: String -> String -> X ()
sendNotification msg desc = spawn $ concat ["notify-send", " ", quoted msg, " ", quoted desc]

winMask :: KeyMask
winMask = mod4Mask

altMask :: KeyMask
altMask = mod1Mask

myBorderWidth :: Dimension
myBorderWidth = 2

myTerm :: String
myTerm  =  "alacritty"

myEditor :: String
myEditor  =  "emacsclient -c -a emacs"

myNormalColor :: String
myNormalColor  =  "#faaa00"

myFocusedColor :: String
myFocusedColor =  "#0000bb"

myFont :: String
myFont =  "xft:firacode:bold:size=10:antialias=true:hinting=true"

myBrowser :: String
myBrowser = "firefox "

myWorkspaces :: [String]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myXPKeyMap :: M.Map (KeyMask, KeySym) (XP ())
myXPKeyMap = M.fromList $
    map (first $ (,) 0)
    [
     (xK_Return, setSuccess True >> setDone True)
    ,(xK_BackSpace, deleteString Prev)
    ,(xK_Delete, deleteString Next)
    ,(xK_Left, moveCursor Prev)
    ,(xK_Right, moveCursor Next)
    ,(xK_Up, moveHistory W.focusUp')
    ,(xK_Down, moveHistory W.focusDown')
    ,(xK_Escape, quit)
    ]

myXPConfig :: XPConfig
myXPConfig = def { font                 = myFont
                 , bgColor              = "#0f0a0a"
                 , fgColor              = "#048ba8"
                 , bgHLight             = "131b23"
                 , fgHLight             = "#32e875"
                 , borderColor          = "#0f0a0a"
                 , promptBorderWidth    = 0
                 , position             = Top
                 , alwaysHighlight      = True
                 , height               = 15
                 , maxComplRows         = Just 5
                 , historySize          = 256
                 , historyFilter        = id
                 , promptKeymap         = myXPKeyMap
--                 , completionKey        =
--                 , changeModeKey        =
                 , defaultText          = ""
                 , autoComplete         = Just 10000
                 , showCompletionOnTab  = False
                 , searchPredicate      = fuzzyMatch
--                 , defaultPrompter      = id $ map toUpper
--                 , sorter               =
                 }

myTreeSelectMenu :: TS.TSConfig (X ()) -> X ()
myTreeSelectMenu a = TS.treeselectAction a
                     [ Node (TS.TSNode "+ Accessories" "Accessories & Apps" (return ()))
                       [ Node (TS.TSNode "Calculatr" "Emacs Calculator" (spawn $ myEditor ++ " --eval '(calc)'")) []
                       , Node (TS.TSNode "Archive Manager" "Manage Archives and Compressed Data" (spawn "engrampa")) []
                       , Node (TS.TSNode "MuPDF" "PDF/XPS/EBook Viewer" (spawn "mupdf")) []
                       , Node (TS.TSNode "Telegram Desktop" "Telegram Messaging Client" (spawn "telegram-desktop")) []
                       ]
                     , Node (TS.TSNode "+ Web Sites" "List of Websites Mostly Used." (return ()))
                       [ Node (TS.TSNode "Github" "https://github.com/rithick-s" (spawn $ myBrowser ++ "https://github.com/rithick-s")) []
                       , Node (TS.TSNode "Void Linux" "https://docs.voidlinux.org" (spawn $ myBrowser ++ "https://docs.voidlinux.org/")) []
                       , Node (TS.TSNode "Send Nofication" "Send a Hello, Notification!" (sendNotification "Hello, User" "Sample Hello Notifiaction")) []
                       , Node (TS.TSNode "Notification 2" "Not2" (sendNotification "Not2Title" "Notificication 2 Desc")) []
                       --, Node (TS.TSNode "Github" "https://github.com/rithick-s" (spawn $ myBrowser ++ "https://github.com/rithick-s")) []
                       --, Node (TS.TSNode "Github" "https://github.com/rithick-s" (spawn $ myBrowser ++ "https://github.com/rithick-s")) []
                       --, Node (TS.TSNode "Github" "https://github.com/rithick-s" (spawn $ myBrowser ++ "https://github.com/rithick-s")) []
                       --, Node (TS.TSNode "Github" "https://github.com/rithick-s" (spawn $ myBrowser ++ "https://github.com/rithick-s")) []
                       --, Node (TS.TSNode "Github" "https://github.com/rithick-s" (spawn $ myBrowser ++ "https://github.com/rithick-s")) []
                       ]
                     , Node (TS.TSNode "+ Emacs" "Elisp Intrepreter/Text Editor" (return ()))
                     [ Node (TS.TSNode "Emacs" "Emacs Dashboard" (spawn myEditor)) []
                     , Node (TS.TSNode "Emacs iBuffer" "List all Interacctive Buffers" (spawn $ myEditor ++ " --eval '(ibuffer)'")) []
                     , Node (TS.TSNode "Emacs Dired" "Directory Editor - Emacs" (spawn $ myEditor ++ " --eval '(dired nil)'")) []
                     ]
                     , Node (TS.TSNode "+ System Utilities" "Management Utilities/System Apps" (return ()))
                     [ Node (TS.TSNode "LXAppearance" "Customize Themes/Widgets" (spawn "lxappearance")) []
                     ]
                     ]

myTSConfig :: TS.TSConfig a
myTSConfig = TS.TSConfig { TS.ts_hidechildren = True
                              , TS.ts_background   = 0xdd282c34
                              , TS.ts_font         = myFont
                              , TS.ts_node         = (0xffd0d0d0, 0xff1c1f24)
                              , TS.ts_nodealt      = (0xffd0d0d0, 0xff282c34)
                              , TS.ts_highlight    = (0xffffffff, 0xff755999)
                              , TS.ts_extra        = 0xffd0d0d0
                              , TS.ts_node_width   = 200
                              , TS.ts_node_height  = 25
                              , TS.ts_originX      = 100
                              , TS.ts_originY      = 100
                              , TS.ts_indent       = 80
                              , TS.ts_navigate     = myTreeNavigation
                              }

myTreeNavigation = M.fromList
    [ ((0, xK_Escape),   TS.cancel)
    , ((0, xK_Return),   TS.select)
    , ((0, xK_space),    TS.select)
    , ((0, xK_Up),       TS.movePrev)
    , ((0, xK_Down),     TS.moveNext)
    , ((0, xK_Left),     TS.moveParent)
    , ((0, xK_Right),    TS.moveChild)
    , ((0, xK_o),        TS.moveHistBack)
    , ((0, xK_i),        TS.moveHistForward)
    ]

myKeys :: [(String, X ())]
myKeys =
  [
    --XMonad
    ("M-C-r"    , spawn "xmonad --recompile")
  , ("M-S-r"     , spawn "xmonad --restart")
  , ("M-S-q"     , io exitSuccess)

  -- Prompts
  , ("M-S-<Return>"     , shellPrompt myXPConfig)

  -- Emacs
  , ("M-e e"            , spawn myEditor)
  , ("M-e d"            , spawn "emacsclient -c -a 'emacs' --eval '(dired nil)'")
  , ("M-e b"            , spawn $ myEditor ++ " --eval '(ibuffer)'")

  -- Utilities
  , ("M-<Return>"       , spawn myTerm)
  , ("M-t t"            , myTreeSelectMenu myTSConfig )

  -- WorkSpaces
  , ("M-<Left>"         , nextWS)
  , ("M-S-<Left>"       , shiftToNext)
  , ("M-<Right>"        , prevWS)
  , ("M-S-<Right>"      , shiftToPrev)
  , ("M-<Tab>"          , toggleWS)

  -- Window Navigation
  , ("M-m"              , windows W.focusMaster)
  , ("M-j"              , windows W.focusDown)
  , ("M-k"              , windows W.focusUp)
  , ("M-S-m"            , windows W.swapMaster)
  , ("M-S-j"            , windows W.swapDown)
  , ("M-S-k"            , windows W.swapUp)

  -- Function[Emulated] Keys
  , ("<XF86MonBrightnessUp>"    , spawn "xbacklight -inc 3")
  , ("<XF86MonBrightnessDown>"  , spawn "xbacklight -dec 3")
  , ("<XF86AudioLowerVolume>"   , spawn "ponymix decrease 3")
  , ("<XF86AudioRaiseVolume>"   , spawn "ponymix increase 3")
  , ("<XF86AudioMute>"          , spawn "ponymix toggle")
  , ("<Print>"                  , spawn "scrot")

  ]

mySpacing, mySpacing' :: Integer -> l a -> ModifiedLayout Spacing l a
mySpacing  i  = spacingRaw True  (Border i i i i) True (Border i i i i) True
mySpacing' i = spacingRaw False (Border i i i i) True (Border i i i i) True

tall = renamed [Replace "tall"]
       $ mySpacing 2
       $ ResizableTall 1 (3/100) (1/2) []

magnify = renamed [ Replace "magnify"]
          $ mySpacing 4
          $ magnifier

myLayoutHook = tall


myStartupHook :: X ()
myStartupHook = do
  spawnOnce "feh --no-fehbg --bg-scale /home/user/.xmonad/res/wallpaper.jpg &"
  spawnOnce "thunar --daemon &"
  spawnOnce "emacs --daemon &"
  spawnOnce "picom -CGb &"
  setDefaultCursor xC_left_ptr
  setWMName "X_EXTENDED"

--myLogHook :: X ()
--myLogHook =  

main :: IO ()
main = xmonad $ ewmh $ def
  { modMask     = winMask
  , terminal    = myTerm
  , workspaces  = myWorkspaces
  , borderWidth = myBorderWidth
  , focusedBorderColor = myFocusedColor
  , normalBorderColor  = myNormalColor
  , startupHook = myStartupHook
  , layoutHook  = myLayoutHook
  } `additionalKeysP` myKeys
