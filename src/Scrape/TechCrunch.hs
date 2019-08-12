{-# LANGUAGE OverloadedStrings #-}
module Scrape.TechCrunch
    ( articleImg
    , articleLinks
    ) where

import Text.HTML.Scalpel

articleImg :: IO (Maybe [String])
articleImg = scrapeURL "https://techcrunch.com" (attrs "src" "img")

articleLinks :: IO (Maybe [String])
articleLinks = scrapeURL "https://techcrunch.com" (attrs "href" "a")
