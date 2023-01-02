module Pages.Posts.ALL_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes
import Http
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Url exposing (Protocol(..))
import Utils.Utils as UU
import View exposing (View)
import Yaml.Decode as Yaml


page : Shared.Model -> Route { first_ : String, rest_ : List String } -> Page Model Msg
page shared route =
    Page.new
        { init = init route
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
        |> Page.withLayout layout



-- LAYOUT


layout : Model -> Layouts.Layout
layout model =
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


init : Route { first_ : String, rest_ : List String } -> () -> ( Model, Effect Msg )
init route () =
    let
        requestUrl =
            -- "https://gist.githubusercontent.com/avinal/a66c60362491498d114b53e8801632d6/raw/cd2fd3816f0f005fe12ebfeead8d8b1fcaafa5db/markdowntest.md"
            UU.contentUrl
                { category = route.params.first_
                , post =
                    Maybe.withDefault "" <| List.head route.params.rest_
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
      , fragment = ""
      , error = Nothing
      }
    , Effect.sendCmd cmd
    )



-- UPDATE


type Msg
    = RawMarkdownReceived (Result Http.Error String)
    | AttributeUpdate String


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

        AttributeUpdate data ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    case model.blog of
        Just blog ->
            { title = "Blog | " ++ blog.meta.title
            , body = [ articleNode blog.content ]
            }

        Nothing ->
            { title = "Be My SpaceTime | Something went wrong"
            , body = [ articleNode <| Maybe.withDefault "" model.error ]
            }


articleNode : String -> Html Msg
articleNode data =
    Html.node "rendered-md"
        [ Html.Attributes.attribute "markdowndata" data ]
        []



-- UTILITIES


type alias YamlMeta =
    { title : String
    , date : String
    , description : Maybe String
    , tags : List String
    , category : String
    , image : Maybe String
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
        (Yaml.maybe (Yaml.field "image" Yaml.string))
        (Yaml.maybe (Yaml.field "modified" Yaml.string))
