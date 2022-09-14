module Base exposing (contentUrlPrefix, urlPrefix, websiteBase)

{-| The base URL for accessing the content for the site
-}


contentBase : String
contentBase =
    "https://raw.githubusercontent.com"


{-| The Github user name for the site
-}
user : String
user =
    "avinal"


urlPrefix : String
urlPrefix =
    "avinal.github.io"


contentUrlPrefix : String
contentUrlPrefix =
    contentBase ++ "/" ++ user ++ "/" ++ urlPrefix ++ "/main/content/"


websiteBase : String
websiteBase =
    "https://avinal.space"
