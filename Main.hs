{-# LANGUAGE OverloadedStrings #-}

import Control.Lens
import Control.Monad
import Network.Wreq
import Network.HTTP.Client (defaultManagerSettings, managerResponseTimeout)
import qualified Data.ByteString.Lazy as BS
import System.Directory (getHomeDirectory)
import System.Process (runProcess)
import System.Environment (getArgs)

-- 有志による訳をダウンロード
-- see http://www.geocities.jp/memo_srv/divinity_os/index.html
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

getAppPath :: IO FilePath
getAppPath = do
  home <- getHomeDirectory
  return $ home ++ "/Library/Application Support/Steam/SteamApps/common/Divinity - Original Sin/Divinity - Original Sin.app"

getXmlPath :: IO FilePath
getXmlPath = do
  appPath <- getAppPath
  return $ appPath ++ "/Contents/Data/Localization/English/english.xml"

--
-- Command line arguments:
-- -d: download Japanese language XML
main :: IO ()
main = do
  args <- getArgs
  appPath <- getAppPath
  when ("-d" `elem` args) $ do
    xmlPath <- getXmlPath
    downloadXml xmlPath
  putStrLn "Launching the game."
  proc <- runProcess "open" [appPath] Nothing Nothing Nothing Nothing Nothing
  return ()
