{-# LANGUAGE OverloadedStrings #-}

import Control.Lens
import Control.Monad
import Network.Wreq
import Network.HTTP.Client (defaultManagerSettings, managerResponseTimeout)
import qualified Data.ByteString.Lazy as BS
import System.Process (runProcess)
import System.Environment (getArgs)
import Divinity.Path
import Divinity.SetupSync

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


--
-- Command line arguments:
-- -d: download Japanese language XML
main :: IO ()
main = do
  args <- getArgs

  profilePath <- getPlayerProfilePath
  syncPath <- getPlayerProfileSyncPath
  setupProfileSync profilePath syncPath
  
  when ("-d" `elem` args) $ do
    xmlPath <- getXmlPath
    downloadXml xmlPath
  putStrLn "Launching the game."
  appPath <- getAppPath
  proc <- runProcess "open" [appPath] Nothing Nothing Nothing Nothing Nothing
  return ()
