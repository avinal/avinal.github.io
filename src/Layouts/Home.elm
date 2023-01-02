module Layouts.Home exposing (Model, Msg, Settings, layout)

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


view : { fromMsg : Msg -> mainMsg, content : View mainMsg, model : Model } -> View mainMsg
view { fromMsg, model, content } =
    let
        footerLinkToCenter : Link -> Html msg
        footerLinkToCenter link =
            Html.a
                [ href link.url
                , class "underline decoration-cyan-500 hover:decoration-pink-500 inline-flex text-xl p-3"
                ]
                [ Html.text link.text ]

        iconLinkToCenter : IconLink -> Html msg
        iconLinkToCenter iconLink =
            Html.a [ href iconLink.url, class " hover:text-pink-500 inline-flex text-2xl p-3" ]
                [ Html.i [ class iconLink.icon ] [] ]
    in
    { title = content.title
    , body =
        [ Html.section [ class "flex items-center justify-center flex-col h-screen text-neutral-400" ]
            [ Html.header [ class "object-cover object-center p-8" ] content.body
            , Html.div [ class "flex justify-center flex-wrap" ]
                (List.map iconLinkToCenter Utils.Constants.iconLinks)
            , Html.div [ class "text-center text-xl p-2" ] [ Html.text "I'm Avinal and I work at Red Hat as an Associate Software Engineer for Hybrid Cloud Engineering." ]
            , Html.footer [ class "flex justify-center flex-wrap" ]
                (List.map footerLinkToCenter Utils.Constants.footerLinks)
            ]
        ]
    }
