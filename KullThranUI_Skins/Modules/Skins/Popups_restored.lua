-- Legacy compatibility placeholder.
--
-- This file was an incomplete recovery fragment and started in the middle of
-- RefreshButtonArt(), which made it fail as soon as it was loaded. Popups.lua
-- is the maintained implementation and is the file registered by the TOC.
-- Keep this legacy filename load-safe for installations or tools that still
-- discover it by name; loading it must not duplicate the popup hooks.

return