-- XMonad
import XMonad
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Data
import qualified Data.Map as M
--import Data.Char (toUpper)

-- XMonad Hooks
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Hooks.EwmhDesktops (ewmh)

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

-- Custom Libraries
import Monad.Variables

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

  -- Utilities
  , ("M-<Return>"       , spawn myTerm)

  -- Window Navigation
  , ("M-m"              , windows W.focusMaster)
  , ("M-j"              , windows W.focusDown)
  , ("M-k"              , windows W.focusUp)
  , ("M-S-m"            , windows W.swapMaster)
  , ("M-S-j"            , windows W.swapDown)
  , ("M-S-k"            , windows W.swapUp)

  ]


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
  --, layoutHook  =
  } `additionalKeysP` myKeys
