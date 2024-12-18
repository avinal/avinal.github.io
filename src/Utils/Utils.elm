module Utils.Utils exposing (..)

import Array
import Html exposing (Html)
import Html.Attributes exposing (class, href, target)
import Http exposing (Error(..))
import Parser exposing (..)
import Utils.Constants exposing (..)


type alias DateTime =
    { year : Int
    , month : Int
    , day : Int
    , hour : Int
    , minute : Int
    }


getFormattedDate : String -> Bool -> String
getFormattedDate dateString time =
    case Parser.run dateParser dateString of
        Ok date ->
            (Maybe.withDefault "Month" <| Array.get (date.month - 1) months)
                ++ " "
                ++ String.fromInt date.day
                ++ ", "
                ++ String.fromInt date.year
                ++ (if time then
                        ", "
                            ++ String.fromInt date.hour
                            ++ ":"
                            ++ String.fromInt date.minute
                            ++ " IST"

                    else
                        ""
                   )

        Err _ ->
            if time then
                "Invalid date!!"

            else
                "Today"


dateParser : Parser DateTime
dateParser =
    oneOf
        [ succeed Tuple.pair
            |= datePart
            |= optional timePart
        ]
        |> map toDateTime


datePart : Parser ( Int, Int, Int )
datePart =
    succeed (\y m d -> ( y, m, d ))
        |= int
        |. token "-"
        |. chompWhile (\c -> c == '0')
        |= int
        |. token "-"
        |. chompWhile (\c -> c == '0')
        |= int


timePart : Parser ( Int, Int )
timePart =
    succeed (\h m -> ( h, m ))
        |. token "T"
        |. chompWhile (\c -> c == '0')
        |= int
        |. token ":"
        |. chompWhile (\c -> c == '0')
        |= int
        |. chompUntilEndOr "\n"
        |. end


toDateTime : ( ( Int, Int, Int ), Maybe ( Int, Int ) ) -> DateTime
toDateTime ( ( y, m, d ), maybeTime ) =
    case maybeTime of
        Just ( h, min ) ->
            DateTime y m d h min

        Nothing ->
            DateTime y m d 0 0


optional : Parser a -> Parser (Maybe a)
optional parser =
    oneOf
        [ succeed Just |= parser
        , succeed Nothing
        ]


categoryNtags : String -> List String -> Html msg
categoryNtags category tags =
    Html.span [ class "flex flex-wrap py-6 space-x-2" ]
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


errorView : String -> Html msg
errorView error =
    Html.div
        [ class "border border-red-400 text-red-700 px-4 py-3 rounded relative" ]
        [ Html.strong [ class "text-red-400" ] [ Html.text "Something bad has happened!" ]
        , Html.br [] []
        , Html.text ("Error: " ++ error)
        ]
