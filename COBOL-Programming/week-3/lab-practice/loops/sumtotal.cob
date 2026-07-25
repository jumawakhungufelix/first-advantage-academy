       IDENTIFICATION DIVISION.
       PROGRAM-ID. FACTORIAL.

       DATA DIVISION. 
       WORKING-STORAGE SECTION.
       01 WS-NUMBER PIC 9(3).
       01 WS-FACTORIAL PIC 9(3).
       01 WS-COUNTER PIC 9(3) VALUE 1.
       01 WS-SUM     PIC 9(3) VALUE ZERO.

       PROCEDURE DIVISION.
           DISPLAY 'ENTER NUMBER: ' WITH NO ADVANCING.
           ACCEPT WS-NUMBER.
           
           PERFORM UNTIL WS-COUNTER > WS-NUMBER
              ADD WS-COUNTER TO WS-SUM GIVING WS-SUM
              
              ADD 1 TO WS-COUNTER
           END-PERFORM.
           DISPLAY WS-SUM
           
           STOP RUN.
           
        