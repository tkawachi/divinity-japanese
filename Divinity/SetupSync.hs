{-# LANGUAGE OverloadedStrings #-}

module Divinity.SetupSync where

import System.Posix.Files
import System.Directory (createDirectoryIfMissing,
                         doesDirectoryExist)
import Shelly (shelly, cp_r, fromText, when)
import qualified Data.Text as T
import System.FilePath.Posix (takeFileName)

setupProfileSync :: FilePath -> FilePath -> IO ()
setupProfileSync profilePath syncPath = do
  let syncProfilePath = syncPath ++ "/" ++ (takeFileName profilePath)
  syncExists <- doesDirectoryExist syncPath
  when (not syncExists) $ do
    putStrLn $ "Creating " ++ syncPath
    profileExists <- doesDirectoryExist profilePath
    case profileExists of
     True -> do
       let pathFor = fromText . T.pack
       putStrLn $ "Copying " ++ profilePath ++ " to " ++ syncPath
       createDirectoryIfMissing True syncPath
       shelly $ cp_r (pathFor profilePath) (pathFor syncPath)
     False -> do
       putStrLn $ "Creating " ++ syncPath
       createDirectoryIfMissing True syncPath

  status <- getSymbolicLinkStatus profilePath
  when (not $ isSymbolicLink status) $ do
    let origPath = profilePath ++ ".orig"
    putStrLn $ "Copying original to " ++ origPath
    rename profilePath origPath
    createSymbolicLink syncProfilePath profilePath
  return ()
