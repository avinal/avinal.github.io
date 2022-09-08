module Blog exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Parser
import Html.Parser.Util



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
    div [ class "foo-interface" ]
        [ div [ class "max-width mx-auto px3 ltr" ]
            [ div [ class "content index py4" ]
                (textToHtml testString)
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


textToHtml : String -> List (Html.Html msg)
textToHtml text =
    case Html.Parser.run text of
        Ok nodes ->
            Html.Parser.Util.toVirtualDom nodes

        Err _ ->
            []


testString : String
testString =
    """
    <div id="header">
    <a href="/">
        <div id="logo" style="background-image: url(/images/logo.png);"></div>
        <div id="title">
            <h1>Hexo</h1>
        </div>
    </a>
    <div id="nav">
        <ul>
            <li class="icon">
                <a href="#" aria-label="Menu"><i class="fas fa-bars fa-2x"></i></a>
            </li>
            <li><a href="/">Home</a></li>
            <li><a href="/about/">About</a></li>
            <li><a href="/archives/">Writing</a></li>
            <li><a target="_blank" rel="noopener" href="http://github.com/probberechts">Projects</a></li>
        </ul>
    </div>
    </div>
    <section id="about">
        <p>
            Find me on
            <a class="icon" target="_blank" rel="noopener" href="http://github.com/probberechts/cactus-dark"
                aria-label="github">
                <i class="fab fa-github"></i>
            </a>
            <a class="icon" target="_blank" rel="noopener" href="/" aria-label="twitter">
                <i class="fab fa-twitter"></i>
            </a>
            <a class="icon" target="_blank" rel="noopener" href="/" aria-label="facebook">
                <i class="fab fa-facebook"></i>
            </a>
            <a class="icon" target="_blank" rel="noopener" href="/" aria-label="linkedin">
                <i class="fab fa-linkedin"></i>
            </a>and
            <a class="icon" target="_blank" rel="noopener" href="mailto:name@email.com" aria-label="mail">
                <i class="fas fa-envelope"></i>
            </a>
        </p>
    </section>
    <section id="writing">
        <span class="h1"><a href="/archives/">Writing</a></span>
        <ul class="post-list">
            <li class="post-item">
                <div class="meta">
                    <time datetime="2022-09-15T17:21:59.000Z" itemprop="datePublished">2022-09-15</time>
                </div>
                <span>
                    <a class="" href="/posts/techtest/hey-world">Hello</a>
                </span>
            </li>
            <li class="post-item">
                <div class="meta">
                    <time datetime="2022-09-05T17:21:59.000Z" itemprop="datePublished">2022-09-05</time>
                </div>
                <span>
                    <a class="" href="/posts/tech/hello-world">Hello World</a>
                </span>
            </li>
        </ul>
    </section>
    """
