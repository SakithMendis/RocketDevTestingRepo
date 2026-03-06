      SUBROUTINE SQ.ADDRESSES.ENTRY(VIEW.ONLY,CLOSED.ENQ,GO.TO.SITE.ADDRESS,SPARE3)
TPVERDATA=''
TPVERDATA := 'TPVERSION=000000003;'
TPVERDATA := 'TPVERSTAMP=1549880593;'
TPVERDATA := 'TPVERDESC=;'
TPVERDATA := 'TPRELEASE=000008613;'
TPVERDATA := 'TPCOMMENT=;'
TPVERDATA := 'TPRELEASEID=15533.05;'
$OPTIONS REALITY
$OPTIONS HEADER.DATE
      PROGRAM.NAME="SQ.ADDRESSES.ENTRY"
      INCLUDE DG-INCLUDES TCSTANDARD
*
*     Sales Quotes - Quote addresses entry/maintenance
*
*     VIEW.ONLY - Cannot amend details
*
* Author       :  Matt Greaves
* Date Written :  10th November 1993
*
* Job #      Date    Inits  Comments
* =====    ========  =====  ========
* 15108r01 12/07/13 tdeer/
*                   delse Increase QTE.HDR.REC dim size
* 15533r05 26/01/17 dmcdo PRB0005414 - Quotes xrefs issues
***********
* EQUATES *
***********
*
      EQU EOL TO CLEOL
      EQU TRUE TO 1
      EQU FALSE TO 0
      EQU NULL TO ""
*
***********************
* SPECIFIC FILE OPENS *
***********************
      ERR = ''
      ACCOUNT.NAME = OCONV(@WHO,'MCU')
      INCLUDE INCLUDES OPEN.FILE.SY.PARAMS
      INCLUDE INCLUDES OPEN.FILE.SCREENS
      INCLUDE INCLUDES OPEN.FILE.QUOTE.HEADER
      INCLUDE INCLUDES OPEN.FILE.QUOTE.STATUS
      IF ERR NE '' THEN
         DATA PROGRAM.NAME:" CANNOT OPEN FILES : ":ERR
         GOSUB ABORT.TRANS
         CHAIN "SY.FATAL.ERROR"
      END
************
* INCLUDES *
************
      INCLUDE INCLUDES QUOTE.COMMON
      INCLUDE INCLUDES GETPRICE.COMMON
      INCLUDE INCLUDES EQU.QUOTE.HEADER
      INCLUDE INCLUDES EQU.QUOTE.LINE
      INCLUDE INCLUDES EQU.QUOTE.CUST.HISTORY
      INCLUDE INCLUDES EQU.POS.CUSTOMER.REC.EPOS
      INCLUDE INCLUDES BUILD.TOP.RIGHT
********************
* SET UP VARIABLES *
********************
      EXT.TODAY = OCONV(DATE(),'D2/')
      SKIP.CALL = FALSE
      READ BS.ADJUST.ADDRESS.REC FROM SY.PARAMS.FV, "BS.ADJUST.ADDRESS" ELSE
         DATA "BS.ADJUST.ADDRESS CANNOT BE FOUND"
         CHAIN "SY.FATAL.ERROR"
      END
      SEL.POS = 1
      DIM BEFORE.REC(300)
      MAT BEFORE.REC = MAT QTE.HDR.REC
      PCODE.VALIDATION = "2A1N' '1N2A":VM:"2A1N' '2N2A":VM:"2A2N' '1N2A":VM:"2A2N' '2N2A":VM:"1A2N' '1N2A":VM:"1A2N' '2N2A":VM:"1A1N' '1N2A":VM:"1A1N' '2N2A":VM:"2A1N1A' '1N2A":VM:"2A1N1A' '2N2A":VM:"1A1N1A' '1N2A":VM:"1A1N1A' '2N2A"
**************************************************************************
***********
* MAIN.PROG
***********
******************************
* Set up line selection data *
******************************
      CHOICE = ''
      SEL.DELIM = "�"
      BEGIN CASE
         CASE VIEW.ONLY = "Y"
            SEL.WORDS = "File"
            SEL.ABBRV = "F"
            SEL.RTNS = "EXIT"
            SEL.HELP = "Exit"
         CASE QH.DIRECT.CALL.OFF # '' OR QH.WEB.ORDER # ''
            SEL.WORDS = "File":VM:"Reply address":VM:"Site address":VM:"Delivery instructions"
            SEL.ABBRV = "F":VM:"R":VM:"S":VM:"D"
            SEL.RTNS = "EXIT":VM:"REPLY":VM:"SITE":VM:"DELIV"
            SEL.HELP = "Exit"
            SEL.HELP<1,2> = "Enter/Amend correspondence address"
            SEL.HELP<1,3> = "Enter/Amend site address"
            SEL.HELP<1,4> = "Enter/Amend delivery instructions"
         CASE 1
            SEL.WORDS = "File":VM:"Reply address":VM:"Site address"
            SEL.ABBRV = "F":VM:"R":VM:"S"
            SEL.RTNS = "EXIT":VM:"REPLY":VM:"SITE"
            SEL.HELP = "Exit"
            SEL.HELP<1,2> = "Enter/Amend correspondence address"
            SEL.HELP<1,3> = "Enter/Amend site address"
      END CASE
**************************************************************************
***********
*MAIN.PROG:
***********
      GOSUB INITIALISATION
      CRT CURSOR.OFF:
      GOSUB READ.IN.SCREEN
      IF GO.TO.SITE.ADDRESS = 'Y' THEN
         GOSUB AMEND.SITE.ADDR
         CRT.VAR = @(1,13):QH.DELIV.ADDR.1'L#30' ; CRT CRT.VAR
         CRT.VAR = @(1,14):QH.DELIV.ADDR.2'L#30' ; CRT CRT.VAR
         CRT.VAR = @(1,15):QH.DELIV.ADDR.3'L#30' ; CRT CRT.VAR
         CRT.VAR = @(1,16):QH.DELIV.ADDR.4'L#30' ; CRT CRT.VAR
         CRT.VAR = @(1,17):QH.DELIV.ADDR.PCODE'L#8' ; CRT CRT.VAR
         CRT.VAR = @(41,13):QH.DEL.CONTACT.NAME'L#30' ; CRT CRT.VAR
         SEL.POS = 3
      END
      LOOP UNTIL EXIT.FLAG DO
         IF NOT(EXIT.FLAG) THEN
            GOSUB DO.LINE.SELECTION.AND.ACTION
         END
      REPEAT
      IF VIEW.ONLY # "Y" THEN
         GOSUB FILE.IT
      END
      CRT CURSOR.ON:
      RETURN
***************************************************************************
***************
INITIALISATION:
***************
      CRT CLS
      EXIT.FLAG = FALSE
      ACTIVATE = "Y"
      RETURN
***************************************************************************
***************
READ.IN.SCREEN:
***************
      SCREEN.NAME = "$SQ.ADDRESSES"
      READ SCREEN1 FROM SCREENS.FV,SCREEN.NAME ELSE
         DATA PROGRAM.NAME : " CANNOT READ SCREEN ITEM ":SCREEN.NAME
         GOSUB ABORT.TRANS
         CHAIN "SY.FATAL.ERROR"
      END
      PART.SCREEN.NAME = "%SQ.ADDRESSES"
      READ SCREEN.PARTS FROM SCREENS.FV,PART.SCREEN.NAME ELSE
         DATA PROGRAM.NAME : " CANNOT READ SCREEN ITEM ":SCREEN.NAME
         GOSUB ABORT.TRANS
         CHAIN "SY.FATAL.ERROR"
      END
      GOSUB RE.DO.SCREEN
      RETURN
***************************************************************************
*************
RE.DO.SCREEN:
*************
      CRT.VAR = SCREEN1:@(1,0):EXT.TODAY:TOP.RIGHT ; CRT CRT.VAR:
* if DCO then display Delivery instruction prompt
      IF QH.DIRECT.CALL.OFF # '' OR QH.WEB.ORDER # '' THEN
         CRT.VAR = @(22,18):NORMAL ; CRT CRT.VAR
         CRT.VAR = @(0,18):TCULDIM:"Delivery instructions":NORMAL ; CRT CRT.VAR
      END
      IF CLOSED.ENQ THEN
         CRT.VAR = @(79,21):NORMAL ; CRT CRT.VAR
         CRT.VAR = @(0,21):TCREV:"              < < <  C L O S E D   Q U O T E   E N Q U I R Y  > > > " ; CRT CRT.VAR
      END
      GOSUB DISPLAY.ADDRESS.DETAILS
      RETURN
***************************************************************************
********
FILE.IT:
********
      HEADER.KEY = QUOTE.NUMBER
      MATWRITEU QTE.HDR.REC ON QUOTE.HEADER.FV,HEADER.KEY
      SHOULD.WE.UPDATE.XREFS = "N"
      BEGIN CASE
         CASE QH.DELIV.ADDR.1 NE BEFORE.REC(9)
            SHOULD.WE.UPDATE.XREFS = "Y"
         CASE QH.DELIV.ADDR.2 NE BEFORE.REC(10)
            SHOULD.WE.UPDATE.XREFS = "Y"
         CASE QH.DELIV.ADDR.3 NE BEFORE.REC(11)
            SHOULD.WE.UPDATE.XREFS = "Y"
      END CASE
      IF SHOULD.WE.UPDATE.XREFS = "Y" THEN
         CALL SQ.UPDATE.ALL.XREFS('DELETE',MAT BEFORE.REC,QUOTE.NUMBER)
         CALL SQ.UPDATE.ALL.XREFS('ADD',MAT QTE.HDR.REC,QUOTE.NUMBER)
      END
      MAT BEFORE.REC = MAT QTE.HDR.REC
      RETURN
***************************************************************************
*****************************
DO.LINE.SELECTION.AND.ACTION:
*****************************
      INPUT.OK = FALSE
      LOOP UNTIL INPUT.OK DO
         SEL.CTL = ''
         IF NOT(SKIP.CALL) THEN
            CRT CURSOR.ON:
            CALL LINE.SELECTION(0,22,CHOICE,SEL.POS,SEL.WORDS,SEL.ABBRV,SEL.RTNS,SEL.HELP,SEL.DELIM,SEL.CTL,"","","",ACTIVATE,"","")
            CRT CURSOR.OFF:
         END
         BEGIN CASE
            CASE CHOICE = "EXIT"
               IF QH.CUST.ADDR.1 = "" AND QH.CCARD.NO # "" THEN
                  CALL ERR("YOU MUST ENTER A REPLY ADDRESS FOR THIS QUOTE","")
                  SKIP.CALL = TRUE
                  CHOICE = "REPLY"
               END ELSE
                  INPUT.OK = TRUE
                  EXIT.FLAG = TRUE
               END
            CASE CHOICE = "SITE"
               GOSUB AMEND.SITE.ADDR
               CRT.VAR = @(1,13):QH.DELIV.ADDR.1'L#30' ; CRT CRT.VAR
               CRT.VAR = @(1,14):QH.DELIV.ADDR.2'L#30' ; CRT CRT.VAR
               CRT.VAR = @(1,15):QH.DELIV.ADDR.3'L#30' ; CRT CRT.VAR
               CRT.VAR = @(1,16):QH.DELIV.ADDR.4'L#30' ; CRT CRT.VAR
               CRT.VAR = @(1,17):QH.DELIV.ADDR.PCODE'L#8' ; CRT CRT.VAR
               CRT.VAR = @(41,13):QH.DEL.CONTACT.NAME'L#30' ; CRT CRT.VAR
            CASE CHOICE = "REPLY"
               GOSUB AMEND.QUOTE.ADDR
               CRT.VAR = @(41,6):QH.CUST.ADDR.1'L#38' ; CRT CRT.VAR
               CRT.VAR = @(41,7):QH.CUST.ADDR.2'L#38' ; CRT CRT.VAR
               CRT.VAR = @(41,8):QH.CUST.ADDR.3'L#38' ; CRT CRT.VAR
               CRT.VAR = @(41,9):QH.CUST.ADDR.4'L#38' ; CRT CRT.VAR
               CRT.VAR = @(41,10):QH.CUST.ADDR.PCODE'L#8' ; CRT CRT.VAR
               CRT.VAR = @(41,11):QH.CONTACT.TEL ; CRT CRT.VAR
               SKIP.CALL = FALSE
            CASE CHOICE = "DELIV"
               GOSUB AMEND.DELIV.INSTR
               CRT.VAR = @(1,19):QH.DELIVERY.INSTR<1,1> "L#60" ; CRT CRT.VAR
               CRT.VAR = @(1,20):QH.DELIVERY.INSTR<1,2> "L#60" ; CRT CRT.VAR
            CASE 1
               CALL ERR("ERROR WITH LINE.SELECTION ...... <RTN>",'')
         END CASE
      REPEAT
      RETURN
**************************************************************************
****************
AMEND.SITE.ADDR:
****************
      TITLE = " Site Address "
      ADDR1 = QH.DELIV.ADDR.1
      ADDR2 = QH.DELIV.ADDR.2
      ADDR3 = QH.DELIV.ADDR.3
      ADDR4 = QH.DELIV.ADDR.4
      PCODE = QH.DELIV.ADDR.PCODE
      CUSTNAME = QH.CUST.NAME
      S.ALLOWED = ''
      S.ADDR1 = ''
      S.ADDR2 = ''
      S.ADDR3 = ''
      S.ADDR4 = ''
      S.PCODE = ''
      CTL.OUT = ''
      MAND.ADDR = ''
      NAME.REQ = "Y"
      CONTACT.NAME = QH.DEL.CONTACT.NAME
      CRT CURSOR.ON:
      CALL ADDRESS.RETRIEVAL(TITLE,ADDR1,ADDR2,ADDR3,ADDR4,PCODE,CUSTNAME,S.ALLOWED,S.ADDR1,S.ADDR2,S.ADDR3,S.ADDR4,S.PCODE,CTL.OUT,MAND.ADDR,NAME.REQ,CONTACT.NAME,'')
      CRT CURSOR.OFF:
      QH.DELIV.ADDR.1 = ADDR1
      QH.DELIV.ADDR.2 = ADDR2
      QH.DELIV.ADDR.3 = ADDR3
      QH.DELIV.ADDR.4 = ADDR4
      QH.DELIV.ADDR.PCODE = PCODE
      QH.DEL.CONTACT.NAME = CONTACT.NAME
      GOSUB RE.DO.SCREEN
      RETURN
****************
AMEND.DELIV.INSTR:
****************
      AMENDING = "D"
      AMEND.FIELD.NO = 0
      AMEND.CTL = ''
      AMEND.COMPLETE = FALSE
      END.OF.INPUTS = FALSE
      LOOP UNTIL AMEND.COMPLETE DO
         LOOP UNTIL END.OF.INPUTS DO
            BEGIN CASE
               CASE AMEND.CTL = '/'
                  RETURN
               CASE AMEND.CTL = '<' ; AMEND.FIELD.NO = AMEND.FIELD.NO - 1
               CASE AMEND.CTL = '.' ; AMEND.FIELD.NO = 999
               CASE TRUE
                  AMEND.FIELD.NO = AMEND.FIELD.NO + 1
            END CASE
            AMEND.CTL = ''
            BEGIN CASE
               CASE AMEND.FIELD.NO = 0 ; END.OF.INPUTS = TRUE ; AMEND.COMPLETE = TRUE
               CASE AMEND.FIELD.NO = 1
                  COL = 1
                  ROW = 19
                  VAR = QH.DELIVERY.INSTR<1,1>
                  GOSUB INP.LINE.ENTRY
                  QH.DELIVERY.INSTR<1,1> = VAR
               CASE AMEND.FIELD.NO = 2
                  COL = 1
                  ROW = 20
                  VAR = QH.DELIVERY.INSTR<1,2>
                  GOSUB INP.LINE.ENTRY
                  QH.DELIVERY.INSTR<1,2> = VAR
               CASE AMEND.FIELD.NO > 2
                  END.OF.INPUTS = TRUE
                  AMEND.COMPLETE = TRUE
            END CASE
         REPEAT
      REPEAT
      RETURN
**************************************************************************
*****************
AMEND.QUOTE.ADDR:
*****************
      AMENDING = "Q"
      AMEND.FIELD.NO = 0
      AMEND.CTL = ''
      AMEND.COMPLETE = FALSE
      END.OF.INPUTS = FALSE
      LOOP UNTIL AMEND.COMPLETE DO
         LOOP UNTIL END.OF.INPUTS DO
            BEGIN CASE
               CASE AMEND.CTL = '/'
                  RETURN
               CASE AMEND.CTL = '<' ; AMEND.FIELD.NO = AMEND.FIELD.NO - 1
               CASE AMEND.CTL = '.' ; AMEND.FIELD.NO = 999
               CASE TRUE
                  AMEND.FIELD.NO = AMEND.FIELD.NO + 1
            END CASE
            AMEND.CTL = ''
            BEGIN CASE
               CASE AMEND.FIELD.NO = 0 ; END.OF.INPUTS = TRUE ; AMEND.COMPLETE = TRUE
               CASE AMEND.FIELD.NO = 1
                  INPUT.VAR = QH.CUST.ADDR.1
                  X.POS = 41
                  Y.POS = 6
                  ADDRESS.LINE = 1
                  GOSUB INPUT.30.CHARS
                  QH.CUST.ADDR.1 = INPUT.VAR
               CASE AMEND.FIELD.NO = 2
                  INPUT.VAR = QH.CUST.ADDR.2
                  X.POS = 41
                  Y.POS = 7
                  ADDRESS.LINE = 2
                  GOSUB INPUT.30.CHARS
                  QH.CUST.ADDR.2 = INPUT.VAR
               CASE AMEND.FIELD.NO = 3
                  INPUT.VAR = QH.CUST.ADDR.3
                  X.POS = 41
                  Y.POS = 8
                  ADDRESS.LINE = 3
                  GOSUB INPUT.30.CHARS
                  QH.CUST.ADDR.3 = INPUT.VAR
               CASE AMEND.FIELD.NO = 4
                  INPUT.VAR = QH.CUST.ADDR.4
                  X.POS = 41
                  Y.POS = 9
                  ADDRESS.LINE = 4
                  GOSUB INPUT.30.CHARS
                  QH.CUST.ADDR.4 = INPUT.VAR
               CASE AMEND.FIELD.NO = 5
                  INPUT.VAR = QH.CUST.ADDR.PCODE
                  X.POS = 41
                  Y.POS = 10
                  GOSUB INPUT.8.CHARS
                  QH.CUST.ADDR.PCODE = INPUT.VAR
                  IF AMEND.CTL = "<" THEN
                     BEGIN CASE
                        CASE QH.CUST.ADDR.1 = ''
                           AMEND.FIELD.NO = 0
                        CASE QH.CUST.ADDR.2 = ''
                           AMEND.FIELD.NO = 0
                        CASE QH.CUST.ADDR.3 = ''
                           AMEND.FIELD.NO = 1
                        CASE QH.CUST.ADDR.4 = ''
                           AMEND.FIELD.NO = 2
                        CASE TRUE
                           AMEND.FIELD.NO = 3
                     END CASE
                     AMEND.CTL = ''
                  END
               CASE AMEND.FIELD.NO = 6
                  INPUT.VAR = QH.CONTACT.TEL
                  X.POS = 41
                  Y.POS = 11
                  GOSUB INPUT.PHONE
                  QH.CONTACT.TEL = INPUT.VAR
                  IF AMEND.CTL = "<" THEN
                     BEGIN CASE
                        CASE QH.CUST.ADDR.1 = ''
                           AMEND.FIELD.NO = 0
                        CASE QH.CUST.ADDR.2 = ''
                           AMEND.FIELD.NO = 0
                        CASE QH.CUST.ADDR.3 = ''
                           AMEND.FIELD.NO = 1
                        CASE QH.CUST.ADDR.4 = ''
                           AMEND.FIELD.NO = 2
                        CASE QH.CUST.ADDR.PCODE = ""
                           AMEND.FIELD.NO = 3
                        CASE TRUE
                           AMEND.FIELD.NO = 4
                     END CASE
                     AMEND.CTL = ''
                  END
               CASE AMEND.FIELD.NO > 6
                  END.OF.INPUTS = TRUE ; AMEND.COMPLETE = TRUE
            END CASE
         REPEAT
      REPEAT
      RETURN
**************************************************************************
***************
INPUT.30.CHARS:
***************
      AMEND.INPUT.COMPLETE = FALSE
      INPUT.HELP = "Enter Address Line ":ADDRESS.LINE
      LOOP UNTIL AMEND.INPUT.COMPLETE DO
         IF AMEND.FIELD.NO=1 AND AMENDING = "S" AND QH.DELIV.ADDR.1 = '' THEN
            INPUT.VAR=QH.CUST.NAME
         END
         AMEND.CTL = ''
         CRT CURSOR.ON:
         CALL INP(X.POS,Y.POS,INPUT.VAR,30,'L#30','','0X',0,0,0,AMEND.CTL,INPUT.HELP,0)
         CRT CURSOR.OFF:
         BEGIN CASE
            CASE AMEND.CTL = "/"
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#30' ; CRT CRT.VAR
               AMEND.INPUT.COMPLETE = TRUE
            CASE AMEND.CTL = "<"
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#30' ; CRT CRT.VAR
               AMEND.INPUT.COMPLETE = TRUE
            CASE AMEND.CTL = "."
               AMEND.INPUT.COMPLETE = TRUE
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#30' ; CRT CRT.VAR
            CASE AMEND.CTL NE NULL
               CALL ERR("OPTIONS: AN ADDRESS LINE, '.', '<' OR '/' ...... <RTN>","")
            CASE INPUT.VAR = ""
               AMEND.INPUT.COMPLETE = TRUE
               FOR CLEAR.LOOP = AMEND.FIELD.NO TO 4
                  IF AMENDING = "Q" THEN
                     QTE.HDR.REC(4+CLEAR.LOOP) = ''
                  END
                  IF AMENDING = "S" THEN
                     QTE.HDR.REC(8+CLEAR.LOOP) = ''
                  END
               NEXT CLEAR.LOOP
               IF AMEND.FIELD.NO = 1 THEN
                  AMEND.FIELD.NO = 6     ; * 9026
                  IF AMENDING = "Q" THEN
                     QTE.HDR.REC(43) = ''
                  END
                  IF AMENDING = "S" THEN
                     QTE.HDR.REC(44) = ''
                  END
               END ELSE
                  AMEND.FIELD.NO = 4
               END
               IF AMENDING = "S" THEN
                  CRT.VAR = @(1,13):QH.DELIV.ADDR.1'L#30' ; CRT CRT.VAR
                  CRT.VAR = @(1,14):QH.DELIV.ADDR.2'L#30' ; CRT CRT.VAR
                  CRT.VAR = @(1,15):QH.DELIV.ADDR.3'L#30' ; CRT CRT.VAR
                  CRT.VAR = @(1,16):QH.DELIV.ADDR.4'L#30' ; CRT CRT.VAR
                  CRT.VAR = @(1,17):QH.DELIV.ADDR.PCODE'L#8' ; CRT CRT.VAR
                  CRT.VAR = @(41,13):QH.DEL.CONTACT.NAME'L#30' ; CRT CRT.VAR
               END ELSE
                  CRT.VAR = @(41,6):QH.CUST.ADDR.1'L#38' ; CRT CRT.VAR
                  CRT.VAR = @(41,7):QH.CUST.ADDR.2'L#38' ; CRT CRT.VAR
                  CRT.VAR = @(41,8):QH.CUST.ADDR.3'L#38' ; CRT CRT.VAR
                  CRT.VAR = @(41,9):QH.CUST.ADDR.4'L#38' ; CRT CRT.VAR
                  CRT.VAR = @(41,10):QH.CUST.ADDR.PCODE'L#8' ; CRT CRT.VAR
                  CRT.VAR = @(41,11):QH.CONTACT.TEL ; CRT CRT.VAR
               END
            CASE 1
               AMEND.INPUT.COMPLETE = TRUE
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#30' ; CRT CRT.VAR
         END CASE
      REPEAT
      RETURN
***************
INP.LINE.ENTRY:
***************
      AMEND.INPUT.COMPLETE = FALSE
      LENGTH = 60
      JUST = ''
      MASK = ''
      VALI = ''
      MAND = ''
      NEG = ''
      ZERO = ''
      HLP = 'Enter delivery instructions - upto 2 lines of 60 characters'
      TIM = ''
      LOOP UNTIL AMEND.INPUT.COMPLETE DO
         AMEND.CTL = ''
         CRT CURSOR.ON:
         CALL INP.LINE(COL,ROW,VAR,LENGTH,JUST,MASK,VALI,MAND,NEG,ZERO,AMEND.CTL,HLP,TIM)
         CRT CURSOR.OFF:
         BEGIN CASE
            CASE AMEND.CTL = "/"
               CRT.VAR = @(COL,ROW):VAR 'L#60' ; CRT CRT.VAR
               AMEND.INPUT.COMPLETE = TRUE
            CASE AMEND.CTL = "<"
               CRT.VAR = @(COL,ROW):VAR 'L#60' ; CRT CRT.VAR
               AMEND.INPUT.COMPLETE = TRUE
            CASE AMEND.CTL = "."
               AMEND.INPUT.COMPLETE = TRUE
               CRT.VAR = @(COL,ROW):VAR 'L#60' ; CRT CRT.VAR
            CASE AMEND.CTL NE NULL
               CALL ERR("Enter the delivery instructions, '.', '<', or '/'  <RTN>","")
            CASE VAR = ""
               AMEND.INPUT.COMPLETE = TRUE
            CASE 1
               AMEND.INPUT.COMPLETE = TRUE
               CRT.VAR = @(COL,ROW):VAR "L#60" ; CRT CRT.VAR
         END CASE
      REPEAT
      RETURN
**************************************************************************
***************
INPUT.8.CHARS:
***************
      AMEND.INPUT.COMPLETE = FALSE
      INPUT.HELP = "Enter Postcode "
      LOOP UNTIL AMEND.INPUT.COMPLETE DO
         AMEND.CTL = ''
         CRT CURSOR.ON:
         CALL INP(X.POS,Y.POS,INPUT.VAR,9,'L#9','',PCODE.VALIDATION,0,0,0,AMEND.CTL,INPUT.HELP,0)
         CRT CURSOR.OFF:
         BEGIN CASE
            CASE AMEND.CTL = "/"
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#9' ; CRT CRT.VAR
               AMEND.INPUT.COMPLETE = TRUE
            CASE AMEND.CTL = "<"
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#9' ; CRT CRT.VAR
               AMEND.INPUT.COMPLETE = TRUE
            CASE AMEND.CTL = "."
               AMEND.INPUT.COMPLETE = TRUE
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#9' ; CRT CRT.VAR
            CASE AMEND.CTL NE NULL
               CALL ERR("OPTIONS: A POSTCODE, '.', '<' OR '/' ...... <RTN>","")
            CASE INPUT.VAR = ""
               AMEND.INPUT.COMPLETE = TRUE
               IF AMENDING = "Q" THEN
                  QTE.HDR.REC(43) = ''
               END
               IF AMENDING = "S" THEN
                  QTE.HDR.REC(44) = ''
               END
            CASE 1
               AMEND.INPUT.COMPLETE = TRUE
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#9' ; CRT CRT.VAR
         END CASE
      REPEAT
      RETURN
**************************************************************************
************
INPUT.PHONE:
************
      AMEND.INPUT.COMPLETE = FALSE
      INPUT.HELP = "Enter Contact Telephone Number "
      LOOP UNTIL AMEND.INPUT.COMPLETE DO
         AMEND.CTL = ''
         CRT CURSOR.ON:
         CALL INP(X.POS,Y.POS,INPUT.VAR,20,'L#20','','',0,0,0,AMEND.CTL,INPUT.HELP,0)
         CRT CURSOR.OFF:
         BEGIN CASE
            CASE AMEND.CTL = "/"
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#20' ; CRT CRT.VAR
               AMEND.INPUT.COMPLETE = TRUE
            CASE AMEND.CTL = "<"
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#20' ; CRT CRT.VAR
               AMEND.INPUT.COMPLETE = TRUE
            CASE AMEND.CTL = "."
               AMEND.INPUT.COMPLETE = TRUE
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#20' ; CRT CRT.VAR
            CASE AMEND.CTL NE NULL
               CALL ERR("OPTIONS: A TELEPHONE NUMBER, '.', '<' OR '/' ...... <RTN>","")
            CASE INPUT.VAR = ""
               AMEND.INPUT.COMPLETE = TRUE
               AMEND.CTL = "."
               IF AMENDING = "Q" THEN
                  QTE.HDR.REC(43) = ''
               END
               IF AMENDING = "S" THEN
                  QTE.HDR.REC(44) = ''
               END
            CASE 1
               AMEND.INPUT.COMPLETE = TRUE
               CRT.VAR = @(X.POS,Y.POS):INPUT.VAR'L#20' ; CRT CRT.VAR
         END CASE
      REPEAT
      RETURN
**************************************************************************
************************
DISPLAY.ADDRESS.DETAILS:
************************
      BEGIN CASE
         CASE QUOTE.NUMBER MATCHES '6X6N'
            CRT.VAR = @(13,1):QUOTE.NUMBER[6,7]'R#7' ; CRT CRT.VAR
         CASE QUOTE.NUMBER MATCHES '1X6N'
            CRT.VAR = @(13,1):QUOTE.NUMBER'R#7' ; CRT CRT.VAR
         CASE 1
            CRT.VAR = @(13,1):""'R#7' ; CRT CRT.VAR
      END CASE
      W.TEST.ADJUST.ADDRESS = FALSE
      COUNTER = DCOUNT(BS.ADJUST.ADDRESS.REC,@AM)
      FOR ATT=1 TO COUNTER UNTIL W.TEST.ADJUST.ADDRESS
         LOCATE QH.CUST.CODE IN BS.ADJUST.ADDRESS.REC<ATT>,1 SETTING CC.POS THEN
            W.TEST.ADJUST.ADDRESS = TRUE
         END
      NEXT ATT
      IF QH.CUST.CODE NE '' THEN
         IF QH.TCC.NO # '' THEN
            CRT.VAR = @(32,1):QH.CUST.CODE:"/":QH.TCC.NO:EOL ; CRT CRT.VAR
         END ELSE
            CRT.VAR = @(32,1):QH.CUST.CODE:EOL ; CRT CRT.VAR
         END
         CRT.VAR = @(47,1):QH.CUST.NAME'L#30' ; CRT CRT.VAR
         CRT.VAR = @(47,2):QH.CUST.ADDR.1'L#30' ; CRT CRT.VAR
      END ELSE
         CRT.VAR = @(32,1):QH.CUST.NAME:EOL ; CRT CRT.VAR
         CRT.VAR = @(47,2):QH.CUST.ADDR.1'L#30' ; CRT CRT.VAR
      END
      CRT.VAR = @(13,2):QH.SALE.TYPE'L#1' ; CRT CRT.VAR
      READV STATUS.DESC FROM QUOTE.STATUS.FV,QH.STATUS,1 ELSE
         STATUS.DESC = ''
      END
      CRT.VAR = @(32,2):STATUS.DESC'L#7' ; CRT CRT.VAR
      CRT.VAR = @(13,3):QH.SITE.REF'L#66' ; CRT CRT.VAR
      IF QH.CUST.CODE NE '' AND W.TEST.ADJUST.ADDRESS = FALSE THEN
         CRT.VAR = @(1,6):PC.CUST.ADDR.1'L#30' ; CRT CRT.VAR
         CRT.VAR = @(1,7):PC.CUST.ADDR.2'L#30' ; CRT CRT.VAR
         CRT.VAR = @(1,8):PC.CUST.ADDR.3'L#30' ; CRT CRT.VAR
         CRT.VAR = @(1,9):PC.CUST.ADDR.4'L#30' ; CRT CRT.VAR
         CRT.VAR = @(1,10):PC.CUST.PCODE'L#8' ; CRT CRT.VAR
      END ELSE
         CRT.VAR = @(32,1):QH.CUST.NAME:EOL ; CRT CRT.VAR
         CRT.VAR = @(1,6):"CASH CUSTOMER - NO ACCOUNT ADDRESS":EOL ; CRT CRT.VAR
      END
      CRT.VAR = @(41,6):QH.CUST.ADDR.1'L#38' ; CRT CRT.VAR
      CRT.VAR = @(41,7):QH.CUST.ADDR.2'L#38' ; CRT CRT.VAR
      CRT.VAR = @(41,8):QH.CUST.ADDR.3'L#38' ; CRT CRT.VAR
      CRT.VAR = @(41,9):QH.CUST.ADDR.4'L#38' ; CRT CRT.VAR
      CRT.VAR = @(41,10):QH.CUST.ADDR.PCODE'L#8' ; CRT CRT.VAR
      CRT.VAR = @(41,11):QH.CONTACT.TEL ; CRT CRT.VAR
      CRT.VAR = @(1,13):QH.DELIV.ADDR.1'L#30' ; CRT CRT.VAR
      CRT.VAR = @(1,14):QH.DELIV.ADDR.2'L#30' ; CRT CRT.VAR
      CRT.VAR = @(1,15):QH.DELIV.ADDR.3'L#30' ; CRT CRT.VAR
      CRT.VAR = @(1,16):QH.DELIV.ADDR.4'L#30' ; CRT CRT.VAR
      CRT.VAR = @(1,17):QH.DELIV.ADDR.PCODE'L#8' ; CRT CRT.VAR
      CRT.VAR = @(41,13):QH.DEL.CONTACT.NAME'L#30' ; CRT CRT.VAR
      CRT.VAR = @(1,19):QH.DELIVERY.INSTR<1,1> 'L#60' ; CRT CRT.VAR
      CRT.VAR = @(1,20):QH.DELIVERY.INSTR<1,2> 'L#60' ; CRT CRT.VAR
      RETURN
***********************************************************************
      INCLUDE INCLUDES TRANS.BOUNDS
   END
