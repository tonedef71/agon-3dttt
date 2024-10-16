10000 REM :::::::::::::::::::::::::::::::::::::::::::::::::
10010 REM :: 3D TIC-TAC-TOE FOR AgonLight (BBC BASIC v3) ::
10020 REM :::::::::::::::::::::::::::::::::::::::::::::::::
10030 REM :: 20241016: V1.0.0 - Initial release          ::
10040 REM :::::::::::::::::::::::::::::::::::::::::::::::::
10050 REM :: 3D Tic-Tac-Toe borrows some of its visuals  ::
10060 REM :: from Mark Doyle's "3D Tic-Tac-Toe" game for ::
10070 REM :: the C-64 first published back in June 1984  ::
10080 REM :: in issue #12 of Compute's Gazette           ::
10090 REM :::::::::::::::::::::::::::::::::::::::::::::::::
10100 REM :: It is best experienced in a 40+ column, 8+  ::
10110 REM :: color display mode                          ::
10120 REM :::::::::::::::::::::::::::::::::::::::::::::::::
10130 CLEAR
10140 REPEAT CLS:SY$=FN_TO_UPPER(FN_PROMPT(0,0,"TARGET (A)gon or (B)BC B-SDL:","A")):UNTIL SY$ = "A" OR SY$ = "B"
10150 IF SY$ = "B" THEN MO% = 9:ELSE MO% = 13
10160 MODE MO%:IF SY$ = "A" THEN CW% = FN_getByteVDP(&13):CH% = FN_getByteVDP(&14):ELSE CW% = 40:CH% = 24
10170 MAXINT% = &3B9AC9FF:BLACK = 0:RED = 1:GREEN = 2:YELLOW = 3:BLUE = 4:MAGENTA = 5:CYAN = 6:WHITE = 7
10180 G$ = "ABCDEFGHIJKLMNPQRSTUVWYZ123":PC% = LEN(G$):CO$="010403":P$ = "045135136":RC% = 147
10190 DIM P%(PC% - 1), R%(RC% - 1), PW%(1), PN$(1), RU$(26)
10200 PROC_SETUP
10210 ON ERROR PROC_HANDLE_ERROR:REM Handle ESC key
10220 PROC_TITLE_SCREEN
10230 PROC_WELCOME
10240 REPEAT
10250   PROC_DEFAULT_COLORS
10260   PROC_NEW_GAME
10270   PROC_MAIN_LOOP
10280   PROC_GAME_OVER
10290   Resp$ = FN_PLAY_AGAIN
10300 UNTIL Resp$ = "N"
10310 PROC_GOODBYE(GameName$)
10320 END
10330 :
10340 REM ::::::::::::::::::::::
10350 REM ::     Welcome      ::
10360 REM ::::::::::::::::::::::
10370 DEF PROC_WELCOME
10380 LOCAL c$, i%, m$, n%
10390 REM PAGE ONE
10400 CLS
10410 PROC_CENTER_TEXT(CHR$(17)+CHR$(CYAN)+"Welcome to "+CHR$(17)+CHR$(YELLOW)+GameName$+CHR$(17)+CHR$(WHITE),6):PRINT:PRINT
10420 PROC_CENTER_TEXT("The classic two-player game of",0):PRINT
10430 PROC_CENTER_TEXT("three-in-a-row as if played within a",0):PRINT
10440 PROC_CENTER_TEXT("3 x 3 cube and with the option to play",0):PRINT
10450 PROC_CENTER_TEXT(CHR$(17)+CHR$(MAGENTA)+"avoidance mode"+CHR$(17)+CHR$(WHITE)+" (each player must",4):PRINT
10460 PROC_CENTER_TEXT("avoid "+CHR$(17)+CHR$(RED)+"*losing*"+CHR$(17)+CHR$(WHITE)+" from three-in-a-row).",4):PRINT:PRINT
10470 PROC_CENTER_TEXT("A player may compete against the",0):PRINT
10480 PROC_CENTER_TEXT("computer ("+CHR$(17)+CHR$(YELLOW)+"1 player mode"+CHR$(17)+CHR$(WHITE)+") or another",4):PRINT
10490 PROC_CENTER_TEXT("player ("+CHR$(17)+CHR$(YELLOW)+"2 player mode"+CHR$(17)+CHR$(WHITE)+"), or the",4):PRINT
10500 PROC_CENTER_TEXT("computer may play against itself",0):PRINT
10510 PROC_CENTER_TEXT("("+CHR$(17)+CHR$(YELLOW)+"0 player mode"+CHR$(17)+CHR$(WHITE)+").",4):PRINT:PRINT
10520 PROC_CENTER_TEXT("The number of three-in-a-rows needed",0):PRINT
10530 PROC_CENTER_TEXT("to end the match may be from "+CHR$(17)+CHR$(YELLOW)+"1"+CHR$(17)+CHR$(WHITE)+" to "+CHR$(17)+CHR$(YELLOW)+"9"+CHR$(17)+CHR$(WHITE)+".",8):PRINT:PRINT
10540 PROC_CENTER_TEXT("For non-two-player games, there are",0):PRINT
10550 PROC_CENTER_TEXT("two levels of difficulty:",0):PRINT
10560 PROC_CENTER_TEXT(CHR$(17)+CHR$(YELLOW)+"1 (normal)"+CHR$(17)+CHR$(WHITE)+" and "+CHR$(17)+CHR$(YELLOW)+"2 (challenging)"+CHR$(17)+CHR$(WHITE),8):PRINT:PRINT
10570 PROC_CENTER_TEXT(CHR$(17)+CHR$(CYAN)+"Press enter to continue",2):c$ = FN_PROMPT_FOR_KEY("", "")
10580 REM PAGE TWO
10590 CLS
10600 PROC_CENTER_TEXT(CHR$(17)+CHR$(CYAN)+"Playing "+CHR$(17)+CHR$(YELLOW)+GameName$+CHR$(17)+CHR$(WHITE),6):PRINT:PRINT
10610 PROC_CENTER_TEXT("In a one-player game, the computer",0):PRINT
10620 PROC_CENTER_TEXT("plays first as '"+CHR$(135)+"'.",0):PRINT:PRINT
10630 PROC_CENTER_TEXT("On your turn, select your play by",0):PRINT
10640 PROC_CENTER_TEXT("pressing a key that matches any one",0):PRINT
10650 PROC_CENTER_TEXT("of the available locations shown on",0):PRINT
10660 PROC_CENTER_TEXT("any of the three tic-tac-toe boards:",0):PRINT:PRINT
10670 n% = PC% DIV 3:FOR i% = 1 TO PC% DIV 3 STEP 3
10680   m$ = CHR$(17) + CHR$(RED) + " " + MID$(G$, i%, 1) + " | " + MID$(G$, i% + 1, 1) + " | " + MID$(G$, i% + 2, 1) + " "
10690   m$ = m$ + CHR$(17) + CHR$(BLUE) + "   " + MID$(G$, n% + i%, 1) + " | " + MID$(G$, n% + 1 + i%, 1) + " | " + MID$(G$, n% + 2 + i%, 1) + " "
10700   m$ = m$ + CHR$(17) + CHR$(YELLOW) + "   "+MID$(G$, 2 * n% + i%, 1) + " | " + MID$(G$, 2 * n% + 1 + i%, 1) + " | " + MID$(G$, 2 * n% + 2 + i%, 1) + " "
10710   PROC_CENTER_TEXT(m$,6)
10720   PRINT
10730   IF 2 > i% DIV 3 THEN PROC_CENTER_TEXT(CHR$(17)+CHR$(RED)+"---+---+---"+CHR$(17)+CHR$(BLUE)+"  ---+---+---"+CHR$(17)+CHR$(YELLOW)+"  ---+---+---",6):PRINT
10740 NEXT i%:PRINT
10750 PROC_CENTER_TEXT(CHR$(17)+CHR$(WHITE)+"Players alternate making plays",2):PRINT
10760 PROC_CENTER_TEXT("until a three-in-a-row occurs.",0):PRINT:PRINT
10770 PROC_CENTER_TEXT("Good luck!",0):PRINT:PRINT
10780 PROC_CENTER_TEXT(CHR$(17)+CHR$(GREEN)+"Press enter to begin playing",2):c$ = FN_PROMPT_FOR_KEY("", "")
10790 PRINT CHR$(17)CHR$(WHITE)
10800 ENDPROC
10810 :
10820 REM ::::::::::::::::::
10830 REM :: Title Screen ::
10840 REM ::::::::::::::::::
10850 DEF PROC_TITLE_SCREEN
10860 VDU 017,128,012
10870 VDU 023,128,255,255,255,255,255,255,255,255
10880 VDU 023,129,000,001,003,007,015,031,063,127
10890 VDU 023,130,000,128,192,224,240,248,252,254
10900 VDU 023,131,255,127,063,031,015,007,003,001
10910 VDU 023,132,255,254,252,248,240,224,192,128
10920 VDU 023,133,000,000,000,255,255,000,000,000
10930 VDU 031,012,001,017,001,129,128,128,128,128,128,128,009,009,128,128,128,128,128,128,130
10940 VDU 031,011,002,129,128,128,128,128,128,128,128,128,009,128,128,128,128,128,128,128,130
10950 VDU 031,010,003,129,128,128,128,128,128,128,128,128,128,009,128,128,128,128,128,128,128,128,130
10960 VDU 031,009,004,017,004,129,128,128,128,128,128,128,017,001,128,128,128,128,009,128,128,128,017,004,128,128,128,128,128,128,130
10970 VDU 031,009,005,128,128,128,128,128,128,128,128,017,001,128,128,128,009,128,128,128,017,004,128,128,128,128,128,128,128,130
10980 VDU 031,009,006,128,128,017,001,132,009,009,129,017,004,128,128,017,001,128,128,128,009,128,128,128,017,004,128,128,009,017,001,128,128,128,017,004,128,128
10990 VDU 031,013,007,017,001,129,128,017,004,128,128,017,001,128,128,128,009,128,128,128,017,004,128,128,009,017,001,128,128,128,017,004,128,128
11000 VDU 031,012,008,017,001,129,128,128,017,004,128,128,017,001,128,128,128,009,128,128,128,017,004,128,128,009,017,001,128,128,128,017,004,128,128
11010 VDU 031,012,009,128,128,128,128,128,017,001,128,128,128,009,128,128,128,017,004,128,128,009,017,001,128,128,128,017,004,128,128
11020 VDU 031,012,010,128,128,128,128,128,017,001,128,128,128,009,128,128,128,017,004,128,128,009,017,001,128,128,128,017,004,128,128
11030 VDU 031,011,011,017,001,129,128,128,128,017,004,128,128,017,001,128,128,128,009,128,128,128,017,004,128,128,009,017,001,128,128,128,017,004,128,128
11040 VDU 031,010,012,017,001,129,128,128,128,128,017,004,128,128,017,001,128,128,132,009,128,128,128,017,004,128,128,017,001,128,128,128,128,017,004,128,128
11050 VDU 031,009,013,017,001,129,128,128,128,128,128,017,004,128,128,017,001,128,132,009,009,128,128,128,017,004,128,128,017,001,128,128,128,128,017,004,128,128
11060 VDU 031,009,014,128,128,017,001,128,128,128,128,017,004,128,128,017,001,132,009,009,009,131,128,128,017,004,128,128,017,001,128,128,128,128,017,004,128,128
11070 VDU 031,009,015,128,128,128,128,128,128,128,132,009,009,009,009,009,017,001,131,128,017,004,128,128,128,128,128,128,128,132
11080 VDU 031,009,016,131,128,128,128,128,128,132,009,009,009,009,009,009,009,017,001,131,017,004,128,128,128,128,128,128,132
11090 VDU 031,009,018,017,006,084,009,073,009,067,009,017,001,133,133,009,017,006,084,009,065,009,067,009,017,001,133,133,009,017,006,084,009,079,009,069
11100 PROC_REDEFINE_CHARS
11110 PROC_TITLE_MUSIC:PROC_SLEEP(200)
11120 ENDPROC
11130 :
11140 REM ::::::::::::::::::
11150 REM :: Title Music  ::
11160 REM ::::::::::::::::::
11170 DEF PROC_TITLE_MUSIC
11180 PROC_PLAY("129004117004129008129004117004129008129004121004129004117004129004117004129010")
11190 ENDPROC
11200 :
11210 REM ::::::::::::::::::::
11220 REM ::   Setup Game   ::
11230 REM ::::::::::::::::::::
11240 DEF PROC_SETUP
11250 GameName$ = "3D TIC-TAC-TOE"
11260 PROC_REDEFINE_COLORS:PROC_HIDE_CURSOR
11270 PROC_LOAD_WINNING_COMBOS
11280 PROC_COMP_POS_ROW_COMBOS
11290 ENDPROC
11300 :
11310 REM ::::::::::::::::::::::
11320 REM ::     New Game     ::
11330 REM ::::::::::::::::::::::
11340 DEF PROC_NEW_GAME
11350 LOCAL n%, y%
11360 CLS
11370 PW%(0) = 0:PW%(1) = 0:REM PLAYER WIN COUNTS
11380 PN$(0) = "CPU 1":PN$(1) = "CPU 2":REM STARTING PLAYER NAMES
11390 HP% = 2:REM INITIAL ID OF HUMAN PLAYER
11400 LV% = 1:REM INITIAL LEVEL OF DIFFICULTY
11410 y% = 0:REM INITIAL ROW COORDINATE
11420 REPEAT
11430   PRINT TAB(0, y%)CHR$(17)CHR$(WHITE)"# OF PLAYERS (0 - 2): "CHR$(17)CHR$(YELLOW)"1";:n%=FN_PROMPT_FOR_DIGIT(1):PRINT CHR$(127)STR$(n%);
11440 UNTIL n% >= 0 AND n% <= 2
11450 PN% = n%:REM NUMBER OF PLAYERS
11460 IF PN% = 1 THEN PN$(HP% - 1) = "HUMAN":PN$(HP% MOD 2) = "CPU 1"
11470 IF PN% = 2 THEN PN$(0) = "HUMAN 1":PN$(1) = "HUMAN 2"
11480 y% = y% + 1
11490 PRINT TAB(0, y%)CHR$(17)CHR$(WHITE)"AVOIDANCE    (Y / N): "CHR$(17)CHR$(YELLOW)"N";:AV$=FN_TO_UPPER(FN_PROMPT_FOR_KEY("YNyn", "N")):PRINT CHR$(127)AV$;
11500 y% = y% + 1
11510 REPEAT
11520   PRINT TAB(0, y%)CHR$(17)CHR$(WHITE)"WINS NEEDED  (1 - 9): "CHR$(17)CHR$(YELLOW)"1";:n%=FN_PROMPT_FOR_DIGIT(1):PRINT CHR$(127)STR$(n%);
11530 UNTIL n% > 0 AND n% <= 9
11540 WN% = n%:REM WINS NEEDED TO WIN MATCH
11550 IF PN% < 2 THEN y% = y% + 1:REPEAT PRINT TAB(0, y%)CHR$(17)CHR$(WHITE)"DIFFICULTY   (1 - 2): "CHR$(17)CHR$(YELLOW)"1";:n%=FN_PROMPT_FOR_DIGIT(1):PRINT CHR$(127)STR$(n%);:UNTIL n% > 0 AND n% <= 2:LV% = n%
11560 ENDPROC
11570 :
11580 REM ::::::::::::::::::::::
11590 REM ::     Main Loop    ::
11600 REM ::::::::::::::::::::::
11610 DEF PROC_MAIN_LOOP
11620 LOCAL gameover%, i%, n%, pl%, round%, roundover%, tone%, tu%, w%
11630 gameover% = FALSE:round% = 0
11640 CLS
11650 REPEAT
11660   roundover% = FALSE
11670   round% = FN_NEW_ROUND(round%)
11680   FOR i% = 0 TO 2:PROC_BOARD(i%):NEXT i%
11690   pl% = 0:tu% = 0
11700   REPEAT
11710     pl% = FN_OTHER_PLAYER(pl%):tone% = 100 + (pl% = 1) * -30
11720     PROC_DISPLAY_SCORES(round%, pl%):PROC_SLEEP(50)
11730     IF PN% = 0 OR (PN% < 2 AND pl% <> HP%) THEN PROC_NEW_PLAY(pl%, tu%):ELSE REPEAT REPEAT n% = FN_GET_POSITION(FN_TO_UPPER(GET$)) UNTIL (n% > -1):UNTIL P%(n%) = 0:P%(n%) = pl%
11740     tu% = tu% + 1:PROC_SOUND(tone%, 1)
11750     FOR i% = 0 TO 2:PROC_UPDATE_BOARD(i%):NEXT i%:PROC_SLEEP(200)
11760     n% = FN_HAS_A_ROW:IF n% > 0 THEN w% = P%(R%(n%)):i% = w% - 1:IF AV$ = "Y" THEN i% = FN_OTHER_PLAYER(w%) - 1
11770     IF n% > 0 THEN PRINT TAB(16, CH% DIV 2 - 2)CHR$(17)CHR$(WHITE)CHR$(FN_VAL_FROM_STR_LIST(P$, w%, 3))" HAS 3 IN A ROW":PROC_FLASH_ROW(n%):roundover% = TRUE:PW%(i%) = PW%(i%) + 1
11780   UNTIL roundover%
11790   PROC_DISPLAY_SCORES(round%, 0):PROC_SLEEP(300):PRINT TAB(16, CH% DIV 2 - 2)STRING$(CW% - 16, " ")
11800   gameover% = ((WN% = PW%(0)) OR (WN% = PW%(1)))
11810 UNTIL gameover%
11820 ENDPROC
11830 :
11840 REM :::::::::::::::::
11850 REM ::  Game Over  ::
11860 REM :::::::::::::::::
11870 DEF PROC_GAME_OVER
11880 LOCAL c%, msg$, w%
11890 c% = GREEN:w% = (PW%(0) > PW%(1)) + 1:msg$ = PN$(w%) + " won the match"
11900 IF (PN% = 1) THEN msg$ = "You won the match":IF (PW%(HP% - 1) < PW%(HP% MOD 2)) THEN c% = RED:msg$ = "You lost the match"
11910 REM IF (PW%(0) = PW%(1)) THEN c% = CYAN:msg$ = "The match was a draw"
11920 VDU 17,c%:VDU 31, 16, CH% DIV 2 - 2:PRINT msg$
11930 IF (PN% = 1) AND c% = GREEN THEN PROC_CHARGE:ELSE IF c% = RED THEN PROC_WAH_WAH:ELSE PROC_TADA
11940 PROC_SLEEP(200)
11950 ENDPROC
11960 :
11970 REM :::::::::::::::::::::::
11980 REM :: Play Another Game ::
11990 REM :::::::::::::::::::::::
12000 DEF FN_PLAY_AGAIN
12010 LOCAL r$
12020 VDU 17,YELLOW
12030 REPEAT r$ = FN_PROMPT(16, CH% DIV 2, "Play Again? (Y/N)", "") UNTIL INSTR("YN", r$) <> 0
12040 = r$
12050 :
12060 REM :::::::::::::::::
12070 REM :: Say Goodbye ::
12080 REM :::::::::::::::::
12090 DEF PROC_GOODBYE(game$)
12100 PROC_HIDE_CURSOR
12110 CLS:PROC_FULL_CENTER_TEXT("So long and thank you for playing...")
12120 FOR i% = 0 TO FN_CENTER(game$) - 1:PRINT TAB(0, CH% DIV 2 + 2)STRING$(i%, " ")CHR$(17)CHR$(i% MOD 7 + 1)game$:PROC_SLEEP(20):NEXT i%
12130 PROC_DEFAULT_COLORS:PROC_RESTORE_CHARS:PROC_SHOW_CURSOR
12140 ENDPROC
12150 :
12160 REM ::::::::::::::::::::::::::::::::::::
12170 REM :: Load Matching Row Combinations ::
12180 REM ::::::::::::::::::::::::::::::::::::
12190 DEF PROC_LOAD_WINNING_COMBOS
12200 LOCAL i%
12210 RESTORE
12220 FOR i% = 0 TO RC% - 1
12230   READ R%(i%)
12240 NEXT i%
12250 ENDPROC
12260 :
12270 REM :::::::::::::::::::::::::::::::::::::::
12280 REM :: Compute Position Row Combinations ::
12290 REM :::::::::::::::::::::::::::::::::::::::
12300 DEF PROC_COMP_POS_ROW_COMBOS
12310 LOCAL i%, j%, l%, n%
12320 PRINT TAB(0,0)"PLEASE WAIT";
12330 FOR i% = 0 TO PC% - 1:RU$(i%) = STRING$(158, " ")
12340   FOR j% = 0 TO RC% - 1 STEP 3
12350     l% = VAL(MID$(RU$(i%),1,2)):n% = l% * 6
12360     IF R%(j%) = i% OR R%(j% + 1) = i% OR R%(j% + 2) = i% THEN RU$(i%) = FN_XSTR$(RU$(i%), 1, FN_PAD_NUMBER(l% + 1, 2)):RU$(i%) = FN_XSTR$(RU$(i%), 3 + n%, FN_PAD_NUMBER(R%(j%), 2) + FN_PAD_NUMBER(R%(j% + 1), 2) + FN_PAD_NUMBER(R%(j% + 2), 2))
12370   NEXT j%:PRINT ".";
12380 NEXT i%
12390 ENDPROC
12400 :
12410 REM ::::::::::::::::::::::::::::::
12420 REM :: Derive Index Of Opponent ::
12430 REM ::::::::::::::::::::::::::::::
12440 DEF FN_OTHER_PLAYER(pl%)
12450 := pl% MOD 2 + 1
12460 :
12470 REM :::::::::::::::::::::::::::::::::::::::
12480 REM :: Determine If Position Is A Center ::
12490 REM :::::::::::::::::::::::::::::::::::::::
12500 DEF FN_IS_CENTER_POS(i%)
12510 LOCAL z%
12520 z% = i% DIV 9
12530 := (4 = i% - 9 * z%)
12540 :
12550 REM :::::::::::::::::::::::::::::::::::::::
12560 REM :: Determine If Position Is A Corner ::
12570 REM :::::::::::::::::::::::::::::::::::::::
12580 DEF FN_IS_CORNER_POS(i%)
12590 LOCAL n%, z%
12600 z% = i% DIV 9:n% = i% - 9 * z%
12610 := (0 = n%) + (2 = n%) + (6 = n%) + (8 = n%)
12620 :
12630 REM ::::::::::::::::::::::::::::::::::::
12640 REM :: Get Index Of Position On Board ::
12650 REM ::::::::::::::::::::::::::::::::::::
12660 DEF FN_GET_POSITION(p$)
12670 LOCAL c$, done%, i%, l%, rv%
12680 done% = FALSE:i% = 0:l% = LEN(G$):rv% = -1
12690 REPEAT
12700   c$ = MID$(G$, i% + 1, 1):IF c$ = p$ THEN rv% = i%:done% = TRUE
12710   i% = i% + 1
12720 UNTIL done% OR (i% >= l%)
12730 := rv%
12740 :
12750 REM ::::::::::::::::::::::::::::::::::::::::::::
12760 REM :: Determine If A Matching Row Is Present ::
12770 REM ::::::::::::::::::::::::::::::::::::::::::::
12780 DEF FN_HAS_A_ROW
12790 LOCAL done%, i%, j%, m%, rv%
12800 rv% = -1:i% = 0:done% = FALSE
12810 REPEAT
12820   m% = TRUE
12830   FOR j% = 0 TO 1
12840     m% = (m% AND (P%(R%(i% + j%)) = P%(R%(i% + j% + 1))) AND (P%(R%(i%)) > 0))
12850   NEXT j%
12860   IF m% THEN rv% = i%:done% = TRUE
12870   IF i% + 3 >= RC% THEN done% = TRUE:ELSE i% = i% + 3
12880 UNTIL done%
12890 := rv%
12900 :
12910 REM ::::::::::::::::::::::::::
12920 REM :: Flash A Matching Row ::
12930 REM ::::::::::::::::::::::::::
12940 DEF PROC_FLASH_ROW(index%)
12950 LOCAL c%, i%, l%, n%, p%, px%, py%, r%, x%, y%, z%
12960 FOR l% = 0 TO 3
12970   FOR i% = 0 TO 2
12980     r% = R%(index% + i%)
12990     z% = r% DIV 9
13000     y% = (r% MOD 9) DIV 3
13010     x% = r% - (9 * z%) - (3 * y%)
13020     n% = y% * 3 + x%
13030     p% = FN_PIECE(z%, n%)
13040     px% = (x% + 1) * 3:py% = z% * 8
13050     px% = px% + (2 * y%)
13060     py% = py% + 2 + (2 * y%)
13070     VDU 017,128+GREEN,017,BLACK,31,px%,py%,p%
13080   NEXT i%
13090   PROC_SOUND(107, 2):PROC_SLEEP(8)
13100   FOR i% = 0 TO 2
13110     r% = R%(index% + i%)
13120     z% = r% DIV 9
13130     y% = (r% MOD 9) DIV 3
13140     x% = r% - (9 * z%) - (3 * y%)
13150     n% = y% * 3 + x%
13160     p% = FN_PIECE(z%, n%)
13170     px% = (x% + 1) * 3:py% = z% * 8
13180     px% = px% + (2 * y%)
13190     py% = py% + 2 + (2 * y%)
13200     VDU 017,128+BLACK,017,GREEN,31,px%,py%,p%
13210   NEXT i%
13220   PROC_SOUND(97, 2):PROC_SLEEP(8)
13230 NEXT l%
13240 VDU 017,128+BLACK,017,WHITE
13250 ENDPROC
13260 :
13270 REM :::::::::::::::::::::::::
13280 REM :: Prepare A New Round ::
13290 REM :::::::::::::::::::::::::
13300 DEF FN_NEW_ROUND(prevround)
13310 LOCAL i%
13320 R0% = RND(-(TIME MOD MAXINT%)):REM RE-SEED THE RNG
13330 IF PN% < 2 THEN EP$ = STRING$(PC%, "99"):REM SET OF EMPTY POSITIONS
13340 FOR i% = 0 TO PC% - 1:P%(i%) = 0:NEXT i%
13350 := prevround + 1
13360 :
13370 REM :::::::::::::::::::::::::::
13380 REM :: Display Player Scores ::
13390 REM :::::::::::::::::::::::::::
13400 DEF PROC_DISPLAY_SCORES(round%, pl%)
13410 LOCAL c%, i%, offset%, p$
13420 offset% = 16:p$ = ""
13430 PRINT TAB(offset%, 0)CHR$(17)CHR$(WHITE)"ROUND: "STR$(round%)
13440 FOR i% = 0 TO 1
13450   c% = WHITE
13460   IF pl% = 0 AND (PW%(i%) = WN%) THEN c% = GREEN
13470   IF pl% = i% + 1 THEN c% = YELLOW:p$ = "*":ELSE p$ = " "
13480   PRINT TAB(offset% - LEN(p$), i% + 1)CHR$(17)CHR$(c%)p$PN$(i%)CHR$(17)CHR$(WHITE)": "STR$(PW%(i%))" OF "STR$(WN%)
13490 NEXT i%
13500 ENDPROC
13510 :
13520 REM :::::::::::::::::::::::::::::
13530 REM :: Derive Piece To Display ::
13540 REM :::::::::::::::::::::::::::::
13550 DEF FN_PIECE(z%, i%)
13560 LOCAL c%, j%, p%, rv%
13570 j% = z% * 9 + i%:p% = P%(j%):c% = FN_VAL_FROM_STR_LIST(CO$, z%, 2)
13580 IF p% <> 0 THEN c% = 7:rv% = FN_VAL_FROM_STR_LIST(P$, p%, 3):ELSE rv% = ASC(MID$(G$, j% + 1, 1))
13590 VDU 17, c%
13600 := rv%
13610 :
13620 REM ::::::::::::::::::::::::::
13630 REM :: Draw A Board (0 - 2) ::
13640 REM ::::::::::::::::::::::::::
13650 DEF PROC_BOARD(z%)
13660 LOCAL x%, y%, c%
13670 x% = 0:y% = z% * 8
13680 c% = FN_VAL_FROM_STR_LIST(CO$, z%, 2)
13690 VDU 31,x%,y%,017,c%,132,132,132,132,132,132,132,132,132
13700 VDU 31,x%,y%+1,129,009,009,134,009,009,134,009,009,134
13710 VDU 31,x%,y%+2,130,129,132,FN_PIECE(z%, 0),017,c%,134,132,FN_PIECE(z%, 1),017,c%,134,132,FN_PIECE(z%, 2),017,c%,134
13720 VDU 31,x%+1,y%+3,130,129,133,133,134,133,133,134,133,133,134
13730 VDU 31,x%+2,y%+4,130,129,132,FN_PIECE(z%, 3),017,c%,134,132,FN_PIECE(z%, 4),017,c%,134,132,FN_PIECE(z%, 5),017,c%,134
13740 VDU 31,x%+3,y%+5,130,129,133,133,134,133,133,134,133,133,134
13750 VDU 31,x%+4,y%+6,130,129,009,FN_PIECE(z%, 6),017,c%,134,009,FN_PIECE(z%, 7),017,c%,134,009,FN_PIECE(z%, 8),017,c%,134
13760 VDU 31,x%+5,y%+7,130,128,128,128,128,128,128,128,128,128
13770 ENDPROC
13780 :
13790 REM ::::::::::::::::::::::::::::
13800 REM :: Update Board Positions ::
13810 REM ::::::::::::::::::::::::::::
13820 DEF PROC_UPDATE_BOARD(z%)
13830 LOCAL x%, y%, c%
13840 x% = 0:y% = z% * 8
13850 c% = FN_VAL_FROM_STR_LIST(CO$, z%, 2)
13860 VDU 31,x%+3,y%+2,FN_PIECE(z%, 0),017,c%,009,009,FN_PIECE(z%, 1),017,c%,009,009,FN_PIECE(z%, 2)
13870 VDU 31,x%+5,y%+4,FN_PIECE(z%, 3),017,c%,009,009,FN_PIECE(z%, 4),017,c%,009,009,FN_PIECE(z%, 5)
13880 VDU 31,x%+7,y%+6,FN_PIECE(z%, 6),017,c%,009,009,FN_PIECE(z%, 7),017,c%,009,009,FN_PIECE(z%, 8)
13890 ENDPROC
13900 :
13910 REM :::::::::::::::::::::::::::::::::::::
13920 REM :: Randomly Pick An Empty Position ::
13930 REM :::::::::::::::::::::::::::::::::::::
13940 DEF FN_SELECT_RANDOM_EMPTY_PLACE
13950 LOCAL c%, i%, n%, r%
13960 c% = 0:r% = -1
13970 FOR i% = 0 TO PC% - 1
13980   n% = R%(P%(i%)):IF n% = 0 THEN c% = c% + 1:n% = 1 + 2 * (c% - 1):EP$ = FN_XSTR$(EP$, n%, FN_PAD_NUMBER(i%, 2))
13990 NEXT i%
14000 IF c% > 0 THEN i% = FN_RND_INT(1, c%):n% = 1 + 2 * (i% - 1):i% = VAL(MID$(EP$, n%, 2)):IF i% <> 99 THEN r% = i%
14010 := r%
14020 :
14030 REM :::::::::::::::::::::::::::::::::::::::::::::::::
14040 REM :: Look To Block A Winning Position On A Board ::
14050 REM :::::::::::::::::::::::::::::::::::::::::::::::::
14060 DEF FN_LOCATE_PLACE_TO_BLOCK(PL%)
14070 LOCAL c%, done%, i%, j%, n%, t%, v%
14080 n% = -1:i% = 0:done% = FALSE
14090 REPEAT
14100   c% = 0:n% = -1:j% = 0
14110   REPEAT
14120     t% = R%(i% + j%):v% = P%(t%)
14130     IF (v% = 0) AND (n% < 0) THEN n% = t%
14140     IF (v% <> 0) AND (v% <> pl%) THEN c% = c% + 1
14150     j% = j% + 1
14160   UNTIL j% > 2
14170   IF i% + 3 >= RC% THEN done% = TRUE:ELSE i% = i% + 3
14180 UNTIL (c% = 2 AND n% >= 0) OR done%
14190 := -1 + (c% = 2 AND n% >= 0) * -(n% + 1)
14200 :
14210 REM :::::::::::::::::::::::::::::::::::::::::::::
14220 REM :: Determine If Position In A Matching Row ::
14230 REM :::::::::::::::::::::::::::::::::::::::::::::
14240 DEF FN_IS_IN_MATCHING_ROW(n%)
14250 LOCAL done%,i%,k%,l%,r%,u%,v%,w%
14260 l% = FN_VAL_FROM_STR_LIST(RU$(n%), 0, 2)
14270 done% = FALSE:i% = 1:r% = FALSE
14280 REPEAT
14290   k% = 1 + (i% - 1) * 3
14300   u% = FN_VAL_FROM_STR_LIST(RU$(n%), k%, 2)
14310   v% = FN_VAL_FROM_STR_LIST(RU$(n%), k% + 1, 2)
14320   w% = FN_VAL_FROM_STR_LIST(RU$(n%), k% + 2, 2)
14330   r% = (P%(u%) = P%(v%)) AND (P%(v%) = P%(w%))
14340   IF ((i% + 1) > l%) OR r% THEN done% = TRUE:ELSE i% = i% + 1
14350 UNTIL done%
14360 := r%
14370 :
14380 REM :::::::::::::::::::::::::::::::::::::::::::::
14390 REM :: Look For Next Empty Position On A Board ::
14400 REM :::::::::::::::::::::::::::::::::::::::::::::
14410 DEF FN_LOCATE_NEXT_EMPTY_PLACE(i%)
14420 LOCAL done%, j%, r%
14430 done% = FALSE:j% = i%:r% = -1
14440 REPEAT
14450   IF P%(j%) = 0 THEN r% = j%:done% = TRUE
14460   IF NOT done% AND (j% + 1 >= PC%) THEN done% = TRUE:ELSE j% = j% + 1
14470 UNTIL done%
14480 := r%
14490 :
14500 REM ::::::::::::::::::::::::::::::::::::::::::::::::
14510 REM :: Look For A Non-winning Position On A Board ::
14520 REM ::::::::::::::::::::::::::::::::::::::::::::::::
14530 DEF FN_AVOID_PLACE_TO_WIN(pl%)
14540 LOCAL c%, done%, i%, j%, kg%, lose%, r%, v%
14550 c% = 0:i% = 0:done% = FALSE:r% = -1
14560 REPEAT
14570   IF LV% = 1 THEN j% = FN_SELECT_RANDOM_EMPTY_PLACE:ELSE j% = FN_LOCATE_NEXT_EMPTY_PLACE(i%)
14580   P%(j%) = pl%:kg% = FN_IS_IN_MATCHING_ROW(j%):P%(j%) = 0
14590   IF NOT kg% THEN r% = j%:done% = TRUE
14600   IF kg% AND LV% > 1 THEN lose% = j%:i% = j% + 1
14610   IF kg% AND LV% = 1 THEN lose% = j%:c% = c% + 1
14620   IF i% >= PC% OR c% > 30 THEN r% = lose%:done% = TRUE
14630 UNTIL done%
14640 := r%
14650 :
14660 REM ::::::::::::::::::::::::::::::::::::::::::::
14670 REM :: Look For A Winning Position On A Board ::
14680 REM ::::::::::::::::::::::::::::::::::::::::::::
14690 DEF FN_LOCATE_PLACE_TO_WIN(pl%)
14700 LOCAL c%, done%, i%, j%, kg%, n%, t%, v%
14710 i% = 0:done% = FALSE
14720 REPEAT
14730   c% = 0:n% = -1:j% = 0:kg% = TRUE
14740   REPEAT
14750     t% = R%(i% + j%):v% = P%(t%)
14760     IF (v% = 0) AND (n% < 0) THEN n% = t%
14770     IF (v% = pl%) THEN c% = c% + 1:ELSE IF (v% <> 0) THEN kg% = FALSE
14780     j% = j% + 1
14790   UNTIL (j% > 2) OR (NOT kg%)
14800   IF i% + 3 >= RC% THEN done% = TRUE:ELSE i% = i% + 3
14810 UNTIL (c% = 2 AND n% >= 0) OR done%
14820 := -1 + (c% = 2 AND n% >= 0) * -(n% + 1)
14830 :
14840 REM ::::::::::::::::::::::::::::::::::::::::::
14850 REM :: Look For An Open Position On A Board ::
14860 REM ::::::::::::::::::::::::::::::::::::::::::
14870 DEF FN_LOCATE_PLACE_TO_PLAY(pl%)
14880 LOCAL c%, done%, i%, j%, n%, t%, v%
14890 i% = 0:done% = FALSE
14900 REPEAT
14910   c% = 0:n% = -1:j% = 0
14920   REPEAT
14930     t% = R%(i% + j%):v% = P%(t%)
14940     IF (v% = 0) AND (n% >= 0) AND (FN_IS_CORNER_POS(t%)) THEN n% = t%
14950     IF (v% = 0) AND (n% < 0) THEN n% = t%
14960     IF (v% = pl%) THEN c% = c% + 1
14970     IF (v% <> pl%) AND (v% <> 0) THEN n% = -1:j% = 2
14980     j% = j% + 1
14990   UNTIL j% > 2
15000   IF i% + 3 >= RC% THEN done% = TRUE:ELSE i% = i% + 3
15010 UNTIL (c% = 1 AND n% >= 0) OR done%
15020 := -1 + (c% = 1 AND n% >= 0) * -(n% + 1)
15030 :
15040 REM ::::::::::::::::::::::::::::::::::::::
15050 REM :: Select A New Play For CPU Player ::
15060 REM ::::::::::::::::::::::::::::::::::::::
15070 DEF PROC_NEW_PLAY(pl%, tu%)
15080 LOCAL done%, n%
15090 done% = FALSE:n% = -1
15100 IF AV$ = "N" AND LV% > 1 AND tu% = 0 THEN n% = 13
15110 IF AV$ = "N" AND n% < 0 THEN n% = FN_LOCATE_PLACE_TO_WIN(pl%)
15120 IF AV$ = "Y" AND n% < 0 THEN n% = FN_AVOID_PLACE_TO_WIN(pl%)
15130 IF AV$ = "N" AND n% < 0 THEN n% = FN_LOCATE_PLACE_TO_BLOCK(pl%)
15140 IF LV% > 1 AND n% < 0 THEN n% = FN_LOCATE_PLACE_TO_PLAY(pl%)
15150 IF n% < 0 THEN n% = FN_SELECT_RANDOM_EMPTY_PLACE
15160 IF n% >= 0 THEN P%(n%) = pl%
15170 ENDPROC
15180 :
15190 REM ::::::::::::::::::::::
15200 REM :: Retrieve a byte  ::
15210 REM :: register value   ::
15220 REM :: from VDP         ::
15230 REM ::::::::::::::::::::::
15240 DEF FN_getByteVDP(var%):A% = &A0:L% = var%:= USR(&FFF4)
15250 :
15260 REM ::::::::::::::::::::::::::::
15270 REM :: Disable display of the ::
15280 REM :: cursor on the screen   ::
15290 REM ::::::::::::::::::::::::::::
15300 DEF PROC_HIDE_CURSOR:VDU 23,1,0;0;0;0;:ENDPROC
15310 :
15320 REM ::::::::::::::::::::::::::::
15330 REM :: Enable display of the  ::
15340 REM :: cursor on the screen   ::
15350 REM ::::::::::::::::::::::::::::
15360 DEF PROC_SHOW_CURSOR:VDU 23,1,1;0;0;0;:ENDPROC
15370 :
15380 REM :::::::::::::::::::::::::::::::::::::::
15390 REM :: Pause execution of the program    ::
15400 REM :: for a number of ticks (1/100) sec ::
15410 REM :::::::::::::::::::::::::::::::::::::::
15420 DEF PROC_SLEEP(hundredth_seconds%):LOCAL t:hundredth_seconds% = hundredth_seconds% + (hundredth_seconds% < 0) * -hundredth_seconds%:t = TIME:REPEAT UNTIL ((TIME - t) > hundredth_seconds%):ENDPROC
15430 :
15440 REM :::::::::::::::::::::::::::
15450 REM :: Empty Keyboard Buffer ::
15460 REM :::::::::::::::::::::::::::
15470 DEF PROC_EMPTY_KEYBOARD_BUFFER
15480 REPEAT UNTIL INKEY(0) = -1
15490 ENDPROC
15500 :
15510 REM :::::::::::::::::::::::::
15520 REM :: Prompt For Response ::
15530 REM :::::::::::::::::::::::::
15540 DEF FN_PROMPT(x%, y%, text$, default$)
15550 LOCAL r$
15560 PROC_EMPTY_KEYBOARD_BUFFER
15570 PRINT TAB(x%, y%)text$;" ";default$:PRINT TAB(x% + LEN(text$) + 1, y%);
15580 r$ = GET$:r$ = FN_TO_UPPER(r$):IF r$ = CHR$(13) THEN r$ = default$
15590 := r$
15600 :
15610 REM :::::::::::::::::::::::::::::::
15620 REM :: Prompt For A Single Key   ::
15630 REM :::::::::::::::::::::::::::::::
15640 DEF FN_PROMPT_FOR_KEY(valuesList$, default$)
15650 LOCAL c$, r$
15660 PROC_EMPTY_KEYBOARD_BUFFER
15670 REPEAT:c$ = GET$:UNTIL INSTR(valuesList$, c$) > 0 OR c$ = CHR$(13)
15680 r$ = c$:IF r$ = CHR$(13) THEN r$ = default$
15690 := r$
15700 :
15710 REM :::::::::::::::::::::::::::::::
15720 REM :: Prompt For A Single Digit ::
15730 REM :::::::::::::::::::::::::::::::
15740 DEF FN_PROMPT_FOR_DIGIT(defaultValue%)
15750 LOCAL c%, r$
15760 PROC_EMPTY_KEYBOARD_BUFFER
15770 REPEAT:c% = GET:UNTIL c% = 13 OR (c% >= 48 AND c% <= 57)
15780 IF c% = 13 THEN r$ = STR$(defaultValue%):ELSE r$ = CHR$(c%)
15790 := VAL(r$)
15800 :
15810 REM ::::::::::::::::::::::
15820 REM ::   To Uppercase   ::
15830 REM ::::::::::::::::::::::
15840 DEF FN_TO_UPPER(ch$):LOCAL ch%:ch% = ASC(ch$):ch$ = CHR$(ch% + 32 * (ch% >= 97 AND ch% <= 122)):=ch$
15850 :
15860 REM :::::::::::::::::::::
15870 REM ::   Center text   ::
15880 REM :::::::::::::::::::::
15890 DEF FN_CENTER(text$)
15900 LOCAL x%
15910 x% = CW% - LEN(text$)
15920 := x% DIV 2 + x% MOD 2
15930 :
15940 REM :::::::::::::::::::::::::::::::::
15950 REM :: Center text horizontally    ::
15960 REM :::::::::::::::::::::::::::::::::
15970 DEF PROC_CENTER_TEXT(text$, m%):LOCAL y%:y% = VPOS:PRINT TAB(FN_CENTER(text$) + (m% DIV 2), y%)text$;:ENDPROC
15980 :
15990 REM :::::::::::::::::::::::::::::::::
16000 REM :: Center text both vertically ::
16010 REM :: and horizontally            ::
16020 REM :::::::::::::::::::::::::::::::::
16030 DEF PROC_FULL_CENTER_TEXT(text$):PRINT TAB(FN_CENTER(text$), CH% DIV 2)text$;:ENDPROC
16040 :
16050 REM :::::::::::::::::::::::::::::::::
16060 REM :: Random Integer Within Range ::
16070 REM :::::::::::::::::::::::::::::::::
16080 DEF FN_RND_INT(lo%, hi%):= INT(RND(1) * (ABS(hi% - lo%) + 1)) + lo%
16090 :
16100 REM ::::::::::::::::::::::::::::::::
16110 REM :: Prepend Zeroes To A Number ::
16120 REM ::::::::::::::::::::::::::::::::
16130 DEF FN_PAD_NUMBER(val%, len%)
16140 LOCAL s$
16150 s$ = STR$(val%)
16160 := STRING$(len% - LEN(s$), "0") + s$
16170 :
16180 REM ::::::::::::::::::::::::::::::::::::::
16190 REM :: Extract Number From A Stringlist ::
16200 REM ::::::::::::::::::::::::::::::::::::::
16210 DEF FN_VAL_FROM_STR_LIST(text$, index%, numdigits%):= VAL(MID$(text$, index% * numdigits% + 1, numdigits%))
16220 :
16230 REM ::::::::::::::::::::::::::::::::
16240 REM :: Replace A Char In A String ::
16250 REM ::::::::::::::::::::::::::::::::
16260 DEF FN_XSTR$(text$, pos%, val$)
16270 LOCAL r%,m%,t%,u%,v%
16280 IF pos% < 0 THEN pos% = 1
16290 t% = LEN(text$):v% = LEN(val$):REM IF t% <= pos% THEN r$ = text$ + STRING$(pos% + v% - t%, " ")
16300 := MID$(MID$(text$, 1, pos% - 1) + MID$(val$, 1, v%) + MID$(text$, pos% + v%, t% - pos% - 1), 1, t%)
16310 :
16320 REM :::::::::::::::::::::::
16330 REM :: Play Simple Sound ::
16340 REM :::::::::::::::::::::::
16350 DEF PROC_SOUND(pitch%, duration%)
16360 SOUND 1, -12, pitch%, duration%
16370 ENDPROC
16380 :
16390 REM :::::::::::::::::::::::::
16400 REM :: Play Musical Phrase ::
16410 REM :::::::::::::::::::::::::
16420 DEF PROC_PLAY(notes$):REM NOTES ARE THREE-DIGIT PAIRS (PITCH,DURATION)
16430 LOCAL d%, j%, l%, p%
16440 l% = LEN(notes$) DIV 3
16450 FOR j% = 1 TO l% STEP 2
16460   p% = VAL(MID$(notes$, 3 * (j% - 1) + 1, 3)):d% = VAL(MID$(notes$, 3 * (j% - 1) + 4, 3))
16470   IF p% >= 0 THEN SOUND 1, -10, p%, d%:ELSE SOUND 1, 0, 0, d%
16480   SOUND 1, 0, p%, 1:REM Stacatto the currently playing sound
16490 NEXT j%
16500 ENDPROC
16510 :
16520 REM :::::::::::::::::::
16530 REM ::  CHARGE!!!!!  ::
16540 REM :::::::::::::::::::
16550 DEF PROC_CHARGE
16560 PROC_PLAY("129001149001165001177004165002177008")
16570 ENDPROC
16580 :
16590 REM ::::::::::::::
16600 REM ::  Tada!!  ::
16610 REM ::::::::::::::
16620 DEF PROC_TADA
16630 PROC_PLAY("197002225008")
16640 ENDPROC
16650 :
16660 REM :::::::::::::::
16670 REM ::  WAH-WAH  ::
16680 REM :::::::::::::::
16690 DEF PROC_WAH_WAH
16700 PROC_PLAY("081002081002081002069020073002073002073002061024")
16710 ENDPROC
16720 :
16730 REM ::::::::::::::::::::::::::
16740 REM :: Define Custom Colors ::
16750 REM ::::::::::::::::::::::::::
16760 DEF PROC_REDEFINE_COLORS
16770 LOCAL c%
16780 c% = FN_getByteVDP(&15):C_ORANGE = 8 + (SY$ = "A" AND c% = &40) *-50
16790 IF SY$="A" AND c% < &40 THEN VDU 19,C_ORANGE,&FF,&FF,&80,&00:ELSE COLOUR C_ORANGE,&FF,&80,&00
16800 ENDPROC
16810 :
16820 REM ::::::::::::::::::::::::::::
16830 REM :: Restore Default Colors ::
16840 REM ::::::::::::::::::::::::::::
16850 DEF PROC_DEFAULT_COLORS
16860 COLOUR 128+BLACK:REM BACKGROUND
16870 COLOUR WHITE:REM FOREGROUND
16880 ENDPROC
16890 :
16900 REM ::::::::::::::::::::::::::::::
16910 REM :: Define Custom Characters ::
16920 REM ::::::::::::::::::::::::::::::
16930 DEF PROC_REDEFINE_CHARS
16940 VDU 23,043,024,024,024,255,255,024,024,024
16950 VDU 23,045,000,000,000,255,255,000,000,000
16960 VDU 23,124,024,024,024,024,024,024,024,024
16970 VDU 23,128,255,255,255,255,255,255,255,255
16980 VDU 23,129,000,128,192,224,240,248,252,254
16990 VDU 23,130,255,127,063,031,015,007,003,001
17000 VDU 23,131,255,254,252,248,240,224,192,128
17010 VDU 23,132,000,000,000,000,000,000,000,255
17020 VDU 23,133,255,000,000,000,000,000,000,000
17030 VDU 23,134,192,224,112,056,028,014,007,003
17040 VDU 23,135,195,231,126,060,060,126,231,195
17050 VDU 23,136,060,126,231,195,195,231,126,060
17060 ENDPROC
17070 :
17080 REM ::::::::::::::::::::::::::::::::
17090 REM :: Restore Default Characters ::
17100 REM ::::::::::::::::::::::::::::::::
17110 DEF PROC_RESTORE_CHARS
17120 VDU 23,043,&00,&18,&18,&7E,&18,&18,&00,&00
17130 VDU 23,045,&00,&00,&00,&7E,&00,&00,&00,&00
17140 VDU 23,124,&18,&18,&18,&00,&18,&18,&18,&00
17150 VDU 23,128,&3C,&62,&F8,&60,&F8,&62,&3C,&00
17160 VDU 23,129,&00,&7E,&7E,&7E,&7E,&7E,&7E,&00
17170 VDU 23,130,&00,&00,&00,&00,&00,&18,&18,&30
17180 VDU 23,131,&00,&0C,&18,&18,&3C,&18,&18,&70
17190 VDU 23,132,&00,&00,&00,&00,&00,&6C,&6C,&D8
17200 VDU 23,133,&00,&00,&00,&00,&00,&00,&54,&00
17210 VDU 23,134,&18,&18,&7E,&18,&18,&18,&18,&00
17220 VDU 23,135,&18,&18,&7E,&18,&18,&7E,&18,&18
17230 VDU 23,136,&10,&38,&6C,&00,&00,&00,&00,&00
17240 ENDPROC
17250 :
17260 REM ::::::::::::::::::::::::::::::
17270 REM ::  Error Handling Routine  ::
17280 REM ::::::::::::::::::::::::::::::
17290 DEF PROC_HANDLE_ERROR
17300 IF ERR <> 17 THEN PROC_DEFAULT_COLORS:PROC_RESTORE_CHARS:PROC_SHOW_CURSOR:PRINT:REPORT:PRINT" @line #";ERL:STOP
17310 ENDPROC
17320 :
17330 REM ::::::::::::::::::::::::
17340 REM :: Miscellaneous Data ::
17350 REM ::::::::::::::::::::::::
17360 DATA 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26
17370 DATA 0,3,6,1,4,7,2,5,8,9,12,15,10,13,16,11,14,17,18,21,24,19,22,25,20,23,26
17380 DATA 0,4,8,2,4,6,9,13,17,11,13,15,18,22,26,20,22,24
17390 DATA 0,9,18,1,10,19,2,11,20,3,12,21,4,13,22,5,14,23,6,15,24,7,16,25,8,17,26
17400 DATA 0,10,20,2,10,18,3,13,23,5,13,21,6,16,26,8,16,24
17410 DATA 0,12,24,6,12,18,1,13,25,7,13,19,2,14,26,8,14,20
17420 DATA 0,13,26,2,13,24,6,13,20,8,13,18
