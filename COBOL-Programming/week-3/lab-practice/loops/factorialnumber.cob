        IDENTIFICATION DIVISION. 
        PROGRAM-ID. Factorial.
        DATA DIVISION. 
        WORKING-STORAGE SECTION.
        01 WS-NUMBER PIC 9(3).
        01 WS-FACTORIAL PIC 9(7) VALUE ZERO.
        01 WS-COUNTER PIC 9(3).

        PROCEDURE DIVISION.
           DISPLAY 'ENTER A NUMBER ' WITH NO ADVANCING.
           ACCEPT WS-NUMBER.
           MOVE 1 TO WS-FACTORIAL.
           PERFORM UNTIL WS-NUMBER <= 1
              MULTIPLY WS-NUMBER BY WS-FACTORIAL GIVING WS-FACTORIAL
              SUBTRACT 1 FROM WS-NUMBER
           END-PERFORM.
           DISPLAY 'FACTORIAL OF THE NUMBER IS ' WS-FACTORIAL.                  
           STOP RUN. 
                                                              
   


        
