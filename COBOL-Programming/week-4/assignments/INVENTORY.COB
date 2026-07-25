       IDENTIFICATION DIVISION.
       PROGRAM-ID. INVENTORY.
       AUTHOR FELIX-JUMA.

       DATA DIVISION. 
       WORKING-STORAGE SECTION. 
       01 WS-INVENTORY-RECORD.
           05 WS-PRODUCT-DATA             OCCURS 10 TIMES
                                            INDEXED BY WS-INDEX.
              10 WS-CODE          PIC X(4).
              10 WS-NAME          PIC X(20).
              10 WS-PRICE         PIC 9(5)V99.
              10 WS-QTY           PIC 999.
              10 WS-VALUE         PIC 9(8)V99.
       01 WS-COUNT                PIC 999 VALUE 1.
       01 WS-TOTAL-VALUE          PIC 9(9)V99 VALUE ZERO.
       01 WS-PARTITIONER          PIC X(60)    VALUE ALL '='.
       01 WS-SINGLE-PARTITIONER   PIC X(60)   VALUE ALL '-'.
       01 WS-SEARCH-CODE          PIC X(4).
       01 WS-CHOICE                PIC 9. 
       01 WS-NEW-SEARCH-CODE       PIC X(4).
       01 WS-USER-CONTINUE-CHOICE     PIC X VALUE 'Y'.



       PROCEDURE DIVISION.
          
           
           PERFORM VARYING WS-COUNT FROM 1 BY 1 UNTIL WS-COUNT > 10
              DISPLAY 'Enter product code: '
              ACCEPT WS-CODE(WS-COUNT)
              DISPLAY 'Enter product name: '
              ACCEPT WS-NAME(WS-COUNT)
              DISPLAY 'Enter product price: '
              ACCEPT WS-PRICE(WS-COUNT)
              DISPLAY 'Enter quantity in stock: '
              ACCEPT WS-QTY(WS-COUNT)
           END-PERFORM.

          

           DISPLAY WS-PARTITIONER.
           DISPLAY '        ---------------STOCK REPORT--------------'.
           DISPLAY WS-PARTITIONER.

           DISPLAY 'CODE     NAME              PRICE      QTY    VALUE'.
           DISPLAY WS-SINGLE-PARTITIONER.
           PERFORM VARYING WS-COUNT FROM 1 BY 1 UNTIL WS-COUNT > 10
               COMPUTE WS-VALUE(WS-COUNT)  = WS-QTY(WS-COUNT)
               * WS-PRICE(WS-COUNT)
              ADD WS-VALUE(WS-COUNT) TO WS-TOTAL-VALUE
              DISPLAY WS-CODE(WS-COUNT) '  ' WS-NAME(WS-COUNT)
              '      ' WS-PRICE(WS-COUNT) '  ' WS-QTY(WS-COUNT) 
                    '  ' WS-VALUE(WS-COUNT)
              END-PERFORM.
           DISPLAY WS-SINGLE-PARTITIONER.
           DISPLAY 'TOTAL INVENTORY VALUE:             ' WS-TOTAL-VALUE.
           DISPLAY WS-PARTITIONER.

           DISPLAY 'Enter 1 TO SEARCH AND 2 TO END PROGRAM: '.
           ACCEPT WS-CHOICE.


           IF WS-CHOICE = 2
              DISPLAY 'PROGRAM TERMINATED'
              STOP RUN
           ELSE
              IF WS-CHOICE = 1
                 
                 PERFORM UNTIL WS-USER-CONTINUE-CHOICE = 'N'
                    DISPLAY
                     'Confirm choice to continue search  Y or to stop N'
                    ACCEPT WS-USER-CONTINUE-CHOICE 
                    
                    
                    IF WS-USER-CONTINUE-CHOICE = 'N'
                       MOVE 'N' TO WS-USER-CONTINUE-CHOICE
                       DISPLAY 'PROGRAM TERMINATED'
                       STOP RUN
                       
                    ELSE
                        DISPLAY 'Enter Item code to search: '
                        ACCEPT WS-SEARCH-CODE
                  
                       SET WS-INDEX TO 1
                       SEARCH WS-PRODUCT-DATA 
                       AT END
                         DISPLAY 'PRODUCT NOT FOUND FROM LIST '
                                 
  
                       WHEN WS-CODE(WS-INDEX) = WS-SEARCH-CODE
                       DISPLAY WS-PARTITIONER

                        DISPLAY 'PRODUCT FOUND AT POSITION 'WS-INDEX
                        DISPLAY WS-SINGLE-PARTITIONER
                        DISPLAY  'Product code :' WS-CODE(WS-INDEX)
                        DISPLAY 'Product name  : ' WS-NAME(WS-INDEX)
                        DISPLAY 'Product price : ' WS-PRICE(WS-INDEX)
                        DISPLAY 'Stock value   : 'WS-VALUE(WS-INDEX)
                        DISPLAY WS-PARTITIONER
                        DISPLAY 'Continue searching (Y/N)'
                        ACCEPT WS-USER-CONTINUE-CHOICE
 
                       ADD 1 TO WS-INDEX
                    

                    END-SEARCH
                    END-IF
                 END-PERFORM
                 END-IF
              END-IF.
                       
                    
           STOP RUN.
