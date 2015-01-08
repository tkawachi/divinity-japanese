module Divinity.Path(
  getAppPath,
  getXmlPath,
  getPlayerProfilePath,
  getPlayerProfileSyncPath
) where
import System.Directory (getHomeDirectory)

getAppPath :: IO FilePath
getAppPath = do
  home <- getHomeDirectory
  return $ home ++ "/Library/Application Support/Steam/SteamApps/common/Divinity - Original Sin/Divinity - Original Sin.app"

getXmlPath :: IO FilePath
getXmlPath = do
  appPath <- getAppPath
  return $ appPath ++ "/Contents/Data/Localization/English/english.xml"

getPlayerProfilePath :: IO FilePath
getPlayerProfilePath = do
  home <- getHomeDirectory
  return $ home ++ "/Documents/Larian Studios/Divinity Original Sin/PlayerProfiles"

getPlayerProfileSyncPath :: IO FilePath
getPlayerProfileSyncPath = do
  home <- getHomeDirectory
  return $ home ++ "/Copy/divinity"
