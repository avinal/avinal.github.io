port module Blog exposing (..)

import Base exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href, id, src, style)
import Http exposing (Error(..))
import Url exposing (Protocol(..))
import Yaml.Decode as Yaml exposing (Decoder, field, list, string)



-- MODEL


type alias Model =
    { blog : Maybe Blog
    , markdownUrl : String
    , success : Bool
    , fragment : String
    , error : Maybe String
    }



-- Blog Post


type alias Blog =
    { meta : YamlMeta
    , content : String
    }


initialModel : Model
initialModel =
    { blog = Nothing
    , markdownUrl = ""
    , success = False
    , fragment = ""
    , error = Nothing
    }



-- PORT


port sendString : String -> Cmd msg



-- port isRenderComplete : (Bool -> msg) -> Sub msg


view : Model -> Html Msg
view model =
    div [ class "foo-interface" ]
        [ div [ class "foo-console foo-terminal foo-active" ]
            [ div [ class "main-wrapper" ]
                [ main_ [ class "main-content", id "content" ]
                    [ case model.blog of
                        Just blog ->
                            case blog.meta.image of
                                Just image ->
                                    img [ src image ] []

                                Nothing ->
                                    text ""

                        Nothing ->
                            text ""
                    , viewArticle model.success
                    ]
                ]
            ]
        ]


viewToc : Bool -> Html Msg
viewToc show =
    if show then
        div
            [ class "toc"
            ]
            [ aside [ class "document-toc-container" ]
                [ section [ class "document-toc" ]
                    [ h2 [ class "document-toc-heading" ]
                        [ if show then
                            text "In this page"

                          else
                            text ""
                        ]
                    , ul
                        [ class "document-toc-list", id "toc-entries" ]
                        []
                    ]
                ]
            ]

    else
        div [] []


viewArticle : Bool -> Html Msg
viewArticle show =
    article
        [ class "main-page-content" ]
        [ div [ id "insert-here" ] []
        , viewMetadata show
        ]


viewMetadata : Bool -> Html Msg
viewMetadata show =
    aside
        [ class "metadata"
        , style "display"
            (if show then
                "block"

             else
                "none"
            )
        ]
        [ div [ class "metadata-content-container" ]
            [ div [ class "on-github" ]
                [ h3 [] [ text "Found a problem" ]
                , ul []
                    [ li []
                        [ a [ href "https://github.com/avinal" ]
                            [ text "open an issue" ]
                        ]
                    , li []
                        [ a [ href "https://avinal.space" ]
                            [ text "Website" ]
                        ]
                    ]
                ]
            ]
        ]


type Msg
    = GetMarkdown
    | DataReceived (Result Http.Error String)
    | NoSuchPage


init : List String -> ( Model, Cmd Msg )
init pathList =
    case pathList of
        [ category, slug, fragment ] ->
            ( { initialModel
                | markdownUrl = Base.contentUrlPrefix ++ "posts/" ++ category ++ "/" ++ slug ++ ".md"
                , fragment = fragment
              }
            , getMarkdown (Base.contentUrlPrefix ++ "posts/" ++ category ++ "/" ++ slug ++ ".md")
            )

        [ category, slug ] ->
            ( { initialModel
                | markdownUrl = Base.contentUrlPrefix ++ "posts/" ++ category ++ "/" ++ slug ++ ".md"
              }
            , getMarkdown (Base.contentUrlPrefix ++ "posts/" ++ category ++ "/" ++ slug ++ ".md")
            )

        -- [ "categories" ] ->
        --     ( { blog = Nothing
        --       , markdownUrl = urlPrefix ++ "/categories" ++ ".md"
        --       , markDown = ""
        --       , success = False
        --       , fragment = ""
        --       }
        --     , getMarkdown (urlPrefix ++ "/categories" ++ ".md")
        --     )
        [] ->
            ( initialModel
            , Cmd.none
            )

        _ ->
            ( initialModel, Cmd.none )


getMarkdown : String -> Cmd Msg
getMarkdown url =
    Http.get
        { url = url
        , expect = Http.expectString DataReceived
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetMarkdown ->
            ( model, Http.get { url = model.markdownUrl, expect = Http.expectString DataReceived } )

        DataReceived (Ok data) ->
            case splitMetaContent data of
                Ok blog ->
                    ( { model | blog = Just blog, success = True }, sendString blog.content )

                Err err ->
                    ( { model | success = False, error = Just err }, Cmd.none )

        DataReceived (Err err) ->
            ( { model | success = False, error = Just (errorToString err) }, Cmd.none )

        NoSuchPage ->
            ( { model | success = False }, Cmd.none )


errorToString : Http.Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "The URL " ++ url ++ " was invalid"

        Timeout ->
            "Unable to reach the server, try again"

        NetworkError ->
            "Unable to reach the server, check your network connection"

        BadStatus 500 ->
            "The server had a problem, try again later"

        BadStatus 400 ->
            "Verify your information and try again"

        BadStatus _ ->
            "Unknown error"

        BadBody errorMessage ->
            errorMessage


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


metaDecoder : Decoder YamlMeta
metaDecoder =
    Yaml.map7 YamlMeta
        (field "title" string)
        (field "date" string)
        (Yaml.maybe (field "description" string))
        (field "tags" (list string))
        (field "category" string)
        (Yaml.maybe (field "image" string))
        (Yaml.maybe (field "modified" string))
