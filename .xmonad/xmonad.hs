-- XMonad
import XMonad
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Data
import qualified Data.Map as M
import Data.Char (toUpper)

-- XMonad Hooks
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Hooks.EwmhDesktops

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

winMask, altMask :: KeyMask
winMask = mod4Mask
altMask = mod1Mask

myTerm, myEditor, myNormalColor, myFocusedColor, myFont :: String
myFont         =  "xft:monospace:bold:italic:size=9:hinting=true:antialias=true"
myTerm         =  "alacritty"
myEditor       =  "emacsclient -c -a emacs"
myNormalColor  =  "#faaa00"
myFocusedColor =  "#0000bb"

myWorkspaces :: [String]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myBorderWidth :: Dimension
myBorderWidth = 2

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
                 , height               = 12
                 , maxComplRows         = Just 5
                 , historySize          = 256
                 , historyFilter        = id
                 , promptKeymap         = myXPKeyMap
--                 , completionKey        = ""
--                 , changeModeKey        = ""
                 , defaultText          = ""
                 , autoComplete         = Just 10000
                 , showCompletionOnTab  = False
                 , searchPredicate      = fuzzyMatch
                 , defaultPrompter      = id $ map toUpper
--                 , sorter               = ""
                 }

myKeys :: [(String, X ())]
myKeys =
  [
    --XMonad
    ("M-C-r"    , spawn "xmonad --recompile")
  , ("M-S-r"     , spawn "xmonad --restart")
  , ("M-S-q"     , io exitSuccess)

  -- Run Prompt
  , ("M-S-<Return>"     , shellPrompt myXPConfig)

  -- Utilities
  , ("M-<Return>"       , spawn myTerm)

  ]

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "thunar --daemon"
  spawnOnce "dbus-run-session pulseaudio --daemon"
  spawnOnce "emacs --daemon"
  --spawnOnce "xsetroot -cursor_name left_ptr"
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
  --, startupHook =
  --, layoutHook  =
  } `additionalKeysP` myKeys
