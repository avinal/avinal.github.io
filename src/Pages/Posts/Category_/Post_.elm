module Pages.Posts.Category_.Post_ exposing (Model, Msg, page)

import Components.Footer exposing (avatarAndLinks)
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes exposing (alt, class, datetime, href, src, title)
import Http
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Url exposing (Protocol(..))
import Utils.Utils as UU
import View exposing (View)
import Yaml.Decode as Yaml


page : Shared.Model -> Route { category : String, post : String } -> Page Model Msg
page _ route =
    Page.new
        { init = init route
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
        |> Page.withLayout layout



-- LAYOUT


layout : Model -> Layouts.Layout
layout _ =
    Layouts.Blog
        { blog =
            {}
        }



-- INIT


type alias Model =
    { blog : Maybe Blog
    , requestUrl : String
    , success : Bool
    , fragment : String
    , error : Maybe String
    }


type alias Blog =
    { meta : YamlMeta
    , content : String
    }


init : Route { category : String, post : String } -> () -> ( Model, Effect Msg )
init route () =
    let
        requestUrl =
            UU.contentUrl
                { category = route.params.category
                , post = route.params.post
                }

        cmd : Cmd Msg
        cmd =
            Http.get
                { url = requestUrl
                , expect = Http.expectString RawMarkdownReceived
                }
    in
    ( { blog = Nothing
      , requestUrl = requestUrl
      , success = False
      , fragment = Maybe.withDefault "" route.hash
      , error = Nothing
      }
    , Effect.sendCmd cmd
    )



-- UPDATE


type Msg
    = RawMarkdownReceived (Result Http.Error String)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        RawMarkdownReceived (Ok data) ->
            case splitMetaContent data of
                Ok blog ->
                    ( { model | blog = Just blog, success = True }, Effect.none )

                Err err ->
                    ( { model | success = False, error = Just err }, Effect.none )

        RawMarkdownReceived (Err err) ->
            ( { model | success = False, error = Just (UU.errorToString err) }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    case model.blog of
        Just blog ->
            { title = "Blog | " ++ blog.meta.title
            , body =
                [ Html.div [ class "bg-neutral-900 md:-mx-8 lg:-mx-16 px-8 py-1" ]
                    [ Html.header [ class "relative" ]
                        [ Html.img
                            [ class "object-cover w-full h-60 sm:h-96 brightness-50 "
                            , src blog.meta.image
                            , alt blog.meta.title
                            ]
                            []
                        , Html.h1 [ class "absolute top-3/4 left-1/2 -translate-x-1/2 -translate-y-1/2 text-center w-full" ] [ Html.text blog.meta.title ]
                        ]
                    , Html.span [ class "text-base font-regular" ]
                        [ Html.text "By "
                        , Html.a [ href "https://avinal.space/pages/about-me", class "font-bold no-underline hover:text-pink-500" ] [ Html.text "Avinal Kumar" ]
                        , Html.text " on "
                        , Html.time [ datetime blog.meta.date ] [ Html.text <| UU.getFormattedDate blog.meta.date ]
                        ]
                    , Html.span [ class "text-base font-light float-right" ] [ Html.a [ href "", class "hover:text-pink-500" ] [ Html.abbr [ class "fa-solid fa-link no-underline", title "Share this article" ] [] ] ]
                    , articleNode blog.content model.fragment blog.meta.title blog.meta.description
                    ]
                , Html.div [ class "text-center text-neutral-300 border-dashed border-teal-500 p-2" ]
                    [ Html.text "Published under "
                    , Html.a [ href "https://www.mozilla.org/en-US/MPL/2.0/" ] [ Html.text "Mozilla Public License 2.0" ]
                    , Html.text "  if you found an issue with the page, please report it "
                    , Html.a [ href <| "https://github.com/avinal/avinal.github.io/issues/new?title=bug:+" ++ String.replace " " "+" blog.meta.title ] [ Html.text "here." ]
                    ]
                , UU.categoryNtags blog.meta.category blog.meta.tags
                , avatarAndLinks
                ]
            }

        Nothing ->
            { title = "Avinal Kumar | Something went wrong"
            , body =
                [ case model.error of
                    Just err ->
                        errorView err

                    Nothing ->
                        Html.div [ class "flex items-center justify-center flex-col object-cover object-center " ]
                            []
                ]
            }


errorView : String -> Html msg
errorView error =
    Html.div
        [ class "border border-red-400 text-red-700 px-4 py-3 rounded relative" ]
        [ Html.strong [ class "text-red-400" ] [ Html.text "Something bad has happened!" ]
        , Html.br [] []
        , Html.text ("Error: " ++ error)
        ]


articleNode : String -> String -> String -> String -> Html Msg
articleNode data fragment title description =
    Html.node "rendered-md"
        [ Html.Attributes.attribute "markdowndata" data
        , Html.Attributes.attribute "fragment" fragment
        , Html.Attributes.attribute "title" title
        , Html.Attributes.attribute "description" description
        , class "line-numbers"
        ]
        []



-- UTILITIES


type alias YamlMeta =
    { title : String
    , date : String
    , description : String
    , tags : List String
    , category : String
    , image : String
    , modified : Maybe String
    }


splitMetaContent : String -> Result String Blog
splitMetaContent data =
    let
        headIndices : List Int
        headIndices =
            String.indices "---" data |> List.take 2

        metadata =
            String.slice ((Maybe.withDefault 0 <| List.head headIndices) + 3)
                ((Maybe.withDefault 0 <| List.head <| List.reverse headIndices) - 1)
                data

        content =
            String.dropLeft ((Maybe.withDefault 0 <| List.head <| List.reverse headIndices) + 3) data
    in
    case Yaml.fromString metaDecoder metadata of
        Ok meta ->
            Ok { meta = meta, content = content }

        Err err ->
            Err ("YAML front matter parsing failed: " ++ Yaml.errorToString err)


metaDecoder : Yaml.Decoder YamlMeta
metaDecoder =
    Yaml.map7 YamlMeta
        (Yaml.field "title" Yaml.string)
        (Yaml.field "date" Yaml.string)
        (Yaml.field "description" Yaml.string)
        (Yaml.field "tags" (Yaml.list Yaml.string))
        (Yaml.field "category" Yaml.string)
        (Yaml.field "image" Yaml.string)
        (Yaml.maybe (Yaml.field "modified" Yaml.string))
