module Splash exposing (..)

import Html exposing (Html, a, b, div, i, img, span, text)
import Html.Attributes exposing (alt, class, height, href, src, width)


type alias Model =
    { support_message : Html Msg
    , error_message : Html Msg
    }


view : Model -> Html Msg
view model =
    div [ class "foo-content" ]
        [ div [ class "foo-error" ]
            [ img
                [ class "foo-error__logo"
                , src "/website/logo-loading.svg"
                , alt "Finding the SpaceTime"
                , width 130
                , height 130
                ]
                []
            , div [ class "foo-support__message" ] [ model.support_message ]
            , div [ class "foo-error__message" ] [ model.error_message ]
            , withSpacing (div [ class "foo-support__message" ])
                [ a [ href "https://avinal.space/pages/about-me" ] [ b [ class "foo-term-blue" ] [ text "A" ], text "bout" ]
                , a [ href "https://avinal.space/posts" ] [ b [ class "foo-term-blue" ] [ text "B" ], text "log" ]
                , a [ href "https://avinal.space/pages/projects" ] [ b [ class "foo-term-blue" ] [ text "P" ], text "rojects" ]
                , a [ href "https://gsoc.avinal.space" ] [ b [ class "foo-term-blue" ] [ text "G" ], text "SoC" ]
                ]
            ]
        ]


type Msg
    = Nothing


{-| How to get whitespace between html tags?

    Link: <https://stackoverflow.com/a/55827562/11143805>

-}
withSpacing : (List (Html msg) -> Html msg) -> List (Html msg) -> Html msg
withSpacing element =
    List.intersperse (text " ") >> element


notFound : String -> Model
notFound error =
    { support_message = default.support_message
    , error_message =
        withSpacing (span [])
            [ i [ class "fa-solid fa-triangle-exclamation foo-term-yellow" ] []
            , text "I could not find anything on this"
            , i [ class "fa-solid fa-link foo-term-red" ] []
            , a [ href error ] [ text error ]
            , text "If you think this is a mistake, please contact me."
            , i [ class "fa-solid fa-triangle-exclamation foo-term-yellow" ] []
            ]
    }


default : Model
default =
    { support_message =
        withSpacing (span [])
            [ a [ href "https://github.com/avinal" ] [ i [ class "fa-brands fa-github" ] [] ]
            , a [ href "https://www.linkedin.com/in/avinal" ] [ i [ class "fa-brands fa-linkedin" ] [] ]
            , a [ href "https://instagram.com/avinal.k" ] [ i [ class "fa-brands fa-instagram" ] [] ]
            , a [ href "https://meet.avinal.space" ] [ i [ class "fa-solid fa-calendar-days" ] [] ]
            , a [ href "mailto:ripple+blog@avinal.space" ] [ i [ class "fa-solid fa-envelope" ] [] ]
            , a [ href "https://avinal.space/terminal" ] [ i [ class "fa-solid fa-terminal" ] [] ]
            ]
    , error_message =
        withSpacing (span [])
            [ text "I'm"
            , b [ class "foo-term-pink" ] [ text "Avinal" ]
            , text "and I work at Red Hat"
            , i [ class "fa-brands fa-redhat foo-term-red" ] []
            , text "as an Associate Software Engineer for Hybrid Cloud Engineering."
            ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nothing ->
            ( model, Cmd.none )


init : () -> Bool -> String -> ( Model, Cmd Msg )
init _ isError error =
    if isError then
        ( notFound error, Cmd.none )

    else
        ( default, Cmd.none )
