module Terminal exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { title : String
    , url : String
    }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.title ]
        , input [ placeholder "Enter URL", onInput UrlEntered ] []
        , button [ onClick Go ] [ text "Go" ]
        , a [ href model.url ] [ text model.url ]
        ]


type Msg
    = UrlEntered String
    | Go


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlEntered url ->
            ( { model | url = url }, Cmd.none )

        Go ->
            ( model, Cmd.none )


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "Terminal" "", Cmd.none )
