@echo off

type Nostromo.txt | PodzielPgm | findstr /b th | findstr /v /r ".*[n|a|e].*"