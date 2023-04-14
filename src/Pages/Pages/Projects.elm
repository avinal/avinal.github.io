module Pages.Pages.Projects exposing (Model, Msg, page)

import Dict exposing (Dict)
import Effect exposing (Effect)
import Html exposing (div, img, section)
import Html.Attributes exposing (class, src)
import Page exposing (Page)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page _ _ =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init () =
    ( {}
    , Effect.pushRoute { path = Route.Path.NotFound_, query = Dict.empty, hash = Nothing }
    )



-- UPDATE


type Msg
    = ExampleMsgReplaceMe


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ExampleMsgReplaceMe ->
            ( model
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view _ =
    { title = "My Projects"
    , body =
        [ section [ class "overflow-hidden" ]
            [ div
                [ class "px-5 py-2 mx-auto lg:pt-24 lg:px-32" ]
                [ div [ class "flex flex-wrap -m-1 md:-m-2" ]
                    (List.repeat 8
                        (div [ class "flex flex-wrap w-1/2" ]
                            (List.repeat 2
                                (div
                                    [ class "w-full p-1 md:p-2" ]
                                    [ img
                                        [ src "https://opengraph.githubassets.com/string/avinal/blowfish"
                                        , class "block object-cover object-center w-full h-full rounded-lg"
                                        ]
                                        []
                                    ]
                                )
                            )
                        )
                    )
                ]
            ]
        ]
    }
