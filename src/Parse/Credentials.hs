module Parse.Credentials where

import Data.String

data Cred = Cred { key :: String, value :: String } deriving Eq

stringToKeyValue :: String -> [ Cred ]
stringToKeyValue str = map (split '=') . lines $ str

getCredVal :: String -> [ Cred ] -> Maybe String
getCredVal k [] = Nothing
getCredVal k (cred:creds) | k == key cred = Just $ value cred
                          | otherwise = getCredVal k creds

split :: Char -> String -> Cred
split c str = go c [] str where
  go _ str1 [] = Cred str1 "" 
  go c str1 (x:xs) | c == x = Cred str1 xs
                   | otherwise = go c (str1 ++ [x]) xs

strip :: String -> String -> String
strip [] str = str
strip _ [] = []
strip (x:xs) res@(y:ys) | x == y = strip xs ys
                        | otherwise = res
