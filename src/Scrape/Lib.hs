{-# LANGUAGE OverloadedStrings #-}
module Scrape.Lib
    ( extractor
    , allComments
    ) where

import Text.HTML.Scalpel
import Control.Applicative

extractor :: IO ()
extractor = putStrLn "someFunc"

type Author = String

data Comment
  = TextComment Author String
  | ImageComment Author URL
  deriving (Show, Eq)

allComments :: IO (Maybe [Comment])
allComments = scrapeURL "http://localhost:3000" comments
  -- scrapeURL :: URL -> Scraper str a -> IO (Maybe a)

  where
    comments :: Scraper String [Comment]
    comments = chroots ("div" @: [hasClass "container"]) comment
  -- chroots :: Selector -> Scraper str a -> Scraper str [a]
  -- (@:) :: TagName -> [AttributePredicate] -> Selector
  -- hasClass :: String -> AttributePredicate

    comment :: Scraper String Comment
    comment = textComment <|> imageComment

    textComment :: Scraper String Comment
    textComment = do
      author <- text $ "span" @: [hasClass "author"]
      commentText <- text $ "div" @: [hasClass "text"]
      return $ TextComment author commentText

    imageComment :: Scraper String Comment
    imageComment = do
      author <- text $ "span" @: [hasClass "author"]
      imageURL <- attr "src" $ "img" @: [hasClass "image"]
      return $ ImageComment author imageURL
