module Pages.Posts.Category_.Post_ exposing (Model, Msg, page)

import Components.Footer exposing (avatarAndLinks)
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes exposing (alt, class, datetime, href, rel, src)
import Http
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
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
                [ Html.img
                    [ class "object-cover w-full h-60 sm:h-96 rounded"
                    , src blog.meta.image
                    , alt blog.meta.title
                    ]
                    []
                , articleNode blog.content model.fragment
                , Html.div [ class "text-center text-neutral-300 border-t border-dashed border-teal-500 p-2" ]
                    [ Html.time [ datetime blog.meta.date ] [ Html.text <| "Published on " ++ UU.getFormattedDate blog.meta.date ++ " under  " ]
                    , Html.a [ href "https://www.mozilla.org/en-US/MPL/2.0/" ] [ Html.text "Mozilla Public License 2.0" ]
                    , Html.text "  if you found an issue with the page, please report it "
                    , Html.a [ href <| "https://github.com/avinal/avinal.github.io/issues/new?title=bug:+" ++ String.replace " " "+" blog.meta.title ] [ Html.text "here." ]
                    ]
                , UU.categoryNtags blog.meta.category blog.meta.tags
                , avatarAndLinks
                ]
            }

        Nothing ->
            { title = "Be My SpaceTime | Something went wrong"
            , body =
                [ case model.error of
                    Just err ->
                        errorView err

                    Nothing ->
                        Html.div [ class "flex items-center justify-center flex-col object-cover object-center " ]
                            [ svg
                                [ SvgAttr.width "85"
                                , SvgAttr.height "80"
                                , SvgAttr.shapeRendering "crispEdges"
                                ]
                                [ Svg.style
                                    [ SvgAttr.type_ "text/css"
                                    ]
                                    [ Html.text ".color { -webkit-animation: col 1s linear infinite; -moz-animation: col 1s linear infinite; -o-animation: col 1s linear infinite; animation: col 1s linear infinite; } @keyframes col { 0% { fill: #EE67A4; } 12.5% { fill: violet; } 25% { fill: indigo; } 37.5% { fill: blue; } 50% { fill: #35BEB8 } 62.5% { fill: green; } 75% { fill: yellow; } 87.5% { fill: orange; } 100% { fill: red; } } .rcolor { -webkit-animation: rcol 1s linear infinite; -moz-animation: rcol 1s linear infinite; -o-animation: rcol 1s linear infinite; animation: rcol 1s linear infinite; } @keyframes rcol { 0% { fill: #35BEB8; } 12.5% { fill: blue; } 25% { fill: indigo; } 37.5% { fill: violet; } 50% { fill: #EE67A4; } 62.5% { fill: red; } 75% { fill: orange; } 87.5% { fill: yellow; } 100% { fill: green; } }" ]
                                , Svg.symbol
                                    [ SvgAttr.id "logo"
                                    , SvgAttr.viewBox "0 -60 65 60"
                                    ]
                                    [ path
                                        [ SvgAttr.class "st0 color"
                                        , SvgAttr.d "M60-60H0V0h60z"
                                        ]
                                        []
                                    , path
                                        [ SvgAttr.class "st1"
                                        , SvgAttr.d "M60-41h-5v10h5z"
                                        ]
                                        []
                                    , path
                                        [ SvgAttr.class "st2 rcolor"
                                        , SvgAttr.d "M65-41h-5v10h5z"
                                        ]
                                        []
                                    ]
                                , Svg.use
                                    [ SvgAttr.xlinkHref "#logo"
                                    , SvgAttr.width "65"
                                    , SvgAttr.height "60"
                                    , SvgAttr.id "XMLID_14_"
                                    , SvgAttr.y "-60"
                                    , SvgAttr.transform "scale(1 -1)"
                                    , SvgAttr.overflow "visible"
                                    ]
                                    []
                                ]
                            ]
                ]
            }


errorView : String -> Html msg
errorView error =
    Html.div
        [ class "flex items-center rounded shadow-md overflow-hidden max-w-xl relative bg-neutral-900 text-gray-100"
        ]
        [ Html.div
            [ class "self-stretch flex items-center px-3 flex-shrink-0 bg-gray-700 text-pink-500"
            ]
            [ svg
                [ SvgAttr.fill "none"
                , SvgAttr.viewBox "0 0 24 24"
                , SvgAttr.stroke "currentColor"
                , SvgAttr.class "h-8 w-8"
                ]
                [ path
                    [ SvgAttr.strokeLinecap "round"
                    , SvgAttr.strokeLinejoin "round"
                    , SvgAttr.strokeWidth "2"
                    , SvgAttr.d "M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"
                    ]
                    []
                ]
            ]
        , Html.div
            [ class "p-4 flex-1"
            ]
            [ Html.h3
                [ class "text-xl font-bold"
                ]
                [ Html.text error ]
            , Html.p
                [ class " text-gray-400"
                ]
                [ Html.a
                    [ href "https://avinal.space/posts"
                    , rel "referrer noopener"
                    , class "underline"
                    ]
                    [ Html.text "return to list of Blogs?" ]
                ]
            ]
        ]


articleNode : String -> String -> Html Msg
articleNode data fragment =
    Html.node "rendered-md"
        [ Html.Attributes.attribute "markdowndata" data, Html.Attributes.attribute "fragment" fragment ]
        []



-- UTILITIES


type alias YamlMeta =
    { title : String
    , date : String
    , description : Maybe String
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
        (Yaml.maybe (Yaml.field "description" Yaml.string))
        (Yaml.field "tags" (Yaml.list Yaml.string))
        (Yaml.field "category" Yaml.string)
        (Yaml.field "image" Yaml.string)
        (Yaml.maybe (Yaml.field "modified" Yaml.string))
