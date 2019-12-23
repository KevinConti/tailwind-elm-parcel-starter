module Main exposing (main)

import Browser
import Html exposing (Html, a, button, div, h2, nav, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { navbarApplied : Bool
    , headerSections : HeaderSections
    , editPaneOpen : Bool
    }


type alias HeaderSections =
    { navbarHeader : Collapsable
    , buttonsHeader : Collapsable
    }


type Collapsable
    = Collapsed
    | Visible


type Content
    = Nav NavType
    | Button ButtonType


type NavType
    = ResponseiveHeader


type ButtonType
    = SimpleButton


initialModel : Model
initialModel =
    { navbarApplied = False
    , headerSections =
        { navbarHeader = Collapsed
        , buttonsHeader = Collapsed
        }
    , editPaneOpen = False
    }


type ItemType
    = NavbarHeader
    | ButtonHeader



-- MSG


type Msg
    = ToggleNav
    | ToggleVisibility ItemType



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleNav ->
            { model | navbarApplied = not model.navbarApplied }

        ToggleVisibility NavbarHeader ->
            { model
                | headerSections = toggleHeaderSection model model.headerSections.navbarHeader setNavbarHeader
            }

        ToggleVisibility ButtonHeader ->
            { model
                | headerSections =
                    toggleHeaderSection model model.headerSections.buttonsHeader setButtonsHeader
            }



-- Toggles a header section
-- Params:
-- model: the model, passed in
-- header: the header section we are changing
-- setter: A helper function that sets a HeaderSection


toggleHeaderSection : Model -> Collapsable -> (Collapsable -> HeaderSections -> HeaderSections) -> HeaderSections
toggleHeaderSection model header setter =
    case header of
        Collapsed ->
            model.headerSections |> setter Visible

        Visible ->
            model.headerSections |> setter Collapsed


setNavbarHeader : Collapsable -> HeaderSections -> HeaderSections
setNavbarHeader newState headerSection =
    { headerSection | navbarHeader = newState }


setButtonsHeader : Collapsable -> HeaderSections -> HeaderSections
setButtonsHeader newState headerSection =
    { headerSection | buttonsHeader = newState }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "font-sans flex" ]
        [ div [ class "flex flex-col w-1/4 bg-gray-400" ]
            [ selectorList "Navbars" model.headerSections.navbarHeader NavbarHeader
            , selectorList "Buttons" model.headerSections.buttonsHeader ButtonHeader
            ]
        , div [ class "w-3/4 bg-gray-300" ] [ applyElements model ]
        ]


selectorList : String -> Collapsable -> ItemType -> Html Msg
selectorList heading visibility itemType =
    div [ class "w-full bg-gray-300 flex flex-col items-center" ]
        [ div [ class "flex items-center" ]
            [ span [] [ text heading ]
            , button [ onClick (ToggleVisibility itemType), class "mx-4 font-light text-xs" ] [ text "toggle" ]
            ]
        , showButtons visibility
        ]


showButtons : Collapsable -> Html Msg
showButtons shouldShow =
    case shouldShow of
        Collapsed ->
            text ""

        Visible ->
            simpleButton "Responsive Header"


simpleButton : String -> Html Msg
simpleButton buttonText =
    button [ onClick ToggleNav, class "leading-tight w-full bg-blue-500 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded" ]
        [ text buttonText ]


applyElements : Model -> Html Msg
applyElements model =
    case model.navbarApplied of
        False ->
            h2 [ class "font-sans" ] [ text "Click a button on the left!" ]

        True ->
            createNav


createNav : Html Msg
createNav =
    nav [ class "flex items-center justify-between flex-wrap bg-teal-500 p-6" ]
        [ div [ class "flex items-center flex-shrink-0 text-white mr-6" ]
            [ span [ class "font-semibold text-xl tracking-tight" ] [ text "Tailwind CSS" ]
            ]
        , div [ class "block lg:hidden" ]
            [ button [ class "flex items-center px-3 py-2 border rounded text-teal-200 border-teal-400 hover:text-white hover:border-white" ]
                [ text "Menu" ]
            ]
        , div [ class "w-full block flex-grow lg:flex lg:items-center lg:w-auto" ]
            [ div [ class "text-sm lg:flex-grow" ]
                [ navLink "Docs"
                , navLink "Examples"
                , navLink "Blog"
                ]
            ]
        , div []
            [ a [ class "inline-block text-sm px-4 py-2 leading-none border rounded text-white border-white hover:border-transparent hover:text-teal-500 hover:bg-white mt-4 lg:mt-0" ]
                [ text "Download" ]
            ]
        ]


navLink : String -> Html Msg
navLink name =
    a [ class "block mt-4 lg:inline-block lg:mt-0 text-teal-200 hover:text-white mr-4" ]
        [ text name ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
