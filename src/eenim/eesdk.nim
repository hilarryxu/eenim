## *******************************************************************************
##  SDK for EverEdit
##  Copyright 2011-2013 everedit.net, All Rights Reserved.
##
##  Plugin must implement the below functions
##
##  DWORD EE_PluginInit(EE_Context* pContext);
##  DWORD EE_PluginUninit();
##  DWORD EE_PluginInfo(wchar_t* lpText, int nLength);
##
##  Version: 1.1
##
##
##  2013/01/10 First Version
##  2013/11/12 Update for EverEdit 3.0
## ******************************************************************************

import
  winapi, eecore

## *
##  @Msg:    Restore layout of docking windows. This message will be sent from EE on startup, DO NOT send this message to EE!
##  @Return: HWND: If plugin has a docking window, it should return a HWND handle, otherwise EE will not update its layout.
##  @wparam: const wchar_t*: Caption of docking window. Plugin can restore itself by this param.
##

const
  EEM_RESOTREDOCKINGWINDOW* = WM_USER + 1211

## *
##  @Msg:    Preview a file with built-in browser.
##  @wparam: WebPreviewData*
##

const
  EEM_WEBPREVIEW* = WM_USER + 1220

## *
##  @Msg:	Get handle of active document(Text mode). If current view was divided, it will return the activated one.
##  @Return: HWND
##

const
  EEM_GETACTIVETEXT* = WM_USER + 3000

## *
##  @Msg:	Get handle of active hex document(Hex Mode)
##  @Return: HWND
##

const
  EEM_GETACTIVEHEX* = WM_USER + 3001

## *
##  @Msg:    Open a file
##  @Return: HWND: return the handle of opened file
##  @wparam: const wchar_t*: full path of file
##  @lparam: EE_LoadFile*
##

const
  EEM_LOADFILE* = WM_USER + 3002

## *
##  @Msg:    Manage callback functions. Plugin can Add/Remove callbacks
##  @Return: int: Total callbacks
##  @wparam: int: Type of callback
##  @lparam: LPVOID: Address of callback function
##

const
  EEM_SETHOOK* = WM_USER + 3003

## *
##  @Msg:    Manage a dockingWindow
##  @Return: BOOL: Return true if success
##  @wparam: int: Action
##           1: Add
## 			2: Hide
## 			3: Activate
##  @lparam: (EE_DockingWindow*)
##

const
  EEM_DOCKINGWINDOW* = WM_USER + 3004

## *
##  @Msg:    Update UI element's state(Check/Uncheck/Disable/Enable). UI elements are menu/button items.
##  @Return: void
##  @wparam: int: ID of UI element
##  @lparam: EE_UpdateUIElement*: You must set a valid value for nAction
##

const
  EEM_UPDATEUIELEMENT* = WM_USER + 3004

## *
##  NOT IMPLEMENTED!
##  @Msg:    Get a array which includes all handle of text document. Plugin should destroy this array after use
##  @Return: HWND*: head address of this vector
##  @wparam: int*: An integer to receive the size
##

const
  EEM_GETHWNDLIST* = WM_USER + 3005

## *
##  NOT IMPLEMENTED!
##  @Msg:    Activate a child window
##  @Return: BOOL: Return true if this window does exist and be activated, otherwise return false
##  @wparam: HWND: Windows' handle
##

const
  EEM_SETACTIVEVIEW* = WM_USER + 3006

## *
##  @Msg:    Add multiple callbacks
##  @Return: int: Total callbacks
##  @wparam: EE_HookFunc*: Address of callback array
##  @lparam: int: array's size
##

const
  EEM_SETHOOKS* = WM_USER + 3007

## *
##  @Msg:    Get default UI font of EverEdit
##  @Return: HFONT: Font's handle. DO NOT destroy this handle!
##

const
  EEM_GETUIFONT* = WM_USER + 3008

## *
##  EE_LoadFile.nViewType
##

const
  WT_UNKNOWN* = 0
  WT_TEXT* = 1
  WT_HEX* = 2

## *
##  EE_UpdateUIElementn.Action
##

const
  EE_UI_REMOVE* = 0
  EE_UI_ADD* = 1
  EE_UI_ENABLE* = 2
  EE_UI_SETCHECK* = 3

## *
##  Remove a callback
##

const
  EEHOOK_REMOVE* = 0

## *
##  @Prototype:int OnPopupTextMenu(HWND hWnd, HWND hMenu, int x, int y )
##  @Vars:
## 		hWnd: 	Handle of current document
## 		hMenu: 	Handle of context menu
## 		x: 		mouse position x
## 		y: 		mouse position y
##
##  Called on popuping context menu of text document. Plugin can add/remove menu items here.
##  The command id of menu item should be retrieved from EE_Context.
##

const
  EEHOOK_TEXTMENU* = 1

## *
##  @Prototype:int OnPopupHexMenu(HWND hWnd, HWND hMenu, int x, int y )
##  @Vars:
## 		hWnd: 	Handle of current document
## 		hMenu: 	Handle of context menu
## 		x: 		mouse position x
## 		y: 		mouse position y
##
##  Called on popuping context menu of hex document. Plugin can add/remove menu items here
##  The command id of menu item should be retrieved from EE_Context.
##

const
  EEHOOK_HEXMENU* = 2

## *
##  @Prototype:int OnPreSaveFile(HWND hWnd)
##  @Vars:
## 		hWnd: 	Handle of current document
##
##  Called before saving a document
##

const
  EEHOOK_PRESAVE* = 3

## *
##  @Prototype:int OnPostSaveFile(HWND hWnd)
##  @Vars:
## 		hWnd: 	Handle of current document
##
##  Called after saving a document
##

const
  EEHOOK_POSTSAVE* = 4

## *
##  @Prototype:int OnPreCloseFile(HWND hWnd)
##  @Vars:
## 		hWnd: 	Handle of current document
##
##  Called before closing a document
##

const
  EEHOOK_PRECLOSE* = 5

## *
##  @Prototype:int OnPostCloseFile(HWND hWnd)
##  @Vars:
## 		hWnd: 	Handle of current document
##
##  Called after closing a document
##

const
  EEHOOK_POSTCLOSE* = 6

## *
##  @Prototype:int OnAppMessage(UINT uMsg, WPARM wp, LPARAM lp)
##  @Vars:
## 		uMsg: 	Message's ID
##
##  Translate and Dispatch messages. Plugin can hook this function and monitor messages.
##

const
  EEHOOK_APPMSG* = 7

## *
##  @Prototype:int OnIdle(HWND hWnd)
##  @Vars:
## 		hWnd: 	Handle of main frame
##
##  Idle message. Plugin can update UI element's state here! DO NOT do complicated operations in this hook!
##

const
  EEHOOK_IDLE* = 8

## *
##  @Prototype:int OnPreTranslateMsg(MSG* pMsg)
##  @Vars:
## 		MSG*: 	See MSDN to get details about struct MSG
##
##  Plugin can monitor messages before dispatching.
##

const
  EEHOOK_PRETRANSLATEMSG* = 9

## *
##  @Prototype:int OnAppResize(RECT* rect)
##  @Vars:
## 		rect: 	Client rect
##
##  Application is reszing
##

const
  EEHOOK_APPRESIZE* = 10

## *
##  @Prototype:int OnAppActivate(HWND hWnd)
##  @Vars:
## 		hWnd: 	Handle of main window
##
##  Main application was activated
##

const
  EEHOOK_APPACTIVATE* = 11

## *
##  @Prototype:int OnChildActivate(HWND hOldWnd, HWND hNewWnd)
##  @Vars:
## 		hOldWnd: Handle of deactivated window
## 		hNewWnd: Handle of activated window
##
##  Child window(Text/Hex/Browser) was activated
##

const
  EEHOOK_CHILDACTIVATE* = 12

## *
##  @Prototype:int OnRunningCommand(const wchar_t* command, int length)
##  @Vars:
## 		command: command's text
## 		length:	 length
##
##  Plugin can handle commands from Command Bar
##

const
  EEHOOK_RUNCOMMAND* = 13

## *
##  @Prototype:int OnPreLoadTextFile(const wchar_t* pathname)
##  @Vars:
## 		pathname: file's full path
##
##  File would be loaded as text format
##

const
  EEHOOK_PRELOAD* = 14

## *
##  @Prototype:int OnPostLoadTextFile(const wchar_t* pathname)
##  @Vars:
## 		pathname: file's full path
##
##  File was loaded as text format. Note: EverEdit loads files asynchronously, plugin might not get content in this hook.
##

const
  EEHOOK_POSTLOAD* = 15

## *
##  @Prototype:int OnPostCreateTextFile(HWND hWnd)
##  @Vars:
## 		hWnd: Handle of this window
##
##  A new text window was created
##

const
  EEHOOK_POSTNEWTEXT* = 16

## *
##  @Prototype:int OnPopupTabMenu(HMENU hMenu, int x, int y)
##  @Vars:
## 		hMenu:	Handle of menu
## 		x:		x position
## 		y:		y position
##
##  Context menu of tab area will popup.
##

const
  EEHOOK_TABMENU* = 17

## *
##  @Prototype:int OnGetTextViewIcon(int type, HWND hWnd, HICON& ret)
##  @Vars:
## 		type:	Type of current window(Always is 1 now)
## 		hWnd:	Handle of window
## 		ret:	Handle of icon
##
##  Plugin can customize icon of each text view.
##

const
  EEHOOK_VIEWICON* = 18

## *
##  @Prototype:int OnPopupDockMenu(HMENU hMenu, int x, int y)
##  @Vars:
## 		hMenu:	Handle of menu
## 		x:		x position
## 		y:		y position
##
##  Context menu of dock tab will popup.
##

const
  EEHOOK_DOCKTABMENU* = 19

## *
##  @Prototype:int OnPreDirViewMenu(HMENU hMenu, int x, int y)
##  @Vars:
## 		hMenu:	Handle of menu
## 		x:		x position
## 		y:		y position
##
##  Context menu of directory view will popup. Plugin can add menu items with any unique id which is different with ContextMenu
##

const
  EEHOOK_PREDIRVIEWMENU* = 20

## *
##  @Prototype:int OnPostDirViewMenu(HWND hWnd, int command)
##  @Vars:
## 		hWnd:	Handle of directory view window
## 		command:Selected command
##
##  Context menu of directory view was popuped. Plugin executes some functions via command.
##

const
  EEHOOK_POSTDIRVIEWMENU* = 21

## *
##  @Prototype:int OnInputText(HWND hWnd, wchar_t* text)
##  @Vars:
## 		hWnd:	Handle of text window
## 		text:	content
##
##  Text will be inserted into text document by keyboard.
##

const
  EEHOOK_TEXTCHAR* = 100

## *
##  @Prototype:int OnTextCommand(HWND hWnd, WPARAM wp, LPARAM lp)
##  @Vars:
## 		hWnd:	Handle of text window
##
##  Command hook for text document
##

const
  EEHOOK_TEXTCOMMAND* = 101

## *
##  @Prototype:int OnUpdateTextView(HWND hWnd, ECNMHDR_TextUpdate* info)
##  @Vars:
## 		hWnd:	Handle of text window
## 		info:	info includes insert/delete range
##
##  Delete/Insert operations were executed! All text were already updated, so DO NOT use info to get text!
##

const
  EEHOOK_UPDATETEXT* = 102

## *
##  @Prototype:int OnCaretChange(HWND hWnd, ECNMHDR_CaretChange* info)
##  @Vars:
## 		hWnd:	Handle of text window
## 		info:
##
##  Caret's position was changed!
##

const
  EEHOOK_TEXTCARETCHANGE* = 103

## *
##  @Prototype:int OnPreWordComplete(HWND hWnd, AutoWordInput* info)
##  @Vars:
## 		hWnd:	Handle of text window
## 		info:
##
##  Auto completion is collecting words.
##

const
  EEHOOK_PREWORDCOMPLETE* = 104

## *
##  @Prototype:int OnPostWordComplete(HWND hWnd, int id, const wchar_t* text, int length)
##  @Vars:
## 		hWnd:	Handle of text window
## 		text:	word's text
## 		length:	word's length
##
##  Word will be inserted into document
##

const
  EEHOOK_POSTWORDCOMPLETE* = 105

## *
##  @Prototype:int OnCloseWordComplete()
##
##  Window of auto completion was closed.
##

const
  EEHOOK_CLOSEWORDCOMPLETE* = 106

## *
##  Hook function can return this message to stop routing message!
##

const
  EEHOOK_RET_DONTROUTE* = 0x00000000

## *
##  Position of docking window
##

const
  EE_DOCK_LEFT* = 0
  EE_DOCK_RIGHT* = 1
  EE_DOCK_BOTTOM* = 2
  EE_DOCK_TOP* = 3
  EE_DOCK_UNKNOWN* = 5

## *
##  Context of main application
##

type
  EE_Context* {.bycopy.} = object
    hMain*: HWND               ##  Main window
    hToolBar*: HWND            ##  Toolbar
    hStatusBar*: HWND          ##  Status bar
    hClient*: HWND             ##  Client window
    hStartPage*: HWND          ##  Start page
    hMainMenu*: HMENU          ##  Main menu
    hPluginMenu*: HMENU        ##  Plugin menu
    pCommand*: ptr DWORD        ##  Command value. Plugin reserves some commands and set a new value for other plugins
    dwVersion*: DWORD          ##  Version info
    dwBuild*: DWORD            ##  Build info
    dwLCID*: DWORD              ##  LCID


## *
##  EE_HookFunc
##

type
  EE_HookFunc* {.bycopy.} = object
    nType*: cint               ##  type
    lpFunc*: LPVOID            ##  address of callback


## *
##  EE_LoadFile
##

type
  EE_LoadFile* {.bycopy.} = object
    nCodepage*: cint           ##  Codepage of file
    nViewType*: cint           ##  View's type
    bReadOnly*: WINBOOL           ##  Is read-only?


## *
##  EE_UpdateUIElement
##

type
  EE_UpdateUIElement* {.bycopy.} = object
    nAction*: cint
    nValue*: cint              ##  update to new state


## *
##  EE_DockingWindow
##

type
  EE_DockingWindow* {.bycopy.} = object
    hWnd*: HWND
    nSide*: cint               ##  valid on adding


## *
##  AutoWordInput
##

type
  AutoWordInput* {.bycopy.} = object
    pos*: ptr EC_Pos            ##  caret pos
    lpHintText*: LPCWSTR    ##  User is inputting some texts
    nLength*: cint


## *
##  Plugin returns words for auto completion
##

type
  AutoWordList* {.bycopy.} = object
    lpWords*: LPCWSTR          ##  words
    nCount*: cint              ##  count
    hIcon*: HICON              ##  Not used!
    id*: DWORD                 ##  ID


## *
##  Web preview
##

type
  WebPreviewData* {.bycopy.} = object
    lpPathName*: LPCWSTR    ##  full path
    lpCharset*: LPCWSTR     ##  Not used!
    bCanDelete*: bool          ##  Can be delete after closing EverEdit?

