module Sloe.Compilation where

import qualified Lambda.Types
import qualified Lambda.Parsing
import qualified Lambda.Evaluation

import qualified Data.Map as Map

import Sloe.Types

compileExpression :: Expression -> String
compileExpression (Name name) = name
compileExpression (Application name expressions) = wrap name $ reverse $ map compileExpression expressions
  where
    wrap prev [] = prev
    wrap prev (x:xs) = "(" ++ wrap prev xs ++ " " ++ x ++ ")"

compileStatement :: Map.Map String Lambda.Types.Expression -> Statement -> Map.Map String Lambda.Types.Expression
compileStatement db (Function funcName args body) = Map.insert funcName (fst (Lambda.Parsing.parseExpression (concatMap (\x -> "\\" ++ x ++ ".") args ++ strBody))) db
  where
    strBody = compileExpression body


compile :: [Statement] -> Expression -> (Map.Map String Lambda.Types.Expression, Lambda.Types.Expression)
compile statements expression = compile' Map.empty statements
  where
    compile' :: Map.Map String Lambda.Types.Expression -> [Statement] -> (Map.Map String Lambda.Types.Expression, Lambda.Types.Expression)
    compile' db [] = (db, fst $ Lambda.Parsing.parseExpression $ compileExpression expression)
    compile' db (x:xs) = compile' (compileStatement db x) xs
