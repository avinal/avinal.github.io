module Layouts.Home exposing (Model, Msg, Props, layout)

import Components.Footer exposing (iconLinkToCenter)
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes exposing (class, href, target, rel)
import Layout exposing (Layout)
import Route exposing (Route)
import Shared
import Utils.Constants exposing (..)
import View exposing (View)
import Html.Attributes exposing (target)


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


view : { toContentMsg : Msg -> contentMsg, content : View contentMsg, model : Model } -> View contentMsg
view { toContentMsg, model, content } =
    let
        footerLinkToCenter : Link -> Html msg
        footerLinkToCenter link =
            Html.a
                [ href link.url
                , class "underline decoration-cyan-500 hover:decoration-pink-500 inline-flex text-xl p-3"
                , target "_blank"
                , rel "noopener noreferrer"
                ]
                [ Html.text link.text ]
    in
    { title = content.title
    , body =
        [ Html.section [ class "flex items-center justify-center flex-col h-screen text-gray-400" ]
            [ Html.header [ class "object-cover object-center p-8" ] content.body
            , iconLinkToCenter
            , Html.div [ class "text-center text-xl p-2" ] [ Html.text "Avinal Kumar, Software Engineer II at Red Hat, Open Sourcerer" ]
            , Html.footer [ class "flex justify-center flex-wrap" ]
                (List.map footerLinkToCenter Utils.Constants.footerLinks)
            ]
        ]
    }
