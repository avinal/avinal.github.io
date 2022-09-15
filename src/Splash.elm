module Splash exposing (..)

import Html exposing (Html, a, div, i, img, p, span, text)
import Html.Attributes exposing (alt, class, height, href, src, style, width)


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
            , div [ class "foo-support__message" ]
                [ a [ href "https://avinal.space/pages/about-me" ] [ text "About me " ]
                , text "   "
                , a [ href "https://avinal.space/posts" ] [ text "Blog" ]
                , text "   "
                , a [ href "https://avinal.space/pages/projects" ] [ text "Projects" ]
                , text "   "
                , a [ href "https://gsoc.avinal.space" ] [ text "GSoC" ]
                ]
            ]
        ]


type Msg
    = Nothing


notFound : String -> Model
notFound error =
    { support_message = default.support_message
    , error_message =
        span []
            [ i [ class "fa-duotone fa-triangle-exclamation foo-term-yellow" ] []
            , text " I could not find anything on this "
            , i [ class "fa-duotone fa-link" ] [ text error ]
            , text " . If you think this is a mistake, please contact me."
            , i [ class "fa-duotone fa-triangle-exclamation foo-term-yellow" ] []
            ]
    }


default : Model
default =
    { support_message =
        span []
            [ a [ href "https://github.com/avinal" ] [ i [ class "fa-brands fa-github" ] [] ]
            , a [ href "https://www.linked.com/in/avinal" ] [ i [ class "fa-brands fa-linkedin" ] [] ]
            , a [ href "https://instagram.com/avinal.k" ] [ i [ class "fa-brands fa-instagram" ] [] ]
            , a [ href "" ] [ i [ class "fa-duotone fa-calandar-days" ] [] ]
            , a [ href "mailto:ripple+blog@avinal.space" ] [ i [ class "fa-duotone fa-envelope" ] [] ]
            , a [ href "https://avinal.space/terminal" ] [ i [ class "fa-duotone fa-terminal" ] [] ]
            ]
    , error_message =
        span []
            [ text "I'm Avinal, and I work at Red Hat"
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
