using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Memo
{
  class Card
  {
    public int Index { get; set; }
    public bool Guessed { get; set; }
    public bool Opened { get; set; }
  }

  public class BoardController : MonoBehaviour
  {
    public GameObject cardPrefab;
    private GameController gameController;
    private List<Card> cards = new List<Card>();
    private GameObject cardsContainer;
    private GridLayoutGroup containerLayout;
    private List<GameObject> cardsObjs = new List<GameObject>();
    private Sprite defaultSprite;
    private List<Sprite> sprites = new List<Sprite>();

    private Card firstCard;
    private Card secondCard;

    private void MarkCardsAsGuessed()
    {
      firstCard.Guessed = true;
      secondCard.Guessed = true;
      firstCard = null;
      secondCard = null;
      gameController.OnGuessed();
    }

    private void CloseCards()
    {
      firstCard.Opened = false;
      secondCard.Opened = false;
      firstCard = null;
      secondCard = null;
      gameController.OnNotGuessed();
    }

    private void InitBoardState()
    {

      for (int i = 0; i < (gameController.board.Height * gameController.board.Width) / 2; i++)
      {
        cards.Add(new Card { Index = i, Guessed = false, Opened = false });
        cards.Add(new Card { Index = i, Guessed = false, Opened = false });
      }

      cards.Shuffle();

      foreach (Card card in cards)
      {
        var cardObj = Instantiate(cardPrefab);
        cardObj.GetComponent<Button>().onClick.AddListener(() =>
        {
          if (card.Guessed) return;

          if (firstCard == null)
          {
            card.Opened = true;
            firstCard = card;
          }
          else if (secondCard == null)
          {
            card.Opened = true;
            secondCard = card;

            if (firstCard.Index == card.Index)
            {
              Invoke("MarkCardsAsGuessed", 0.5f);
            }
            else
            {
              Invoke("CloseCards", 0.5f);
            }
          }
        });

        cardObj.transform.SetParent(cardsContainer.transform, false);
        cardsObjs.Add(cardObj);
      }
    }

    private void LoadSprites()
    {
      defaultSprite = Resources.Load<Sprite>("Sprites/ImgDefault");

      for (int i = 0; i < 8; i++)
      {
        sprites.Add(
          Resources.Load<Sprite>($"Sprites/Img{i}")
        );
      }
    }

    void Awake()
    {
      LoadSprites();

      gameController = GameObject.FindGameObjectWithTag("GameController").GetComponent<GameController>();
      cardsContainer = GameObject.FindGameObjectWithTag("CardsContainer");
      containerLayout = cardsContainer.GetComponent<GridLayoutGroup>();
      containerLayout.constraint = GridLayoutGroup.Constraint.FixedColumnCount;
      containerLayout.constraintCount = gameController.board.Width;

      InitBoardState();
    }

    void Start()
    {
    }

    void Update()
    {
      for (int i = 0; i < cards.Count; i++)
      {
        var card = cards[i];
        if (card.Guessed)
        {
          cardsObjs[i].transform.localScale = new Vector3(0, 0, 0);
        }
        else
        {
          cardsObjs[i].GetComponent<Image>().sprite = card.Guessed || card.Opened ? sprites[card.Index] : defaultSprite;
        }

      }
    }
  }
}