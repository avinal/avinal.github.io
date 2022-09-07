module Static exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { title : String
    , url : String
    }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.title ]
        , a [ href model.url ] [ text model.url ]
        ]


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "Hello World" "http://elm-lang.org"
    , Cmd.none
    )
