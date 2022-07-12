;;;;;;;;;;;;;;editable settings
;LogDir := A_ScriptDir "\logs\" 		;point this at the top most level of your logs, whether a single folder or a collection of folders.
										;Uncomment the above line to disable folder select prompt (so it runs silently)
LogExt := "txt" 						;I assume its just a regular text file
PlayerMask := "PokerStar" 				;affects the player handles and also the log name.

;;;;;;;;;;;;;the rest of all things ever
#NoEnv
SetBatchLines,-1

OnExit,ExitRoutine
If (LogDir = "")
{
	FileSelectFolder,LogDir ,% a_scriptdir
	LogDir .= "\"
}
PlayerMaskFile := FileOpen(a_scriptdir "\" PlayerMask a_space A_NowUTC "." LogExt,"w")
Loop,Files,% LogDir "*",R
{
	FileRead,CurrentFile,% A_LoopFileLongPath
	CurrentFileArray := StrSplit(CurrentFile,"`r`n`r`n")
	;CurrentFileArray := StrSplit(CurrentFile,"`n`n") ;uncomment this if the above line doesn't work
	for k,v in CurrentFileArray
	{
		CurrentHand := Trim(v,"`n`r")
		CurrentHandHeader := StrSplit(CurrentHand,"*** HOLE CARDS ***")[1]
		for k,v in StrSplit(CurrentHandHeader,"`n")
		{
			If RegExMatch(v,"O)(Seat ([0-9])): (.+) \(.+\)",match)
				CurrentHand := StrReplace(CurrentHand,match.value(3),PlayerMask . match.value(2))
		}
		PlayerMaskFile.Write(CurrentHand "`n`n`n")
	}
}

ExitRoutine:
PlayerMaskFile.Close()
ExitApp