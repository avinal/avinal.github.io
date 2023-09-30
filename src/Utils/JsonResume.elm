module Utils.JsonResume exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)



-- Main Resume type


type alias Resume =
    { basics : Basics
    , work : List Work
    , volunteer : List Volunteer
    , education : List Education
    , awards : List Award
    , certificates : List Certificate
    , publications : List Publication
    , skills : List Skill
    , languages : List Language
    , interests : List Interest
    , references : List Reference
    , projects : List Project
    , meta : Meta
    }



-- Basics


type alias Basics =
    { name : String
    , label : String
    , image : String
    , email : String
    , phone : String
    , url : String
    , summary : String
    , location : Location
    , profiles : List Profile
    }


type alias Location =
    { address : String
    , postalCode : String
    , city : String
    , countryCode : String
    , region : String
    }


type alias Profile =
    { network : String
    , username : String
    , url : String
    }



-- Work


type alias Work =
    { name : String
    , location : String
    , description : String
    , position : String
    , url : String
    , startDate : String
    , endDate : String
    , summary : String
    , highlights : List String
    }



-- Volunteer


type alias Volunteer =
    { organization : String
    , position : String
    , url : String
    , startDate : String
    , endDate : String
    , summary : String
    , highlights : List String
    }



-- Education


type alias Education =
    { institution : String
    , url : String
    , area : String
    , studyType : String
    , startDate : String
    , endDate : String
    , score : String
    , courses : List String
    }



-- Awards


type alias Award =
    { title : String
    , date : String
    , awarder : String
    , summary : String
    }



-- Certificates


type alias Certificate =
    { name : String
    , date : String
    , url : String
    , issuer : String
    }



-- Publications


type alias Publication =
    { name : String
    , publisher : String
    , releaseDate : String
    , url : String
    , summary : String
    }



-- Skills


type alias Skill =
    { name : String
    , level : String
    , keywords : List String
    }



-- Languages


type alias Language =
    { language : String
    , fluency : String
    }



-- Interests


type alias Interest =
    { name : String
    , keywords : List String
    }



-- References


type alias Reference =
    { name : String
    , reference : String
    }



-- Projects


type alias Project =
    { name : String
    , description : String
    , highlights : List String
    , keywords : List String
    , startDate : String
    , endDate : String
    , url : String
    , roles : List String
    , entity : String
    , type_ : String
    }



-- Meta


type alias Meta =
    { canonical : String
    , version : String
    , lastModified : String
    }



-- JSON Decoders
-- Resume Decoder


resumeDecoder : Decoder Resume
resumeDecoder =
    Decode.succeed Resume
        |> required "basics" basicsDecoder
        |> required "work" (Decode.list workDecoder)
        |> optional "volunteer" (Decode.list volunteerDecoder) []
        |> required "education" (Decode.list educationDecoder)
        |> optional "awards" (Decode.list awardDecoder) []
        |> optional "certificates" (Decode.list certificateDecoder) []
        |> optional "publications" (Decode.list publicationDecoder) []
        |> optional "skills" (Decode.list skillDecoder) []
        |> optional "languages" (Decode.list languageDecoder) []
        |> optional "interests" (Decode.list interestDecoder) []
        |> optional "references" (Decode.list referenceDecoder) []
        |> optional "projects" (Decode.list projectDecoder) []
        |> optional "meta" metaDecoder (Meta "" "" "")



-- Basics Decoder


basicsDecoder : Decoder Basics
basicsDecoder =
    Decode.succeed Basics
        |> required "name" Decode.string
        |> required "label" Decode.string
        |> optional "image" Decode.string ""
        |> required "email" Decode.string
        |> optional "phone" Decode.string ""
        |> required "url" Decode.string
        |> required "summary" Decode.string
        |> optional "location" locationDecoder (Location "" "" "" "" "")
        |> optional "profiles" (Decode.list profileDecoder) []


locationDecoder : Decoder Location
locationDecoder =
    Decode.succeed Location
        |> optional "address" Decode.string ""
        |> optional "postalCode" Decode.string ""
        |> required "city" Decode.string
        |> required "countryCode" Decode.string
        |> optional "region" Decode.string ""


profileDecoder : Decoder Profile
profileDecoder =
    Decode.succeed Profile
        |> required "network" Decode.string
        |> required "username" Decode.string
        |> required "url" Decode.string


workDecoder : Decoder Work
workDecoder =
    Decode.succeed Work
        |> required "name" Decode.string
        |> optional "location" Decode.string ""
        |> optional "description" Decode.string ""
        |> required "position" Decode.string
        |> optional "url" Decode.string ""
        |> required "startDate" Decode.string
        |> required "endDate" Decode.string
        |> required "summary" Decode.string
        |> optional "highlights" (Decode.list Decode.string) []



-- Volunteer Decoder


volunteerDecoder : Decoder Volunteer
volunteerDecoder =
    Decode.succeed Volunteer
        |> required "organization" Decode.string
        |> required "position" Decode.string
        |> required "url" Decode.string
        |> required "startDate" Decode.string
        |> required "endDate" Decode.string
        |> required "summary" Decode.string
        |> optional "highlights" (Decode.list Decode.string) []



-- Education Decoder


educationDecoder : Decoder Education
educationDecoder =
    Decode.succeed Education
        |> required "institution" Decode.string
        |> optional "url" Decode.string ""
        |> required "area" Decode.string
        |> required "studyType" Decode.string
        |> required "startDate" Decode.string
        |> required "endDate" Decode.string
        |> optional "score" Decode.string ""
        |> optional "courses" (Decode.list Decode.string) []



-- Award Decoder


awardDecoder : Decoder Award
awardDecoder =
    Decode.succeed Award
        |> required "title" Decode.string
        |> required "date" Decode.string
        |> required "awarder" Decode.string
        |> required "summary" Decode.string



-- Certificate Decoder


certificateDecoder : Decoder Certificate
certificateDecoder =
    Decode.succeed Certificate
        |> required "name" Decode.string
        |> required "date" Decode.string
        |> required "url" Decode.string
        |> required "issuer" Decode.string



-- Publication Decoder


publicationDecoder : Decoder Publication
publicationDecoder =
    Decode.succeed Publication
        |> required "name" Decode.string
        |> required "publisher" Decode.string
        |> required "releaseDate" Decode.string
        |> required "url" Decode.string
        |> required "summary" Decode.string



-- Skill Decoder


skillDecoder : Decoder Skill
skillDecoder =
    Decode.succeed Skill
        |> required "name" Decode.string
        |> optional "level" Decode.string ""
        |> optional "keywords" (Decode.list Decode.string) []



-- Language Decoder


languageDecoder : Decoder Language
languageDecoder =
    Decode.succeed Language
        |> required "language" Decode.string
        |> required "fluency" Decode.string



-- Interest Decoder


interestDecoder : Decoder Interest
interestDecoder =
    Decode.succeed Interest
        |> required "name" Decode.string
        |> required "keywords" (Decode.list Decode.string)



-- Reference Decoder


referenceDecoder : Decoder Reference
referenceDecoder =
    Decode.succeed Reference
        |> required "name" Decode.string
        |> required "reference" Decode.string



-- Project Decoder


projectDecoder : Decoder Project
projectDecoder =
    Decode.succeed Project
        |> required "name" Decode.string
        |> required "description" Decode.string
        |> optional "highlights" (Decode.list Decode.string) []
        |> optional "keywords" (Decode.list Decode.string) []
        |> required "startDate" Decode.string
        |> optional "endDate" Decode.string ""
        |> required "url" Decode.string
        |> optional "roles" (Decode.list Decode.string) []
        |> optional "entity" Decode.string ""
        |> optional "type_" Decode.string ""



-- Meta Decoder


metaDecoder : Decoder Meta
metaDecoder =
    Decode.succeed Meta
        |> required "canonical" Decode.string
        |> required "version" Decode.string
        |> required "lastModified" Decode.string
