module Layouts.Blog exposing (Model, Msg, Settings, layout)

import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes exposing (class, href)
import Layout exposing (Layout)
import Route exposing (Route)
import Shared
import Utils.Constants exposing (..)
import View exposing (View)


type alias Settings =
    {}


layout : Settings -> Shared.Model -> Route () -> Layout Model Msg mainMsg
layout settings shared route =
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
init settings _ =
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
subscriptions model =
    Sub.none



-- VIEW


blogTheme : String
blogTheme =
    "mt-4 prose prose-invert mx-auto lg:prose-lg prose-a:decoration-cyan-500 hover:prose-a:decoration-pink-500 prose-img:float-right"


view : { fromMsg : Msg -> mainMsg, content : View mainMsg, model : Model } -> View mainMsg
view { fromMsg, model, content } =
    { title = content.title
    , body =
        let
            footerLinkToLeft : Link -> Html msg
            footerLinkToLeft link =
                Html.li []
                    [ Html.a
                        [ href link.url
                        , class "mr-4 md:mr-6 underline decoration-cyan-500 hover:decoration-pink-500"
                        ]
                        [ Html.text link.text ]
                    ]
        in
        [ Html.div [ class "min-h-screen py-4 flex flex-col justify-center relative overflow-hidden " ]
            [ Html.div [ class "relative w-full py-4 bg-neutral  md:max-w-3xl md:mx-auto lg:max-w-4xl lg:pb-28" ]
                [ Html.article [ class blogTheme ]
                    content.body
                ]
            ]
        , Html.div [ class "fixed bottom-0 left-0 bg-neutral-900 z-20 p-4 w-full md:flex md:items-center md:justify-between md:p-4" ]
            [ Html.ul
                [ class "flex flex-wrap items-center mt-3 text-xl text-neutral-500 sm:mt-0" ]
                (List.map footerLinkToLeft <|
                    { text = "Home", url = "/" }
                        :: Utils.Constants.footerLinks
                )
            ]
        ]
    }
