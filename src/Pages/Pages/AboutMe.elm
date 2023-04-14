module Pages.Pages.AboutMe exposing (page)

import Html exposing (Html)
import Html.Attributes exposing (class, datetime, href)
import Utils.Constants exposing (Job, jobList)
import Utils.Utils exposing (getFormattedDate)
import View exposing (View)
import Components.Footer exposing (footerLinksToSide)


page : View msg
page =
    { title = "About Me"
    , body =
        [ Html.section []
            [ Html.div [ class "text-white py-8" ]
                [ Html.div [ class "container mx-auto flex flex-col items-start md:flex-row my-12 md:my-24" ]
                    [ Html.div [ class "flex flex-col w-full sticky md:top-36 lg:w-1/3 mt-2 md:mt-12 px-8" ]
                        [ Html.p [ class "text-lg ml-2 text-cyan-500 uppercase tracking-lppse" ] [ Html.text "Software Engineer" ]
                        , Html.p [ class "text-3xl md:text-6xl leading-normal md:leading-relaxed mb-2" ] [ Html.text "Avinal Kumar" ]
                        , Html.p [ class "md:text-base text-gray-50 mb-4 text-xl " ] [ Html.text description ]
                        , Html.a
                            [ class "bg-transparent mr-auto hover:bg-pink-600 text-cyan-500 hover:text-white rounded border py-2 px-4 border-cyan-500"
                            , href "https://docs.google.com/document/d/1uoCxH9UvWwzFRtuJQ40MJ4kNxVT0tDnHguY7OQOKkN4/edit?usp=sharing"
                            ]
                            [ Html.text "Download CV" ]
                        ]
                    , Html.div [ class "ml-0 md:ml-12 lg:w-2/3 sticky" ]
                        [ Html.div [ class "container mx-auto w-full h-full" ]
                            [ Html.div [ class "relative wrap overflow-hidden p-10 h-full" ]
                                [ Html.ol [ class "relative border-l border-cyan-700" ]
                                    (List.map jobListing jobList)
                                ]
                            ]
                        ]
                    ]
                ]
            ]
            , footerLinksToSide
        ]
    }


description : String
description =
    """
    I am a Software Engineer Associate at Red Hat, specialising in hybrid cloud engineering.
    I have been involved with Google's Summer of Code and Google Season of Docs programmes as a mentor and contributor to Open Source for many years.
    For fun, I like to play around with cutting-edge areas of computer science; at the moment, I'm learning about Elm.
    GNU/Linux and free/open-source software are two of my favourite things
    """


jobListing : Job msg -> Html msg
jobListing job =
    Html.li [ class "mb-10 ml-6" ]
        [ Html.span [ class "absolute flex items-center justify-center w-6 h-6 bg-pink-600 ring-pink-900 rounded-full -left-3 ring-8" ]
            [ Html.text <| String.left 1 job.company
            ]
        , Html.h3 [ class "flex items-center mb-1 text-xl font-semibold" ] [ Html.text <| job.title ++ " at " ++ job.company ]
        , Html.time [ class "block mb-2 text font-normal leading-none text-gray-500", datetime job.from ]
            [ Html.text <| getFormattedDate job.from False ++ " - " ++ getFormattedDate job.to False ]
        , job.body
        ]
