README f�r das Source Repository

Einmaliges Auschecken des CVS-Repositories f�r das Source Repository:

	cd $HOME
	cvs checkout repository

Eigene Dateien und Verzeichnisse hinzuf�gen mit

	<Datei mit Editor anlegen und abspeichern>
	cvs add datei
	cvs commit datei

Die Verzeichnisstruktur sollte klar sein: f�r jede Programmiersprache
ein eigenes Verzeichnis, in dem die Funktionen als Dateien abgelegt
werden. Die Dateien sollten m�glichst wie die Funktion benannt werden
und nur eine Funktion mit Dokumentation (bei Perl ein POD-Fragment,
ansonsten einen Kommentar mit Ein- und Ausgabeparametern) enthalten.
Der Verzeichnisname sollte sich am entsprechenden Emacs-Lisp-Mode
orientieren, also f�r "C" der name "c", weil der Mode "c-mode" hei�t,
"perl" wegen "perl-mode" usw.

CVS-Repository auf den neuesten Stand bringen (falls von anderen
Leuten Funktionen eingef�gt oder ge�ndert wurden):

	cvs update -d

In .emacs sollte folgendes eingef�gt werden:

    (define-key global-map [C-f10] 'repository-insert)
    (autoload 'repository-insert "repository" "Source repository" t)

Au�erdem kann man

    (setq repository-directory "/home/ole/repository")

einf�gen, wenn sich das Repository nicht im Standard-Verzeichnis
$HOME/src/repository befindet.

Mit den Emacs-Definitionen wird die Taste Control-F10 auf die Funktion
zum Einf�gen von Repository-Funktion gesetzt.


In /oo/onlineoffice/programm/perl kann man die perl-Funktionen mit

    make

zu einem Modul namens OOFunctions.pm zusammenfassen.


Test-Skripte (z.Zt. nur f�r perl) k�nnen im Verzeichnis t abgelegt
werden. Mit

    sh -c 'for i in *.t; do perl $i; done'

im t-Verzeichnis k�nnen die Test-Skripte aufgerufen werden. Beim
Schreiben eigener Test-Skripte sollte man darauf achten, dass
do-Aufrufe in "BEGIN DO" und "END DO" eingeschlossen sind (XXX noch
nicht unbedingt notwendig).
