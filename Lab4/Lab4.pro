/*****************************************************************************

		Copyright (c) My Company

 Project:  LAB4
 FileName: LAB4.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "lab4.inc"
include "lab4.con"
include "hlptopic.con"

%BEGIN_WIN Task Window
/***************************************************************************
		Event handling for Task Window
***************************************************************************/

predicates

  task_win_eh : EHANDLER

constants

%BEGIN Task Window, CreateParms, 17:12:32-9.4.2019, Code automatically updated!
  task_win_Flags = [wsf_SizeBorder,wsf_TitleBar,wsf_Close,wsf_Maximize,wsf_Minimize,wsf_ClipSiblings]
  task_win_Menu  = res_menu(idr_task_menu)
  task_win_Title = "Lab4"
  task_win_Help  = idh_contents
%END Task Window, CreateParms

clauses

%BEGIN Task Window, e_Create
  task_win_eh(_Win,e_Create(_),0):-!,
  dlg_main_window_Create(_Win), win_Destroy(_Win),
%BEGIN Task Window, InitControls, 17:12:32-9.4.2019, Code automatically updated!
%END Task Window, InitControls
%BEGIN Task Window, ToolbarCreate, 17:12:32-9.4.2019, Code automatically updated!
%END Task Window, ToolbarCreate
ifdef use_message
	msg_Create(100),
enddef
	!.
%END Task Window, e_Create

%MARK Task Window, new events

%BEGIN Task Window, id_help_contents
  task_win_eh(_Win,e_Menu(id_help_contents,_ShiftCtlAlt),0):-!,
  	vpi_ShowHelp("lab4.hlp"),
	!.
%END Task Window, id_help_contents

%BEGIN Task Window, id_help_about
  task_win_eh(Win,e_Menu(id_help_about,_ShiftCtlAlt),0):-!,
	dlg_about_dialog_Create(Win),
	!.
%END Task Window, id_help_about

%BEGIN Task Window, id_file_exit
  task_win_eh(Win,e_Menu(id_file_exit,_ShiftCtlAlt),0):-!,
  	win_Destroy(Win),
	!.
%END Task Window, id_file_exit

%BEGIN Task Window, e_Size
  task_win_eh(_Win,e_Size(_Width,_Height),0):-!,
ifdef use_tbar
	toolbar_Resize(_Win),
enddef
ifdef use_message
	msg_Resize(_Win),
enddef
	!.
%END Task Window, e_Size

%END_WIN Task Window

/***************************************************************************
		Invoking on-line Help
***************************************************************************/

  project_ShowHelpContext(HelpTopic):-
  	vpi_ShowHelpContext("lab4.hlp",HelpTopic).

/***************************************************************************
			Main Goal
***************************************************************************/

goal

ifdef use_mdi
  vpi_SetAttrVal(attr_win_mdi,b_true),
enddef
ifdef ws_win
  ifdef use_3dctrl
    vpi_SetAttrVal(attr_win_3dcontrols,b_true),
  enddef
enddef  
  vpi_Init(task_win_Flags,task_win_eh,task_win_Menu,"lab4",task_win_Title).

%BEGIN_DLG About dialog
/**************************************************************************
	Creation and event handling for dialog: About dialog
**************************************************************************/

constants

%BEGIN About dialog, CreateParms, 17:12:32-9.4.2019, Code automatically updated!
  dlg_about_dialog_ResID = idd_dlg_about
  dlg_about_dialog_DlgType = wd_Modal
  dlg_about_dialog_Help = idh_contents
%END About dialog, CreateParms

predicates

  dlg_about_dialog_eh : EHANDLER

clauses

  dlg_about_dialog_Create(Parent):-
	win_CreateResDialog(Parent,dlg_about_dialog_DlgType,dlg_about_dialog_ResID,dlg_about_dialog_eh,0).

%BEGIN About dialog, idc_ok _CtlInfo
  dlg_about_dialog_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtrlInfo),0):-!,
	win_Destroy(_Win),
	!.
%END About dialog, idc_ok _CtlInfo
%MARK About dialog, new events

  dlg_about_dialog_eh(_,_,_):-!,fail.

%END_DLG About dialog

%BEGIN_DLG main_window
/**************************************************************************
	Creation and event handling for dialog: main_window
**************************************************************************/

constants

%BEGIN main_window, CreateParms, 19:55:05-9.4.2019, Code automatically updated!
  dlg_main_window_ResID = idd_main_window
  dlg_main_window_DlgType = wd_Modal
  dlg_main_window_Help = idh_contents
%END main_window, CreateParms
   
global domains 
  FILE = input
  
predicates

  dlg_main_window_eh : EHANDLER
  dlg_main_window_handle_answer(INTEGER EndButton,DIALOG_VAL_LIST)
  dlg_main_window_update(DIALOG_VAL_LIST)
  
  nondeterm repfile
  read_and_write(FILE,Window)

clauses

  repfile.    
  repfile:- repfile.
  
  read_and_write(F,W):- not(eof(F)),readln(L), lbox_Add(W, L), fail.
  read_and_write(F,_):- eof(F), closefile(F).
  
  dlg_main_window_Create(Parent):-

%MARK main_window, new variables

	dialog_CreateModal(Parent,dlg_main_window_ResID,"",
  		[
%BEGIN main_window, ControlList, 19:55:05-9.4.2019, Code automatically updated!
		df(idc_path,editstr("",[]),nopr),
		df(idc_lbox,listbox([],[0]),nopr)
%END main_window, ControlList
		],
		dlg_main_window_eh,0,VALLIST,ANSWER),
	dlg_main_window_handle_answer(ANSWER,VALLIST).

  dlg_main_window_handle_answer(idc_ok,VALLIST):-!,
	dlg_main_window_update(VALLIST).
  dlg_main_window_handle_answer(idc_cancel,_):-!.  % Handle Esc and Cancel here
  dlg_main_window_handle_answer(_,_):-
	errorexit().

  dlg_main_window_update(_VALLIST):-
%BEGIN main_window, Update controls, 19:55:05-9.4.2019, Code automatically updated!
	_IDC_PATH_VALUE = dialog_VLGetstr(idc_path,_VALLIST),
	dialog_VLGetListBox(idc_lbox,_VALLIST,_IDC_LBOX_ITEMLIST,_IDC_LBOX_SELECT),
%END main_window, Update controls
	true.

%MARK main_window, new events

%BEGIN main_window, idc_ok _CtlInfo
  dlg_main_window_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-
  LBox_Handle = win_GetCtlHandle(_Win,idc_lbox),     
  Path_Heandle = win_GetCtlHandle(_Win,idc_path),
  Path_Text = win_GetText(Path_Heandle), 
  Path_Text <> "",
  existfile(Path_Text),  
  
  openread(input,Path_Text),
  readdevice(input),
  
  lbox_Clear(LBox_Handle),
  repfile,
  read_and_write(input,LBox_Handle),!.
 		
  dlg_main_window_eh(_Win,e_Control(idc_ok,_CtrlType,_CtrlWin,_CtlInfo),0):-  
  dlg_Error("������","���� �� ������!"),
  	!.	
%END main_window, idc_ok _CtlInfo

%BEGIN main_window, idc_help _CtlInfo
  dlg_main_window_eh(_Win,e_Control(idc_help,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
	dlg_Note("������","��������� ��� ����������� ������ ���������� � �����, ������ �������. ��������� ���� � ����� � ������� ������ '�������'."),
	!.
%END main_window, idc_help _CtlInfo

%BEGIN main_window, idc_exit _CtlInfo
  dlg_main_window_eh(_Win,e_Control(idc_exit,_CtrlType,_CtrlWin,_CtlInfo),0):-!,
  win_Destroy(_Win),
	!.
%END main_window, idc_exit _CtlInfo

  dlg_main_window_eh(_,_,_):-!,fail.

%END_DLG main_window

