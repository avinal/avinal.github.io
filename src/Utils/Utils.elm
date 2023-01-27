module Utils.Utils exposing (..)

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes exposing (class, href, target)
import Http exposing (Error(..))
import Parser exposing (..)
import Utils.Constants exposing (..)


type alias Date =
    { day : Int
    , month : Int
    , year : Int
    }


day : Parser Int
day =
    succeed identity
        |= int


month : Parser Int
month =
    succeed identity
        |= int


year : Parser Int
year =
    succeed identity
        |= int


getFormattedDate : String -> String
getFormattedDate dateString =
    case Parser.run dateParser dateString of
        Ok date ->
            (Maybe.withDefault "Month" <| Array.get (date.month - 1) months) ++ " " ++ String.fromInt date.day ++ ", " ++ String.fromInt date.year

        Err err ->
            "Invalid date!!"


dateParser : Parser Date
dateParser =
    succeed Date
        |= day
        |. symbol "-"
        |= month
        |. symbol "-"
        |= year



categoryNtags : String -> List String -> Html msg
categoryNtags category tags =
    Html.span [ class "flex flex-wrap py-6 space-x-2 border-t border-dashed border-teal-500" ]
        (Html.a [ class "px-3 py-1 m-1 rounded-sm hover:underline bg-pink-400 text-gray-900 font-bold", href <| "/posts/" ++ category, target "_blank" ]
            [ Html.text category
            ]
            :: List.map
                (\tag ->
                    Html.i [ class "px-3 py-1 m-1 rounded-sm hover:underline bg-cyan-500 text-gray-900" ]
                        [ Html.text <| "#" ++ tag
                        ]
                )
                tags
        )


contentUrl : { category : String, post : String } -> String
contentUrl { category, post } =
    "/content/posts/" ++ category ++ "/" ++ post ++ ".md"


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
            "The content can't be found, please check your url"

        BadBody errorMessage ->
            errorMessage
