module Components.Footer exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (class, href, src, target)
import Utils.Constants exposing (IconLink, Link, footerLinks)
import Html.Attributes exposing (rel)


singleLink : Link -> Html msg
singleLink link =
         Html.a
            [ href link.url
            , class "underline decoration-cyan-500 hover:decoration-pink-500 text-xl"
            , target "_blank"
            , rel "noopener noreferrer"
            ]
            [ Html.text link.text ]

iconedLink : IconLink -> Html msg
iconedLink iconLink =
    Html.a [ href iconLink.url, class "hover:text-pink-500 inline-flex text-2xl p-3 no-underline" ]
        [ Html.i [ class iconLink.icon ] []
        ]


footerLinksToSide : Html msg
footerLinksToSide =
    Html.div [ class "fixed bottom-0 left-0 bg-neutral-900 p-4 w-full border-t border-cyan-500" ]
        [ Html.div [ class "mx-auto flex justify-center space-x-6 text-gray-400" ]
            (List.map singleLink <|
                { text = "Home", url = "/" }
                    :: footerLinks
            )
        ]


iconLinkToCenter : Html msg
iconLinkToCenter =
    Html.div [ class "flex justify-center flex-wrap" ] (List.map iconedLink Utils.Constants.iconLinks)


avatarAndLinks : Html msg
avatarAndLinks =
    Html.div []
        [ Html.div [ class "flex flex-col md:space-y-0 md:space-x-6 md:flex-row border-t border-neutral-700" ]
            [ Html.img
                [ class "self-center flex-shrink-0 w-24 h-24 border rounded-full md:justify-self-start"
                , src "https://github.com/avinal.png"
                ]
                []
            , Html.div [ class "flex flex-col self-center" ]
                [ Html.h4 [ class "text-xl font-semibold sm:justify-self-start" ] [ Html.text "Avinal Kumar" ]
                , Html.p [ class "text-gray-400" ]
                    [ Html.text "I am a Associate Software Engineer at Red Hat and I work for Hybrid Cloud Engineering. I contribute to Open Source projects and write blogs in tech and literature."
                    ]
                ]
            ]
        , Html.div [ class "flex justify-center align-center text-neutral-700 text-xl" ] (List.map iconedLink Utils.Constants.iconLinks)
        ]
