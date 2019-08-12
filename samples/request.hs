{-# LANGUAGE OverloadedStrings #-}
module ClientTrial
    ( getR
    , getJ
    , sendJSON
    ) where

import Data.Aeson (Value, encode, object, (.=))
import qualified Data.ByteString.Char8 as S8
import qualified Data.ByteString.Lazy.Char8 as BC
import qualified Data.Yaml as Yaml
import Network.HTTP.Simple as Sim
import Network.HTTP.Client as Cli
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Status (statusCode)

getR :: IO ()
getR = do
  -- Note here the url is overloaded.
  -- it has an isString instance, in another source file
  -- This enables it to be read as an URI and converted into a Request type
  -- Request types are then taken in by httpLBS
  response <-  Sim.httpLBS "http://httpbin.org/get"
  putStrLn $ "The status code was : " ++
             show (getResponseStatusCode response)
  print $ getResponseHeader "Content-Type" response
  BC.putStrLn $ getResponseBody response

getJ :: IO ()
getJ = do
  response <- httpJSON "http://httpbin.org/get"
  putStrLn $ "The status code was: " ++
              show (getResponseStatusCode response)
  print $ getResponseHeader "Content-Type" response
  S8.putStrLn $ Yaml.encode (getResponseBody response :: Value)

sendJSON :: IO ()
sendJSON = do
    manager <- newManager tlsManagerSettings

    -- Create the request
    let requestObject = object
            [ "name" .= ("Alice" :: String)
            , "age"  .= (35 :: Int)
            ]
    initialRequest <- parseRequest "http://httpbin.org/post"
    let request = initialRequest
            { method = "POST"
            , requestBody = RequestBodyLBS $ encode requestObject
            , requestHeaders =
                [ ("Content-Type", "application/json; charset=utf-8")
                ]
            }
    response <- Cli.httpLbs request manager
    putStrLn $ "The status code was: "
            ++ show (statusCode $ responseStatus response)
    BC.putStrLn $ responseBody response
