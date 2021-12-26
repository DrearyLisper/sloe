module Main where

import System.Environment

import Sloe.Parsing (parseFile)
import Sloe.Compilation (compile)
import Lambda.Parsing (parseExpression, formatExpression)
import Lambda.Evaluation (eval)

main :: IO ()
main = do
  args <- getArgs
  let filename = head args
  content <- readFile filename
  let (statements, expression) = parseFile content
  let lambda = compile statements expression
  putStrLn $ lambda
  putStrLn $ formatExpression $ eval $ fst $ parseExpression lambda
