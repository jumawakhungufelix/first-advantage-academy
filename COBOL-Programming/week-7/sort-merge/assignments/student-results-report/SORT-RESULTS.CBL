      *****************************************************************
      * PROGRAM:  SORT-RESULTS.CBL
      * PART A:   Sort RESULTS.DAT by GRADE descending, then MARKS
      *           descending within grade, writing RANKED.DAT.
      *
      * SORT manages the opening/closing of RESULTS-FILE and
      * RANKED-FILE internally via USING/GIVING - they are never
      * OPENed or CLOSEd explicitly in this program.
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SORT-RESULTS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT RESULTS-FILE ASSIGN TO "RESULTS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-RESULTS-STATUS.

           SELECT RANKED-FILE ASSIGN TO "RANKED.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-RANKED-STATUS.

           SELECT SORT-WORK ASSIGN TO "SORTWK1"
               FILE STATUS IS WS-SORT-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  RESULTS-FILE.
       01  RESULTS-RECORD.
           05  RF-NAME             PIC X(20).
           05  RF-GRADE            PIC X.
           05  RF-MARKS            PIC 9(3).

       FD  RANKED-FILE.
       01  RANKED-RECORD.
           05  RK-NAME             PIC X(20).
           05  RK-GRADE            PIC X.
           05  RK-MARKS            PIC 9(3).

       SD  SORT-WORK.
       01  SORT-RECORD.
           05  SR-NAME             PIC X(20).
           05  SR-GRADE            PIC X.
           05  SR-MARKS            PIC 9(3).

       WORKING-STORAGE SECTION.
      * FILE STATUS fields declared for every file used in this part,
      * per the technical requirements - even though SORT opens
      * RESULTS-FILE/RANKED-FILE internally and this program does not
      * issue its own OPEN/READ/WRITE against them.
       01  WS-RESULTS-STATUS       PIC XX.
       01  WS-RANKED-STATUS        PIC XX.
       01  WS-SORT-STATUS          PIC XX.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
      * NOTE ON KEY DIRECTION: the brief's business definition is
      * "GRADE descending (A before B before C)". A is the ASCII
      * value 65, C is 67 - so a literal ON DESCENDING KEY SR-GRADE
      * sorts on ASCII value and puts C-grade students FIRST, which
      * fails test case 1 ("RANKED.DAT begins with all A-grade
      * students"). Since A < B < C alphabetically, ASCENDING key on
      * SR-GRADE is what actually produces A-before-B-before-C. Marks
      * genuinely are descending (highest first), so that key stays
      * DESCENDING. Always verify against the stated test cases
      * rather than a key-direction word in isolation.
           SORT SORT-WORK
               ON ASCENDING KEY SR-GRADE
               ON DESCENDING KEY SR-MARKS
               USING RESULTS-FILE
               GIVING RANKED-FILE.

           IF WS-SORT-STATUS NOT = "00"
               DISPLAY "PART A: SORT FAILED, FILE STATUS: "
                   WS-SORT-STATUS
               MOVE 1 TO RETURN-CODE
           ELSE
               DISPLAY "PART A COMPLETE: RANKED.DAT CREATED"
           END-IF.

           STOP RUN.
