%Start of game
start = false;
%Loop for main screen
while ~start 
    scene = simpleGameEngine('title.png',1530 ,920);
    card_display = [1];
    drawScene(scene,card_display);
    
    key = getKeyboardInput(scene);
    pause(0.2);

while ~strcmp(key, 'space') && ~strcmp(key,'i')
        key = getKeyboardInput(scene);
        pause(0.2); 
end

if(strcmp(key,'space'))
    start = true;
    
elseif(strcmp(key,'i'))
    close(scene.my_figure);
    card_display = [1];
    scene = simpleGameEngine('tutorial.png',1530, 920);
    drawScene(scene,card_display);

    key = getKeyboardInput(scene);
    pause(0.2);

while ~strcmp(key, 'm') 
        key = getKeyboardInput(scene);
        pause(0.2); 
end

end

close(scene.my_figure);
end

if(start)

% Initialize game scene
scene = simpleGameEngine('retro_cards.png',16,16,20,[153,92,30]);

%Create deck
cards = ["Ace", "2" , "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"];


for i = 1:1:52
  
    if i <= 13
    deck(i) = "C" + cards(i);
    elseif i <= 26
    c = i - 13;
    deck(i) = "D" + cards(c);
    elseif i <= 39
     c = i - 26;
    deck(i) = "H" + cards(c);
    elseif i <= 52
    c = i - 39;
    deck(i) = "S" + cards(c);
    end

end

%Create player decks
deckP1 = deck(randperm(52,26));
deckP2 = setdiff(deck,deckP1);

%Initializing Variable For Sprites
empty_sprite = 1;
card_sprites = 21:74;
card_backs = 3:10;
text_playerOne = 75:78;
text_playerTwo = 79:83;
winround_playerTwo = 83:86;
winround_playerOne = [98 99 100 86];
warDisplay = 17:20;
brown = 88;
white = 89;
brownRight = 90;
brownTop = 91;
brownRightCorner = 92;
brownLeftCorner = 93;
brownRightBottomCorner = 95;
brownLeftBottomCorner = 96;
brownBottom = 97;

%Draw cards representing players decks 
card_display = ones(10,6);
card_display(3,3) = card_backs(1);
card_display(3,4) = card_backs(2);

card_display(9,3) = card_backs(3);
card_display(9,4) = card_backs(4);

%Draw Table and Player Turn Display
card_display(1,2:5) = text_playerOne(1:4);
card_display(3,1) = brownLeftCorner;

for o = 3:9
    card_display(o,1) = brown;
    card_display(o,6) = brownRight;
end

for m = 2:5
    card_display(2,m) = brownTop;
end

for r = 2:5
    card_display(10,r) = brownBottom;
end

card_display(2,1) = brownLeftCorner;
card_display(2,6) = brownRightCorner;
card_display(10,1) = brownLeftBottomCorner;
card_display(10,6) = brownRightBottomCorner;

card_display(1,1) = white;
card_display(1,6) = white;

drawScene(scene,card_display);

%Initialize varaibles for game
    currentPlayer = 1; 
    index = 1; 
    p1Discard = string.empty;
    p2Discard = string.empty;
    equal = false;

while ~checkWinGame([deckP1 p1Discard],[deckP2 p2Discard])

    key = getKeyboardInput(scene);
    pause(0.2);

    if currentPlayer == 1 
   
    while ~strcmp(key, 'space')
        key = getKeyboardInput(scene);
        pause(0.2); 
    end    
    %Update board to show card drawn by player one
    card_display(8,4) = card_sprites(cardIndex(deckP1(index)));
    
    %Update currentPlayer varaiable and board with sprite for player 2 turn
    currentPlayer = currentPlayer + 1; 
    card_display(1,2:5) = text_playerTwo(1:4);

    drawScene(scene,card_display);

    else
    
    while ~strcmp(key, 'a')
        key = getKeyboardInput(scene);
        pause(0.2); 
    end  

    %Update board to show card drawn by player two
    card_display(4,4) = card_sprites(cardIndex(deckP2(index)));

    %Update currentPlayer varaiable and board with sprite for player 1 turn
    currentPlayer = currentPlayer - 1;
    card_display(1,2:5) = text_playerOne(1:4);

    drawScene(scene,card_display);
    end 
    
    %Check if both cards are placed down 
    if (card_display(8,4) ~= 1) && (card_display(4,4) ~= 1)
       if compareCard(deckP1(index), deckP2(index)) == 1
        %Player 1 has greater rank
        fprintf('Player 1 Greater\n')
        fprintf("Player one : " + length(deckP1) + " Player two " + length(deckP2) + "\n")

        %Add cards to player one discard pile
        p1Discard(length(p1Discard) + 1) = deckP1(index);
        p1Discard(length(p1Discard) + 1) = deckP2(index);
       
        %Draw win display for player 1
        card_display(1,2:5) = winround_playerOne(1:4);
        drawScene(scene,card_display);

        %Change current player sprite
        pause(2.5)
        if currentPlayer == 2
        card_display(1,2:5) = text_playerTwo(1:4);
        else
         card_display(1,2:5) = text_playerOne(1:4);
        end

        %Update Discard Pile Sprite
        card_display(9,2) = card_sprites(cardIndex(p1Discard(length(p1Discard)-1)));

        %Reset card in actual decks since added to discard pile
        deckP1(index) = [];
        deckP2(index) = [];

       elseif compareCard(deckP1(index), deckP2(index)) == 2
        %Player 2 has greater rank
        fprintf('Player 2 Greater\n')
        fprintf("Player one : " + length(deckP1) + " Player two " + length(deckP2) + "\n")

        %Add cards to player 2 discard pile
        p2Discard(length(p2Discard) + 1) = deckP2(index);
        p2Discard(length(p2Discard) + 1) = deckP1(index);

        %Draw win display for player 2
        card_display(1,2:5) = winround_playerTwo(1:4);
        drawScene(scene,card_display);

        %Change current player sprite
        pause(2.5)
        if currentPlayer == 2
        card_display(1,2:5) = text_playerTwo(1:4);
        else
         card_display(1,2:5) = text_playerOne(1:4);
        end
        
         %Update Discard Pile Sprite
        card_display(3,2) = card_sprites(cardIndex(p2Discard(length(p2Discard)-1)));
        
        %Reset card in actual decks since added to discard pile
        deckP1(index) = [];
        deckP2(index) = [];

       else
         %Cards Placed Are Equal
         fprintf('Equal')

         card_display(1,2:5) = warDisplay(1:4);
         drawScene(scene,card_display);
         %Start War
         pause(3)   
           
         %Add three cards for each player
         card_display(8,3) = card_backs(5);
         card_display(8,4) = card_backs(5);
         card_display(8,5) = card_backs(5);
         
         card_display(4,3) = card_backs(6);
         card_display(4,4) = card_backs(6);
         card_display(4,5) = card_backs(6);

         drawScene(scene,card_display);

         %Initalize variable for equal function
         equal = true;
         beginIndex = 1;
         endIndex = 4;
         if length(deckP1) + length(p1Discard) < 4
          fprintf("Player One has less than 4 cards left")
          equal = false;
        
          p2Discard = [p2Discard deckP2(1:endIndex) p1Discard deckP1];

          %Draw win display for player 2
        card_display(1,2:5) = winround_playerTwo(1:4);
        drawScene(scene,card_display);
         pause(2)

         %Reset cards placed down during war in both player decks
         deckP1 = string.empty;
         p1Discard = string.empty;
         deckP2(1:endIndex)= [];

          
         elseif length(deckP2) + length(p2Discard) < 4
          fprintf("Player two has less than 4 cards left")
          equal = false;
          p1Discard = [p1Discard p2Discard deckP2 deckP1(1:endIndex)];

          %Draw win display for player 2
        card_display(1,2:5) = winround_playerOne(1:4);
        drawScene(scene,card_display);
          
        pause(2)
         %Reset cards placed down during war in both player decks
         deckP2 = string.empty;
         p2Discard = string.empty;
         deckP2(1:endIndex)= [];
         card_display(1,2:5) = text_playerOne(1:4);
          drawScene(scene,card_display);
         end

         %Start to take turns again
         while equal 

         %Check if each deck has enough card in main deck and shuffle if
         %nota
             if length(deckP1) < 4
            %Reset index and shuffle deck
            deckP1 = p1Discard(randperm(length(p1Discard)));
            p1Discard = string.empty;
             end

        if length(deckP2) < 4 
        deckP2 = p2Discard(randperm(length(p2Discard)));
        p2Discard = string.empty;
        end

         %Get Input from players to place down card to compare again
         if currentPlayer == 1 
            card_display(1,2:5) = text_playerOne(1:4);
            drawScene(scene,card_display);

            key = getKeyboardInput(scene);
            pause(0.2); 
            
            while ~strcmp(key, 'space')
            key = getKeyboardInput(scene);
            pause(0.2); 
            end 

            %Update board to show player one card placed down 
            card_display(7,4) = card_sprites(cardIndex(deckP1(endIndex)));
            
            %Change current player display to player two
            card_display(1,2:5) = text_playerTwo(1:4);
            drawScene(scene,card_display);

            %Change Current Player Variable to Player 2
            currentPlayer = 2; 
         else
            card_display(1,2:5) = text_playerTwo(1:4);
            drawScene(scene,card_display);
            
            key = getKeyboardInput(scene);
            pause(0.2); 

            while ~strcmp(key, 'a')
            key = getKeyboardInput(scene);
            pause(0.2); 
            end

            %Update board to show player two card placed down 
            card_display(5,4) = card_sprites(cardIndex(deckP2(endIndex)));
            
            %Change current player display to player two
             card_display(1,2:5) = text_playerOne(1:4);

            drawScene(scene,card_display);

            %Change currentPlayer variable to player one
            currentPlayer = 1;
         end 

         %Check if cards are placed down from both players
         if (card_display(7,4) ~= 1) && (card_display(5,4) ~= 1)

         %Compare the cards of each 
         if compareCard(deckP1(endIndex), deckP2(endIndex)) == 1

          %Player One has greater rank card
          fprintf('Player 1 Greater\n') 

          %Set boolean equal to false since the cards were not equal and 
          %to exit loop
          equal = false; 
          
          %Update Player One discard pile adding cards placed down by
          %player two and player one
          p1Discard = [p1Discard deckP1(1:endIndex) deckP2(1:endIndex)];

           %Draw win display for player 1
        card_display(1,2:5) = winround_playerOne(1:4);
        drawScene(scene,card_display);
  

          %Remove cards placed down by player two and one from their pile
          deckP2(1:endIndex) = [];
          deckP1(1:endIndex) = [];

         %Update board clearing cards
         pause(3);
         %Reset where three cards placed face up 
         card_display(8,3) = 1;
         card_display(8,4) = 1;
         card_display(8,5) = 1;
         
         card_display(4,3) = 1;
         card_display(4,4) = 1;
         card_display(4,5) = 1;

         %Reset where cards placed face up
         card_display(7,4) = 1;
         card_display(5,4) = 1;

        card_display(1,2:5) = text_playerOne(1:4);

         drawScene(scene,card_display);

         elseif compareCard(deckP1(endIndex), deckP2(endIndex)) == 2
         %Player two has greater ranked card placed down
         fprintf('Player 2 Greater\n')

         %Update player two discard pile adding cards placed down by
         %player one and two during war
         p2Discard = [p2Discard deckP2(1:endIndex) deckP1(1:endIndex)];

          %Draw win display for player 2
        card_display(1,2:5) = winround_playerTwo(1:4);
        drawScene(scene,card_display);

         %Reset cards placed down during war in both player decks
         deckP1(1:endIndex) = [];
         deckP2(1:endIndex) = [];

           equal = false;

         %Update board clearing cards
         pause(3);

        %Reset where three cards placed face up 
         card_display(8,3) = 1;
         card_display(8,4) = 1;
         card_display(8,5) = 1;
         
         card_display(4,3) = 1;
         card_display(4,4) = 1;
         card_display(4,5) = 1;

         %Reset where cards placed face up
         card_display(7,4) = 1;
         card_display(5,4) = 1;
         card_display(1,2:5) = text_playerOne(1:4);
         drawScene(scene,card_display);
        
         else
            %Still equal
            endIndex = endIndex + 4;
         end
         end

         drawScene(scene,card_display);

       if isempty(deckP1) 
        %Reset index and shuffle deck
        deckP1 = p1Discard(randperm(length(p1Discard)));
        p1Discard = string.empty;
       end
       if isempty(deckP2) 
        deckP2 = p2Discard(randperm(length(p2Discard)));
        p2Discard = string.empty;
       end

         end
            
       end 

       %Shuffle players deck if they dont have enough cards
       if isempty(deckP1) &&  ~checkWinGame([deckP1 p1Discard],[deckP2 p2Discard])
       fprintf('One shuffled\n')
       %Shuffle player one deck with cards from discard pile
        deckP1 = p1Discard(randperm(length(p1Discard)));
        %Reset discard pile
         p1Discard = string.empty;
         
       end

       if isempty(deckP2) &&  ~checkWinGame([deckP1 p1Discard],[deckP2 p2Discard])
        fprintf('Two shuffled\n')
        %Shuffle player two deck with cards from discard pile
        deckP2 = p2Discard(randperm(length(p2Discard)));
        %Reset discard pile
        p2Discard = string.empty;
        
       end
        
        %If Player one or two had greater rank update board removing card
        if ~equal
        pause(1);
        card_display(8,4) = 1;
        card_display(4,4) = 1;
        end

end

%Update board to current sprites
drawScene(scene,card_display);

end
end
    %End of game show win screen for the winner  
    if isempty(deckP2)
    close(scene.my_figure);
    card_display = [index];
    scene = simpleGameEngine('p1win.png',1530 ,920);
    drawScene(scene,card_display);

    elseif isempty(deckP2)
    close(scene.my_figure);
    card_display = [index];
    scene = simpleGameEngine('p2win.png',1530 ,920);
    drawScene(scene,card_display);

    end

    key = getKeyboardInput(scene);
    pause(0.2);

    while ~strcmp(key, 'space') && ~strcmp(key,'q')
        key = getKeyboardInput(scene);
        pause(0.2); 
    end

    if(strcmp(key,'space'))
    close(scene.my_figure);
    war();p
    elseif(strcmp(key,'q'))
    close(scene.my_figure);
    end
    
%Function returns index in sprite sheet of given card string

function c = cardIndex(v)
    rank = extractBefore(v,2);
    type = extractAfter(v,1);
    c = 1;

 if ~isnan(str2double(type))
    if strcmp(rank,"H")
    c = str2num(type);
    elseif strcmp(rank,"D")
    c = 13 + str2num(type);
    elseif strcmp(rank,"C")
    c = 26 + str2num(type);
    elseif strcmp(rank,"S")
    c = 39 + str2num(type);
    end
 else
    if strcmp(rank,"H")
     c = 1;
    elseif strcmp(rank,"D")
    c = 14;
    elseif strcmp(rank,"C")
    c = 27;
    elseif strcmp(rank,"S")
    c = 40;
    end

     if(strcmp(type, "Jack"))
     c = c + 10;
     elseif(strcmp(type, "Queen"))
     c = c + 11;
     elseif(strcmp(type, "King"))
     c = c + 12;
     end

 end
    
end

%Returns 2 if Player 2's card is of greater rank, 1 if Player 1 card, -1 if
%equal
function m = compareCard(p1Card, p2Card)
   p1V = extractAfter(p1Card,1);
   p2V = extractAfter(p2Card,1);
 
   if(strcmp(p1V, p2V))
   m = -1;
   elseif (strcmp(p1V,"Ace"))
       m = 1;
   elseif (strcmp(p1V,"King"))
       if ~strcmp(p2V,"Ace")
           m = 1;
       else
           m = 2;
       end
   elseif (strcmp(p1V,"Queen"))
       if ~strcmp(p2V,"Ace") && ~strcmp(p2V,"King")
           m = 1;
       else
           m = 2;
       end
   elseif (strcmp(p1V,"Jack"))
       if ~strcmp(p2V,"Ace") && ~strcmp(p2V,"King") && ~strcmp(p2V,"Queen")
           m = 1;
       else
           m = 2;
       end
   elseif(str2num(p1V) > str2num(p2V))
   m = 1;
   else
       m = 2;
   end

end

%Function that check if player 
function r = checkWinGame(deckP1, deckP2)
    if isempty(deckP1) || isempty(deckP2)
        r = true; 
    else
        r = false;
    end
end



