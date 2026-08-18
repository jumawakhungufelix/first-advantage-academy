      *****************************************************************
      * PROGRAM:  MERGE-BANKING.CBL
      * PART A:   Merge NAIROBI-TXN.DAT and MOMBASA-TXN.DAT (both
      *           already sorted ACCOUNT-TYPE ascending, then BALANCE
      *           ascending within type) into COMBINED-TXN.DAT,
      *           preserving that order.
      *
      * Unlike a letter grade (A/B/C), ACCOUNT-TYPE here really does
      * sort correctly in plain alphabetical/ASCII order: CURRENT (C)
      * < FIXED (F) < SAVINGS (S), which is also the order the test
      * cases expect - so ASCENDING KEY on both fields is correct as
      * written, no inversion needed here.
      *
      * MERGE manages opening/closing NAIROBI-FILE, MOMBASA-FILE and
      * COMBINED-FILE internally via USING/GIVING - none of them are
      * OPENed or CLOSEd explicitly in this program. MERGE has no
      * INPUT PROCEDURE (SORT-only feature) - only USING and
      * GIVING/OUTPUT PROCEDURE are supported, so none is used here.
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MERGE-BANKING.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT NAIROBI-FILE ASSIGN TO "NAIROBI-TXN.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-NAIROBI-STATUS.

           SELECT MOMBASA-FILE ASSIGN TO "MOMBASA-TXN.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-MOMBASA-STATUS.

           SELECT COMBINED-FILE ASSIGN TO "COMBINED-TXN.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-COMBINED-STATUS.

           SELECT MERGE-WORK ASSIGN TO "MRGWK1"
               FILE STATUS IS WS-MERGE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  NAIROBI-FILE.
       01  NAIROBI-RECORD.
           05  NB-ACCT-NO          PIC X(5).
           05  NB-NAME             PIC X(20).
           05  NB-ACCT-TYPE        PIC X(8).
           05  NB-BALANCE          PIC 9(7)V99.

       FD  MOMBASA-FILE.
       01  MOMBASA-RECORD.
           05  MB-ACCT-NO          PIC X(5).
           05  MB-NAME             PIC X(20).
           05  MB-ACCT-TYPE        PIC X(8).
           05  MB-BALANCE          PIC 9(7)V99.

       FD  COMBINED-FILE.
       01  COMBINED-RECORD.
           05  CB-ACCT-NO          PIC X(5).
           05  CB-NAME             PIC X(20).
           05  CB-ACCT-TYPE        PIC X(8).
           05  CB-BALANCE          PIC 9(7)V99.

       SD  MERGE-WORK.
       01  MERGE-RECORD.
           05  MG-ACCT-NO          PIC X(5).
           05  MG-NAME             PIC X(20).
           05  MG-ACCT-TYPE        PIC X(8).
           05  MG-BALANCE          PIC 9(7)V99.

       WORKING-STORAGE SECTION.
      * FILE STATUS declared for every file used in this part, even
      * though MERGE opens all three internally - this program issues
      * no OPEN/READ/WRITE of its own against them.
       01  WS-NAIROBI-STATUS       PIC XX.
       01  WS-MOMBASA-STATUS       PIC XX.
       01  WS-COMBINED-STATUS      PIC XX.
       01  WS-MERGE-STATUS         PIC XX.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           MERGE MERGE-WORK
               ON ASCENDING KEY MG-ACCT-TYPE
               ON ASCENDING KEY MG-BALANCE
               USING NAIROBI-FILE, MOMBASA-FILE
               GIVING COMBINED-FILE.

           IF WS-MERGE-STATUS NOT = "00"
               DISPLAY "PART A: MERGE FAILED, FILE STATUS: "
                   WS-MERGE-STATUS
               MOVE 1 TO RETURN-CODE
           ELSE
               DISPLAY "PART A COMPLETE: COMBINED-TXN.DAT CREATED"
           END-IF.

           STOP RUN.
