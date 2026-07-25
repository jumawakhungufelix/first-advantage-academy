        IDENTIFICATION DIVISION.
        PROGRAM-ID. STUDENTS-REGISTRATION-FORM.

        DATA DIVISION. 
        WORKING-STORAGE SECTION. 
        01 WS-STUDENT-NAME            PIC X(45)         VALUE SPACES.
        01 FILLER                     PIC X(10).
        01 WS-STUDENT-ID              PIC 9(8)          VALUE ZERO.
        01 FILLER                     PIC X(10).
        01 WS-SUBJ-1                  PIC 9(3)          VALUE ZERO.
        01 FILLER                     PIC X(10).
        01 WS-SUBJ-2                  PIC 9(3)          VALUE ZERO.
        01 FILLER                     PIC X(10).
        01 WS-SUBJ-3                  PIC 9(3)          VALUE ZERO.
        01 FILLER                     PIC X(10).
        01 WS-SUBJ-4                  PIC 9(3)          VALUE ZERO.
        01 FILLER                     PIC X(10).
        01 WS-TOTAL-MARKS             PIC 9(6)          VALUE ZERO.
        01 FILLER                     PIC X(10).
        01 WS-GRADE                   PIC X(1)          VALUE SPACES.
        01 FILLER                     PIC X(10).
        01 WS-REG-DATE                PIC X(8)          VALUE SPACES.
        01 FILLER                     PIC X(10).
        01 WS-DISPLAY-AVERAGE         PIC ZZZ,ZZ9.99    VALUE ZERO.
        01 WS-COUNTER                 PIC 9(8)          VALUE ZERO.
        