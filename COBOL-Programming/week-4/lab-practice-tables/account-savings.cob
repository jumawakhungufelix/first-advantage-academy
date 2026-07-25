       IDENTIFICATION DIVISION. 
       PROGRAM-ID. ACCOUNT-SAVINGS.

       DATA DIVISION. 
       WORKING-STORAGE SECTION. 
       01 WS-SAVINGS-TABLE.
           05 WS-MONTHLY-SAVINGS       OCCURS 5 TIMES
                                   INDEXED BY WS-IDX.
                    10 WS-SAVINGS        PIC 9(6)V99.
       01 WS-I                        PIC 99 VALUE 1.
       01 WS-TOTAL-SAVINGS            PIC 9(6) VALUE ZERO.
       01 WS-TARGET-SAVINGS           PIC 9(6)V99.


       PROCEDURE DIVISION.

           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 5
               DISPLAY 'Enter monthly savings: '
               ACCEPT WS-SAVINGS(WS-I)
           END-PERFORM.

           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 5
              ADD WS-SAVINGS(WS-I)  TO WS-TOTAL-SAVINGS
           END-PERFORM.

           DISPLAY 'THE TOTAL SAVINGS FOR THE MONTHS IS : '
                    WS-TOTAL-SAVINGS.
           DISPLAY 'Entertarget savings: '
           ACCEPT WS-TARGET-SAVINGS.

           SET WS-IDX TO 1
      
           SEARCH WS-MONTHLY-SAVINGS
              AT END
                 DISPLAY 'savings not found'
                 WHEN WS-SAVINGS(WS-IDX) = WS-TARGET-SAVINGS
                    DISPLAY 'Found at position 'WS-IDX
           END-SEARCH.

              
           STOP RUN.