{-# LANGUAGE OverloadedStrings #-}
module Telegram.Client where

import Data.Aeson (Value, encode, object, (.=))
import qualified Data.ByteString.Char8 as S8
import qualified Data.ByteString.Lazy.Char8 as BC
import qualified Data.Yaml as Yaml
import Network.HTTP.Simple as Sim
import Network.HTTP.Client as Cli
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Status (statusCode)

import qualified Parse.Credentials as C

getCredentials :: IO [C.Cred]
getCredentials = fmap C.stringToKeyValue raw where
  raw = readFile "/home/noel/projects/haskell-news-bot/credentials"

sendTelegram :: String -> IO ()
sendTelegram msg = do
  manager <- newManager tlsManagerSettings
  -- Create the request
  creds <- getCredentials
  let Just chatId = C.getCredVal "TELEGRAM_CHAT_ID" creds 
      Just apiKey = C.getCredVal "TELEGRAM_API" creds
      helloWorld = object
          [ "chat_id" .= (chatId :: String)
          , "text" .= (msg :: String)
          ]
  initialRequest <- parseRequest apiKey

  let request = initialRequest
          { method = "POST"
          , requestBody = RequestBodyLBS $ encode helloWorld
          , requestHeaders =
              [ ("Content-Type", "application/json")
              ]
          }
  response <- Cli.httpLbs request manager
  putStrLn $ "The status code was: "
          ++ show (statusCode $ responseStatus response)
  BC.putStrLn $ responseBody response
