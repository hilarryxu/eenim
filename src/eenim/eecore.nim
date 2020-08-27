import winapi

## ******************************************************************************
##  SDK for EverEdit
##  Copyright 2011-2013 everedit.net, All Rights Reserved.
##
##  Core Edit Component SDK of EverEdit
##
##  Version: 1.1
##
##
##  2013/01/10 First Version
##  2013/11/12 Update for EverEdit 3.0
## *****************************************************************************

## *
##  Selection Type
##

const
  EC_SEL_NONE* = 0
  EC_SEL_NORMAL* = 1
  EC_SEL_COLUMN* = 2
  EC_SEL_MULTIPLE* = 3

## *
##  Line Break(EOL) Type
##

const
  EC_EOL_NULL* = 0
  EC_EOL_WIN* = 1
  EC_EOL_UNIX* = 2
  EC_EOL_MAC* = 3

## *
##  Folding Method
##

const
  EC_FD_NONE* = 0
  EC_FD_SYNTAX* = 1
  EC_FD_INDENT* = 2
  EC_FD_ANYTEXT* = 3

## *
##  Folding Style
##

const
  EC_FDSTYLE_LINE* = 1
  EC_FDSTYLE_BOX* = 2
  EC_FDSTYLE_ARROW* = 3
  EC_FDSTYLE_BOXLINE* = 4
  EC_FDSTYLE_PENTAGON* = 5
  EC_FDSTYLE_ICON* = 5

## *
##  Edit Mode
##

const
  EC_EDITMODE_NORMAL* = 0
  EC_EDITMODE_OVERWRITE* = 1

## *
##  Line Wrap Mode
##

const
  EC_WRAP_NONE* = 0
  EC_WRAP_WINEDGE* = 1
  EC_WRAP_SMART* = 2
  EC_WRAP_COL* = 3
  EC_WRAP_EXPANDTAB* = 4
  EC_WRAP_GETWRAPDATA* = 11

## *
##  Move Caret and Selection Commands
##

const
  ECC_LEFT* = 1
  ECC_RIGHT* = 2
  ECC_UP* = 3
  ECC_DOWN* = 4
  ECC_LINEHOME* = 5
  ECC_LINEEND* = 6
  ECC_DOCHOME* = 7
  ECC_DOCEND* = 8
  ECC_PGUP* = 9
  ECC_PGDOWN* = 10
  ECC_RIGHTWORD* = 11
  ECC_LEFTWORD* = 12
  ECC_SELTOLEFT* = 13
  ECC_SELTORIGHT* = 14
  ECC_SELTOUP* = 15
  ECC_SELTODOWN* = 16
  ECC_SELTOLINEHOME* = 17
  ECC_SELTOLINEEND* = 18
  ECC_SELTODOCHOME* = 19
  ECC_SELTODOCEND* = 20
  ECC_SELTOPGUP* = 21
  ECC_SELTOPGDOWN* = 22
  ECC_SELTORIGHTWORD* = 23
  ECC_SELTOLEFTWORD* = 24
  ECC_SELALL* = 25

## *
##  Delete Commands
##

const
  ECC_DELLEFT* = 26
  ECC_DELRIGHT* = 27
  ECC_DELLEFTWORD* = 28
  ECC_DELNEXTWORD* = 29
  ECC_DELLINE* = 30

## *
##  Undo/Redo/Copy/Paste
##

const
  ECC_UNDO* = 31
  ECC_REDO* = 32
  ECC_COPY* = 33
  ECC_PASTE* = 34
  ECC_CUT* = 35
  ECC_TOGGLEINSOVR* = 36

## *
##  Scroll up or down without moving caret
##

const
  ECC_SCROLLUP* = 38
  ECC_SCROLLDOWN* = 39
  ECC_CENTERCARET* = 40
  ECC_TOGGLEMARKER* = 41
  ECC_NEXTMARKER* = 42
  ECC_PREVMARKER* = 43
  ECC_NEWLINEAFTER* = 44
  ECC_NEWLINEBEFORE* = 45

## *
##  Select word on caret position
##

const
  ECC_SELWORD* = 46
  ECC_INDENT* = 47
  ECC_UNINDENT* = 48
  ECC_UPLINE* = 49
  ECC_DOWNLINE* = 50
  ECC_FOLDSEL* = 51
  ECC_UNFOLD* = 52
  ECC_DELALLMARKER* = 53
  ECC_DUPLICATELINE* = 54
  ECC_SELUPLINE* = 55
  ECC_SELDOWNLINE* = 56
  ECC_CASEUPPER* = 57
  ECC_CASELOWER* = 58
  ECC_CENTERLINE* = 59
  ECC_NEXTPAIR* = 60
  ECC_INDENTPASTE* = 61
  ECC_FOLD* = 62
  ECC_TRIMHEAD* = 63
  ECC_TRIMTAIL* = 64
  ECC_CLEARSEL* = 65
  ECC_NEWLINE* = 66
  ECC_SELTOPAIR* = 67
  ECC_COPYLINE* = 68
  ECC_TAB2SPACE* = 69
  ECC_SPACE2TAB* = 70
  ECC_LASTEDITPOINT* = 71
  ECC_JOINLINE* = 72
  ECC_SUBLINEHOME* = 73
  ECC_SUBLINEEND* = 74
  ECC_SELTOSUBLINEHOME* = 75
  ECC_SELTOSUBLINEEND* = 76
  ECC_DELTOLINEHEAD* = 79
  ECC_DELTOLINETAIL* = 80
  ECC_TRANSPOSE* = 81
  ECC_CASEINVERT* = 82
  ECC_HEADTAB2SPACE* = 83
  ECC_HEADSPACE2TAB* = 84
  ECC_DELWORD* = 85
  ECC_SELLINE* = 86
  ECC_CUTAPPEND* = 87
  ECC_COPYAPPEND* = 88
  ECC_COPYMARKEDLINES* = 89
  ECC_CUTMARKEDLINES* = 90
  ECC_COLUMNPASTE* = 91
  ECC_COPYASRTF* = 92
  ECC_UPDATECARET* = 93
  ECC_PASTETAIL* = 94
  ECC_NEXTPARA* = 95
  ECC_PREVPARA* = 96
  ECC_TOFULLWIDTH* = 97
  ECC_TOHALFWIDTH* = 98
  ECC_TOHIRAGANA* = 99
  ECC_SELCHANGE* = 100
  ECC_TOKATAKANA* = 101
  ECC_CAPITALIZE* = 102
  ECC_CLEAR* = 103
  ECC_NEXTCARETPOS* = 104
  ECC_PREVCARETPOS* = 105
  ECC_SPLITSEL* = 106
  ECC_PASTEDIRECT* = 107

## *
##  @Msg:	Can undo?
##  @Return: BOOL
##

const
  ECM_CANUNDO* = WM_USER + 1

## *
##  @Msg:	Can redo?
##  @Return: BOOL
##

const
  ECM_CANREDO* = WM_USER + 2

## *
##  @Msg:	Jump tp line
##  @Return: void
##  @wparam: int: line number
##

const
  ECM_JUMPTOLINE* = WM_USER + 3

## *
##  @Msg:	Get word from caret. Note: this message will not return any text, you can use wParam to get a range.
##  @Return: void
##  @wparam: EC_Pos**
##  @lparam: int: flag, ref GETWORD_LWORD to get more details
##

const
  ECM_GETWORD* = WM_USER + 4

## *
##  @Msg:	Get total line count
##  @Return: int
##

const
  ECM_GETLINECNT* = WM_USER + 8

## *
##  @Msg:	Get path name
##  @Return: const wchar_t*
##

const
  ECM_GETPATH* = WM_USER + 11

## *
##  @Msg:	Get current position of caret
##  @wparam: EC_POS*: to get the value
##

const
  ECM_GETCARETPOS* = WM_USER + 12

## *
##  @Msg:	Get char. Note: this function might be slow, DO NOT use this message get char one by one.
##  @Return: wchar
##  @wparam: int: line
##  @lparam: int: column
##

const
  ECM_GETCHAR* = WM_USER + 13

## *
##  @Msg:	Get line text
##  @Return: Length of this line
##  @wparam: int: line number
##  @lparam: wchar_t*: It's a buffer to get text. If it's null, the return value will be line's length.
##

const
  ECM_GETLINETEXT* = WM_USER + 14

## *
##  @Msg:	Get the line text with built-in buffer. Note: it's fast but might be refreshed on next draw cycle.
##  @Return: const wchar_t*
##  @wparam: int: line number
##

const
  ECM_GETLINEBUF* = WM_USER + 15

## *
##  @Msg:	Delete text
##  @wparam: EC_POS*: start pos
##  @lparam: EC_POS*: end pos
##

const
  ECM_DELETETEXT* = WM_USER + 16

## *
##  @Msg:	Insert text
##  @wparam: EC_POS*: pos. if null, the pos will be current caret.
##  @lparam: EC_INSERTTEXT*: insert what?
##

const
  ECM_INSERTTEXT* = WM_USER + 17

## *
##  @Msg:	Set style of line break(EOL)
##  @Return: int: New style
##  @wparam: int: EC_EOL_NULL,EC_EOL_WIN,EC_EOL_UNIX,EC_EOL_MAC. Set a invalid value to get current EOL type.
##

const
  ECM_SETEOLTYPE* = WM_USER + 18

## *
##  @Msg:	Is current doc dirty?
##  @Return: bool
##

const
  ECM_ISDOCDIRTY* = WM_USER + 21

## *
##  @Msg:	Hit test
##  @wparam: EC_HitTestInfo*
##

const
  ECM_HITTEST* = WM_USER + 26

## *
##  @Msg:	Set/get line spacing
##  @Return:	current line spacing
##  @wparam: >=0: set
## 			<0: get
##

const
  ECM_LINESPACING* = WM_USER + 27

## *
##  @Msg:	Set/get current edit mode
##  @Return: int: Current edit mode
##  @wparam: int: set a invalid value to return current setting.
##

const
  ECM_EDITMODE* = WM_USER + 28

## *
##  @Msg:	Show or hide element
##  @Return: bool: Current value
##  @wparam: Word: LBYTE is ID of element, HIBYTE is value:0:hide, 1:show
##  @lparam: 0: Don't refresh window
## 			1: Refresh window
##

const
  ECM_SHOWELEMENT* = WM_USER + 29

## *
##  @Msg:	Select text as normal selection
##  @wparam: EC_POS* :start pos
##  @lparam: EC_POS* :end pos
##

const
  ECM_SETSEL* = WM_USER + 32

## *
##  @Msg:	Get selection type.
##

const
  ECM_HASSEL* = WM_USER + 33

## *
##  @Msg:	Get selection start/end pos
##  @Return: BOOL:	TRUE if is EC_SEL_NORMAL
##  @wparam: EC_POS*
##  @lparam: EC_POS*
##

const
  ECM_GETSEL* = WM_USER + 34

## *
##  @Msg:    Get range text
##  @Return: int: Return size of this range which includes line break(EOL)
##  @wparam: EC_SelInfo*
##

const
  ECM_GETTEXT* = WM_USER + 35

## *
##  @Msg:    Get/set wrap method
##  @Return: int: Current wrap method
##  @wparam: EC_WRAP_NONE,EC_WRAP_WINEDGE,EC_WRAP_SMART,EC_WRAP_COL,EC_WRAP_EXPANDTAB,EC_WRAP_GETWRAP
##

const
  ECM_WRAP* = WM_USER + 37

## *
##  @Msg:    Push text insert/delete commands into same stack, so you can undo/redo them with one operation.
##  			Note:you must call it twice(TRUE/FALSE), otherwise app may crash!
##  @Return: (void)
##  @wparam: BOOL
## 			TRUE: Begin Group
## 			FALSE:End Group
##

const
  ECM_GROUPUNDO* = WM_USER + 39

## *
##  @Msg:    Get selected text
##  @Return: HANDLE: Use GlobalLock/GlobalUnlock to get text value
##

const
  ECM_GETSELTEXT* = WM_USER + 40

## *
##  @Msg:    Force caret visible
##

const
  ECM_FORCECARETVISIBLE* = WM_USER + 41

## *
##  @Msg:    Is it a word char?
##  @Return: bool
##  @wparam: wchar
##

const
  ECM_ISWORDCHAR* = WM_USER + 43

## *
##  @Msg:    Set tab size
##  @Return: int: Current tab size
##  @wparam: >=1&&<=64:Set, <=0：Get
##

const
  ECM_SETTABSIZE* = WM_USER + 44

## *
##  @Msg: 	Move caret to specified location
##  @Return: void
##  @wparam: EC_POS*
##  @lparam: BOOL*: Force caret visible?
##

const
  ECM_SETPOS* = WM_USER + 46

## *
##  @Msg: 	Hide/Show caret
##  @Return: bool: 	Current value
##  @wparam: true: 	Hide caret
## 			false: 	Show caret
##

const
  ECM_NOCARET* = WM_USER + 52

## *
##  @Msg: 	Enable/Disable undo
##  @Return: bool: 	Current value
##  @wparam: true: 	Enable undo
## 			false:	Disable undo
##

const
  ECM_ENABLEUNDO* = WM_USER + 53

## *
##  @Msg: 	Get line height. Line Height=Font Height+Line Spacing
##  @Return: int
##

const
  ECM_GETLINEHEIGHT* = WM_USER + 57

## *
##  @Msg: 	Get count of visual lines
##  @Return:	int
##

const
  ECM_GETVISUALLINECOUNT* = WM_USER + 58

## *
##  @Msg: 	Get/set folding method
##  @Return: int: Current folding method
##  @wparam: int: Folding method, set it to EC_FD_RETURN to get current value
##

const
  ECM_SETFOLDMETHOD* = WM_USER + 59

## *
##  @Msg: 	Claculate pixel with of string with current font
##  @Return: int
##  @wparam: const wchar_t*
##  @lparam:	int: string length
##

const
  ECM_CALCTEXTEXTENT* = WM_USER + 60

## *
##  @Msg: 	Get font height
##  @Return: int
##

const
  ECM_GETFONTHEIGHT* = WM_USER + 61

## *
##  @Msg   : Export all text to a file
##  @wparam: wchar_t*:	full path
##  @lparan: EC_Export*
##

const
  ECM_EXPORT* = WM_USER + 64

## *
##  @Msg: 	Make current document be dirty or new
##  @Return: void
##  @wparam: TRUE:	Clear dirty flag/undo/redo/caret history/line edit state..
## 			FALSE:	Make doc be dirty
##

const
  ECM_FORCENEW* = WM_USER + 65

## *
##  @Msg: 	Get/set column marker
##  @Return: int*:	Address of column marker(length is 10)
##  @wparam: int*:	Array, the size must be 10. Each value represents a vertical line in this column.
##  @lparam: TRUE: 	Set
## 			FALSE: 	Get
##

const
  ECM_SETCOLMARKER* = WM_USER + 67

## *
##  @Msg: 	Insert texts(Comment symbol, such as '//' in c/c++) in the beginning of each selected line.
##  @Return: BOOL: return TRUE if success
##  @wparam: const wchar_t*
##  @lparam: BOOL
## 			TRUE:	Comment
## 			FALSE:	Uncomment
##

const
  ECM_COMMENTLINE* = WM_USER + 69

## *
##  @Msg: 	Comment or uncomment selection
##  @Return: BOOL: return TRUE if success
##  @wparam: const wchar_t*
##  @lparam: BOOL
## 			TRUE:	Comment
## 			FALSE:	Uncomment
##

const
  ECM_COMMENTBLOCK* = WM_USER + 70

## *
##  @Msg: 	Set word chars for current document
##  @Return: const wchar_t*:	Current word chars
##  @wparam: const wchar_t*:	New word chars, set it to NULL to get return value.
##

const
  ECM_SETWORDCHARS* = WM_USER + 73

## *
##  @Msg:    Refresh all views which associated with current document
##  @Return: void
##

const
  ECM_REDRAW* = WM_USER + 74

## *
##  @Msg:    Move caret to a position with specified length
##  @wparam: int: length
##

const
  ECM_MOVECARET* = WM_USER + 77

## *
##  @Msg: 	Get total sub lines of a physical line
##  @Return: int: total sub lines
##  @wparam: int: line number
##

const
  ECM_WRAPCOUNT* = WM_USER + 79

## *
##  @Msg: 	Insert a snippet in caret position
##  @Return: void
##  @wparam: const wchar_t*: text
##  @lparam: int: length of text
##

const
  ECM_INSERTSNIPPET* = WM_USER + 82

## *
##  @Msg:    Clear dirty flag
##

const
  ECM_CLEARDIRTY* = WM_USER + 84

## *
##  @Msg: 	Get a text that demonstrates current scope information of caret position.
##  @Return: const wchar_t*
##

const
  ECM_GETSCOPE* = WM_USER + 87

## *
##  @Return: Get/set bookmark
##  @wparam: int
## 			0: Delete bookmark
## 			1: Set bookmark
## 			2: Return current state
##  @lparam: int: line number
##

const
  ECM_BOOKMARKER* = WM_USER + 88

## *
##  @Msg: 	Get/set folding level
##  @Return: int: Current level
##  @wparam: int:
## 			-1: 	Return current level
## 			-2: 	Is busy?(parsing folding)
## 			0~64: 	Folding level
##  @lparam: int:	line number
##

const
  ECM_LINELEVEL* = WM_USER + 89

## *
##  @Msg: 	Get/set folding style
##  @Return: int: Current style
##  @wparam: int
## 			0: Return current style
## 			1: Set
##  @lparam: int: ref Folding styles to get more details
##

const
  ECM_FOLDINGSTYLE* = WM_USER + 90

## *
##  Notify Messages
##

const
  ECN_UPDATETEXT* = 1
  ECN_CARETCHANGE* = 2
  ECN_IMEINSERT* = 3
  ECN_TEXTCLICK* = 4

## *
##  flags for ECM_GETWORD
##

const
  GETWORD_LWORD* = 1
  GETWORD_RWORD* = 2
  GETWORD_WORD* = GETWORD_LWORD or GETWORD_RWORD
  GETWORD_LEDGE* = 4
  GETWORD_REDGE* = 8
  GETWORD_EDGE* = GETWORD_LEDGE or GETWORD_REDGE
  GETWORD_LSYNTAX* = 16
  GETWORD_RSYNTAX* = 32
  GETWORD_SYNTAX* = GETWORD_LSYNTAX or GETWORD_RSYNTAX

type
  EC_Pos* {.bycopy.} = object
    line*: cint
    col*: cint

  EC_InsertText* {.bycopy.} = object
    lpText*: LPCWSTR
    len*: cint

  EC_SelInfo* {.bycopy.} = object
    spos*: EC_Pos
    epos*: EC_Pos
    lpBuffer*: LPCWSTR
    nEol*: cint

  EC_HitTestInfo* {.bycopy.} = object
    line*: cint
    col*: cint
    vline*: cint
    sub*: cint

  EC_Export* {.bycopy.} = object
    nEncoding*: cint
    nEol*: cint
    bBom*: WINBOOL

  ECNMHDR_TextUpdate* {.bycopy.} = object
    hdr*: NMHDR
    spos*: EC_Pos
    epos1*: EC_Pos
    epos2*: EC_Pos

  ECNMHDR_CaretChange* {.bycopy.} = object
    hdr*: NMHDR
    posOld*: EC_Pos
    posNew*: EC_Pos

  ECNMHDR_IMEInsert* {.bycopy.} = object
    hdr*: NMHDR
    lpText*: LPCWSTR
    length*: cint

  ECNMHDR_TextClick* {.bycopy.} = object
    hdr*: NMHDR
    pos*: EC_Pos
    spos*: EC_Pos
    epos*: EC_Pos
    lpText*: LPCWSTR

