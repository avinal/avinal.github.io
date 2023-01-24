module Pages.Posts exposing (Model, Msg, page)

import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes exposing (class, href, src)
import Http
import Json.Decode as Json
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Url exposing (Protocol(..))
import Utils.Constants exposing (..)
import Utils.Utils as UU
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias JsonMeta =
    { title : String
    , date : String
    , description : String
    , category : String
    , slug : String
    , image : String
    }


type alias Model =
    { error : Maybe String
    , blogList : Maybe (List JsonMeta)
    }


init : () -> ( Model, Effect Msg )
init () =
    let
        cmd : Cmd Msg
        cmd =
            Http.get
                { url = "/content/posts/posts.json"
                , expect = Http.expectJson BloglistReceived (Json.list jsonMetaDecoder)
                }
    in
    ( { error = Nothing
      , blogList = Nothing
      }
    , Effect.sendCmd cmd
    )



-- UPDATE


type Msg
    = BloglistReceived (Result Http.Error (List JsonMeta))


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        BloglistReceived (Ok data) ->
            ( { model | blogList = Just data }
            , Effect.none
            )

        BloglistReceived (Err err) ->
            ( { model | error = Just (UU.errorToString err) }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    let
        maincard : List JsonMeta -> Html msg
        maincard bloglist =
            case bloglist of
                first :: rest ->
                    Html.div [ class "max-w-6xl p-6 mx-auto space-y-6 sm:space-y-12 mb-16" ]
                        [ Html.a [ class "block max-w-sm gap-3 mx-auto sm:max-w-full group hover:no-underline focus:no-underline lg:grid lg:grid-cols-12 bg-neutral-900", href ("/posts/" ++ first.category ++ "/" ++ first.slug) ]
                            [ Html.img [ class "object-cover w-full h-64 rounded sm:h-96 lg:col-span-7", src first.image ] []
                            , Html.div [ class "p-6 space-y-2 lg:col-span-5" ]
                                [ Html.h3 [ class "text-2xl font-semibold sm:text-4xl group-hover:underline group-focus:underline" ]
                                    [ Html.text first.title ]
                                , Html.span [ class "text-gray-400" ] [ Html.text first.date ]
                                , Html.p [] [ Html.text <| String.left 200 first.description ]
                                , UU.categoryNtags first.category []
                                ]
                            ]
                        , Html.div [ class "grid justify-center grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3" ] <| List.map card rest
                        ]

                [] ->
                    Html.div [] []

        card : JsonMeta -> Html msg
        card blog =
            Html.a [ class "max-w-sm  mx-auto group hover:no-underline focus:no-underline bg-neutral-900", href ("/posts/" ++ blog.category ++ "/" ++ blog.slug) ]
                [ Html.img [ class "object-cover w-full h-44 rounded", src blog.image ] []
                , Html.div [ class "p-6 space-y-2" ]
                    [ Html.h3 [ class "text-2xl font-semibold group-hover:underline group-focus:underline" ] [ Html.text blog.title ]
                    , Html.span [ class " text-gray-400" ] [ Html.text blog.date ]
                    , Html.p [] [ Html.text <| String.left 200 blog.description ]
                    , UU.categoryNtags blog.category []
                    ]
                ]

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
    case model.blogList of
        Just blogList ->
            { title = "Blog by Avinal"
            , body =
                [ Html.section [ class "text-gray-100" ]
                    [ maincard blogList
                    , Html.div [ class "fixed bottom-0 left-0 bg-neutral-900 z-20 p-4 w-full md:flex md:items-center md:justify-between md:p-4" ]
                        [ Html.ul
                            [ class "flex flex-wrap items-center mt-3 text-xl text-neutral-500 sm:mt-0" ]
                            (List.map footerLinkToLeft <|
                                { text = "Home", url = "/" }
                                    :: Utils.Constants.footerLinks
                            )
                        ]
                    ]
                ]
            }

        Nothing ->
            { title = "Something went wrong"
            , body = [ Html.text <| Maybe.withDefault "" model.error ]
            }



-- UTILS


jsonMetaDecoder : Json.Decoder JsonMeta
jsonMetaDecoder =
    Json.map6 JsonMeta
        (Json.field "title" Json.string)
        (Json.field "date" Json.string)
        (Json.field "description" Json.string)
        (Json.field "category" Json.string)
        (Json.field "slug" Json.string)
        (Json.field "image" Json.string)
