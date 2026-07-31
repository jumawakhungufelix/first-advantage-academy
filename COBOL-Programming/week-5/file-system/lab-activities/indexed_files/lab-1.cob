       IDENTIFICATION DIVISION.
       PROGRAM-ID. INDEXEDFILE.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRODUCT-FILE ASSIGN TO 'PRODUCT-FILE.DAT'
           ORGANIZATION IS INDEXED
           ACCESS MODE IS RANDOM
           RECORD KEY IS PRODUCT-CODE
           FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION. 
          FILE SECTION.
          FD PRODUCT-FILE.
          01 PRODUCT-RECORD.
              05 PRODUCT-CODE         PIC X(4).
              05 PRODUCT-NAME         PIC X(20).
              05 PRODUCT-PRICE        PIC 9(5)V99.
              05 PRODUCT-QUANTITY     PIC 9(5).

          WORKING-STORAGE SECTION.
          01 WS-FILE-STATUS          PIC XX.
          01 WS-EOF-FLAG             PIC X VALUE 'N'.
          01 WS-PRODUCT-COUNT        PIC 9(5)  VALUE ZERO.
          01 WS-SEARCH-CODE          PIC X(40).

          01 WS-SEARCH-NAME        PIC X(20).
          01 WS-SEARCH-PRICE       PIC 9(5)V99.
          01 WS-SEARCH-QUANTITY    PIC 9(5).

          PROCEDURE DIVISION.
           OPEN I-O PRODUCT-FILE
           PERFORM UNTIL WS-PRODUCT-COUNT > 4
              DISPLAY 'ENTER CODE: '
              ACCEPT PRODUCT-CODE
              DISPLAY 'ENTER NAME: '
              ACCEPT PRODUCT-NAME
              DISPLAY 'PRODUCT PRICE: '
              ACCEPT PRODUCT-PRICE
              DISPLAY 'QUANTITY: '
              ACCEPT PRODUCT-QUANTITY
              WRITE PRODUCT-RECORD
              ADD 1 TO WS-PRODUCT-COUNT
              END-PERFORM
      
           DISPLAY 'Enter product code to search : '.
           ACCEPT WS-SEARCH-CODE.  
           MOVE WS-SEARCH-CODE TO PRODUCT-CODE.  
              READ PRODUCT-FILE
                 INVALID KEY
                    DISPLAY 'PRODUCT NOT FOUND'
                 NOT INVALID KEY
                    DISPLAY 'PRIDUCT CODE : 'PRODUCT-CODE
                    DISPLAY 'PRODUCT NAME: ' PRODUCT-NAME
                    DISPLAY 'PRODUCT PRICE: ' PRODUCT-PRICE
                    DISPLAY 'PRODUCT QUANTITY: ' PRODUCT-QUANTITY
              END-READ

           DISPLAY 'ENTER PRODUCT TO REWRITE: '.
           ACCEPT WS-SEARCH-CODE.

           MOVE WS-SEARCH-CODE TO PRODUCT-CODE.
            READ PRODUCT-FILE
              INVALID KEY 
                 DISPLAY 'PRODUCT NOT FOUND'
                 NOT INVALID KEY
                    DISPLAY 'ENTER NEW PRICE: '
                    
                    ACCEPT WS-SEARCH-PRICE
                    MOVE WS-SEARCH-PRICE TO PRODUCT-PRICE
                    REWRITE PRODUCT-RECORD
                       INVALID KEY 
                          DISPLAY 'INVALID'
                    END-REWRITE.
                       

              CLOSE PRODUCT-FILE.
              STOP RUN.
                


       
