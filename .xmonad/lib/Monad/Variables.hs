module Monad.Variables ( winMask
                       , altMask
                       , myTerm
                       , myEditor
                       , myNormalColor
                       , myFocusedColor
                       , myFont
                       , myWorkspaces
                       , myBorderWidth
                       ) where

import XMonad ( KeyMask
              , mod4Mask
              , mod1Mask
              , Dimension
              )

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
myFont  =  "xft:firacode:bold:italic:size=10:antialias=true:hinting=true"

myWorkspaces :: [String]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
