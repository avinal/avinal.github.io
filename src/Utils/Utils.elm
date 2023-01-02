module Utils.Utils exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Http exposing (Error(..))
import Utils.Constants exposing (..)


categoryNtags : String -> List String -> Html msg
categoryNtags category tags =
    Html.span [ class "flex flex-wrap py-6 space-x-2 border-t border-dashed border-teal-500" ]
        (Html.b [ class "px-3 py-1 m-1 rounded-sm hover:underline dark:bg-pink-400 dark:text-gray-900" ]
            [ Html.text category
            ]
            :: List.map
                (\tag ->
                    Html.i [ class "px-3 py-1 m-1 rounded-sm hover:underline dark:bg-cyan-500 dark:text-gray-900" ]
                        [ Html.text tag
                        ]
                )
                tags
        )


contentUrl : { category : String, post : String } -> String
contentUrl { category, post } =
    contentUrlPrefix ++ "posts/" ++ category ++ "/" ++ post ++ ".md"


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
