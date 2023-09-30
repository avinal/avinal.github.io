module Pages.Home_ exposing (Model, Msg, page)

import Array exposing (Array)
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Events exposing (onClick, onMouseLeave)
import Layouts
import Page exposing (Page)
import Route exposing (Route)
import Shared
import Svg exposing (..)
import Svg.Attributes as SA
import Svg.Events as SE
import Time
import Utils.Constants exposing (nameMatrix)
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page _ _ =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
        |> Page.withLayout layout



-- LAYOUT


layout : Model -> Layouts.Layout Msg
layout _ =
    Layouts.Home
        {}



-- INIT


type Cell
    = Alive
    | Dead


type alias Universe a =
    { space : Array a
    , width : Int
    , height : Int
    }


type alias Model =
    { universe : Universe Cell
    , generations : Int
    , generating : Bool
    }


cellSize : Int
cellSize =
    10


init : () -> ( Model, Effect Msg )
init () =
    ( { universe = bigBang 30 30 Dead
      , generating = False
      , generations = 0
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = Ressurect Int Int
    | NextGeneration
    | LiveLife
    | Apocalypse


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        Ressurect x y ->
            ( { model
                | universe =
                    buildRelationship model.universe
                        x
                        y
                        invertLife
              }
            , Effect.none
            )

        NextGeneration ->
            let
                universe =
                    nextGeneration model.universe

                generations =
                    model.generations + 1

                generating =
                    model.generating && universe /= model.universe
            in
            ( { model
                | universe = universe
                , generations = generations
                , generating = generating
              }
            , Effect.none
            )

        LiveLife ->
            ( { model | generating = not model.generating }
            , Effect.none
            )

        Apocalypse ->
            ( { model | generating = False }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.generating then
        Time.every 500 (always NextGeneration)

    else
        Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Welcome to my website"
    , body = [ Html.div [ onClick LiveLife, onMouseLeave LiveLife ] [ universeSvg model ] ]
    }


cellToSvg : Int -> Int -> Cell -> Svg Msg
cellToSvg x y cell =
    let
        isName =
            if Array.get ((y - 12) * 24 + x - 3) nameMatrix == Just 1 && x >= 3 && x < 27 then
                True

            else
                False

        color =
            case cell of
                Alive ->
                    if isName then
                        "fill-cyan-500"

                    else
                        "fill-pink-500"

                Dead ->
                    "fill-neutral-800"
    in
    rect
        [ SA.x (String.fromInt (x * cellSize))
        , SA.y (String.fromInt (y * cellSize))
        , SA.width (String.fromInt cellSize)
        , SA.height (String.fromInt cellSize)
        , SA.class color
        , SE.onMouseOver (Ressurect x y)
        ]
        []


universeSvg : Model -> Html Msg
universeSvg model =
    let
        svgWidth =
            String.fromInt (model.universe.width * cellSize)

        svgHeight =
            String.fromInt (model.universe.height * cellSize)
    in
    svg
        [ SA.width "150"
        , SA.height "150"
        , SA.viewBox ("0 0 " ++ svgWidth ++ " " ++ svgHeight)
        , SA.class "stroke-0"
        ]
        (stretchUniverseThin cellToSvg model.universe)



-- UTIL


bigBang : Int -> Int -> a -> Universe a
bigBang width height value =
    { space = Array.repeat (width * height) value
    , width = width
    , height = height
    }


stretchUniverseThin : (Int -> Int -> a -> b) -> Universe a -> List b
stretchUniverseThin f universe =
    Array.toIndexedList universe.space
        |> List.map (\( i, cell ) -> f (modBy universe.width i) (i // universe.width) cell)


nextGeneration : Universe Cell -> Universe Cell
nextGeneration universe =
    { universe
        | space =
            Array.indexedMap
                (decideFateOf universe)
                universe.space
    }


decideFateOf : Universe Cell -> Int -> Cell -> Cell
decideFateOf u i today =
    let
        aliveAtoms =
            countLiveAtoms i u
    in
    case today of
        Alive ->
            if aliveAtoms < 2 || aliveAtoms > 3 then
                Dead

            else
                Alive

        Dead ->
            if aliveAtoms == 3 then
                Alive

            else
                Dead


buildRelationship : Universe a -> Int -> Int -> (a -> a) -> Universe a
buildRelationship universe x y fn =
    case getUniverseAt x y universe of
        Just cell ->
            setUniverseAt x y (fn cell) universe

        Nothing ->
            universe


getUniverseAt : Int -> Int -> Universe a -> Maybe a
getUniverseAt x y u =
    Array.get (y * u.width + x) u.space


setUniverseAt : Int -> Int -> a -> Universe a -> Universe a
setUniverseAt x y value u =
    { u | space = Array.set (y * u.width + x) value u.space }


countLiveAtoms : Int -> Universe Cell -> Int
countLiveAtoms i universe =
    let
        above =
            i - universe.width

        below =
            i + universe.width

        coordinate =
            [ above - 1
            , above
            , above + 1
            , i - 1
            , i + 1
            , below - 1
            , below
            , below + 1
            ]
    in
    coordinate
        |> List.filter
            (\n ->
                abs
                    (modBy universe.width n - modBy universe.width i)
                    <= 1
            )
        |> List.map (\c -> universe.space |> Array.get c)
        |> List.filter (\c -> c == Just Alive)
        |> List.length


invertLife : Cell -> Cell
invertLife cell =
    case cell of
        Alive ->
            Dead

        Dead ->
            Alive
