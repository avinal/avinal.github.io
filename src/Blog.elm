port module Blog exposing (..)

import Base exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, datetime, href, id, src, style)
import Http exposing (Error(..))
import Json.Decode as Json
import Json.Decode.Pipeline exposing (required)
import Url exposing (Protocol(..))
import Yaml.Decode as Yaml



-- MODEL


type alias Model =
    { blog : Maybe Blog
    , requestUrl : String
    , success : Bool
    , fragment : String
    , error : Maybe String
    , bloglist : Maybe (List JsonMeta)
    }



-- Blog Post


type alias Blog =
    { meta : YamlMeta
    , content : String
    }


initialModel : Model
initialModel =
    { blog = Nothing
    , requestUrl = ""
    , success = False
    , fragment = ""
    , error = Nothing
    , bloglist = Nothing
    }



-- PORT


port sendString : String -> Cmd msg



-- port isRenderComplete : (Bool -> msg) -> Sub msg


view : Model -> Html Msg
view model =
    div [ class "foo-interface" ]
        [ div [ class "foo-console foo-terminal foo-active" ]
            [ div [ class "page-wrapper category-html document-page" ]
                [ div [ class "main-wrapper" ]
                    [ div [] (viewBlogList model)
                    , main_ [ class "main-content", id "content" ]
                        [ case model.blog of
                            Just blog ->
                                case blog.meta.image of
                                    Just image ->
                                        img [ src image ] []

                                    Nothing ->
                                        text ""

                            Nothing ->
                                text ""
                        , viewArticle model
                        ]
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


viewArticle : Model -> Html Msg
viewArticle model =
    article
        [ class "main-page-content" ]
        [ div [ id "insert-here" ] []
        , viewMetadata model
        ]


viewMetadata : Model -> Html Msg
viewMetadata model =
    aside
        [ class "metadata"
        , style "display"
            (if model.success then
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
                        [ a
                            [ href
                                ("https://github.com/avinal/avinal.github.io/issues/new?title=blog:"
                                    ++ (case model.blog of
                                            Just blog ->
                                                blog.meta.title

                                            Nothing ->
                                                model.requestUrl
                                       )
                                )
                            ]
                            [ text "Open an issue on ", i [ class "fa-brands fa-github" ] [] ]
                        ]
                    , li []
                        [ a [ href "mailto:ripple+blog@avinal.space" ]
                            [ text "Contact me via email" ]
                        ]
                    ]
                ]
            ]
        ]


viewBlogListItem : JsonMeta -> Html Msg
viewBlogListItem meta =
    div []
        [ hr [] []
        , div [ class "foo-term-story" ]
            [ div []
                [ span []
                    [ i [ class "fa-regular fa-clock" ] []
                    , time [ datetime meta.date ] [ text meta.date ]
                    , text " in "
                    , i [ class "fa-regular fa-folder-open" ] []
                    , a [ href ("/posts/" ++ meta.category) ]
                        [ text meta.category ]
                    ]
                ]
            , br [] []
            , h2 []
                [ a [ href ("/posts/" ++ meta.category ++ "/" ++ meta.slug) ]
                    [ text meta.title ]
                ]
            , br [] []
            , p [] [ text meta.description ]
            ]
        ]


viewBlogList : Model -> List (Html Msg)
viewBlogList model =
    case model.bloglist of
        Just bloglist ->
            h1 [] [ text "Blog" ]
                :: List.map viewBlogListItem bloglist

        Nothing ->
            []


type Msg
    = MdDataReceived (Result Http.Error String)
    | JsonDataReceived (Result Http.Error (List JsonMeta))
    | NoSuchPage


{-| To maintain compatibility with old links

    Old links: <https://avinal.space/posts/category/slug.html>
    New links: <https://avinal.space/posts/category/slug>

-}
removeHtmlSuffix : String -> String
removeHtmlSuffix slug =
    if String.right 5 slug == ".html" then
        String.dropRight 5 slug

    else
        slug


init : List String -> ( Model, Cmd Msg )
init pathList =
    case pathList of
        [ category, slug, fragment ] ->
            let
                requestUrl =
                    Base.contentUrlPrefix
                        ++ "posts/"
                        ++ category
                        ++ "/"
                        ++ removeHtmlSuffix slug
                        ++ ".md"
            in
            ( { initialModel
                | requestUrl = requestUrl
                , fragment = fragment
              }
            , getMarkdown requestUrl
            )

        [ category, slug ] ->
            let
                requestUrl =
                    Base.contentUrlPrefix
                        ++ "posts/"
                        ++ category
                        ++ "/"
                        ++ removeHtmlSuffix slug
                        ++ ".md"
            in
            ( { initialModel
                | requestUrl = requestUrl
              }
            , getMarkdown requestUrl
            )

        -- [ category ] ->
        --     let
        --         requestUrl =
        --             Base.contentUrlPrefix
        --                 ++ "posts/"
        --                 ++ category
        --                 ++ ".md"
        --     in
        --     ( { initialModel
        --         | requestUrl = requestUrl
        --       }
        --     , getMarkdown requestUrl
        --     )
        -- [ "categories" ] ->
        --     ( { blog = Nothing
        --       , requestUrl = urlPrefix ++ "/categories" ++ ".md"
        --       , markDown = ""
        --       , success = False
        --       , fragment = ""
        --       }
        --     , getMarkdown (urlPrefix ++ "/categories" ++ ".md")
        --     )
        [] ->
            ( { initialModel | requestUrl = Base.contentUrlPrefix ++ "/posts/posts.json" }
            , getPostLists (Base.contentUrlPrefix ++ "/posts/posts.json")
            )

        _ ->
            ( initialModel, Cmd.none )


type alias JsonMeta =
    { title : String
    , date : String
    , description : String
    , category : String
    , slug : String
    }


getPostLists : String -> Cmd Msg
getPostLists url =
    Http.get
        { url = url
        , expect = Http.expectJson JsonDataReceived (Json.list jsonMetaDecoder)
        }


jsonMetaDecoder : Json.Decoder JsonMeta
jsonMetaDecoder =
    required "title" Json.string <|
        required "date" Json.string <|
            required "description" Json.string <|
                required "category" Json.string <|
                    required "slug" Json.string <|
                        Json.succeed JsonMeta


getMarkdown : String -> Cmd Msg
getMarkdown url =
    Http.get
        { url = url
        , expect = Http.expectString MdDataReceived
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- GetMarkdown ->
        --     ( model, Http.get { url = model.requestUrl, expect = Http.expectString MdDataReceived } )
        MdDataReceived (Ok data) ->
            case splitMetaContent data of
                Ok blog ->
                    ( { model | blog = Just blog, success = True }, sendString blog.content )

                Err err ->
                    ( { model | success = False, error = Just err }, Cmd.none )

        MdDataReceived (Err err) ->
            ( { model | success = False, error = Just (errorToString err) }, Cmd.none )

        JsonDataReceived (Ok data) ->
            ( { model | blog = Nothing, success = True, bloglist = Just data }, Cmd.none )

        JsonDataReceived (Err err) ->
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
