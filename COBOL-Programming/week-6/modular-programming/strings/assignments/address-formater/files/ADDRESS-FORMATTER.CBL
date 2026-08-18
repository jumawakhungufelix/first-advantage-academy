      ******************************************************************
      * PROGRAM-ID   : ADDRESS-FORMATTER
      * PURPOSE      : Read raw, messy address lines from ADDRESSES.DAT,
      *                clean/title-case the street and city, validate
      *                the postal code, and write one formatted record
      *                per input line to CLEAN-ADDRESSES.DAT.
      * WEEK 6, SESSION 1 - STRING/UNSTRING, intrinsic functions, and
      *                the AT END/NOT AT END sequential file pattern.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ADDRESS-FORMATTER.
       AUTHOR. FELIX.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ADDRESS-FILE ASSIGN TO "ADDRESSES.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT CLEAN-ADDRESS-FILE ASSIGN TO "CLEAN-ADDRESSES.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  ADDRESS-FILE.
       01  ADDRESS-RECORD               PIC X(60).

       FD  CLEAN-ADDRESS-FILE.
       01  CLEAN-ADDRESS-RECORD         PIC X(80).

       WORKING-STORAGE SECTION.

       01  WS-EOF-FLAG                  PIC X VALUE "N".
           88  WS-EOF                          VALUE "Y".

      * ---------------------------------------------------------------
      * RAW FIELDS - split out of the incoming comma-separated line
      * ---------------------------------------------------------------
       01  WS-RAW-STREET                PIC X(30).
       01  WS-RAW-CITY                  PIC X(20).
       01  WS-RAW-POSTAL                PIC X(6).

      * ---------------------------------------------------------------
      * SCRATCH FIELDS USED BY THE WORD-SPLIT / TITLE-CASE ROUTINES
      * ---------------------------------------------------------------
       01  WS-TRIMMED                   PIC X(30).
       01  WS-WORD-1                    PIC X(15).
       01  WS-WORD-2                    PIC X(15).
       01  WS-WORD-3                    PIC X(15).
       01  WS-WORD-4                    PIC X(15).

      * ---------------------------------------------------------------
      * CLEANED / VALIDATED OUTPUT FIELDS
      * ---------------------------------------------------------------
       01  WS-CLEAN-STREET              PIC X(40).
       01  WS-CLEAN-CITY                PIC X(40).
       01  WS-POSTAL-LEN                PIC 9(2).
       01  WS-STATUS                    PIC X(7).

      * ---------------------------------------------------------------
      * STRETCH GOAL - running VALID/INVALID counters
      * ---------------------------------------------------------------
       01  WS-VALID-COUNT               PIC 9(4) VALUE 0.
       01  WS-INVALID-COUNT             PIC 9(4) VALUE 0.

       PROCEDURE DIVISION.

       MAIN-LOGIC.
           OPEN INPUT  ADDRESS-FILE
           OPEN OUTPUT CLEAN-ADDRESS-FILE

           PERFORM UNTIL WS-EOF
               READ ADDRESS-FILE
                   AT END
                       SET WS-EOF TO TRUE
                   NOT AT END
                      *> Split the raw line into its 3 comma-delimited
                      *> fields: street, city, postal code.
                       UNSTRING ADDRESS-RECORD DELIMITED BY ","
                           INTO WS-RAW-STREET,
                                WS-RAW-CITY,
                                WS-RAW-POSTAL
                       END-UNSTRING

                       PERFORM CLEAN-STREET
                       PERFORM CLEAN-CITY
                       PERFORM VALIDATE-POSTAL-CODE
                       PERFORM WRITE-CLEAN-RECORD
               END-READ
           END-PERFORM

           CLOSE ADDRESS-FILE, CLEAN-ADDRESS-FILE

           DISPLAY "Processing complete."
           DISPLAY "Valid records   : " WS-VALID-COUNT
           DISPLAY "Invalid records : " WS-INVALID-COUNT

           STOP RUN.

      *----------------------------------------------------------------
      * CLEAN-STREET - trim, split into words, title-case each word,
      * rebuild single-spaced. Handles up to 4 words.
      *----------------------------------------------------------------
       CLEAN-STREET.
           MOVE FUNCTION TRIM(WS-RAW-STREET) TO WS-TRIMMED
           MOVE SPACES TO WS-WORD-1 WS-WORD-2 WS-WORD-3 WS-WORD-4

           UNSTRING WS-TRIMMED DELIMITED BY ALL SPACE
               INTO WS-WORD-1, WS-WORD-2, WS-WORD-3, WS-WORD-4
           END-UNSTRING

           IF WS-WORD-1 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-1) TO WS-WORD-1
               MOVE FUNCTION UPPER-CASE(WS-WORD-1(1:1))
                   TO WS-WORD-1(1:1)
           END-IF

           IF WS-WORD-2 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-2) TO WS-WORD-2
               MOVE FUNCTION UPPER-CASE(WS-WORD-2(1:1))
                   TO WS-WORD-2(1:1)
           END-IF

           IF WS-WORD-3 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-3) TO WS-WORD-3
               MOVE FUNCTION UPPER-CASE(WS-WORD-3(1:1))
                   TO WS-WORD-3(1:1)
           END-IF

           IF WS-WORD-4 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-4) TO WS-WORD-4
               MOVE FUNCTION UPPER-CASE(WS-WORD-4(1:1))
                   TO WS-WORD-4(1:1)
           END-IF

           MOVE SPACES TO WS-CLEAN-STREET

           STRING WS-WORD-1 DELIMITED BY SPACE
                  " "       DELIMITED BY SIZE
                  WS-WORD-2 DELIMITED BY SPACE
                  " "       DELIMITED BY SIZE
                  WS-WORD-3 DELIMITED BY SPACE
                  " "       DELIMITED BY SIZE
                  WS-WORD-4 DELIMITED BY SPACE
               INTO WS-CLEAN-STREET
           END-STRING

           MOVE FUNCTION TRIM(WS-CLEAN-STREET) TO WS-CLEAN-STREET.

      *----------------------------------------------------------------
      * CLEAN-CITY - same pattern as CLEAN-STREET, applied to
      * WS-RAW-CITY, result stored in WS-CLEAN-CITY.
      *----------------------------------------------------------------
       CLEAN-CITY.
           MOVE FUNCTION TRIM(WS-RAW-CITY) TO WS-TRIMMED
           MOVE SPACES TO WS-WORD-1 WS-WORD-2 WS-WORD-3 WS-WORD-4

           UNSTRING WS-TRIMMED DELIMITED BY ALL SPACE
               INTO WS-WORD-1, WS-WORD-2, WS-WORD-3, WS-WORD-4
           END-UNSTRING

           IF WS-WORD-1 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-1) TO WS-WORD-1
               MOVE FUNCTION UPPER-CASE(WS-WORD-1(1:1))
                   TO WS-WORD-1(1:1)
           END-IF

           IF WS-WORD-2 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-2) TO WS-WORD-2
               MOVE FUNCTION UPPER-CASE(WS-WORD-2(1:1))
                   TO WS-WORD-2(1:1)
           END-IF

           IF WS-WORD-3 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-3) TO WS-WORD-3
               MOVE FUNCTION UPPER-CASE(WS-WORD-3(1:1))
                   TO WS-WORD-3(1:1)
           END-IF

           IF WS-WORD-4 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-4) TO WS-WORD-4
               MOVE FUNCTION UPPER-CASE(WS-WORD-4(1:1))
                   TO WS-WORD-4(1:1)
           END-IF

           MOVE SPACES TO WS-CLEAN-CITY

           STRING WS-WORD-1 DELIMITED BY SPACE
                  " "       DELIMITED BY SIZE
                  WS-WORD-2 DELIMITED BY SPACE
                  " "       DELIMITED BY SIZE
                  WS-WORD-3 DELIMITED BY SPACE
                  " "       DELIMITED BY SIZE
                  WS-WORD-4 DELIMITED BY SPACE
               INTO WS-CLEAN-CITY
           END-STRING

           MOVE FUNCTION TRIM(WS-CLEAN-CITY) TO WS-CLEAN-CITY.

      *----------------------------------------------------------------
      * VALIDATE-POSTAL-CODE - trimmed length must be exactly 5.
      * An invalid code is flagged, never a reason to skip the record.
      *----------------------------------------------------------------
       VALIDATE-POSTAL-CODE.
           COMPUTE WS-POSTAL-LEN =
               FUNCTION LENGTH(FUNCTION TRIM(WS-RAW-POSTAL))

           IF WS-POSTAL-LEN = 5
               MOVE "VALID"   TO WS-STATUS
               ADD 1 TO WS-VALID-COUNT
           ELSE
               MOVE "INVALID" TO WS-STATUS
               ADD 1 TO WS-INVALID-COUNT
           END-IF.

      *----------------------------------------------------------------
      * WRITE-CLEAN-RECORD - build and write one output line
      * containing street, city, trimmed postal code, and status.
      *----------------------------------------------------------------
       WRITE-CLEAN-RECORD.
           MOVE SPACES TO CLEAN-ADDRESS-RECORD

           STRING FUNCTION TRIM(WS-CLEAN-STREET)  DELIMITED BY SIZE
                  ", "                             DELIMITED BY SIZE
                  FUNCTION TRIM(WS-CLEAN-CITY)     DELIMITED BY SIZE
                  ", "                             DELIMITED BY SIZE
                  FUNCTION TRIM(WS-RAW-POSTAL)     DELIMITED BY SIZE
                  ", "                             DELIMITED BY SIZE
                  WS-STATUS                        DELIMITED BY SIZE
               INTO CLEAN-ADDRESS-RECORD
           END-STRING

           WRITE CLEAN-ADDRESS-RECORD.
