       IDENTIFICATION DIVISION. 
       PROGRAM-ID. INVENTORY.

       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL. 
           SELECT INVENTORY-FILE ASSIGN TO 'INVENTORY.DAT'
           ORGANIZATION IS LINE SEQUENTIAL.
           SELECT SORTED-INVENTORY ASSIGN TO 'SORTED-INVENTORY.DAT'
           ORGANIZATION IS LINE SEQUENTIAL.

           SELECT SORT-WORK ASSIGN TO 'SORTING.PRT'.

       DATA DIVISION. 
       FILE SECTION. 
       FD INVENTORY-FILE.
       01 PRODUCT-RECORD.
           05 CARTEGORY      PIC X(20).
           05 PROD-NAME      PIC X(20).
           05 PROD-PRICE     PIC 9(6)V99.
           05 PROD-QTY       PIC 9(3).

       FD SORTED-INVENTORY.
       01 SORTED-RECORD.
           05 OUT-CARTEGORY      PIC X(20).
           05 OUT-PROD-NAME      PIC X(20).
           05 OUT-PROD-PRICE     PIC 9(6)V99.
           05 OUT-PROD-QTY       PIC 9(3).

       SD SORT-WORK.
       01 SORTING-RECORD.
           05 SR-CARTEGORY      PIC X(20).
           05 SR-PROD-NAME      PIC X(20).
           05 SR-PROD-PRICE     PIC 9(6)V99.
           05 SR-PROD-QTY       PIC 9(3).
       
       WORKING-STORAGE SECTION. 
       01 WS-EOF-FLAG        PIC X VALUE 'N'.
       01 WS-PREV-CARTEGORY  PIC X(20).
       01 WS-COUNT           PIC 99.

       01 WS-DETAIL-LINES.
           05 WS-CARTEGORY         PIC X(20).
           05 WS-PROD-NAME         PIC X(20).
           05 WS-PROD-PRICE        PIC ZZZ,ZZ9,V99.
           05 WS-PROD-QTY          PIC ZZ9.
       
       PROCEDURE DIVISION .

       MAIN-LOGIC.
          
           SORT SORT-WORK 
              ON ASCENDING KEY SR-CARTEGORY 
              ON ASCENDING KEY SR-PROD-NAME 
              USING INVENTORY-FILE 
              GIVING SORTED-INVENTORY .
           
           OPEN INPUT SORTED-INVENTORY 

           READ SORTED-INVENTORY 
              AT END
                 MOVE 'Y' TO WS-EOF-FLAG 

              NOT AT END
                 MOVE OUT-CARTEGORY TO WS-PREV-CARTEGORY 
           END-READ.

           PERFORM PROCESS-PROCUCTS.

           CLOSE SORTED-INVENTORY .
           STOP RUN.

       PROCESS-PROCUCTS.
           
           IF NOT OUT-CARTEGORY = WS-PREV-CARTEGORY 
              MOVE OUT-CARTEGORY TO WS-PREV-CARTEGORY 
              
               MOVE OUT-CARTEGORY TO WS-CARTEGORY 
              MOVE OUT-PROD-NAME TO WS-PROD-NAME 
              MOVE OUT-PROD-PRICE TO WS-PROD-PRICE 

           MOVE OUT-PROD-QTY TO WS-PROD-QTY
           DISPLAY '=============================================='
           DISPLAY '  ' WS-CARTEGORY ' INVENTORY                     '
           DISPLAY 'CARTEGORY       NAME        PRICE        QURANTITY'
           DISPLAY WS-CARTEGORY '  ' WS-PROD-NAME ' ' WS-PROD-PRICE ' '
           WS-PROD-QTY 
           DISPLAY '==============================================='

           END-IF.


              