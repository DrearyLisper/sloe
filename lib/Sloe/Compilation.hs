module Sloe.Compilation where

import Sloe.Parsing
import Sloe.Types

compileExpression :: Expression -> String
compileExpression (Name name) = name
compileExpression (Application name expressions) = wrap name $ reverse $ map compileExpression expressions
  where
    wrap prev [] = prev
    wrap prev (x:xs) = "(" ++ wrap prev xs ++ " " ++ x ++ ")"

compile :: [Statement] -> Expression -> String
compile statements expression = compile' statements
  where
    compile' [] = compileExpression expression
    compile' ((Function funcName args body):xs) =
      "(\\" ++ funcName ++ "." ++
      compile' xs ++ " " ++
      concatMap (\x -> "\\" ++ x ++ ".") args ++
      compileExpression body ++ ")"
