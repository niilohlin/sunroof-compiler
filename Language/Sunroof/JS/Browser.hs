{-# LANGUAGE OverloadedStrings #-}

-----------------------------------------------------------------------------
-- |
-- Module      :  Data.Active
-- Copyright   :  (c) 2011 The University of Kansas
-- License     :  BSD-style (see LICENSE)
-- Maintainer  :  ???
--
-- A reflection of the standard browser JavaScript API.
--

module Language.Sunroof.JS.Browser
  -- Top level API
  ( alert
  , decodeURI
  , encodeURI
  , decodeURIComponent
  , encodeURIComponent
  , eval
  , isFinite
  , isNaN
  , parseFloat
  , parseInt
  -- Window API
  , window
  , setInterval
  , clearInterval
  , setTimeout
  , clearTimeout
  -- Screen API
  , screen
  -- Document API
  , document
  , getElementById
  , getElementsByName
  , getElementsByTagName
  , createAttribute
  , createElement
  , createTextNode
  , open
  , close
  , write
  , writeln
  , setCookie
  , cookie
  , referrer
  , setTitle
  , title
  , url
  -- * The JavaScript Console
  , JSConsole
  , console
  , Language.Sunroof.JS.Browser.log
  , debug
  , info
  , warn
  , Language.Sunroof.JS.Browser.error
  ) where

import Prelude hiding (isNaN)

import Language.Sunroof.Types
  ( JSFunction
  , JS
  , JS ( (:=) )
  , fun
  , invoke
  , object
  , attribute
  , apply
  , (#)
  )
import Language.Sunroof.Classes ( Sunroof(..), JSArgument )
import Language.Sunroof.Selector ( JSSelector )
import Language.Sunroof.JS.Bool ( JSBool )
import Language.Sunroof.JS.Object ( JSObject )
import Language.Sunroof.JS.String ( JSString )
import Language.Sunroof.JS.Number ( JSNumber )

-- -----------------------------------------------------------------------
-- Object Independent Functions
-- -----------------------------------------------------------------------

-- | Display the given text in a message box.
alert :: JSString -> JS t ()
alert msg = fun "alert" `apply` (msg)

-- | Decode the URI encoded in the given string.
decodeURI :: JSString -> JS t JSString
decodeURI str = fun "decodeURI" `apply` (str)

-- | Encode the given string in URI encoding.
encodeURI :: JSString -> JS t JSString
encodeURI str = fun "encodeURI" `apply` (str)

-- | Decode the URI encoded string. For use with 'encodeURIComponent'.
decodeURIComponent :: JSString -> JS t JSString
decodeURIComponent str = fun "decodeURIComponent" `apply` (str)

-- | Encode the string with URI encoding. This encodes a few more
--   characters to make the string safe for direct server communication (AJAX).
encodeURIComponent :: JSString -> JS t JSString
encodeURIComponent str = fun "encodeURIComponent" `apply` (str)

-- | Evaluate the given JavaScript string if possible. Returns
--   the result of evaluation.
-- TODO: think about this a bit.
eval :: (Sunroof a) => JSString -> JS t a
eval str = fun "eval" `apply` (str)

-- | Check if a given number is within the valid JavaScript number range.
isFinite :: JSNumber -> JS t JSBool
isFinite n = fun "isFinite" `apply` (n)

-- | Check if a given number is NaN or not.
isNaN :: JSNumber -> JS t JSBool
isNaN n = fun "isNaN" `apply` (n)

-- | Parse the given string to a number.
parseFloat :: JSString -> JS t JSNumber
parseFloat str = fun "parseFloat" `apply` (str)

-- | Parse the given string to a number.
parseInt :: JSString -> JS t JSNumber
parseInt str = fun "parseInt" `apply` (str)

-- -----------------------------------------------------------------------
-- Window API
-- -----------------------------------------------------------------------

-- | The window object.
window :: JSObject
window = object "window"

-- | Calls a function at specified intervals in milliseconds.
--   It will continue calling the function until 'clearInterval' is called,
--   or the window is closed. The returned number is needed for 'clearInterval'.
setInterval :: (Sunroof r) => JSFunction () r -> JSNumber -> JSObject -> JS t JSNumber
setInterval f interval = invoke "setInterval" (f, interval)

-- | Clears a timer set with the 'setInterval' method.
clearInterval :: JSNumber -> JSObject -> JS t ()
clearInterval ident = invoke "clearInterval" (ident)

setTimeout :: (Sunroof r) => JSFunction () r -> JSNumber -> JSObject -> JS t JSNumber
setTimeout f interval = invoke "setTimeout" (f, interval)

clearTimeout :: JSNumber -> JSObject -> JS t ()
clearTimeout ident = invoke "clearTimeout" (ident)

-- -----------------------------------------------------------------------
-- Screen API
-- -----------------------------------------------------------------------

-- | The screen object.
screen :: JSObject
screen = object "screen"

-- -----------------------------------------------------------------------
-- Document API
-- -----------------------------------------------------------------------

-- | The document object.
document :: JSObject
document = object "document"

-- | Get the DOM object of the element with the given id.
--   For use with 'document'.
getElementById :: JSString -- ^ The id.
               -> JSObject -> JS t JSObject
getElementById ident = invoke "getElementById" (ident)

-- | Get the DOM objects of the elements with the given name.
--   For use with 'document'.
getElementsByName :: JSString -- ^ The name.
                  -> JSObject -> JS t JSObject
getElementsByName name = invoke "getElementsByName" (name)

-- | Get the DOM objects of the elements with the given tag.
--   For use with 'document'.
getElementsByTagName :: JSString -- ^ The tag name.
                     -> JSObject -> JS t JSObject
getElementsByTagName tag = invoke "getElementsByTagName" (tag)

-- | Create a attribute DOM node with the given name.
--   For use with 'document'.
createAttribute :: JSString -- ^ The name of the new attribute.
                -> JSObject -> JS t JSObject
createAttribute attr = invoke "createAttribute" (attr)

-- | Create a element DOM node with the given tag name.
--   For use with 'document'.
createElement :: JSString -- ^ The tag name of the new element.
              -> JSObject -> JS t JSObject
createElement e = invoke "createElement" (e)

-- | Create a text DOM node with the given string as text.
--   For use with 'document'.
createTextNode :: JSString -- ^ The text of the new text node.
               -> JSObject -> JS t JSObject
createTextNode text = invoke "createTextNode" (text)

-- | Opens the document for writing.
--   For use with 'document'.
open :: JSObject -> JS t ()
open = invoke "open" ()

-- | Closes the document after writing.
--   For use with 'document'.
close :: JSObject -> JS t ()
close = invoke "close" ()

-- | Writes something into the document.
--   For use with 'document'.
write :: JSString -> JSObject -> JS t ()
write str = invoke "write" (str)

-- | Write something into the document and appends a new line.
--   For use with 'document'.
writeln :: JSString -> JSObject -> JS t ()
writeln str = invoke "writeln" (str)

-- | Sets the value of the cookie.
--   For use with 'document'.
setCookie :: JSString -> JSObject -> JS t ()
setCookie c = "cookie" := c

-- | Returns the value of the cookie.
--   For use with 'document'.
cookie :: JSSelector JSString
cookie = attribute "cookie"

-- | Returns the referrer of the document.
--   For use with 'document'.
referrer :: JSSelector JSString
referrer = attribute "referrer"

-- | Sets the title of the document.
--   For use with 'document'.
setTitle :: JSString -> JSObject -> JS t ()
setTitle t = "title" := t

-- | Returns the title of the document.
--   For use with 'document'.
title :: JSSelector JSString
title = attribute "title"

-- | Returns the complete URL of the document.
--   For use with 'document'.
url :: JSSelector JSString
url = attribute "URL"

-- -----------------------------------------------------------------------
-- Console API
-- -----------------------------------------------------------------------

data JSConsole = JSConsole JSObject
        deriving (Show)

instance Sunroof JSConsole where
        box = JSConsole . box
        unbox (JSConsole e) = unbox e

-- | The console object.
console :: JSConsole
console = JSConsole (object "console")

log :: (JSArgument a) => a -> JSConsole -> JS t ()
log a (JSConsole o) = o # invoke "log" a

debug :: (JSArgument a) => a -> JSConsole -> JS t ()
debug a (JSConsole o) = o # invoke "debug" a

info :: (JSArgument a) => a -> JSConsole -> JS t ()
info a (JSConsole o) = o # invoke "info" a

warn :: (JSArgument a) => a -> JSConsole -> JS t ()
warn a (JSConsole o) = o # invoke "warn" a

error :: (JSArgument a) => a -> JSConsole -> JS t ()
error a (JSConsole o) = o # invoke "error" a


