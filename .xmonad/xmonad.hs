-- XMonad
import XMonad
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- XMonad Hooks
import XMonad.Hooks.SetWMName (setWMName)

-- XMonad Util
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Cursor

-- XMonad.Prompt
import XMonad.Prompt
import XMonad.Prompt.Shell

winMask, altMask :: KeyMask
winMask = mod4Mask
altMask = mod1Mask

myTerm, myEditor, myNormalColor, myFocusedColor :: String
myTerm         =  "alacritty"
myEditor       =  "emacsclient -c -a emacs"
myNormalColor  =  "#faaa00"
myFocusedColor =  "#0000bb"

myWorkspaces :: [String]
myWorkspaces = map show [1..9]

myBorderWidth :: Dimension
myBorderWidth = 2

myXPConfig :: XPConfig
myXPConfig = def { font                 = ""
                 , bgColor              = ""
                 , fgColor              = ""
                 , bgHLight             = ""
                 , fgHLight             = ""
                 , borderColor          = ""
                 , promptBorderWidth    = ""
                 , position             = ""
                 , alwaysHighlight      = ""
                 , height               = ""
                 , maxComplRows         = ""
                 , historySize          = ""
                 , historyFilter        = ""
                 , promptKeymap         = ""
                 , completionKey        = ""
                 , changeModeKey        = ""
                 , defaultText          = ""
                 , autoComplete         = ""
                 , showCompletionOnTab  = ""
                 , searchPredicate      = ""
                 , defaultPrompter      = ""
                 , sorter               = ""
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


main :: IO ()
main = xmonad $ def
  { modMask     = winMask
  , terminal    = myTerm
  , workspaces  = myWorkspaces
  , borderWidth = myBorderWidth
  , focusedBorderColor = myFocusedColor
  , normalBorderColor  = myNormalColor
  --, startupHook =
  --, layoutHook  =
  } `additionalKeysP` myKeys
