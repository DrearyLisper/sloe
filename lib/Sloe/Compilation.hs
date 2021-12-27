module Sloe.Compilation where

import qualified Lambda.Types
import qualified Lambda.Parsing

import qualified Data.Map as Map

import Sloe.Parsing
import Sloe.Types

compileExpression :: Expression -> String
compileExpression (Name name) = name
compileExpression (Application name expressions) = wrap name $ reverse $ map compileExpression expressions
  where
    wrap prev [] = prev
    wrap prev (x:xs) = "(" ++ wrap prev xs ++ " " ++ x ++ ")"

compile :: [Statement] -> Expression -> (Map.Map String Lambda.Types.Expression, Lambda.Types.Expression)
compile statements expression = compile' Map.empty statements
  where
    compile' :: Map.Map String Lambda.Types.Expression -> [Statement] -> (Map.Map String Lambda.Types.Expression, Lambda.Types.Expression)
    compile' m [] = (m, fst $ Lambda.Parsing.parseExpression $ compileExpression expression)
    compile' m ((Function funcName args body):xs) = compile' (Map.insert funcName (fst (Lambda.Parsing.parseExpression
                           (concatMap (\x -> "\\" ++ x ++ ".") args ++ compileExpression body))) m) xs
