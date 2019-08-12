module Test.Parse.Credentials where

import Parse.Credentials

main :: IO ()
main = do
  print $ strip "hello" "helloWorld" == "World"
  print $ split '=' "asd=bcd" == Cred "asd" "bcd"
  print $ stringToKeyValue "asd=bcde\nnerd=ggg\na=e" == [ Cred "asd" "bcde"
                                                        , Cred "nerd" "ggg"
                                                        , Cred "a" "e"
                                                        ]
  print $ getCredVal "nerd" [ Cred "asd" "bcde", Cred "nerd" "ggg", Cred "a" "e" ] == Just "ggg"
