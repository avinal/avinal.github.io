module Utils.Constants exposing (..)

import Array exposing (Array)
import Html exposing (Html)
import Html.Attributes exposing (class)


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
    , { text = "Blog", url = "/posts" }
    , { text = "Projects", url = "/pages/projects" }
    , { text = "GSoC", url = "/posts/gsoc" }
    ]


iconLinks : List IconLink
iconLinks =
    [ { url = "https://github.com/avinal", icon = "fa-brands fa-github" }
    , { url = "https://www.linkedin.com/in/avinal", icon = "fa-brands fa-linkedin" }
    , { url = "https://twitter.com/Avinal_", icon = "fa-brands fa-twitter" }
    , { url = "mailto:ripple@avinal.space", icon = "fa-solid fa-envelope" }
    , { url = "/meet", icon = "fa-solid fa-video" }
    ]


jobList : List (Job msg)
jobList =
    [ { title = "Associate Software Engineer"
      , company = "Red Hat"
      , from = "2022-07-01 10:10"
      , to = "Present"
      , body = Html.div [] [ Html.p [ class "mb-4 text-base font-normal text-gray-400" ] [ Html.text "Working on Tekton Results and Pipeline Service." ] ]
      }
    , { title = "Google Summer of Code Mentor"
      , company = "FOSSology"
      , from = "2022-05-01 10:10"
      , to = "Present"
      , body = Html.p [ class "mb-4 text-base font-normal text-gray-400" ] [ Html.text "Mentoring Google Summer of Code contributors for The FOSSology Project." ]
      }
    , { title = "Software Engineering Intern"
      , company = "Red Hat"
      , from = "2022-01-05 10:10"
      , to = "2022-06-30 10:10"
      , body = Html.p [ class "mb-4 text-base font-normal text-gray-400" ] [ Html.text "Worked on Pipeline Service and Minimal Tekton Server." ]
      }
    , { title = "Technical Writer"
      , company = "API7.ai"
      , from = "2022-02-01 10:10"
      , to = "2022-07-31 10:10"
      , body = Html.p [ class "mb-4 text-base font-normal text-gray-400" ] [ Html.text "Created Katacoda tutorials for Apache APISIX, a cloud-native API gateway." ]
      }
    , { title = "Open Source Contributor"
      , company = "FOSSology"
      , from = "2021-05-15 10:10"
      , to = "2021-09-23 10:10"
      , body = Html.p [ class "mb-4 text-base font-normal text-gray-400" ] [ Html.text "Upgraded old build system to CMake and improved tests and CI/CD for FOSSology." ]
      }
    , { title = "Java Developer Intern"
      , company = "XResearch"
      , from = "2021-03-01 10:10"
      , to = "2021-05-15 10:10"
      , body = Html.p [ class "mb-4 text-base font-normal text-gray-400" ] [ Html.text "" ]
      }
    , { title = "Technical Writer"
      , company = "VideoLAN"
      , from = "2020-09-15 10:10"
      , to = "2020-11-30 10:10"
      , body = Html.p [ class "mb-4 text-base font-normal text-gray-400" ] [ Html.text "Created Mobile App user documentation for VLC Media Player." ]
      }
    , { title = "Hindi Editor"
      , company = "SRIJAN, NIT Hamirpur"
      , from = "2018-11-01 10:10"
      , to = "2022-09-30 10:10"
      , body = Html.p [ class "mb-4 text-base font-normal text-gray-400" ] []
      }
    , { title = "Member"
      , company = "Computer Science Engineers' Society, NIT Hamirpur"
      , from = "2019-01-07 10:10"
      , to = "2022-06-30 10:10"
      , body = Html.p [ class "mb-4 text-base font-normal text-gray-400" ] []
      }
    , { title = "Computer Science and Engineering"
      , company = "National Institute of Technology Hamirpur"
      , from = "2018-06-20 10:10"
      , to = "2022-05-31 10:10"
      , body = Html.p [ class "mb-4 text-base font-normal text-gray-400" ] []
      }
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
