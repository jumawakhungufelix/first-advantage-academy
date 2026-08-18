       IDENTIFICATION DIVISION.
       PROGRAM-ID. BOOKING.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT SEAT-FILE ASSIGN TO 'SEAT.DAT'
           ORGANIZATION IS RELATIVE
           ACCESS MODE IS RANDOM
           RELATIVE KEY IS WS-SEAT-NUM
           FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION. 
       FILE SECTION. 
       FD SEAT-FILE.
       01 SEAT-RECORD.
           05 SEAT-STATUS       PIC X.
           05 PASSENGER-NAME    PIC X(30).

       WORKING-STORAGE SECTION. 
       01 WS-SEAT-NUM        PIC 9(3).
       01 WS-FILE-STATUS        PIC XX.
       01 WS-REQUESTE-SEAT      PIC 9(3).
       01 WS-PASSENGER-NAME     PIC X(30).
       01 WS-SEAT-COUNT         PIC 999 VALUE 1.
       01 WS-CHOICE             PIC X VALUE 'Y'.

       

       PROCEDURE DIVISION.


           
           OPEN OUTPUT SEAT-FILE
           PERFORM VARYING WS-SEAT-NUM FROM 1 BY 1 UNTIL
            WS-SEAT-NUM > 100
            MOVE 'A' TO SEAT-STATUS 
            MOVE SPACES TO PASSENGER-NAME 
           
            WRITE SEAT-RECORD
              INVALID
                 DISPLAY 'Iitialization error at 'WS-SEAT-NUM
              NOT INVALID
                 IF SEAT-STATUS = 'B'
                 MOVE WS-PASSENGER-NAME  TO PASSENGER-NAME
                 DISPLAY 'seat ' WS-SEAT-NUM ' BOOKED BY  '
                  PASSENGER-NAME
                 END-IF
           END-WRITE
           END-PERFORM
           CLOSE SEAT-FILE.
           DISPLAY '100 seats created successfuly'
           

            

           OPEN I-O SEAT-FILE
           PERFORM UNTIL WS-CHOICE = 'N' OR WS-CHOICE = 'n'


           DISPLAY 'ENTER SEAT NUMBER TO BOOK (1-100)'
           ACCEPT WS-REQUESTE-SEAT
           DISPLAY 'ENTER PASSENGER NAME: '
           ACCEPT WS-PASSENGER-NAME

           MOVE WS-REQUESTE-SEAT TO WS-SEAT-NUM
              READ SEAT-FILE
              INVALID KEY
                 DISPLAY 'NO SUCH SEAT NUMBER'
              NOT INVALID KEY
                 IF SEAT-STATUS = 'B'
                    DISPLAY 'SEAT ALREADY BOOKED'
                 ELSE
                    MOVE 'B' TO SEAT-STATUS
                    MOVE WS-PASSENGER-NAME TO PASSENGER-NAME
                 REWRITE SEAT-RECORD
                    INVALID KEY 
                       DISPLAY 'BOOKING FAILED'
                 END-REWRITE
                 END-IF
                 END-READ
                 DISPLAY 'ENTER YOUR CHOICE: (Y/N): '
                 ACCEPT WS-CHOICE
                 

                 END-PERFORM
                 DISPLAY 'THANK YOU FOR USING OUR SERVICES.'

                 CLOSE SEAT-FILE.




