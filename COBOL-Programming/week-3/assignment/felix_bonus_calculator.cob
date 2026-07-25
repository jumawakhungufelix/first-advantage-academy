       IDENTIFICATION DIVISION. 
       PROGRAM-ID. BONUS-CALCULATOR.

       DATA DIVISION. 
       WORKING-STORAGE SECTION. 
       01 WS-EMPLOYEE-NAME      PIC X(20).
       01 WS-DEPT-CODE PIC XX.
           88 SALES                            VALUE 'SL'.
           88 INFORMATION-TECHNOLOGY           VALUE 'IT'.
           88 DEP-3                            VALUE 'D3'.
           88 HUMAN-RESOURCES                  VALUE 'HR'.
           88 FINAMCE                          VALUE 'FN'.
       01 WS-PERFORMANCE-RATING PIC 9(5).
           88 LOW-PERFORMAER                    VALUE 1 THRU 2.
           88 AVERAGE-PERFORMER                 VALUE 3.
           88 HIGH-PERFORMER                    VALUE 4 THRU 5.
       01 WS-YEARS-OF-SERVICE    PIC 99.
           88 JUNIOR-TENURE                      VALUE 1 THRU 2.
           88 MID-TENURE                          VALUE 2 THRU 4.
           88 SENIOR-TENURE                       VALUE 5 THRU 99.
       01 WS-BASE-SALARY        PIC 9(6)V99.
       01 WS-BONUS-PERCENT-RATIO      PIC V99.
       01 WS-BONUS-PERCENT         PIC 99.
       01 WS-BONUS-AMOUNT       PIC 9(6)V99.
       01 WS-DISPLAY-PERFORMANCE PIC X(40).
       01 WS-DISPLAY-LEVEL      PIC X(40).
       01 WS-DISPLAY-YEARS-CLASS  PIC X(30).
       01 WS-INVALID-DEPT         PIC X(30).
       01 WS-PARTITIONER           PIC X(35)       VALUE ALL'='.

       01 WS-PERFORMANCE-RATING-DISPLAY        PIC ZZ9.
       01 WS-YEARS-OF-SERVICE-DISPLAY          PIC ZZ9.
       01 WS-BONUS-AMOUNT-DISPLAY              PIC ZZZZZ9.






     

          PROCEDURE DIVISION.
           DISPLAY 'Enter employee name: '.
            ACCEPT WS-EMPLOYEE-NAME.
           DISPLAY 'Enter department code: '.
            ACCEPT WS-DEPT-CODE.
           DISPLAY 'Enter performance ratings: '.
           ACCEPT WS-PERFORMANCE-RATING.
           DISPLAY 'Enter department years of service: '.
           ACCEPT WS-YEARS-OF-SERVICE.
           DISPLAY 'Enter base salary: '.
           ACCEPT WS-BASE-SALARY.

           EVALUATE TRUE ALSO TRUE
              WHEN LOW-PERFORMAER        ALSO JUNIOR-TENURE
                 MOVE 'Bronze' TO WS-DISPLAY-LEVEL
                 MOVE '(low Performer)' TO WS-DISPLAY-PERFORMANCE
                 MOVE '(Junior Tenure)' TO WS-DISPLAY-YEARS-CLASS
                 MOVE 0.05 TO WS-BONUS-PERCENT-RATIO
                 
              WHEN LOW-PERFORMAER        ALSO MID-TENURE
                 MOVE 'Bronze' TO WS-DISPLAY-LEVEL
                 MOVE '(low Performer)' TO WS-DISPLAY-PERFORMANCE
                 MOVE '(Mid Tenure)' TO WS-DISPLAY-YEARS-CLASS
                 MOVE 0.05 TO WS-BONUS-PERCENT-RATIO
                 
              WHEN LOW-PERFORMAER        ALSO SENIOR-TENURE
                 MOVE 'Silver' TO WS-DISPLAY-LEVEL
                 MOVE '(low Performer)' TO WS-DISPLAY-PERFORMANCE
                 MOVE '(Senior Tenure)' TO WS-DISPLAY-YEARS-CLASS
                 MOVE 0.1 TO WS-BONUS-PERCENT-RATIO
              WHEN AVERAGE-PERFORMER     ALSO JUNIOR-TENURE
                 MOVE 'BRONZE' TO WS-DISPLAY-LEVEL
                 MOVE '(Average Performer)' TO WS-DISPLAY-PERFORMANCE
                 MOVE '(Junior Tenure)' TO WS-DISPLAY-YEARS-CLASS
                  MOVE 0.05 TO WS-BONUS-PERCENT-RATIO
              WHEN AVERAGE-PERFORMER     ALSO MID-TENURE
                 MOVE 'Silver' TO WS-DISPLAY-LEVEL
                 MOVE '(Average Performer)' TO WS-DISPLAY-PERFORMANCE
                 MOVE '(Mid Tenure)' TO WS-DISPLAY-YEARS-CLASS
                 MOVE 0.1 TO WS-BONUS-PERCENT-RATIO
              WHEN AVERAGE-PERFORMER     ALSO SENIOR-TENURE
                 MOVE 'Gold' TO WS-DISPLAY-LEVEL
                 MOVE '(Average Performer)' TO WS-DISPLAY-PERFORMANCE
                 MOVE '(Senior Tenure)' TO WS-DISPLAY-YEARS-CLASS
                 MOVE 0.15 TO WS-BONUS-PERCENT-RATIO

              WHEN HIGH-PERFORMER        ALSO JUNIOR-TENURE
                 MOVE 'Silver' TO WS-DISPLAY-LEVEL
                 MOVE '(High Performer)' TO WS-DISPLAY-PERFORMANCE
                 MOVE '(Junior Tenure)' TO WS-DISPLAY-YEARS-CLASS
                 MOVE 0.1 TO WS-BONUS-PERCENT-RATIO
              WHEN HIGH-PERFORMER        ALSO MID-TENURE
                 MOVE 'Gold' TO WS-DISPLAY-LEVEL
                 MOVE '(High Performer)' TO WS-DISPLAY-PERFORMANCE
                 MOVE '(Mid Tenure)' TO WS-DISPLAY-YEARS-CLASS
                 MOVE 0.15 TO WS-BONUS-PERCENT-RATIO
              WHEN HIGH-PERFORMER        ALSO SENIOR-TENURE
                 MOVE 'Premium' TO WS-DISPLAY-LEVEL
                 MOVE '(High Performer)' TO WS-DISPLAY-PERFORMANCE
                 MOVE '(Senior Tenure)' TO WS-DISPLAY-YEARS-CLASS
                 MOVE 0.2 TO WS-BONUS-PERCENT-RATIO
              WHEN OTHER
                 MOVE 'ERROR: ' TO WS-INVALID-DEPT
                
                

                 

                 
           END-EVALUATE.
           
           IF WS-DEPT-CODE = 'SL' OR WS-DEPT-CODE = 'IT' OR 
           WS-DEPT-CODE = 'HR' OR WS-DEPT-CODE = 'FN'
              COMPUTE
               WS-BONUS-AMOUNT ROUNDED =
                              WS-BASE-SALARY * WS-BONUS-PERCENT-RATIO
               COMPUTE
               WS-BONUS-PERCENT = WS-BONUS-PERCENT-RATIO * 100
               
             
              MOVE WS-PERFORMANCE-RATING TO
                  WS-PERFORMANCE-RATING-DISPLAY
              MOVE WS-YEARS-OF-SERVICE TO WS-YEARS-OF-SERVICE-DISPLAY
              MOVE WS-BONUS-AMOUNT TO WS-BONUS-AMOUNT-DISPLAY

              DISPLAY 'Employee Name:         'WS-EMPLOYEE-NAME
              DISPLAY 'Department ID:         'WS-DEPT-CODE
              DISPLAY 'Performance  :         '
                                         WS-PERFORMANCE-RATING-DISPLAY 
                                               WS-DISPLAY-PERFORMANCE 
              DISPLAY 'Years of Service:       '
                                            WS-YEARS-OF-SERVICE-DISPLAY 
                                             WS-DISPLAY-YEARS-CLASS
   
              DISPLAY WS-PARTITIONER
   
              DISPLAY 'Bonus Tier           : ' WS-DISPLAY-LEVEL
              DISPLAY 'Bonus Percent        : 'WS-BONUS-PERCENT'%'
              DISPLAY 'Bonus Amount(KES)    : 'WS-BONUS-AMOUNT-DISPLAY

           ELSE
              
              DISPLAY 'Employee Name:         'WS-EMPLOYEE-NAME
              DISPLAY WS-PARTITIONER
              DISPLAY 'ERROR: Department code ' WS-DEPT-CODE 
              'is not recognised.'
              DISPLAY 'No bonus calculated.'
           
           END-IF
           
           STOP RUN.
          

              
           

           

       