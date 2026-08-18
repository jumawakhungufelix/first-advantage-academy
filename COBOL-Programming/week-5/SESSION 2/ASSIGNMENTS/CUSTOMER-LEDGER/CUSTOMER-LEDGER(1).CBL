      ******************************************************************
      * PROGRAM-ID   : CUSTOMER-LEDGER
      * PURPOSE      : Menu-driven Customer Ledger system, CRUD against
      *                an indexed file keyed on Customer ID, with full
      *                FILE STATUS handling on every I/O operation.
      * PHASE 2 DELIVERABLE - integrates EVALUATE, PERFORM UNTIL, and
      *                indexed file processing (Weeks 3-5).
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CUSTOMER-LEDGER.
       AUTHOR. FELIX.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTOMER-FILE ASSIGN TO "CUSTOMERS.DAT"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS CUST-ID
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  CUSTOMER-FILE.
       01  CUSTOMER-RECORD.
           05  CUST-ID              PIC X(5).
           05  CUST-NAME            PIC X(25).
           05  CUST-PHONE           PIC X(13).
           05  CUST-BALANCE         PIC 9(7)V99.

       WORKING-STORAGE SECTION.

      * ---------------------------------------------------------------
      * FILE STATUS AND ITS 88-LEVEL CONDITION NAMES
      * ---------------------------------------------------------------
       01  WS-FILE-STATUS           PIC XX.
           88  FS-SUCCESS                    VALUE "00".
           88  FS-NOT-FOUND                  VALUE "23".
           88  FS-DUPLICATE-KEY              VALUE "22".
           88  FS-FILE-NOT-FOUND             VALUE "35".

      * ---------------------------------------------------------------
      * MENU CONTROL
      * ---------------------------------------------------------------
       01  WS-MENU-CHOICE            PIC 9 VALUE 0.
       01  WS-CONTINUE-FLAG          PIC X VALUE "Y".
           88  WS-KEEP-LOOPING                VALUE "Y".
           88  WS-STOP-LOOPING                VALUE "N".

      * ---------------------------------------------------------------
      * WORKING FIELDS FOR RECORD ENTRY / DISPLAY
      * ---------------------------------------------------------------
       01  WS-SEARCH-ID              PIC X(5).
       01  WS-EDIT-BALANCE           PIC Z,ZZZ,ZZ9.99.
       01  WS-CONFIRM                PIC X VALUE SPACE.
           88  WS-CONFIRM-YES                 VALUE "Y" "y".
           88  WS-CONFIRM-NO                  VALUE "N" "n".

       01  WS-UPDATE-FIELD           PIC X VALUE SPACE.
       01  WS-NEW-BALANCE            PIC 9(7)V99.

       PROCEDURE DIVISION.

       000-MAIN.
           PERFORM 100-OPEN-FILE

           IF FS-SUCCESS
               PERFORM UNTIL WS-STOP-LOOPING
                   PERFORM 200-DISPLAY-MENU
                   PERFORM 300-PROCESS-CHOICE
               END-PERFORM
               PERFORM 900-CLOSE-FILE
           ELSE
               DISPLAY "Unable to open customer file. Program ending."
           END-IF

           STOP RUN.

      *----------------------------------------------------------------
      * 100-OPEN-FILE : open once at program start
      *----------------------------------------------------------------
       100-OPEN-FILE.
           OPEN I-O CUSTOMER-FILE
           EVALUATE TRUE
               WHEN FS-SUCCESS
                   CONTINUE
               WHEN FS-FILE-NOT-FOUND
                   DISPLAY "File not found - creating a new one."
                   CLOSE CUSTOMER-FILE
                   OPEN OUTPUT CUSTOMER-FILE
                   CLOSE CUSTOMER-FILE
                   OPEN I-O CUSTOMER-FILE
               WHEN OTHER
                   DISPLAY "ERROR opening file. FILE STATUS = "
                       WS-FILE-STATUS
           END-EVALUATE.

      *----------------------------------------------------------------
      * 200-DISPLAY-MENU : show the menu every time control returns
      *----------------------------------------------------------------
       200-DISPLAY-MENU.
           DISPLAY " "
           DISPLAY "===== CUSTOMER LEDGER ====="
           DISPLAY "1. Add customer"
           DISPLAY "2. Update customer"
           DISPLAY "3. Display customer"
           DISPLAY "4. Delete customer"
           DISPLAY "5. Exit"
           DISPLAY "============================"
           DISPLAY "Enter your choice: " WITH NO ADVANCING
           ACCEPT WS-MENU-CHOICE.

      *----------------------------------------------------------------
      * 300-PROCESS-CHOICE : route via EVALUATE
      *----------------------------------------------------------------
       300-PROCESS-CHOICE.
           EVALUATE WS-MENU-CHOICE
               WHEN 1
                   PERFORM 400-ADD-CUSTOMER
               WHEN 2
                   PERFORM 500-UPDATE-CUSTOMER
               WHEN 3
                   PERFORM 600-DISPLAY-CUSTOMER
               WHEN 4
                   PERFORM 700-DELETE-CUSTOMER
               WHEN 5
                   SET WS-STOP-LOOPING TO TRUE
                   DISPLAY "Exiting Customer Ledger. Goodbye."
               WHEN OTHER
                   DISPLAY "Invalid choice - please enter 1-5."
           END-EVALUATE.

      *----------------------------------------------------------------
      * 400-ADD-CUSTOMER
      *----------------------------------------------------------------
       400-ADD-CUSTOMER.
           DISPLAY " "
           DISPLAY "--- Add Customer ---"
           DISPLAY "Enter Customer ID (5 chars): " WITH NO ADVANCING
           ACCEPT CUST-ID
           DISPLAY "Enter Customer Name: " WITH NO ADVANCING
           ACCEPT CUST-NAME
           DISPLAY "Enter Phone Number: " WITH NO ADVANCING
           ACCEPT CUST-PHONE
           DISPLAY "Enter Starting Balance: " WITH NO ADVANCING
           ACCEPT CUST-BALANCE

           WRITE CUSTOMER-RECORD
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-WRITE

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   DISPLAY "Customer added successfully."
               WHEN FS-DUPLICATE-KEY
                   DISPLAY "ID already in use - customer not added."
               WHEN OTHER
                   DISPLAY "Unexpected error adding customer. "
                       "FILE STATUS = " WS-FILE-STATUS
           END-EVALUATE.

      *----------------------------------------------------------------
      * 500-UPDATE-CUSTOMER
      *----------------------------------------------------------------
       500-UPDATE-CUSTOMER.
           DISPLAY " "
           DISPLAY "--- Update Customer ---"
           DISPLAY "Enter Customer ID to update: " WITH NO ADVANCING
           ACCEPT CUST-ID

           READ CUSTOMER-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-READ

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   DISPLAY "Current details:"
                   DISPLAY "  Name   : " CUST-NAME
                   DISPLAY "  Phone  : " CUST-PHONE
                   MOVE CUST-BALANCE TO WS-EDIT-BALANCE
                   DISPLAY "  Balance: " WS-EDIT-BALANCE

                   DISPLAY "Change name? (Y/N): " WITH NO ADVANCING
                   ACCEPT WS-UPDATE-FIELD
                   IF WS-UPDATE-FIELD = "Y" OR WS-UPDATE-FIELD = "y"
                       DISPLAY "New Name: " WITH NO ADVANCING
                       ACCEPT CUST-NAME
                   END-IF

                   DISPLAY "Change phone? (Y/N): " WITH NO ADVANCING
                   ACCEPT WS-UPDATE-FIELD
                   IF WS-UPDATE-FIELD = "Y" OR WS-UPDATE-FIELD = "y"
                       DISPLAY "New Phone: " WITH NO ADVANCING
                       ACCEPT CUST-PHONE
                   END-IF

                   DISPLAY "Change balance? (Y/N): " WITH NO ADVANCING
                   ACCEPT WS-UPDATE-FIELD
                   IF WS-UPDATE-FIELD = "Y" OR WS-UPDATE-FIELD = "y"
                       DISPLAY "New Balance: " WITH NO ADVANCING
                       ACCEPT CUST-BALANCE
                   END-IF

                   REWRITE CUSTOMER-RECORD
                       INVALID KEY
                           CONTINUE
                       NOT INVALID KEY
                           CONTINUE
                   END-REWRITE

                   EVALUATE TRUE
                       WHEN FS-SUCCESS
                           DISPLAY "Customer updated successfully."
                       WHEN OTHER
                           DISPLAY "Unexpected error updating "
                               "customer. FILE STATUS = "
                               WS-FILE-STATUS
                   END-EVALUATE

               WHEN FS-NOT-FOUND
                   DISPLAY "Customer not found - nothing updated."
               WHEN OTHER
                   DISPLAY "Unexpected error reading customer. "
                       "FILE STATUS = " WS-FILE-STATUS
           END-EVALUATE.

      *----------------------------------------------------------------
      * 600-DISPLAY-CUSTOMER
      *----------------------------------------------------------------
       600-DISPLAY-CUSTOMER.
           DISPLAY " "
           DISPLAY "--- Display Customer ---"
           DISPLAY "Enter Customer ID: " WITH NO ADVANCING
           ACCEPT CUST-ID

           READ CUSTOMER-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-READ

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   MOVE CUST-BALANCE TO WS-EDIT-BALANCE
                   DISPLAY "Customer ID : " CUST-ID
                   DISPLAY "Name        : " CUST-NAME
                   DISPLAY "Phone       : " CUST-PHONE
                   DISPLAY "Balance     : " WS-EDIT-BALANCE
               WHEN FS-NOT-FOUND
                   DISPLAY "Customer not found."
               WHEN OTHER
                   DISPLAY "Unexpected error reading customer. "
                       "FILE STATUS = " WS-FILE-STATUS
           END-EVALUATE.

      *----------------------------------------------------------------
      * 700-DELETE-CUSTOMER
      *----------------------------------------------------------------
       700-DELETE-CUSTOMER.
           DISPLAY " "
           DISPLAY "--- Delete Customer ---"
           DISPLAY "Enter Customer ID to delete: " WITH NO ADVANCING
           ACCEPT CUST-ID

           READ CUSTOMER-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-READ

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   MOVE CUST-BALANCE TO WS-EDIT-BALANCE
                   DISPLAY "Customer found:"
                   DISPLAY "  Name   : " CUST-NAME
                   DISPLAY "  Phone  : " CUST-PHONE
                   DISPLAY "  Balance: " WS-EDIT-BALANCE
                   DISPLAY "Confirm deletion? (Y/N): "
                       WITH NO ADVANCING
                   ACCEPT WS-CONFIRM

                   EVALUATE TRUE
                       WHEN WS-CONFIRM-YES
                           DELETE CUSTOMER-FILE
                               INVALID KEY
                                   CONTINUE
                               NOT INVALID KEY
                                   CONTINUE
                           END-DELETE

                           EVALUATE TRUE
                               WHEN FS-SUCCESS
                                   DISPLAY "Customer deleted "
                                       "successfully."
                               WHEN OTHER
                                   DISPLAY "Unexpected error "
                                       "deleting customer. "
                                       "FILE STATUS = "
                                       WS-FILE-STATUS
                           END-EVALUATE

                       WHEN WS-CONFIRM-NO
                           DISPLAY "Deletion cancelled - no "
                               "changes made."
                       WHEN OTHER
                           DISPLAY "Unrecognised response - "
                               "deletion cancelled."
                   END-EVALUATE

               WHEN FS-NOT-FOUND
                   DISPLAY "Customer not found - nothing to "
                       "delete."
               WHEN OTHER
                   DISPLAY "Unexpected error reading customer. "
                       "FILE STATUS = " WS-FILE-STATUS
           END-EVALUATE.

      *----------------------------------------------------------------
      * 900-CLOSE-FILE : close once, just before STOP RUN
      *----------------------------------------------------------------
       900-CLOSE-FILE.
           CLOSE CUSTOMER-FILE.
