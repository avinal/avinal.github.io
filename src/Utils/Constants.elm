module Utils.Constants exposing (..)

import Array exposing (Array)


type alias Link =
    { url : String
    , text : String
    }


type alias IconLink =
    { url : String
    , icon : String
    }


footerLinks : List Link
footerLinks =
    [ { text = "About", url = "/pages/about-me" }
    , { text = "Blog", url = "/posts" }
    , { text = "Projects", url = "/pages/projects" }
    , { text = "GSoC", url = "https://gsoc.avinal.space" }
    ]


iconLinks : List IconLink
iconLinks =
    [ { url = "https://github.com/avinal", icon = "fa-brands fa-github" }
    , { url = "https://www.linkedin.com/in/avinal", icon = "fa-brands fa-linkedin" }
    , { url = "https://instagram.com/avinal", icon = "fa-brands fa-instagram" }
    , { url = "mailto:ripple@avinal.space", icon = "fa-solid fa-envelope" }
    ]


contentBase : String
contentBase =
    "https://avinal.space/"


user : String
user =
    "avinal"


urlPrefix : String
urlPrefix =
    "avinal.github.io"


contentUrlPrefix : String
contentUrlPrefix =
    contentBase ++ "/content/"


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
