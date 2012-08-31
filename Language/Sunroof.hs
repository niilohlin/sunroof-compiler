{-# LANGUAGE ScopedTypeVariables, OverloadedStrings, KindSignatures, GADTs #-}
module Language.Sunroof where

import Control.Monad.Operational

import Language.Sunroof.Compiler
import Language.Sunroof.Types

-- export register
import Web.KansasComet (Template(..), extract, register, Scope, send, Document)

-- Async requests that something be done, without waiting for any reply
async :: Document -> JS () -> IO ()
async doc jsm = do
        let (res,_) = compileJS jsm
        send doc $ res  -- send it, and forget it
        return ()

-- Sync requests that something be done, *and* waits for a reply.
sync :: (Sunroof a) => Document -> JS a -> IO a
sync doc jsm = do
        let (res,ret) = compileJS jsm
        print (res,ret)
        send doc $ res
        return $ undefined

-- This can be build out of primitives
wait :: Scope -> Template event -> (JSObject -> JS ()) -> JS ()
wait scope tmpl k = do
        o <- function k
        call "$.kc.waitFor" <$> with [ cast (string scope)
                                     , cast (object (show (map fst (extract tmpl))))
                                     , cast o]

-- The API of Javascript, reflected

alert :: JSString -> JS ()
alert msg = call "alert" <$> with [cast msg]

