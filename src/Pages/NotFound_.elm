module Pages.NotFound_ exposing (page)

import Html exposing (Html)
import Html.Attributes exposing (class, href)
import Utils.Utils exposing (errorView)
import View exposing (View)


page : View msg
page =
    { title = "Not Found"
    , body =
        [ Html.div [ class "min-h-screen flex flex-col justify-center relative overflow-hidden" ]
            [ Html.div [ class "relative w-full bg-neutral  md:max-w-3xl md:mx-auto lg:max-w-4xl lg:pb-28 space-2" ]
                [ errorView "Couldn't find what you are looking for. Please check back later"
                , Html.a [ class "float-right bg-transparent mr-auto hover:bg-pink-600 text-cyan-500 hover:text-white rounded border py-2 px-4 border-cyan-500 mt-2", href "https://avinal.space" ] [ Html.text "Return to Home!" ]
                ]
            ]
        ]
    }
