@echo off
cd /d "%~dp0"
echo Compilando el proyecto...
javac -cp "lib\jpl.jar;lib\flatlaf-3.4.1.jar" TechAdvisor.java
echo Iniciando el Sistema Experto...
set PATH=%~dp0bin;%PATH%
java -Dfile.encoding=UTF-8 -cp ".;lib\jpl.jar;lib\flatlaf-3.4.1.jar" "-Djava.library.path=bin" TechAdvisor
pause