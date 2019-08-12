module Parse.Link where

import Text.Regex.Posix

type Year = String

parseLink :: Year -> [String] -> [String]
parseLink year =  filter (\link -> (link =~ year) :: Bool )

uniq :: Eq a => [a] -> [a]
uniq [] = []
uniq (x:xs) | (== 0) . length . filter (x ==) $ xs = x : uniq xs
            | otherwise = uniq xs
