        IDENTIFICATION DIVISION. 
        PROGRAM-ID. VOTER.

        DATA DIVISION. 
        WORKING-STORAGE SECTION.
        01 WS-NAME           PIC X(20).
        01 WS-AGE            PIC 99.
        01 WS-ELIGIBILITY    PIC X(3) VALUE "NO".

        PROCEDURE DIVISION.
        MAIN-LOGIC SECTION.
        MAIN-PARA.
           DISPLAY "Enter your name: " WITH NO ADVANCING.
           ACCEPT WS-NAME.
           DISPLAY "Enter your age: " WITH NO ADVANCING.
           ACCEPT WS-AGE.
           IF WS-AGE >= 18 THEN
              MOVE "YES" TO WS-ELIGIBILITY
           END-IF.
           DISPLAY "Hello " WS-NAME "you are " WS-AGE " years old and your eligibility is " WS-ELIGIBILITY.
           STOP RUN.



