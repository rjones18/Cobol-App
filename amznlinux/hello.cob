       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 WS-OUTPUT PIC X(80) VALUE "Content-Type: text/html".
       01 WS-BODY-1 PIC X(40) VALUE "<html><body><h1>Hello, ".
       01 WS-BODY-2 PIC X(40) VALUE "World!</h1></body></html>".

       PROCEDURE DIVISION.
           DISPLAY WS-OUTPUT.
           DISPLAY " ".
           DISPLAY WS-BODY-1.
           DISPLAY WS-BODY-2.
           STOP RUN.


       