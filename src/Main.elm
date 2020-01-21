module Main exposing (main)

import Browser
import Html exposing (Html, a, button, div, h2, nav, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    {}


initialModel : Model
initialModel =
    {}

init : flags -> (Model, Cmd Msg)
init _ =
    (initialModel, Cmd.none)

-- MSG


type Msg
    = Nothing



-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Nothing ->
            (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ header
        ]


header : Html Msg
header =
    nav [ class "flex items-center justify-between flex-wrap bg-teal-500 p-6" ]
        [ div [ class "flex items-center flex-shrink-0 text-white mr-6" ]
            [ span [ class "font-semibold text-xl tracking-tight" ] [ text "IShipEveryDay" ]
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

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
