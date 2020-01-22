module Main exposing (main)

import Browser
import Html exposing (Html, a, button, div, h2, h3, nav, pre, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http



-- MODEL


type alias Model =
    { flag : String
    , httpStatus : HttpStatus
    }


type HttpStatus
    = Failure Http.Error
    | Loading
    | Success String


initialModel : String -> Model
initialModel jsInput =
    { flag = jsInput
    , httpStatus = Loading
    }


init : String -> ( Model, Cmd Msg )
init jsInput =
    ( initialModel jsInput
    , Http.get
        { url = "elm-lang.org/assets/public-opinion.txt"
        , expect = Http.expectString GotText
        }
    )



-- MSG


type Msg
    = GotText (Result Http.Error String)



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( { model
                        | httpStatus = Success fullText
                      }
                    , Cmd.none
                    )

                Err error ->
                    ( { model
                        | httpStatus = Failure error
                      }
                    , Cmd.none
                    )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ header model.flag
        , displayBook model.httpStatus
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
                ]
            ]
        ]


displayBook : HttpStatus -> Html Msg
displayBook httpStatus =
    case httpStatus of
        Failure error ->
            div []
                [ h2 [] [ text "I was unable to load the book" ]
                , h3 [] [ text ("Error: " ++ Debug.toString error) ]
                ]

        Loading ->
            text "Loading..."

        Success fullText ->
            pre [] [ text fullText ]


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
