module Main where

import System.Environment
import Control.Monad

import qualified Data.Map as Map

import Sloe.Parsing (parseFile)
import Sloe.Compilation (compile)
import Lambda.Parsing (parseExpression, formatExpression)
import Lambda.Evaluation (eval)
import Lambda.Types

foldF (prevDB, evals) (db, lambda) = (newDB, evaled:evals)
  where
    db' = Map.union prevDB db
    (newDB, evaled) = eval (db', lambda)


main :: IO ()
main = do
  args <- getArgs
  let filename = head args
  content <- readFile filename
  let expressions = snd $ foldl foldF (Map.empty, []) (parseFile content)
  forM_ (reverse expressions) $ \lambda -> do
    putStrLn $ "> " ++ (formatExpression lambda)
