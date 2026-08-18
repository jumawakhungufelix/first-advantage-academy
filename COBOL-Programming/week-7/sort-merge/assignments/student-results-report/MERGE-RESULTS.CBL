      *****************************************************************
      * PROGRAM:  MERGE-RESULTS.CBL
      * PART B:   Merge RANKED.DAT (sorted output of Part A) with
      *           RESIT-RESULTS.DAT (already sorted on the same keys)
      *           into COMBINED.DAT, preserving GRADE descending /
      *           MARKS descending order throughout.
      *
      * MERGE trusts that both input files are already sorted on the
      * merge keys - it does not sort them and gives no warning if
      * they are not. RANKED.DAT must be verified correct (Part A's
      * test cases 1-2) before running this program.
      *
      * MERGE does NOT support INPUT PROCEDURE (only SORT does), so no
      * filtering/transform logic is attempted here.
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MERGE-RESULTS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT RANKED-FILE ASSIGN TO "RANKED.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-RANKED-STATUS.

           SELECT RESIT-FILE ASSIGN TO "RESIT-RESULTS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-RESIT-STATUS.

           SELECT COMBINED-FILE ASSIGN TO "COMBINED.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-COMBINED-STATUS.

           SELECT MERGE-WORK ASSIGN TO "MRGWK1"
               FILE STATUS IS WS-MERGE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  RANKED-FILE.
       01  RANKED-RECORD.
           05  RK-NAME             PIC X(20).
           05  RK-GRADE            PIC X.
           05  RK-MARKS            PIC 9(3).

       FD  RESIT-FILE.
       01  RESIT-RECORD.
           05  RS-NAME             PIC X(20).
           05  RS-GRADE            PIC X.
           05  RS-MARKS            PIC 9(3).

       FD  COMBINED-FILE.
       01  COMBINED-RECORD.
           05  CB-NAME             PIC X(20).
           05  CB-GRADE            PIC X.
           05  CB-MARKS            PIC 9(3).

       SD  MERGE-WORK.
       01  MERGE-RECORD.
           05  MG-NAME             PIC X(20).
           05  MG-GRADE            PIC X.
           05  MG-MARKS            PIC 9(3).

       WORKING-STORAGE SECTION.
      * FILE STATUS declared for every file used in this part, even
      * though MERGE opens RANKED-FILE/RESIT-FILE/COMBINED-FILE
      * internally - this program issues no OPEN/READ/WRITE of its
      * own against them.
       01  WS-RANKED-STATUS        PIC XX.
       01  WS-RESIT-STATUS         PIC XX.
       01  WS-COMBINED-STATUS      PIC XX.
       01  WS-MERGE-STATUS         PIC XX.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
      * Key directions must mirror Part A's SORT exactly (see the
      * note in SORT-RESULTS.CBL): ASCENDING on GRADE gives
      * A-before-B-before-C; DESCENDING on MARKS gives highest marks
      * first within a grade. MERGE requires both input files to
      * already be ordered this way - RANKED.DAT and
      * RESIT-RESULTS.DAT both are.
           MERGE MERGE-WORK
               ON ASCENDING KEY MG-GRADE
               ON DESCENDING KEY MG-MARKS
               USING RANKED-FILE, RESIT-FILE
               GIVING COMBINED-FILE.

           IF WS-MERGE-STATUS NOT = "00"
               DISPLAY "PART B: MERGE FAILED, FILE STATUS: "
                   WS-MERGE-STATUS
               MOVE 1 TO RETURN-CODE
           ELSE
               DISPLAY "PART B COMPLETE: COMBINED.DAT CREATED"
           END-IF.

           STOP RUN.
