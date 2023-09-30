module Pages.Pages.AboutMe exposing (Model, Msg, page)

import Components.Footer exposing (footerLinksToSide)
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes exposing (class, datetime, href, src)
import Http
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Utils.JsonResume exposing (Education, Resume, Work, resumeDecoder)
import Utils.Utils exposing (getFormattedDate)
import View exposing (View)
import Components.Footer exposing (iconLinkToCenter)


page : Shared.Model -> Route () -> Page Model Msg
page _ _ =
    Page.new
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { resume : Maybe Resume
    , error : Maybe String
    }


init : () -> ( Model, Effect Msg )
init () =
    let
        cmd : Cmd Msg
        cmd =
            Http.get
                { url = "/resume/resume.json"
                , expect = Http.expectJson GotResume resumeDecoder
                }
    in
    ( { resume = Nothing, error = Nothing }, Effect.sendCmd cmd )



-- UPDATE


type Msg
    = GotResume (Result Http.Error Resume)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotResume (Ok resume) ->
            ( { model | resume = Just resume }, Effect.none )

        GotResume (Err err) ->
            ( { model | error = Just (Utils.Utils.errorToString err) }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View msg
view model =
    { title = "About Me"
    , body =
        let
            experience : List Work -> Html msg
            experience workList =
                Html.ol [ class "relative border-l border-cyan-700" ]
                    (List.map
                        (\work ->
                            Html.li [ class "mb-10 ml-6 " ]
                                [ Html.span [ class "absolute flex items-center justify-center w-6 h-6 bg-pink-600 ring-pink-900 rounded-full -left-3 ring-8" ]
                                    [ Html.text <| String.left 1 work.name ]
                                , Html.h3 [ class "flex items-center mb-1 text-xl font-semibold" ] [ Html.text <| work.position ++ " at " ++ work.name ]
                                , Html.time [ class "block mb-2 text font-normal leading-none text-gray-500", datetime work.startDate ]
                                    [ Html.text <| getFormattedDate work.startDate False ++ " - " ++ getFormattedDate work.endDate False ]
                                , Html.p [ class "mb-4 text-base font-normal text-gray-400" ] [ Html.text work.summary ]
                                , Html.p [ class "mb-4 text-lg font-normal text-gray-300" ] [ Html.text work.description ]
                                , Html.p [ class "mb-4 text-lg font-normal text-gray-300 ml-8" ] [ listThings work.highlights ]
                                ]
                        )
                        workList
                    )

            education : List Education -> Html msg
            education eduList =
                Html.ol [ class "relative border-l border-cyan-700" ]
                    (List.map
                        (\edu ->
                            Html.li [ class "mb-10 ml-6" ]
                                [ Html.span [ class "absolute flex items-center justify-center w-6 h-6 bg-pink-600 ring-pink-900 rounded-full -left-3 ring-8" ]
                                    [ Html.text <| String.left 1 edu.institution ]
                                , Html.h3 [ class "flex items-center mb-1 text-2xl font-semibold" ] [ Html.text <| edu.studyType ++ " at " ++ edu.institution ]
                                , Html.time [ class "block mb-2 text font-normal leading-none text-gray-500", datetime edu.startDate ]
                                    [ Html.text <| getFormattedDate edu.startDate False ++ " - " ++ getFormattedDate edu.endDate False ]
                                , Html.p [ class "mb-4 text-base font-normal text-gray-400" ] [ Html.text edu.area ]
                                ]
                        )
                        eduList
                    )
        in
        case model.resume of
            Just resume ->
                [ Html.section []
                    [ Html.div [ class "text-white" ]
                        [ Html.div [ class "container mx-auto flex flex-col items-start xl:flex-row my-12 xl:my-24" ]
                            [ Html.div [ class "flex flex-col w-full sticky xl:top-36 xl:w-2/3 mt-2 xl:mt-12 px-8" ]
                                [ Html.img [ class "w-full h-80 object-cover mx-auto mb-4", src resume.basics.image ] []
                                , Html.p [ class "text-5xl lg:text-6xl 2xl:text-7xl leading-normal md:leading-relaxed" ] [ Html.text resume.basics.name ]
                                , Html.p [ class "lg:text-xl md:text-md text-base text-cyan-500 uppercase tracking-lppse mb-2" ] [ Html.text resume.basics.label ]
                                , Html.p [ class "md:text-base text-gray-50 mb-4 lg:text-xl" ] [ Html.text resume.basics.summary ]
                                , iconLinkToCenter
                                ]
                            , Html.div [ class "flex-row" ]
                                [ Html.div [ class "ml-0 md:ml-12 lg:w-3/3 sticky" ]
                                    [ Html.div [ class "container mx-auto w-full h-full" ]
                                        [ Html.div [ class "relative wrap overflow-hidden p-10 h-full" ]
                                            [ experience resume.work ]
                                        ]
                                    ]
                                , Html.div [ class "ml-0 md:ml-12 lg:w-3/3 sticky" ]
                                    [ Html.div [ class "container mx-auto w-full h-full" ]
                                        [ Html.h2 [ class "text-xl ml-2 text-cyan-500" ] [ Html.text "Education" ]
                                        , Html.div [ class "relative wrap overflow-hidden p-10 h-full" ]
                                            [ education resume.education ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                , footerLinksToSide
                ]

            Nothing ->
                []
    }



-- simply list things


listThings : List String -> Html msg
listThings things =
    Html.ul []
        (List.map
            (\thing ->
                Html.li [ class "list-disc" ] [ Html.text thing ]
            )
            things
        )
