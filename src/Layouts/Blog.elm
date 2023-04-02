module Layouts.Blog exposing (Model, Msg, Settings, layout)

import Components.Footer exposing (footerLinksToSide)
import Effect exposing (Effect)
import Html
import Html.Attributes exposing (class)
import Layout exposing (Layout)
import Route exposing (Route)
import Shared
import Utils.Constants exposing (..)
import View exposing (View)


type alias Settings =
    {}


layout : Settings -> Shared.Model -> Route () -> Layout Model Msg mainMsg
layout settings _ _ =
    Layout.new
        { init = init settings
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    {}


init : Settings -> () -> ( Model, Effect Msg )
init _ _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


blogTheme : String
blogTheme =
    "prose prose-invert mx-auto lg:prose-lg prose-a:decoration-cyan-500 hover:prose-a:decoration-pink-500"


view : { fromMsg : Msg -> mainMsg, content : View mainMsg, model : Model } -> View mainMsg
view { fromMsg, model, content } =
    { title = content.title
    , body =
        [ Html.div [ class "min-h-screen flex flex-col justify-center relative overflow-hidden" ]
            [ Html.div [ class "relative w-full bg-neutral  md:max-w-3xl md:mx-auto lg:max-w-4xl lg:pb-28" ]
                [ Html.article [ class blogTheme ]
                    content.body
                ]
            ]
        , footerLinksToSide
        ]
    }
