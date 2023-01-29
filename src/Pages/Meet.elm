module Pages.Meet exposing (page)

import Components.Footer exposing (footerLinksToSide)
import Html 
import View exposing (View)


page : View msg
page =
    { title = "Schedule a meet with me"
    , body = [ footerLinksToSide, Html.node "calcom" [] [] ]
    }
