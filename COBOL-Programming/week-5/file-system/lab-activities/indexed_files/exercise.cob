       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXAMPLE.

       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRODUCT-FILE ASSIGN TO 'PRODUCT.DAT'
           ORGANIZATION IS INDEXED 
           ACCESS MODE IS DYNAMIC
           RECORD KEY IS PRODUCT-CODE
           FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION. 
       FILE SECTION. 
       FD PRODUCT-FILE.
       01 PRODUCT-RECORD.
           05 PRODUCT-CODE      PIC X(4).
           05 PRODUCT-NAME      PIC X(20).
           05 PRODUCT-PRICE     PIC 9(5)V99.
           05 PROD-QTY          PIC 9(3).
           

       WORKING-STORAGE SECTION. 
       01 WS-FILE-STATUS           PIC XX.
       01 WS-SEARCH-CODE           PIC X(4).
       

       01 WS-PRODUCT-DATA          OCCURS 3 TIMES 
                                INDEXED BY WS-INDEX .
           05 WS-PRODUCT-CODE         PIC X(4).
           05 WS-PRODUCT-NAME         PIC X(20).
           05 WS-PRODUCT-PRICE        PIC 9(5)V99.
           05 WS-PROD-QTY             PIC X(3).

       PROCEDURE DIVISION.
           
           
           OPEN OUTPUT PRODUCT-FILE
           DISPLAY 'FILE STATUS= 'WS-FILE-STATUS
           
           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 3
           DISPLAY 'Enter product Code: ' WITH NO ADVANCING 
           ACCEPT WS-PRODUCT-CODE(WS-INDEX)
           DISPLAY 'Enter product name: ' WITH NO ADVANCING 
           ACCEPT WS-PRODUCT-NAME(WS-INDEX)
           DISPLAY 'Enter product price: ' WITH NO ADVANCING 
           ACCEPT WS-PRODUCT-PRICE(WS-INDEX)
           DISPLAY 'Enter quantity: ' WITH NO ADVANCING 
           ACCEPT WS-PROD-QTY(WS-INDEX)

           
           END-PERFORM

           CLOSE PRODUCT-FILE

           OPEN I-O PRODUCT-FILE

           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 3
           MOVE WS-PRODUCT-CODE(WS-INDEX) TO PRODUCT-CODE
           MOVE WS-PRODUCT-NAME(WS-INDEX) TO PRODUCT-NAME
           MOVE WS-PRODUCT-PRICE(WS-INDEX) TO PRODUCT-PRICE
           MOVE WS-PROD-QTY(WS-INDEX) TO PROD-QTY

           
           WRITE PRODUCT-RECORD
              INVALID KEY
                 DISPLAY 'Duplicate key not added'
              NOT INVALID
                 DISPLAY 'Records added successfyly'
           END-WRITE

           DISPLAY 'FILE STATUS: ' WS-FILE-STATUS

         

           
           END-PERFORM
           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 3
             DISPLAY WS-PRODUCT-CODE(WS-INDEX)  ' ' 
             WS-PRODUCT-NAME(WS-INDEX)
           END-PERFORM

           DISPLAY 'Enter product code to search: ' WITH NO ADVANCING 
           ACCEPT WS-SEARCH-CODE
           MOVE WS-SEARCH-CODE TO PRODUCT-CODE.

           READ PRODUCT-FILE
              INVALID KEY 
                 DISPLAY 'Product not found'WS-SEARCH-CODE
                  WITH NO ADVANCING 

              NOT INVALID KEY
                 DISPLAY ' ' PRODUCT-PRICE " " PROD-QTY 
                 WITH NO ADVANCING 
           END-READ.
           DISPLAY 'fILE STATUS: 'WS-FILE-STATUS
           CLOSE PRODUCT-FILE.
