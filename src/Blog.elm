module Blog exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick, onInput)
import Html.Parser
import Html.Parser.Util
import Http exposing (Error(..))
import Markdown exposing (defaultOptions)
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


view : Model -> Html Msg
view model =
    div [ class "foo-interface" ]
        [ div [ class "foo-console foo-terminal foo-active" ]
            [ div [ class "max-width mx-auto px3 ltr" ]
                [ div
                    [ class "foo-term-story" ]
                    [ input
                        [ placeholder "Enter URL to a markdown file"
                        , value model.markDownUrl
                        , onInput StoreInput
                        ]
                        []
                    , button [ onClick GetMarkdown ] [ text "Get Markdown" ]
                    ]
                , div [ class "content index py4" ]
                    [ if model.success then
                        markdownToHtml model

                      else
                        div [ class "foo-error" ] [ text model.markDown ]
                    ]
                ]
            ]
        ]


type Msg
    = GetMarkdown
    | StoreInput String
    | DataReceived (Result Http.Error String)


init : () -> ( Model, Cmd Msg )
init _ =
    ( { blog =
            { title = "My First Blog Post"
            , url = "my-first-blog-post"
            , description = "This is my first blog post"
            , content = "This is the content of my first blog post"
            , category = "category"
            , tags = [ "elm", "blog" ]
            , date = "2018-01-01"
            }
      , markDownUrl = ""
      , markDown = ""
      , success = True
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetMarkdown ->
            ( model, Http.get { url = model.markDownUrl, expect = Http.expectString DataReceived } )

        DataReceived (Ok data) ->
            ( { model | markDown = data, success = True }, Cmd.none )

        DataReceived (Err err) ->
            ( { model | success = False, markDown = errorToString err }, Cmd.none )

        StoreInput input ->
            ( { model | markDownUrl = input }, Cmd.none )


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


markdownToHtml : Model -> Html Msg
markdownToHtml model =
    Markdown.toHtmlWith
        { defaultOptions
            | githubFlavored = Just { tables = True, breaks = False }
        }
        []
        model.markDown
