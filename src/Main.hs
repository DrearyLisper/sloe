module Main where

import System.Environment
import Control.Monad

import Sloe.Parsing (parseFile)
import Sloe.Compilation (compile)
import Lambda.Parsing (parseExpression, formatExpression)
import Lambda.Evaluation (eval)

main :: IO ()
main = do
  args <- getArgs
  let filename = head args
  content <- readFile filename
  let expressions = parseFile content
  forM_ expressions $ \(db, lambda) -> do
    putStrLn $ formatExpression $ eval db lambda
