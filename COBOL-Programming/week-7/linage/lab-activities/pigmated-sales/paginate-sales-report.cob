       IDENTIFICATION DIVISION. 
       PROGRAM-ID. PAGINATED.

       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL. 
            SELECT SALES-FILE ASSIGN TO 'SALES.DAT'
           ORGANIZATION IS LINE SEQUENTIAL.
           SELECT SORTED-SALES ASSIGN TO 'SORTED.DAT'
           ORGANIZATION IS LINE SEQUENTIAL.
           SELECT SORT-WORK ASSIGN TO 'SORTING.TMP'.


       DATA DIVISION. 
       FILE SECTION. 
       FD SALES-FILE.
       01 SALES-RECORD.
           05 DEPT        PIC X(3).
           05 SALESPERSON PIC X(18).
           05 AMOUNT      PIC 9(6)V99.

       FD SORTED-SALES
            LINAGE IS 24 LINES
              WITH FOOTING AT 22
              LINES AT TOP 2 
              LINES AT BOTTOM 1.
              

       01 RPT-LINE        PIC X(132).
       01  SORTED-RECORD.
           05 OUT-DEPT              PIC X(3).
           05 OUT-SALESPERSON       PIC X(18).
           05 OUT-AMOUNT            PIC 9(6)V99.



       SD SORT-WORK.
           
       01 SORTED-RECORD.
           05 SR-DEPT              PIC X(3).
           05 SR-SALESPERSON       PIC X(18).
           05 SR-AMOUNT            PIC 9(6)V99.


       WORKING-STORAGE SECTION. 
       01 WS-PREV-DEPT       PIC X(3) VALUE SPACES.c
       01 WS-DEPT-SALES      PIC 9(11)V99 VALUE ZERO.
       01 WS-GRAND-SALES     PIC 9(13)V99 VALUE ZERO.
       01 WS-LINE               PIC X(60).
       01 WS-EOF                PIC X VALUE 'N'.

       01 WS-SUB-TOTAL.
           05 WS-BR-DEPT              PIC X(3).
           05 WS-BR-SALESPERSON       PIC X(18).
           05 WS-BR-AMOUNT             PIC ZZZ,ZZZ9.99.
           05 WS-GRAND-AMOUNT          PIC ZZZ,ZZZ,ZZ9.99.

       01 WS-SUB-TOTAL-DISPLAY           PIC ZZZ,ZZZ,ZZ9.99.

       01 WS-PAGE-NUM        PIC 9(3).
       01 WS-PAGE-LINE       PIC X(50).

       PROCEDURE DIVISION.
       MAIN-LOGIC.
            SORT SORT-WORK
              ON ASCENDING KEY SR-DEPT
              ON ASCENDING KEY SR-SALESPERSON
              USING SALES-FILE
              GIVING SORTED-SALES.
           
           OPEN OUTPUT  SORTED-SALES .
           PERFORM PROCESS-SALES
           PERFORM PRINT-HEADER
           READ SORTED-SALES 
              AT END
                 MOVE 'Y' TO WS-EOF
              NOT AT END   
                 MOVE OUT-DEPT TO WS-PREV-DEPT 
                 
           END-READ.

           

           DISPLAY 'DEPT           SALESPERSON             AMOUNT'
           DISPLAY SPACE 

           DISPLAY '==================================================='
           PERFORM  PROCESS-RECORDS UNTIL WS-EOF = 'Y'.
           
           PERFORM PRINT-DEP-SUBTOTAL .

           MOVE WS-GRAND-SALES TO WS-GRAND-AMOUNT .

           DISPLAY '--------Grand Total :' WS-GRAND-AMOUNT '---------'.
           


           CLOSE  SORTED-SALES .
           DISPLAY '================================================='.
           STOP RUN.

       PROCESS-SALES.
           IF SR-DEPT NOT = WS-PREV-DEPT
              PERFORM PRINT-DEP-SUBTOTAL
              MOVE ZERO TO WS-DEPT-SALES
              MOVE SR-DEPT TO WS-PREV-DEPT
            END-IF
           MOVE SPACES TO RPT-LINE 
           STRING SR-DEPT DELIMITED BY SIZE ' ' DELIMITED BY SIZE 
              SR-SALESPERSON DELIMITED BY  SIZE ' 'DELIMITED BY SIZE 
              SR-AMOUNT DELIMITED BY SIZE INTO RPT-LINE 

           WRITE RPT-LINE
              AT END-OF-PAGE 
                 PERFORM PRINT-HEADER
           END-WRITE.

           ADD SR-AMOUNT TO WS-DEPT-SALES
           READ SORTED-SALES 
              AT END
                 MOVE 'Y' TO WS-EOF
           END-READ.

       PRINT-HEADER.
           ADD 1 TO WS-PAGE-NUM 
           MOVE SPACES TO RPT-LINE 
           STRING 'SALES REPORT ' DELIMITED BY SIZE ' 'DELIMITED BY SIZE
              'PAGE 'DELIMITED BY SIZE WS-PAGE-NUM DELIMITED BY SIZE
              INTO RPT-LINE.
           WRITE RPT-LINE.

       PROCESS-RECORDS.

         
           IF OUT-DEPT NOT = WS-PREV-DEPT 
              
              PERFORM PRINT-DEP-SUBTOTAL
              DISPLAY '-----------------------------------------------'
              DISPLAY '            DEPARTMENT DETAILS              '
              DISPLAY '            --------------------               '
              MOVE ZERO TO WS-DEPT-SALES 
              MOVE OUT-DEPT TO WS-PREV-DEPT 
              DISPLAY SPACE 
              DISPLAY '-----------------------------------------------'
              
           END-IF .

           MOVE OUT-DEPT  TO WS-BR-DEPT. 
           MOVE OUT-SALESPERSON TO WS-BR-SALESPERSON .
           MOVE OUT-AMOUNT TO WS-BR-AMOUNT .

           
           
           DISPLAY WS-BR-DEPT  '           'WS-BR-SALESPERSON '        '
            WS-BR-AMOUNT .
             
           
           DISPLAY WS-LINE.
           ADD OUT-AMOUNT TO WS-DEPT-SALES.
           ADD OUT-AMOUNT TO WS-GRAND-SALES .
           READ SORTED-SALES
              AT END
                 MOVE 'Y' TO WS-EOF 
              END-READ.

           

       PRINT-DEP-SUBTOTAL.
           DISPLAY SPACE 
           DISPLAY '--------------------------------------------------'.
           MOVE WS-DEPT-SALES TO WS-SUB-TOTAL-DISPLAY.
           DISPLAY '---' WS-PREV-DEPT
            ' SUB-TOTAL: 'WS-SUB-TOTAL-DISPLAY.
            

           


                