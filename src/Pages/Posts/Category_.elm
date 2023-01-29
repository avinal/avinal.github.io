module Pages.Posts.Category_ exposing (Model, Msg, page)

import Components.Footer exposing (footerLinksToSide)
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes exposing (class, datetime, href, src)
import Http
import Json.Decode as Json
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Utils.Constants exposing (..)
import Utils.Utils as UU
import View exposing (View)


page : Shared.Model -> Route { category : String } -> Page Model Msg
page _ route =
    Page.new
        { init = init route
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
    , category : String
    }


init : Route { category : String } -> () -> ( Model, Effect Msg )
init route () =
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
      , category = route.params.category
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
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    let
        card : JsonMeta -> Html msg
        card blog =
            Html.a [ class "flex flex-wrap mb-6 ", href <| "/posts/" ++ blog.category ++ "/" ++ blog.slug ]
                [ Html.div [ class "grow-0 shrink-0 basis-auto w-full md:w-3/12 md:mb-0 ml-auto" ]
                    [ Html.div [ class "overflow-hidden relative bg-no-repeat bg-cover ripple" ]
                        [ Html.img [ src blog.image, class "w-full h-44 object-cover rounded" ] []
                        ]
                    ]
                , Html.div [ class "grow-0 shrink-0 basis-auto w-full md:w-9/12 xl:w-7/12 p-3 md:mb-0 mr-auto bg-neutral-900" ]
                    [ Html.h5 [ class "text-2xl font-bold mb-2" ] [ Html.text blog.title ]
                    , Html.time [ class "text-gray-400 text-sm", datetime blog.date ] [ Html.text <| UU.getFormattedDate blog.date ]
                    , Html.p [ class "text-gray-500 mt-4 text-md" ] [ Html.text <| String.left 200 blog.description ]
                    ]
                ]
    in
    case model.blogList of
        Just blogList ->
            let
                filteredList =
                    filterBlogListByCategory blogList model.category
            in
            case filteredList of
                [] ->
                    { title = "No posts in this category"
                    , body = []
                    }

                clist ->
                    { title = "Posts in " ++ model.category ++ " category"
                    , body =
                        [ Html.div []
                            [ Html.section [ class "mb-32 text-gray-200 text-center md:text-left" ] <|
                                Html.h1 [ class "text-5xl font-bold mb-12 mt-12 text-center text-white" ] [ Html.text "Posts in ", Html.i [ class "text-pink-600" ] [ Html.text model.category ], Html.text " category" ]
                                    :: List.map card clist
                            , footerLinksToSide
                            ]
                        ]
                    }

        Nothing ->
            { title = "There is no such category"
            , body = []
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


filterBlogListByCategory : List JsonMeta -> String -> List JsonMeta
filterBlogListByCategory blogList category =
    List.filter (\meta -> meta.category == category) blogList
