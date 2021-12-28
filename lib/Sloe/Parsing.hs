module Sloe.Parsing (parseFile) where

import Data.List
import qualified Data.Map as Map

import Sloe.Types
import Sloe.Compilation

import qualified Lambda.Parsing
import qualified Lambda.Types



parseNames :: String -> ([String], String)
parseNames xs = (words names, rest)
  where
    namesStart = dropWhile (==' ') xs
    names = takeWhile (\x -> x `notElem` ['(', ')', '=']) namesStart
    rest = dropWhile (\x -> x `notElem` ['(', ')', '=']) namesStart


parseExpression :: String -> (Expression, String)
parseExpression [] = error "Can't parse empty string"
parseExpression line = if length expressions > 1
                        then (let (Name func) = head expressions in Application func $ tail expressions, rest'')
                        else (head expressions, rest'')
  where
    (expressions, rest'') = parseExpression' line

    parseExpression' :: String -> ([Expression], String)
    parseExpression' "" = ([], "")
    parseExpression' (x:xs) | x == '=' = ([], x:xs)
                            | x == ')' = ([], x:xs)
                            | x == ' ' = parseExpression' xs
                            | x == '(' = let (expression, rest) = parseExpression xs
                                             (restExpression, rest') = parseExpression' $ tail rest
                                         in (expression:restExpression, rest')
                            | otherwise = let (names, rest) = parseNames (x:xs)
                                              (restExpression, rest') = parseExpression' rest
                                          in (map Name names ++ restExpression, rest')

parseStatement :: String -> (Statement, String)
parseStatement [] = error "Can't parse empty string"
parseStatement line = (Function (head names) (tail names) expression, rest')
  where
    (names, rest) = parseNames line
    (expression , rest') = parseExpression $ tail rest

parse :: String -> (Either Statement Expression, String)
parse line = if '=' `elem` line
                         then let (statement, rest) = parseStatement line
                              in (Left statement, rest)
                         else let (expression, rest) = parseExpression line
                              in (Right expression, rest)



parseFile :: String -> [(Map.Map String Lambda.Types.Expression, Lambda.Types.Expression)]
parseFile c = parse' Map.empty (map (fst.parse) $ filter (not.null) $  lines c)
  where
    parse' :: Map.Map String Lambda.Types.Expression -> [Either Statement Expression] -> [(Map.Map String Lambda.Types.Expression, Lambda.Types.Expression)]
    parse' db ((Left statement):xs) = parse' (compileStatement db statement) xs
    parse' db ((Right expression):xs) = (db, fst $ Lambda.Parsing.parseExpression $ compileExpression expression):parse' db xs
    parse' db [] = []
