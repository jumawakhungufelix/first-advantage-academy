       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRODUCT-LOOKUP.


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
           05 PRODUCT-CODE               PIC X(4).
           05 PRODUCT-NAME                PIC X(20).
           05 PRODUCT-PRICE               PIC 9(5)V99.
           05 PRODUCT-QUANTITY            PIC 9(5).
           05 PRODUCT-ACTIVE-FLAG         PIC X VALUE 'A'.
      *        'A' = active, 'D' = discontinued (soft delete)

       WORKING-STORAGE SECTION.

      *--- FILE STATUS and its 88-level condition names --------
       01 WS-FILE-STATUS                 PIC XX.
           88 FS-SUCCESS                  VALUE "00".
           88 FS-NOT-FOUND                 VALUE "23".
           88 FS-DUPLICATE-KEY             VALUE "22".
           88 FS-FILE-NOT-FOUND            VALUE "35".

       01 WS-MENU-CHOICE                 PIC 9.
       01 WS-CONTINUE-FLAG               PIC X VALUE 'Y'.

      * NOTE: this was PIC X(40) in the original program, which
      * did not match PRODUCT-CODE's PIC X(4) - fixed to X(4).
       01 WS-SEARCH-CODE                 PIC X(4).
       01 WS-SEARCH-PRICE                PIC 9(5)V99.
       01 WS-SEARCH-QUANTITY             PIC 9(5).

       01 WS-PARTITIONER                 PIC X(50) VALUE ALL '-'.

       PROCEDURE DIVISION.

       MAIN-LOGIC.
           OPEN I-O PRODUCT-FILE

      * An OPEN failure is fatal - end cleanly before the menu
      * ever runs, instead of letting a missing file surface as
      * a confusing crash on the first READ.
           EVALUATE TRUE
              WHEN FS-SUCCESS
                 CONTINUE
              WHEN FS-FILE-NOT-FOUND
                 DISPLAY WS-PARTITIONER
                 DISPLAY 'ERROR: Product file could not be found.'
                 DISPLAY 'Cannot continue - ending program.'
                 DISPLAY WS-PARTITIONER
                 STOP RUN
              WHEN OTHER
                 DISPLAY 'UNEXPECTED FILE ERROR ON OPEN. '
                    'FILE STATUS = ' WS-FILE-STATUS
                 DISPLAY 'Cannot continue - ending program.'
                 STOP RUN
           END-EVALUATE

           PERFORM UNTIL WS-CONTINUE-FLAG = 'N'
              DISPLAY WS-PARTITIONER
              DISPLAY '1. Add product'
              DISPLAY '2. Look up product'
              DISPLAY '3. Update price / quantity'
              DISPLAY '4. Discontinue product'
              DISPLAY '5. Exit'
              DISPLAY 'Enter choice: '
              ACCEPT WS-MENU-CHOICE

              EVALUATE WS-MENU-CHOICE
                 WHEN 1 PERFORM ADD-PRODUCT
                 WHEN 2 PERFORM LOOKUP-PRODUCT
                 WHEN 3 PERFORM UPDATE-PRODUCT
                 WHEN 4 PERFORM DISCONTINUE-PRODUCT
                 WHEN 5 MOVE 'N' TO WS-CONTINUE-FLAG
                 WHEN OTHER
                    DISPLAY 'Invalid menu choice, try again.'
              END-EVALUATE
           END-PERFORM

           CLOSE PRODUCT-FILE
           STOP RUN.

      *---------------------------------------------------------
       ADD-PRODUCT.
           DISPLAY 'ENTER CODE: '
           ACCEPT PRODUCT-CODE
           DISPLAY 'ENTER NAME: '
           ACCEPT PRODUCT-NAME
           DISPLAY 'PRODUCT PRICE: '
           ACCEPT PRODUCT-PRICE
           DISPLAY 'QUANTITY: '
           ACCEPT PRODUCT-QUANTITY
           MOVE 'A' TO PRODUCT-ACTIVE-FLAG

           WRITE PRODUCT-RECORD
              INVALID KEY
                 CONTINUE
              NOT INVALID KEY
                 CONTINUE
           END-WRITE

           EVALUATE TRUE
              WHEN FS-SUCCESS
                 DISPLAY 'Product added successfully.'
              WHEN FS-DUPLICATE-KEY
                 DISPLAY 'Cannot add: product code is already '
                    'in use.'
              WHEN OTHER
                 DISPLAY 'UNEXPECTED FILE ERROR ON ADD. '
                    'FILE STATUS = ' WS-FILE-STATUS
           END-EVALUATE.

      *---------------------------------------------------------
       LOOKUP-PRODUCT.
           DISPLAY 'Enter product code to search: '
           ACCEPT WS-SEARCH-CODE
           MOVE WS-SEARCH-CODE TO PRODUCT-CODE

           READ PRODUCT-FILE
              INVALID KEY
                 CONTINUE
              NOT INVALID KEY
                 CONTINUE
           END-READ

           EVALUATE TRUE
              WHEN FS-SUCCESS
                 DISPLAY 'PRODUCT CODE : ' PRODUCT-CODE
                 DISPLAY 'PRODUCT NAME : ' PRODUCT-NAME
                 DISPLAY 'PRODUCT PRICE: ' PRODUCT-PRICE
                 DISPLAY 'PRODUCT QTY  : ' PRODUCT-QUANTITY
              WHEN FS-NOT-FOUND
                 DISPLAY 'PRODUCT NOT FOUND: no record exists '
                    'for code ' WS-SEARCH-CODE
              WHEN OTHER
                 DISPLAY 'UNEXPECTED FILE ERROR ON LOOKUP. '
                    'FILE STATUS = ' WS-FILE-STATUS
           END-EVALUATE.

      *---------------------------------------------------------
       UPDATE-PRODUCT.
           DISPLAY 'ENTER PRODUCT CODE TO REWRITE: '
           ACCEPT WS-SEARCH-CODE
           MOVE WS-SEARCH-CODE TO PRODUCT-CODE

           READ PRODUCT-FILE
              INVALID KEY
                 CONTINUE
              NOT INVALID KEY
                 CONTINUE
           END-READ

           EVALUATE TRUE
              WHEN FS-SUCCESS
                 DISPLAY 'ENTER NEW PRICE: '
                 ACCEPT WS-SEARCH-PRICE
                 MOVE WS-SEARCH-PRICE TO PRODUCT-PRICE

                 DISPLAY 'ENTER NEW QUANTITY: '
                 ACCEPT WS-SEARCH-QUANTITY
                 MOVE WS-SEARCH-QUANTITY TO PRODUCT-QUANTITY

                 REWRITE PRODUCT-RECORD
                    INVALID KEY
                       CONTINUE
                    NOT INVALID KEY
                       CONTINUE
                 END-REWRITE

                 EVALUATE TRUE
                    WHEN FS-SUCCESS
                       DISPLAY 'Product updated successfully.'
                    WHEN FS-NOT-FOUND
                       DISPLAY 'Product not found during update '
                          '(record changed by another process).'
                    WHEN OTHER
                       DISPLAY 'UNEXPECTED FILE ERROR ON '
                          'REWRITE. FILE STATUS = '
                          WS-FILE-STATUS
                 END-EVALUATE

              WHEN FS-NOT-FOUND
                 DISPLAY 'PRODUCT NOT FOUND: nothing to update '
                    'for code ' WS-SEARCH-CODE
              WHEN OTHER
                 DISPLAY 'UNEXPECTED FILE ERROR ON READ. '
                    'FILE STATUS = ' WS-FILE-STATUS
           END-EVALUATE.

      *---------------------------------------------------------
       DISCONTINUE-PRODUCT.
           DISPLAY 'ENTER PRODUCT CODE TO DISCONTINUE: '
           ACCEPT WS-SEARCH-CODE
           MOVE WS-SEARCH-CODE TO PRODUCT-CODE

           READ PRODUCT-FILE
              INVALID KEY
                 CONTINUE
              NOT INVALID KEY
                 CONTINUE
           END-READ

           EVALUATE TRUE
              WHEN FS-SUCCESS
                 MOVE 'D' TO PRODUCT-ACTIVE-FLAG

                 REWRITE PRODUCT-RECORD
                    INVALID KEY
                       CONTINUE
                    NOT INVALID KEY
                       CONTINUE
                 END-REWRITE

                 EVALUATE TRUE
                    WHEN FS-SUCCESS
                       DISPLAY 'Product discontinued '
                          'successfully.'
                    WHEN FS-NOT-FOUND
                       DISPLAY 'Product not found during '
                          'discontinue (record changed by '
                          'another process).'
                    WHEN OTHER
                       DISPLAY 'UNEXPECTED FILE ERROR ON '
                          'DISCONTINUE. FILE STATUS = '
                          WS-FILE-STATUS
                 END-EVALUATE

              WHEN FS-NOT-FOUND
                 DISPLAY 'PRODUCT NOT FOUND: nothing to '
                    'discontinue for code ' WS-SEARCH-CODE
              WHEN OTHER
                 DISPLAY 'UNEXPECTED FILE ERROR ON READ. '
                    'FILE STATUS = ' WS-FILE-STATUS
           END-EVALUATE.