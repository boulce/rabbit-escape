module ViewDialog exposing (viewDialog)

import BlockImage exposing (blockImage)
import Html exposing (Html, button, div, img, p, text, textarea)
import Html.Attributes exposing (id, readonly, src, style)
import Html.Events exposing (onClick)
import Model exposing (Model, UiMode(..), UiState)
import Msg exposing (Msg(..))
import World exposing (Block(..), BlockMaterial(..), BlockShape(..))
import Rabbit exposing
    ( Direction(..)
    , Rabbit
    , RabbitType(..)
    , makeRabbit
    , makeRabbot
    )
import RabbitImage exposing (rabbitImage)
import Thing exposing (Thing(..))
import ThingImage exposing (thingImage)


type alias Contents =
    { visible : Bool
    , dialogStyles : List (String, String)
    , items : List (Html Msg)
    }


-- Make a string into a paragraph of translated text
tp : Model -> String -> Html Msg
tp model s =
    p [] [text (model.t s)]


chooseBlockButtons : Model -> Contents
chooseBlockButtons model =
    let
        but : Block -> Html Msg
        but block =
            button
                [ onClick (ChangeBlock block) ]
                [ img [ src ("images/" ++ (blockImage block)) ] [] ]
    in
        { visible =
            True
        , dialogStyles =
            [ ("overflow", "auto") ]
        , items =
            [ tp model "Choose a block:"
            , but (Block Earth Flat)
            , but (Block Earth UpRight)
            , but (Block Earth UpLeft)
            , but (Block Earth BridgeUpRight)
            , but (Block Earth BridgeUpLeft)
            , but (Block Metal Flat)
            , but (NoBlock)
            ]
        }


chooseRabbitButtons : Model -> Contents
chooseRabbitButtons model =
    let
        but : Maybe Rabbit -> Html Msg
        but rabbit =
            button
                [ onClick (ChangeRabbit rabbit) ]
                [ img [ src ("images/" ++ (rabbitImage rabbit)) ] [] ]
    in
        { visible =
            True
        , dialogStyles =
            [ ("overflow", "auto") ]
        , items =
            [ tp model "Choose a rabbit:"
            , but (Just (makeRabbit 0 0 Right))
            , but (Just (makeRabbit 0 0 Left))
            , but (Just (makeRabbot 0 0 Right))
            , but (Just (makeRabbot 0 0 Left))
            , but (Nothing)
            ]
        }


chooseThingButtons : Model -> Contents
chooseThingButtons model =
    let
        but : Maybe Thing -> Html Msg
        but thing =
            button
                [ onClick (ChangeThing thing) ]
                [ img [ src ("images/" ++ (thingImage thing)) ] [] ]
    in
        { visible =
            True
        , dialogStyles =
            [ ("overflow", "auto") ]
        , items =
            [ tp model "Choose an item:"
            , but (Just (Entrance 0 0))
            , but (Just (Exit 0 0))
            , but (Nothing)
            ]
        }


codeText : Model -> String -> Contents
codeText model code =
    { visible =
        True
    , dialogStyles =
        [ ("display", "grid")
        , ("grid-template-rows", "3em 3fr 1fr")
        ]
    , items =
        [ tp model
            (  "Copy this code and paste it somewhere to save. Paste it into "
            ++ "Rabbit Escape to play it."
            )
        , textarea
            [ id "code"
            , readonly True
            ]
            [ text code ]
        , textarea
            [ id "errors"
            , readonly True
            ]
            [ text "" ]
        ]
    }


invisible : Contents
invisible =
    { visible = False
    , dialogStyles = []
    , items = []
    }


drawDialog : Contents -> List (Html Msg)
drawDialog contents =
    let
        vs =
            if contents.visible then
                [("visibility", "visible")]
            else
                []
    in
        [ div
            [ id "dialogBackground"
            , style vs
            ]
            []
        , div
            [ id "dialog"
            , style (vs ++ contents.dialogStyles)
            ]
            contents.items
        ]


viewDialog : Model -> List (Html Msg)
viewDialog model =
    drawDialog
        ( case model.uiState.mode of
            ChooseBlockMode -> chooseBlockButtons model
            ChooseThingMode -> chooseThingButtons model
            ChooseRabbitMode -> chooseRabbitButtons model
            CodeMode code   -> codeText model code
            other           -> invisible
        )
