       IDENTIFICATION DIVISION. 
       PROGRAM-ID. HOUSES.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT HOUSES-INPUT-FILE ASSIGN TO 'HOUSE-INPUT.DAT'
                                ORGANIZATION IS LINE SEQUENTIAL.
           SELECT HOUSES-OUTPUT-FILE ASSIGN TO 'HOUSE-OUTPUT.DAT'
                                ORGANIZATION IS LINE SEQUENTIAL.


       DATA DIVISION. 
       FILE SECTION. 
       FD HOUSES-INPUT-FILE.
       01 HOUSE-ID-INPUT                 PIC X(10).
       

       FD HOUSES-OUTPUT-FILE.
       01 HOUSE-ID-OUTPUT                 PIC X(10).
       WORKING-STORAGE SECTION. 
       01 WS-EOF-FLAG              PIC X(1) VALUE 'N'.
       01 WS-COUNT                 PIC 9(5) VALUE ZERO.

       01 WS-HOUSES-TABLE.
           05 WS-HOUSE-ID          OCCURS 4 TIMES 
                                   ASCENDING KEY IS WS-HOUSE-TENANT
                                   INDEXED BY WS-INDEX.
              10 WS-IDS            PIC X(10) .
              10 WS-HOUSE-TENANT      PIC X(30).

       01 WS-SEARCH-ITEM              PIC X(10).
           

       
       

       PROCEDURE DIVISION .

           OPEN INPUT HOUSES-INPUT-FILE
           OPEN OUTPUT HOUSES-OUTPUT-FILE

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
              READ HOUSES-INPUT-FILE
                 AT END
                    MOVE 'Y' TO WS-EOF-FLAG
                 NOT AT END
                    MOVE HOUSE-ID-INPUT TO HOUSE-ID-OUTPUT
                    WRITE HOUSE-ID-OUTPUT
                    ADD 1 TO WS-COUNT
              END-READ
           END-PERFORM
           CLOSE HOUSES-INPUT-FILE
           CLOSE HOUSES-OUTPUT-FILE

           DISPLAY 'RECORD COPIED' WS-COUNT.
                    
           

           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 4
           DISPLAY 'Enter house id: ' WS-INDEX
           ACCEPT WS-HOUSE-ID(WS-INDEX)

           DISPLAY 'Enter tenant name: '
           ACCEPT WS-HOUSE-TENANT(WS-INDEX)
           
           END-PERFORM.

           DISPLAY 'HOUSES'
           DISPLAY '========================================='
           DISPLAY 'HOUSE ID  -- HOUSE TENANT'
           DISPLAY '========================================='

           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 4
           DISPLAY WS-HOUSE-ID(WS-INDEX)
                    
            
           END-PERFORM.

           DISPLAY 'Enter ID to look at: '.
           ACCEPT WS-SEARCH-ITEM.

           SET  WS-INDEX TO 1
              SEARCH WS-HOUSE-ID
                 AT END
                    DISPLAY 'ID NOT FOUND'
                 WHEN WS-IDS(WS-INDEX) = WS-SEARCH-ITEM
                    DISPLAY 'FOUND AT POSITION ' WS-INDEX
              END-SEARCH.

           STOP RUN.
           