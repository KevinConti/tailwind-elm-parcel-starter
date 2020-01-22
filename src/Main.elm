port module Main exposing (main)

import Browser
import Html exposing (Html, a, button, div, h2, h3, img, nav, pre, span, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E


port cache : E.Value -> Cmd msg



-- MODEL


type alias Model =
    { flag : String -- Flag from javascript - becomes the title in the top-left of the navbar
    , httpStatus : HttpStatus -- Http get request for cat memes
    , httpStatusTwo : HttpStatus -- Http get request that is parsed using json-pipeline-decoder
    }


type HttpStatus
    = Failure Http.Error
    | Loading
    | Success String


initialModel : String -> Model
initialModel jsInput =
    { flag = jsInput
    , httpStatus = Loading
    , httpStatusTwo = Loading
    }


init : String -> ( Model, Cmd Msg )
init jsInput =
    ( initialModel jsInput
    , Cmd.batch [getRandomCatGif
    , getRandomDogGif]
    )



-- MSG


type Msg
    = GotGif (Result Http.Error String) -- Msg response from Cmd when the Http.get returns
    | GotDogGif (Result Http.Error DogGif) -- Msg response from Cmd



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotGif result ->
            case result of
                Ok url ->
                    ( { model
                        | httpStatus = Success url
                      }
                    , Cmd.none
                    )

                Err error ->
                    ( { model
                        | httpStatus = Failure error
                      }
                    , Cmd.none
                    )

        GotDogGif result ->
            case result of
                Ok gif ->
                    ( { model
                    | httpStatusTwo = Success gif.data.image_url 
                    }
                     , Cmd.none
                    )

                Err error ->
                    ( { model 
                        | httpStatusTwo = Failure error 
                        }
                      , Cmd.none 
                    )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ header model.flag
        , viewGif model.httpStatus
        , viewGif model.httpStatusTwo
        ]


header : String -> Html Msg
header title =
    nav [ class "flex items-center justify-between flex-wrap bg-teal-500 p-6" ]
        [ div [ class "flex items-center flex-shrink-0 text-white mr-6" ]
            [ span [ class "font-semibold text-xl tracking-tight" ] [ text title ]
            ]
        , div [ class "block lg:hidden" ]
            [ button [ class "flex items-center px-3 py-2 border rounded text-teal-200 border-teal-400 hover:text-white hover:border-white" ] [ text "Menu" ]
            ]
        , div [ class "w-full block flex-grow lg:flex lg:items-center lg:w-auto" ]
            [ div [ class "text-sm lg:flex-grow" ]
                [ a [ class "block mt-4 lg:inline-block lg:mt-0 text-teal-200 hover:text-white mr-4" ] [ text "Profile" ]
                , a [ class "block mt-4 lg:inline-block lg:mt-0 text-teal-200 hover:text-white mr-4" ] [ text "My Feed" ]
                , a [ class "block mt-4 lg:inline-block lg:mt-0 text-teal-200 hover:text-white mr-4" ] [ text "Contact Us" ]
                ]
            , div []
                [ a [ class "inline-block text-sm px-4 py-2 leading-none border rounded text-white border-white hover:border-transparent hover:text-teal-500 hover:bg-white mt-4 lg:mt-0" ] [ text "Sign Up" ]
                ] ]
        ]


viewGif : HttpStatus -> Html Msg
viewGif httpStatus =
    case httpStatus of
        Failure error ->
            div []
                [ h2 [] [ text "I was unable to load the gif" ]
                , h3 [] [ text ("Error: " ++ Debug.toString error) ]
                ]

        Loading ->
            text "Loading..."

        Success url ->
            div [ class "h-48 w-48" ]
                [ h3 [ class "text-gray-800" ] [ text "Http get request: " ]
                , img [ src url ] []
                ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program String Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- HTTP


getRandomCatGif : Cmd Msg
getRandomCatGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
        , expect = Http.expectJson GotGif gifDecoder
        }


getRandomDogGif : Cmd Msg
getRandomDogGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=dog"
        , expect = Http.expectJson GotDogGif jsonPipelineDecoder }

dogGifToString : DogGif -> String 
dogGifToString gif =
    gif.data.image_url

gifDecoder : Decoder String
gifDecoder =
    field "data" (field "image_url" string)



-- json-decode-pipeline


type alias Data =
    { image_url : String
    }


type alias DogGif =
    { data : Data
    }


jsonPipelineDecoder : Decoder DogGif
jsonPipelineDecoder =
    Json.Decode.succeed DogGif
        |> required "data" dataDecoder


dataDecoder : Decoder Data
dataDecoder =
    Json.Decode.succeed Data
        |> required "image_url" string
