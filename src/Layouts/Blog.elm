module Layouts.Blog exposing (Model, Msg, Props, layout)

import Components.Footer exposing (footerLinksToSide)
import Effect exposing (Effect)
import Html
import Html.Attributes exposing (class, id)
import Layout exposing (Layout)
import Route exposing (Route)
import Shared
import Utils.Constants exposing (..)
import View exposing (View)


type alias Props =
    {}


layout : Props -> Shared.Model -> Route () -> Layout () Model Msg contentMsg
layout props shared route =
    Layout.new
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model
            , Effect.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW

blogTheme : String
blogTheme =
    "prose prose-invert mx-auto lg:prose-lg prose-a:decoration-cyan-500 hover:prose-a:decoration-pink-500"


view : { toContentMsg : Msg -> contentMsg, content : View contentMsg, model : Model } -> View contentMsg
view { toContentMsg, model, content } =
    { title = content.title
    , body =
        [ Html.div [ class "min-h-screen flex flex-col justify-center relative overflow-hidden" ]
            [ Html.div [ class "relative w-full bg-neutral  md:max-w-3xl md:mx-auto lg:max-w-4xl lg:pb-28" ]
                [ Html.article [ class blogTheme ]
                    content.body
                , Html.div [ id "remark42", class "md:px-4 mb-16" ] []
                ]
            ]
        , footerLinksToSide
        ]
    }
