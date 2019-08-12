module Main where

import Scrape.TechCrunch
import Parse.Link
import Telegram.Client (sendTelegram)
import Data.Foldable (fold)

main :: IO ()
main = do
--  images <- articleImg
--  links <- articleLinks
  filterLinks <- (fmap . fmap) (uniq . parseLink "2019") articleLinks
--  print images
--  print links
  putStrLn "\n\n\n"
  print filterLinks
  putStrLn "\n\n\n"
  (print . head . fold) filterLinks
  x <- (read <$> getLine) :: IO Int
  (sendTelegram . (!! x) . fold) filterLinks

  -- implement database cache links

  -- Implement daily system to send links
  -- Log sent links, check outgoing links against these guys
