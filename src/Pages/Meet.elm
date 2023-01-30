module Pages.Meet exposing (page)

import Components.Footer exposing (footerLinksToSide)
import Html
import Html.Attributes exposing (class, id)
import View exposing (View)


page : View msg
page =
    { title = "Schedule a meet with me"
    , body =
        [ Html.div [ class "flex items-center justify-center flex-col h-screen m-2" ]
            [ Html.node "cal-com" [ id "calcom-widget", class "w-full p-2" ] []
            ]
        , Html.div [ class "py-16" ] []
        , footerLinksToSide
        ]
    }
