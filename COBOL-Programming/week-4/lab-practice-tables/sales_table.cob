       IDENTIFICATION DIVISION.
       PROGRAM-ID. SALES-TABLE.

       DATA DIVISION.
       WORKING-STORAGE SECTION. 
       01  WS-MONTHLY-SALES-TABLE.
           05 WS-SALES          PIC 9(6)V99 OCCURS 5 TIMES
                                   INDEXED BY IDX.
       
       01  WS-I                 PIC 9(2)    VALUE 1.
       01 WS-ANNUAL-TOTAL       PIC 9(12).
       

       PROCEDURE DIVISION.
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 12
              DISPLAY 'Enter sales for month ' WS-I ': '
              ACCEPT WS-SALES(WS-I)
           END-PERFORM.

           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 12
              ADD WS-SALES(WS-I) TO WS-ANNUAL-TOTAL
           END-PERFORM.

           

           DISPLAY 'Annual total: 'WS-ANNUAL-TOTAL.
              