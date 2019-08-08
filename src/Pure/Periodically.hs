{-# LANGUAGE RecordWildCards #-}
module Pure.Periodically (Periodically(..),periodically) where

import Pure.Data.Default
import Pure.Data.View
import Pure.Data.View.Patterns

import Control.Concurrent
import Control.Monad
import Data.Function (fix)
import Data.Typeable

data Periodically a = Periodically
  { every  :: Int
  , action :: IO a
  , render :: a -> View
  }

-- | periodically will perform the `action` every `every` microseconds
-- and render the result of the action with `render`.
periodically :: Typeable a => Int -> IO a -> (a -> View) -> View
periodically every action render = View Periodically {..}

instance Typeable a => Pure (Periodically a) where
  view = LibraryComponentIO $ \self ->
    let
        execute = do
          Periodically {..} <- ask self
          void $ forkIO $ flip fix every $ \restart delay -> do
              threadDelay delay
              Periodically {..} <- ask self
              a <- action
              b <- modify self $ \_ _ -> a
              when b (restart every)
    in
        def
            { construct = ask self >>= action
            , executing = \st -> execute >> pure st
            , Pure.Data.View.render = \Periodically {..} -> render
            }
