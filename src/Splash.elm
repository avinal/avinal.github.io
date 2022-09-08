module Splash exposing (..)

import Html exposing (Html, div, img, p, text)
import Html.Attributes exposing (alt, class, height, src, width)


type alias Model =
    { urls : List String
    , support_message : String
    , error_message : String
    }


view : Model -> Html msg
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
            , p [ class "foo-support__message" ] [ text model.support_message ]
            , p [ class "foo-error__message" ] [ text model.error_message ]
            ]
        ]


type Msg
    = Nothing


notFound : String -> Model
notFound error =
    { urls = []
    , support_message = "We couldn't find the page you were looking for."
    , error_message = "The url " ++ error ++ " does not exist."
    }


default : Model
default =
    { urls = []
    , support_message = "We are looking for the SpaceTime"
    , error_message = "We are sorry, but we can't find the SpaceTime"
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
