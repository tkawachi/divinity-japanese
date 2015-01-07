{-# LANGUAGE OverloadedStrings #-}
module Main
       where

import Network.Wreq
import Control.Lens
import Network.HTTP.Client (defaultManagerSettings, managerResponseTimeout)
import qualified Data.ByteString.Lazy as BS

downloadXml :: FilePath -> IO ()
downloadXml xmlPath = do
  let timeoutSecs = 120
  let opts = defaults
             & manager .~ Left (
               defaultManagerSettings {
                  managerResponseTimeout = Just (timeoutSecs * 1000 * 1000)})
             & param "n" .~ ["b1"]
  let url = "http://hearts.s276.xrea.com/divinity_os/english.xml"
  putStrLn $ "Downloading " ++ url
  resp <- getWith opts url
  BS.writeFile xmlPath (resp ^. responseBody)
  putStrLn $ "Saved as " ++ xmlPath

main :: IO ()
main = do
  let xmlPath = "/Users/kawachi/Library/Application Support/Steam/SteamApps/common/Divinity - Original Sin/Divinity - Original Sin.app/Contents/Data/Localization/English/english.xml"
  downloadXml xmlPath
