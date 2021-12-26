module Sloe.Types where

data Expression = Name String | Application String [Expression] deriving Show
data Statement = Function String [String] Expression deriving Show

isName :: Expression -> Bool
isName (Name _) = True
isName _ = False

isApplication :: Expression -> Bool
isApplication (Application _ _) = True
isApplication _ = False
