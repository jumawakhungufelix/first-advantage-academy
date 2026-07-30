       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXAMPLE.

       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRODUCT-FILE ASSIGN TO 'PRODUCT.DAT'
           ORGANIZATION IS INDEXED 
           ACCESS MODE IS RANDOM
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

       PROCEDURE DIVISION.
           MOVE WS-SEARCH-CODE TO PRODUCT-CODE.
           
           OPEN INPUT PRODUCT-FILE
           READ PRODUCT-FILE
              INVALID KEY 
                 DISPLAY 'Product not found'
              NOT INVALID KEY
                 DISPLAY ' ' PRODUCT-PRICE " " PROD-QTY
           END-READ.
           CLOSE PRODUCT-FILE.


