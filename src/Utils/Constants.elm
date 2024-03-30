module Utils.Constants exposing (..)

import Array exposing (Array)
import Html exposing (Html)


type alias Link =
    { url : String
    , text : String
    }


type alias IconLink =
    { url : String
    , icon : String
    }


type alias Job msg =
    { title : String
    , company : String
    , from : String
    , to : String
    , body : Html msg
    }


footerLinks : List Link
footerLinks =
    [ { text = "About", url = "/pages/about-me" }
    , { text = "Blog", url = "https://avinal.space/posts" }
    , { text = "Projects", url = "/pages/projects" }
    , { text = "GSoC", url = "https://avinal.space/posts/category/gsoc" }
    ]


iconLinks : List IconLink
iconLinks =
    [ { url = "https://github.com/avinal", icon = "fa-brands fa-github" }
    , { url = "https://www.linkedin.com/in/avinal", icon = "fa-brands fa-linkedin" }
    , { url = "https://twitter.com/Avinal_", icon = "fa-brands fa-twitter" }
    , { url = "mailto:ripple@avinal.space", icon = "fa-solid fa-envelope" }
    , { url = "/meet", icon = "fa-solid fa-video" }
    ]


months : Array String
months =
    Array.fromList
        [ "January"
        , "February"
        , "March"
        , "April"
        , "May"
        , "June"
        , "July"
        , "August"
        , "September"
        , "October"
        , "November"
        , "December"
        ]


nameMatrix : Array Int
nameMatrix =
    Array.fromList
        [ 0
        , 1
        , 1
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 1
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 1
        , 1
        , 0
        , 0
        , 1
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 1
        , 1
        , 1
        , 1
        , 1
        , 0
        , 1
        , 0
        , 0
        , 0
        , 1
        , 0
        , 1
        , 0
        , 1
        , 1
        , 1
        , 0
        , 0
        , 1
        , 1
        , 1
        , 0
        , 0
        , 1
        , 1
        , 0
        , 0
        , 1
        , 0
        , 1
        , 0
        , 0
        , 0
        , 1
        , 0
        , 1
        , 0
        , 1
        , 0
        , 0
        , 1
        , 0
        , 1
        , 0
        , 1
        , 0
        , 0
        , 1
        , 1
        , 0
        , 0
        , 1
        , 0
        , 0
        , 1
        , 0
        , 1
        , 0
        , 0
        , 1
        , 0
        , 1
        , 0
        , 0
        , 1
        , 0
        , 1
        , 0
        , 1
        , 0
        , 0
        , 1
        , 1
        , 0
        , 0
        , 1
        , 0
        , 0
        , 0
        , 1
        , 0
        , 0
        , 0
        , 1
        , 0
        , 1
        , 0
        , 0
        , 1
        , 0
        , 1
        , 1
        , 1
        , 1
        , 0
        , 1
        ]
