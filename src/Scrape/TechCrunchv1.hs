{-# LANGUAGE OverloadedStrings #-}
module Scrape.TechCrunchv1
    ( articleURL
    ) where

import Text.HTML.Scalpel
import Control.Applicative


type Url = String

data Article
  = Article Url
  deriving (Show, Eq)

articleURL :: IO (Maybe [Article])
articleURL = scrapeURL "https://techcrunch.com" articles
  -- scrapeURL :: URL -> Scraper str a -> IO (Maybe a)

  where
    articles :: Scraper String [Article]
    articles = chroots ("body" @: [hasClass ""]) article
  -- chroots :: Selector -> Scraper str a -> Scraper str [a]
  -- (@:) :: TagName -> [AttributePredicate] -> Selector
  -- hasClass :: String -> AttributePredicate

    article :: Scraper String Article
    article = do
      url <- text $ "span" @: [hasClass "uacFocusPlaceholder"]
      return $ Article url

  {-
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

-}
