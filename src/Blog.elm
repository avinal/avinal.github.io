module Blog exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, datetime)



-- MODEL


type alias Model =
    { blog : Blog
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


view : Model -> Html msg
view model =
    div [ class "max-width mx-auto px3 ltr" ]
        [ div [ class "content index py4" ]
            [ article [ class "post" ]
                [ h1 [ class "posttitle" ] [ text model.blog.title ]
                , div [ class "meta" ]
                    [ div [ class "article-tag" ]
                        [ a [ class "tag-link" ] [ text "tag" ] ]
                    ]
                , div [ class "content" ] [ text model.blog.content ]
                ]
            ]
        ]


type Msg
    = Nothing


init : () -> ( Model, Cmd Msg )
init _ =
    ( { blog =
            { title = "My First Blog Post"
            , url = "my-first-blog-post"
            , description = "This is my first blog post"
            , content = "This is the content of my first blog post"
            , category = "blog"
            , tags = [ "elm", "blog" ]
            , date = "2018-01-01"
            }
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nothing ->
            ( model, Cmd.none )
