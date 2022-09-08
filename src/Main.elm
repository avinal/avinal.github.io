module Main exposing (main)

import Blog as Blog
import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (Html, a, div, footer, header, img, li, text, ul)
import Html.Attributes exposing (class, href, src)
import Html.Lazy exposing (lazy)
import Splash as Splash
import Static as Static
import Terminal as Terminal
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s)



--MODEL


{-| Model design
Model
Page: Page that currently is active
-}
type alias Model =
    { page : Page
    , title : String
    , key : Nav.Key
    , url : Url
    }



-- PAGE


{-| Page designs

    BlogPage: Page design for blogs
    TerminalPage: Page design for terminal
    StaticPage: Page design for static pages
    NotFound: Page design for 404 page

-}
type Page
    = SplashPage Splash.Model
    | BlogPage Blog.Model
    | TerminalPage Terminal.Model
    | StaticPage Static.Model
    | NotFound



-- VIEW


view : Model -> Document Msg
view model =
    let
        content =
            case model.page of
                SplashPage splashModel ->
                    Splash.view splashModel
                        |> Html.map GotSplashMsg

                BlogPage blogs ->
                    Blog.view blogs
                        |> Html.map GotBlogMsg

                TerminalPage terminal ->
                    Terminal.view terminal
                        |> Html.map GotTerminalMsg

                StaticPage static ->
                    Static.view static
                        |> Html.map GotStaticMsg

                NotFound ->
                    Splash.view (Splash.notFound (Url.toString model.url))
                        |> Html.map GotSplashMsg
    in
    { title = model.title
    , body =
        [ lazy viewHeader model.page
        , content
        , lazy viewFooter model.page
        ]
    }


type Msg
    = GotSplashMsg Splash.Msg
    | GotBlogMsg Blog.Msg
    | GotTerminalMsg Terminal.Msg
    | GotStaticMsg Static.Msg
    | ChangeUrl Url
    | ClickedLink Browser.UrlRequest


viewHeader : Page -> Html msg
viewHeader page =
    let
        headerContent =
            case page of
                SplashPage _ ->
                    div [] []

                _ ->
                    header [ class "foo-logo" ]
                        [ img [ src "/website/logo-static.svg" ]
                            []
                        ]
    in
    headerContent


viewFooter : Page -> Html msg
viewFooter page =
    let
        footerContent =
            case page of
                SplashPage _ ->
                    div [] []

                _ ->
                    footer [ class "foo-footer" ]
                        [ ul []
                            [ li []
                                [ a [ href urlPrefix ] [ text "Home" ]
                                ]
                            ]
                        ]
    in
    footerContent


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSplashMsg splashMsg ->
            case model.page of
                SplashPage splash ->
                    toSplash model (Splash.update splashMsg splash)

                _ ->
                    ( model, Cmd.none )

        GotBlogMsg blogMsg ->
            case model.page of
                BlogPage blog ->
                    toBlog
                        { model
                            | title = blog.blog.title ++ " | " ++ model.title
                        }
                        (Blog.update blogMsg blog)

                _ ->
                    ( model, Cmd.none )

        GotTerminalMsg terminalMsg ->
            case model.page of
                TerminalPage terminal ->
                    toTerminal model (Terminal.update terminalMsg terminal)

                _ ->
                    ( model, Cmd.none )

        GotStaticMsg staticMsg ->
            case model.page of
                StaticPage static ->
                    toStatic model (Static.update staticMsg static)

                _ ->
                    ( model, Cmd.none )

        ChangeUrl url ->
            updateUrl { model | url = url }

        ClickedLink urlRequest ->
            case urlRequest of
                Browser.Internal href ->
                    ( model, Nav.pushUrl model.key (Url.toString href) )

                Browser.External url ->
                    ( model, Nav.load url )


toSplash : Model -> ( Splash.Model, Cmd Splash.Msg ) -> ( Model, Cmd Msg )
toSplash model ( splashModel, cmd ) =
    ( { model | page = SplashPage splashModel }, Cmd.map GotSplashMsg cmd )


toBlog : Model -> ( Blog.Model, Cmd Blog.Msg ) -> ( Model, Cmd Msg )
toBlog model ( blogModel, cmd ) =
    ( { model | page = BlogPage blogModel }, Cmd.map GotBlogMsg cmd )


toTerminal : Model -> ( Terminal.Model, Cmd Terminal.Msg ) -> ( Model, Cmd Msg )
toTerminal model ( terminalModel, cmd ) =
    ( { model | page = TerminalPage terminalModel }, Cmd.map GotTerminalMsg cmd )


toStatic : Model -> ( Static.Model, Cmd Static.Msg ) -> ( Model, Cmd Msg )
toStatic model ( staticModel, cmd ) =
    ( { model | page = StaticPage staticModel }, Cmd.map GotStaticMsg cmd )


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    updateUrl { url = url, page = NotFound, title = "Be My SpaceTime", key = key }



-- PARSER


type Route
    = Splash
    | Blog
    | Terminal
    | Static


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Splash Parser.top
        , Parser.map Splash (s urlPrefix)
        , Parser.map Blog (s urlPrefix </> s "posts")
        , Parser.map Static (s urlPrefix </> s "pages")
        , Parser.map Terminal (s urlPrefix </> s "terminal")
        ]


updateUrl : Model -> ( Model, Cmd Msg )
updateUrl model =
    case Parser.parse parser model.url of
        Just Splash ->
            Splash.init () False ""
                |> toSplash model

        Just Blog ->
            Blog.init ()
                |> toBlog model

        Just Terminal ->
            Terminal.init ()
                |> toTerminal model

        Just Static ->
            Static.init ()
                |> toStatic model

        Nothing ->
            Splash.init () True (Url.toString model.url)
                |> toSplash model



-- ENTRYPOINT


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = ChangeUrl
        , onUrlRequest = ClickedLink
        }



-- URLPREFIX


urlPrefix : String
urlPrefix =
    "website"
