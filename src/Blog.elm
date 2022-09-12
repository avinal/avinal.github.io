port module Blog exposing (..)

import Base exposing (urlPrefix)
import Html exposing (..)
import Html.Attributes exposing (class, href, id, style)
import Html.Parser
import Html.Parser.Util
import Http exposing (Error(..))
import Url exposing (Protocol(..))



-- MODEL


type alias Model =
    { blog : Blog
    , markDownUrl : String
    , markDown : String
    , success : Bool
    }



-- Blog Post


type alias Blog =
    { title : String
    , url : String
    , description : String
    , content : String
    , category : String
    , tags : List String
    , date : String
    }



-- PORT


port sendString : String -> Cmd msg


view : Model -> Html Msg
view model =
    div [ class "foo-interface" ]
        [ div [ class "foo-console foo-terminal foo-active" ]
            [ div [ class "main-wrapper" ]
                [ viewToc model.success
                , main_ [ class "main-content", id "content" ]
                    [ viewArticle model.success ]
                ]
            ]
        ]


viewToc : Bool -> Html Msg
viewToc show =
    if show then
        div
            [ class "toc"
            , style "display"
                (if show then
                    "block"

                 else
                    "none"
                )
            ]
            [ aside [ class "document-toc-container" ]
                [ section [ class "document-toc" ]
                    [ h2 [ class "document-toc-heading" ] [ text "In this page" ]
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


init : Maybe String -> ( Model, Cmd Msg )
init slug =
    ( { blog = initBlog
      , markDownUrl = finalUrl slug
      , markDown = ""
      , success = False
      }
    , getMarkdown <| finalUrl slug
    )


getMarkdown : String -> Cmd Msg
getMarkdown url =
    Http.get
        { url = url
        , expect = Http.expectString DataReceived
        }


finalUrl : Maybe String -> String
finalUrl slug =
    let
        resolvedSlug =
            Maybe.withDefault "error" slug
    in
    case resolvedSlug of
        "error" ->
            "https://raw.githubusercontent.com/avinal/avinal.space/content/posts/error.md"

        _ ->
            "https://raw.githubusercontent.com/avinal/"
                ++ urlPrefix
                ++ "/main/content/posts/"
                ++ resolvedSlug
                ++ ".md"


initBlog : Blog
initBlog =
    { title = ""
    , url = ""
    , description = ""
    , content = ""
    , category = ""
    , tags = []
    , date = ""
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetMarkdown ->
            ( model, Http.get { url = model.markDownUrl, expect = Http.expectString DataReceived } )

        DataReceived (Ok data) ->
            ( { model | markDown = data, success = True }, sendString data )

        DataReceived (Err err) ->
            ( { model | success = False, markDown = errorToString err }, Cmd.none )


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


textToHtml : String -> List (Html.Html msg)
textToHtml text =
    case Html.Parser.run text of
        Ok nodes ->
            Html.Parser.Util.toVirtualDom nodes

        Err _ ->
            []



-- main : Program (String, String) Model Msg
-- main =
--     Browser.element
--         { init = init
--         , view = view
--         , update = update
--         , subscriptions = \_ -> Sub.none
--         }
-- div
--                             [ class "foo-term-story section-content" ]
--                             [ input
--                                 [ placeholder "Enter URL to a markdown file"
--                                 , value model.markDownUrl
--                                 , onInput StoreInput
--                                 ]
--                                 []
--                             , button [ class "button secondary", onClick GetMarkdown ] [ text "Get Markdown" ]
--                             , if model.success then
--                                 div [] []
--                               else
--                                 div [ class "foo-error" ] [ text model.markDown ]
--                             ]
