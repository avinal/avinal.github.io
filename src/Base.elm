module Base exposing (urlPrefix, contentUrlPrefix)

{-| The base URL for accessing the content for the site

    Using Github CDN for now, but this could be changed to a custom domain

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
    "website"


contentUrlPrefix : String
contentUrlPrefix =
    contentBase ++ "/" ++ user ++ "/" ++ urlPrefix ++ "/main/content/"
