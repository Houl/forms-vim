" Features:
"   - Supports "textfield", "combobox", "checkbox" and "button" fields.
"   - Edititable and non-editable comboboxes.
"   - Supports tabbing between fields.
"   - Hotkeys to jump to a field directly (use hotkey in combination with meta
"     key or <C-G> prefix, e.g., Alt+f or Ctrl+Gf). If multiple fields share the
"     same hotkey, the focus will be rotated forward.
"   - Listeners for actions on buttons and changes in the values of fields.
"   - Validators to prevent loosing focus when value is invalid.
"   - Use <Esc> in fields to cancel change and restore old value. You can
"     press <Esc> twice to toggle between the last two values, so you never
"     completely loose a value that you type.
"   - Support for "default button" by hitting <Return> anywhere.
"   - API to create form, add fields and change the value of fields (see
"     forms#demo() for usage).
"   - Syntax highligting of title, labels and hotkeys.
"   - The form object can be reused to show multiple times.
"   - Use <Space> to toggle checkboxes and click on buttons. Use <CR> to click
"     buttons or trigger default button from anywhere else.
"   - Support for disabling fields
"     - greyed out
"     - no editing
"     - no focus
"     - hotkeys are ignored
"   - Keyboard navigation:
"     - <Tab>/<S-Tab>: Move focus forwards/backwards.
"     - <Down>/<C-N>: Open combobox popup or select next item in the combobox
"                     popup or move focus forwards.
"     - <Up>/<C-P>: Select next item in the combobox popup or move focus
"                   backwards.
"     - <F2>: Start editing mode for the current field.
"     - <Space>: Click button/checkbox or start editing mode.
"     - <CR>: Accept current selection in combobox or click current button or
"             default button (if set).
"     - <C-Y>: Accept current combobox selection.
"     - <C-E>: Cancel current combobox selection and close popup.
"     - <M-X>/<C-G>X: Move focus to the field with the specified hotkey.
"   - Operations on fields:
"     - Textfield:
"       - Type in to change value.
"       - <Esc> in select or insert mode restores old value.
"       - <Home> moves cursor to the start of the field.
"       - <End> moves cursor to the end of the field.
"       - <Space> in normal mode start editing.
"     - Combobox:
"       - <Down>/<C-N>: Open popup or select next item in the popup (only when
"                       the cursor is after the last character).
"       - <Up>/<C-P>: Select next item in the popup.
"       - <CR>: Accept current popup selection.
"       - <Space> in normal mode start editing.
"       - <C-Y>: Accept current popup selection.
"       - <C-E>: Cancel current popup selection and close popup.
"       - <Esc> in select or insert mode restores old value.
"       - <Esc> in insert mode to restore old value (works only while the focus
"       - <Home> moves cursor to the start of the field.
"       - <End> moves cursor to the end of the field.
"     - Checkbox:
"       - <Space> toggle value.
"     - Button:
"       - <Space> click button.
"       - <CR> click button.
" Running Demo:
"   - To execute demo, :call forms#demo().
"   - The form is a simplified address entry form. The address fields are
"     arranged in a reverse order just for the ease of demoing features.
"   - Enter data and and press <Tab> to go to next field.
"   - If you select USA as country, the states dropdown is enabled. Otherwise, a
"     textfield to enter arbitrary state name will be enabled.
"   - Enter the zip code. If country is "USA", an additional validation is done
"     to make sure the zipcode is of right format. For valid US zipcodes, a
"     zipcode lookup is done to lookup city and state. You need wget in the path
"     and Internet should be accessible.
"   - Check "Copy into System Clipboard" to copy the address into system
"     clipboard when OK button is pressed.
"   - At the end, to click OK button, do one of the following:
"     - While focus is in a field that is not a button, press <Enter>
"     - When focus is in the OK button press <Space> or <Enter>
"     - From anywhere, press the hotkey for the OK button (<M-O> or <C-G>o).
"   - To close the window/form you can click Cancel button by doing one of the
"     following:
"     - When focus is in the Cancel button press <Space> or <Enter>
"     - From anywhere, press the hotkey for the Cancel button (<M-C> or <C-G>c).
" Limitations:
"   - You can only show one form in each buffer. The buffer can't be reused to
"     show another form, without having the previous left-over hotkey maps
"     interfere. The same form can't simultaneously be shown in multiple buffers
"     (but you can easily make several copies using deepcopy() function to do
"     this).
"   - No mouse support.
"   - The new value of the field is recognized only when <Tab>/<Up>/<Down> keys
"     or hotkeys are used to move focus out of a field.
"   - User is responsible for creating window and buffer to show form and later
"     destroy it.
"   - Single line fields only, which means:
"     - No list support, a workaround would be to use comma (or other character)
"       separated values in a textfield. With the combination of user-completion
"       support on textfields this can work like a multi-selection list.
"     - No textarea support.
"   - The i_CTRL-O key is blocked in the forms buffer. This prevents
"     accidentally modifying unexpected areas.
"   - The form has sophisticated support for monitoring the cursor position and
"     prevent accidentally modifying readonly portions, but it is almost
"     impossible to guard against all possibilities, so if the user doesn't
"     follow the guidelines for navigating the form, it might result in
"     destroying the layout of the form and thus the field values. If you find
"     additional ways in which readonly areas of the form can be modified
"     using the default Vim functionality, please send me the steps and I can
"     try to guard against that.
"   - The validation check is merely intended for the user as a guideline. The
"     form doesn't guarantee that all the fields have valid values at the end,
"     as doing so is nearly impossible. Preventing the user completely from
"     moving the focus away from a field containing invalid value is impossible.
"     However, the plugin using the forms can easily do an extra check at the
"     end and take appropriate actions.
"   - There is no ability to control tab/focus order.
"   - The combobox popup is displayed only when the cursor is after the last
"     character.
" TODO:
"   - Some of the remappable <expr>s are returning bare commands (like i, a and
"     o) that could get interference from user mappings. To be paranoid, we
"     should have <Plug> mappings for all of these.
"   - field.requestFocus() function will be useful.
"   - Support for radio buttons.
"   - Optional user completion for textfields and comboboxes (no preset data).
"   - Avoid first empty line (in an empty buffer).
"   - The trick to automatically popup non-editable combobox popup marks the
"     buffer modified.
"   - Visit all the uses of FT_* and see if they can be abstracted.
"   - If we use the value as label for buttons, then some conditional code can
"     go away and avoid some bugs (e.g., I just realized that the button labels
"     are included in calculating maxLblSize, but this is wrong).

" Make sure line-continuations won't cause any problem. This will be restored
"   at the end
let s:save_cpo = &cpo
set cpo&vim

let s:ignoreNextCursorMovedI = 0
let s:ignoreNextCursorMoved = 0

" The form class/factory {{{

if exists('s:field')
  " To be able to hot-reload this file
  unlockvar! forms#form s:field
  unlockvar forms#FT_TEXTFIELD forms#FT_COMBOBOX forms#FT_BUTTON forms#FT_CHECKBOX
endif

let forms#FT_TEXTFIELD = 'textfield'
let forms#FT_COMBOBOX = 'combobox'
let forms#FT_BUTTON = 'button'
let forms#FT_CHECKBOX = 'checkbox'
lockvar forms#FT_TEXTFIELD forms#FT_COMBOBOX forms#FT_BUTTON forms#FT_CHECKBOX

" defaultbutton is the name of the button, not a reference to the hash.
let forms#form = {
      \ 'title': '',
      \ 'fields': [],
      \ 'defaultbutton': '',
      \ 'fieldMap': {},
      \ }

function! forms#form.new(title)
  let newform = deepcopy(self)
  unlockvar! newform
  unlet newform.new
  let newform.title = a:title
  lockvar! newform
  return newform
endfunction

" The name should correspond to an existing button field.
function! forms#form.setDefaultButton(buttonName)
  if !has_key(self.fieldMap, a:buttonName)
    throw 'forms: no field named '.a:buttonName
  endif
  let field = self.fieldMap[a:buttonName]
  if field.type != g:forms#FT_BUTTON
    throw 'forms: specified field: '.a:buttonName.' is not a button'
  endif
  unlockvar! self
  let self.defaultbutton = a:buttonName
  lockvar! self
endfunction

" field class/factory {{{
let s:field = {
      \       'name': '',
      \       'label': '',
      \       'value': '',
      \       'data': '',
      \       'type': '',
      \       'hotkey': '',
      \       'editable': 1,
      \       'enabled': 1,
      \       'cantypein': 1,
      \       'selectable': 1,
      \       'boundsSt': '',
      \       'boundsEn': '',
      \       'boundsSynGrp': '',
      \     }

function! s:field.new(form, ftype, fname, flabel, fvalue, hotkey)
  let newfield = deepcopy(self)
  unlet newfield.new

  unlockvar! newfield
  let newfield.type = a:ftype
  let newfield.name = a:fname
  let newfield.value = a:fvalue
  let newfield.label = a:flabel
  let newfield.hotkey = a:hotkey
  " FIXME: Vim bug with lockvar.
  "let newfield.form = a:form

  unlockvar! a:form
  call add(a:form.fields, newfield)
  let a:form.fieldMap[newfield.name] = newfield
  lockvar! a:form

  lockvar! newfield
  return newfield
endfunction

function! s:field.isFormShowing()
  " FIXME: Vim bug with lockvar.
  "return exists('b:curForm') && b:curForm is self.form
  return exists('b:curForm') && index(b:curForm.fields, self) != -1
endfunction

function! s:field.setValue(value)
  unlockvar! self
  let self.value = a:value
  lockvar! self
  if self.isFormShowing()
    " Update the display.
    call s:SetCurFieldValue(self, self.value)
  endif
endfunction

function! s:field.setListener(listener)
  unlockvar! self
  let self.listener = a:listener
  lockvar! self
endfunction

function! s:field.setData(data)
  if self.type != g:form#FT_COMBOBOX
    throw self.name.' is not a combobox'
  endif
  unlockvar! self
  let self.data = a:data
  lockvar! self
endfunction

function! s:field.setEnabled(enabled)
  unlockvar! self
  let self.enabled = a:enabled
  if self.isFormShowing()
    " Refresh syntax rules if form is already being displayed.
    call s:SetupSyntax()
  endif
  lockvar! self
endfunction

" A non-editable combobox.
function! s:field.isDropdown()
  return self.type == g:forms#FT_COMBOBOX && !self.editable
endfunction

" }}}

function! forms#form.getFieldValue(fname)
  if !has_key(self.fieldMap, a:fname)
    throw 'No such field: '.a:fname
  endif
  return self.fieldMap[a:fname].value
endfunction

function! forms#form.addTextField(fname, flabel, fvalue, hotkey)
  let field = s:field.new(self, g:forms#FT_TEXTFIELD, a:fname, a:flabel,
        \ a:fvalue, a:hotkey)
  return field
endfunction

function! forms#form.addComboBox(fname, flabel, fvalue, data, hotkey, editable)
  let field = s:field.new(self, g:forms#FT_COMBOBOX, a:fname, a:flabel,
        \ a:fvalue, a:hotkey)
  unlockvar! field
  let field.data = a:data
  let field.editable = a:editable
  if ! a:editable
    let field.selectable = 0
  endif
  let field.boundsSt = (a:editable ? '{' : '<')
  let field.boundsEn = (a:editable ? '}' : '>')
  let field.boundsSynGrp = 'formsCombo'
  lockvar! field
  return field
endfunction

function! forms#form.addCheckBox(fname, flabel, fvalue, hotkey)
  let field = s:field.new(self, g:forms#FT_CHECKBOX, a:fname, a:flabel,
        \ a:fvalue, a:hotkey)
  unlockvar! field
  let field.editable = 0
  let field.cantypein = 0
  let field.boundsSt = '['
  let field.boundsEn = ']'
  let field.boundsSynGrp = 'formsCheck'
  lockvar! field
  return field
endfunction

function! forms#form.addButton(fname, flabel, fvalue, hotkey, listener)
  let field = s:field.new(self, g:forms#FT_BUTTON, a:fname, a:flabel,
        \ a:fvalue, a:hotkey)
  unlockvar! field
  let field.boundsSt = '['
  let field.boundsEn = ']'
  let field.boundsSynGrp = 'formsButton'
  let field.editable = 0
  let field.cantypein = 0
  let field.listener = a:listener
  return field
endfunction

lockvar! s:field forms#form

" }}}

" ShowForm {{{

function! forms#ShowForm(form)
  call genutils#OptClearBuffer()
  " Find the max label size.
  let maxLblSize = 0
  for field in a:form.fields
    if field.type != g:forms#FT_BUTTON && strlen(field.label) > maxLblSize
      let maxLblSize = strlen(field.label)
    endif
  endfor
  unlockvar! a:form
  let a:form.maxLblSize = maxLblSize
  let a:form.stLine = line('$') + 1
  lockvar! a:form

  " Generate the form
  let _modified = &modified
  let b:curForm = a:form
  $
  setl modifiable
  if a:form.title != ''
    silent! put =a:form.title
    silent! put =substitute(a:form.title, '.', '-', 'g')
  endif
  unlockvar! a:form.fields
  try
    for field in a:form.fields
      let field.stLine = line('$')+1
      call s:SetCurFieldValue(field, field.value)
    endfor
  finally
    lockvar! a:form.fields
  endtry
  setl nomodifiable
  if !_modified
    setl nomodified
  endif

  call s:SetupBuf()

  exec a:form.stLine
  " Note: it is not normal! because we have mapped keystroke coming back.
  let cmd = s:NextField(1)
  if cmd != ''
    exec 'normal' cmd
  endif
endfunction

function! s:SetupBuf()
  inoremap <buffer> <Plug>FormsCY <C-Y>
  inoremap <buffer> <Plug>FormsCE <C-E>
  inoremap <buffer> <Plug>FormsCH <C-H>
  inoremap <buffer> <Plug>FormsCN <C-N>
  inoremap <buffer> <Plug>FormsCP <C-P>
  xnoremap <buffer> <Plug>FormsCG <C-G>
  snoremap <buffer> <Plug>FormsCG <C-G>
  inoremap <buffer> <Plug>FormsSpace <Space>
  inoremap <buffer> <Plug>FormsEsc <Esc>
  xnoremap <buffer> <Plug>FormsEsc <Esc>
  snoremap <buffer> <Plug>FormsEsc <Esc>
  " Warning: Using x and s modes separately preserve the right selecton mode.
  " This also avoids Vim automatically setting "select-mode" even when we
  " explicitly set visual mode (see "select-mode-mappings").
  nmap <buffer> <silent> <expr> <Down> <SID>Arrow(1)
  xmap <buffer> <silent> <expr> <Down> <SID>Arrow(1)
  smap <buffer> <silent> <expr> <Down> <SID>Arrow(1)
  imap <buffer> <silent> <expr> <Down> <SID>Arrow(1)
  nmap <buffer> <silent> <expr> <C-N> <SID>Arrow(1)
  xmap <buffer> <silent> <expr> <C-N> <SID>Arrow(1)
  smap <buffer> <silent> <expr> <C-N> <SID>Arrow(1)
  imap <buffer> <silent> <expr> <C-N> <SID>Arrow(1)
  nmap <buffer> <silent> <expr> <Tab> <SID>Tab(1)
  xmap <buffer> <silent> <expr> <Tab> <SID>Tab(1)
  smap <buffer> <silent> <expr> <Tab> <SID>Tab(1)
  imap <buffer> <silent> <expr> <Tab> <SID>Tab(1)
  nmap <buffer> <silent> <expr> <Up> <SID>Arrow(0)
  xmap <buffer> <silent> <expr> <Up> <SID>Arrow(0)
  smap <buffer> <silent> <expr> <Up> <SID>Arrow(0)
  imap <buffer> <silent> <expr> <Up> <SID>Arrow(0)
  nmap <buffer> <silent> <expr> <C-P> <SID>Arrow(0)
  xmap <buffer> <silent> <expr> <C-P> <SID>Arrow(0)
  smap <buffer> <silent> <expr> <C-P> <SID>Arrow(0)
  imap <buffer> <silent> <expr> <C-P> <SID>Arrow(0)
  nmap <buffer> <silent> <expr> <S-Tab> <SID>Tab(0)
  xmap <buffer> <silent> <expr> <S-Tab> <SID>Tab(0)
  smap <buffer> <silent> <expr> <S-Tab> <SID>Tab(0)
  imap <buffer> <silent> <expr> <S-Tab> <SID>Tab(0)
  xmap <buffer> <silent> <expr> <Space> <SID>Space()
  nmap <buffer> <silent> <expr> <Space> <SID>Space()
  nmap <buffer> <silent> <expr> <CR> <SID>Return()
  vmap <buffer> <silent> <expr> <CR> <SID>Return()
  imap <buffer> <silent> <expr> <CR> <SID>Return()
  inoremap <buffer> <silent> <expr> <Esc> <SID>Esc()
  xnoremap <buffer> <silent> <expr> <Esc> <SID>Esc()
  snoremap <buffer> <silent> <expr> <Esc> <SID>Esc()
  inoremap <buffer> <silent> <expr> <C-C> <SID>CtrlC()
  xnoremap <buffer> <silent> <expr> <C-C> <SID>CtrlC()
  snoremap <buffer> <silent> <expr> <C-C> <SID>CtrlC()
  imap <buffer> <expr> <C-Y> <SID>CtrlY()
  imap <buffer> <expr> <C-E> <SID>CtrlE()
  xnoremap <buffer> <silent> <expr> <Del> <SID>Del()
  snoremap <buffer> <silent> <expr> <Del> <SID>Del()
  xnoremap <buffer> <silent> <expr> <BS> <SID>BS()
  snoremap <buffer> <silent> <expr> <BS> <SID>BS()
  inoremap <buffer> <silent> <expr> <BS> <SID>BS()
  inoremap <buffer> <silent> <expr> <C-U> <SID>CtrlU()
  inoremap <buffer> <silent> <C-O> <Nop>
  "inoremap <buffer> <silent> <expr> <Plug>FormsPopup <SID>CursorMovedI()
  inoremap <buffer> <silent> <Plug>FormsPopup <C-R>=<SID>CursorMovedI()<CR>
  inoremap <buffer> <silent> <Plug>FormsInvVal <C-R>=<SID>ShowInvValMsg()<CR>
  vnoremap <buffer> <silent> <Plug>FormsInvVal :<C-U>call <SID>ShowInvValMsg()<CR>gv
  nmap <buffer> <silent> <expr> <F2> <SID>F2()
  imap <buffer> <silent> <expr> <End> <SID>End()
  smap <buffer> <silent> <expr> <End> <SID>End()
  imap <buffer> <silent> <expr> <Home> <SID>Home()
  smap <buffer> <silent> <expr> <Home> <SID>Home()

  for field in b:curForm.fields
    if field.hotkey != ''
      let hotkey = tolower(field.hotkey)
      for m in ['i', 'x', 's', 'n']
        exec m.'map <buffer> <silent> <expr> <C-G>'.hotkey.' '.
              \ (m == 'n' ? '' : '"\<Plug>FormsEsc".').
              \ "<SID>MoveToFieldForHotkey('".hotkey."')"
        exec m.'map <buffer> <silent> <M-'.hotkey.
              \ '> <C-G>'.hotkey
      endfor
    endif
  endfor

  call s:SetupSyntax()
  hi def link formsHeader Comment
  hi def link formsLabel Question
  "hi def link formsLabel Statement
  "hi def link formsHotkey Statement
  hi def link formsHotkey Underlined
  hi def link formsButton Statement
  hi def link formsCombo Statement
  hi def link formsCheck Statement
  hi def link formsDisabled Ignore

  aug FormsCursMonitor
    au! * <buffer>
    au CursorMovedI <buffer> :call <SID>CursorMovedI()
    au CursorMoved <buffer> :call <SID>CursorMoved()
    au WinLeave <buffer> call <SID>SetEditMode(0)
    au BufWinLeave <buffer> call <SID>SetEditMode(0)
    au WinLeave <buffer> call <SID>SetEditMode(0)
    au TabLeave <buffer> call <SID>SetEditMode(0)
    au BufHidden <buffer> call <SID>SetEditMode(0)
  aug END
endfunction

function! s:SetupSyntax()
  " Setup syntax highlighting.
  syn clear
  exec 'syn match formsHeader /\%'.b:curForm.stLine.'l.*/'
  for field in b:curForm.fields
    if ! field.enabled
      exec 'syn match formsDisabled /\%'.field.stLine.'l.*/'
      continue
    endif
    if field.type == g:forms#FT_BUTTON
      let stCol = b:curForm.maxLblSize+3
      let enCol = b:curForm.maxLblSize+3+strlen(field.label)+1
      let hotkeyCol = b:curForm.maxLblSize+3+
            \ match(field.label, '\c\V'.field.hotkey)
    else
      let stCol = 0
      let enCol = b:curForm.maxLblSize+2
      let hotkeyCol = b:curForm.maxLblSize -
            \ (strlen(field.label)-match(field.label, '\c\V'.field.hotkey))+1
    endif
    exec 'syn match formsLabel /\%'.field.stLine.'l\%>'.stCol.'c.*\%<'.enCol.
          \ 'c/ contains=formsHotkey,formsButton,formsCombo,formsCheck'
    exec 'syn match formsHotkey /\c\%'.field.stLine.'l\%'.hotkeyCol.'c'.
          \ field.hotkey.'/'
    if field.boundsSynGrp != ''
      exec 'syn match' field.boundsSynGrp '/\%'.field.stLine.'l\%'.
                \ (b:curForm.maxLblSize+1+strlen(field.boundsSt)).'c\V'.
                \ field.boundsSt.'/'
      exec 'syn match' field.boundsSynGrp '/\%'.field.stLine.'l'.field.boundsEn.
            \ '$/'
    endif
  endfor
endfunction

" }}}

" Key overrides/customizations (alphabetical) {{{

" Down/Up Arrow
"   - when popup is visible, acts like Ctrl-N/P
"   - on a combobox, opens popup if not open (only for Down)
"   - in all other conditions, moves to next/prevous field.
function! s:Arrow(downwards, ...)
  let curFieldNr = s:GetCurFieldNr(1)
  let noOpenComboPopup = (a:0 ? a:1 : 0)
  let cmd = ''
  if s:IsInsertMode()
    if curFieldNr != -1
      let curField = b:curForm.fields[curFieldNr]
      if pumvisible()
        let cmd = (a:downwards ? "\<Plug>FormsCN" : "\<Plug>FormsCP")
      elseif curField.type == g:forms#FT_COMBOBOX && a:downwards &&
            \ !noOpenComboPopup
        " Trigger showing popup.
        let cmd = "\<Plug>FormsSpace\<Plug>FormsCH"
      else
        let cmd = "\<Plug>FormsEsc".<SID>NextField(a:downwards)
      endif
    endif
  elseif s:IsSelectMode() || s:IsVisualMode()
    if curFieldNr != -1
      let curField = b:curForm.fields[curFieldNr]
      if curField.type == g:forms#FT_COMBOBOX && a:downwards &&
            \ !noOpenComboPopup
        let cmd = (s:IsSelectMode() ? "\<Plug>FormsCG" : '').
              \ "\<Plug>FormsEsca\<Plug>FormsPopup"
      else
        let cmd = "\<Plug>FormsEsc".<SID>NextField(a:downwards)
      endif
    endif
  elseif mode() == 'n'
    let cmd = <SID>NextField(a:downwards)
  endif
  return cmd
endfunction

function! s:BS()
  if s:IsVisualMode() || s:IsSelectMode()
    return s:Del()
  else
    let curFieldNr = s:GetCurFieldNr(1)
    let blockCol = b:curForm.maxLblSize + 2 + (curFieldNr != -1 ?
          \ strlen(b:curForm.fields[curFieldNr].boundsSt) : 0)
    if col('.') <= blockCol
      " Ignore when it will remove the separator.
      return ''
    endif
  endif
  return "\<BS>"
endfunction

function! s:CtrlC()
  call s:SetEditMode(0)
  return (s:IsSelectMode() ? "\<C-G>" : '' )."\<C-C>"
endfunction

" Ctrl-E
"   - when popup is visible, hides popup
"   - in any other condition acts like Ctrl-E
function! s:CtrlE()
  if pumvisible()
    let s:ignoreNextCursorMovedI += 1
  endif
  return "\<Plug>FormsCE"
endfunction

function! s:CtrlU()
  if col('.') <= (b:curForm.maxLblSize+2)
    return ''
  endif
  return "\<C-U>"
endfunction

" Ctrl-Y
"   - when popup is visible, behaves just like <Tab>
"   - in any other condition acts like Ctrl-Y
function! s:CtrlY()
  if pumvisible()
    return s:Tab(1)
  endif
  return "\<Plug>FormsCY"
endfunction

" Del (in visual/select mode)
"   - on fields in which you can "type in" value, deletes selection
"   - in all other conditions it is just ignored.
function! s:Del()
  if &modifiable && s:IsSelectMode() || s:IsVisualMode()
    let curFieldNr = s:GetCurFieldNr(1)
    if curFieldNr != -1 && b:curForm.fields[curFieldNr].cantypein
      let s:ignoreNextCursorMoved += 2
      return (s:IsVisualMode()?"\<C-G>":'')."\<Space>\<BS>"
    endif
  endif
  return ''
endfunction

" End (in select mode)
"   - starts Append mode.
function! s:End()
  let curFieldNr = s:GetCurFieldNr(1)
  if curFieldNr != -1 && b:curForm.fields[curFieldNr].cantypein
    if s:IsSelectMode()
      return "\<Plug>FormsEsca"
    elseif s:IsInsertMode()
      return "\<Plug>FormsEsc\<F2>\<End>"
    endif
  endif
  return ''
endfunction

" Home (in select mode)
"   - starts Insert mode.
function! s:Home()
  let curFieldNr = s:GetCurFieldNr(1)
  if curFieldNr != -1 && b:curForm.fields[curFieldNr].cantypein
    if s:IsSelectMode()
      return "\<Plug>FormsCGo\<Plug>FormsEsci"
    elseif s:IsInsertMode()
      return "\<Plug>FormsEsc\<F2>\<Home>"
    endif
  endif
  return ''
endfunction

" Esc
"   - for textfield and combobox.
"     - in insert mode, restores old value
"     - in select mode, starts append mode.
"   - in all other conditions, is ignored.
function! s:Esc()
  let curFieldNr = s:GetCurFieldNr(1)
  if curFieldNr != -1
    let curField = b:curForm.fields[curFieldNr]
    if s:IsInsertMode() || s:IsSelectMode()
      " Cancel change.
      let newval = s:GetCurFieldValue(curField)
      let oldval = ((newval ==# curField.value &&
            \ has_key(curField, 'transvalue')) ? curField.transvalue :
            \ curField.value)
      unlockvar! curField
      let curField.transvalue = newval
      lockvar! curField
      let stCol = b:curForm.maxLblSize+2+strlen(curField.boundsSt)
      let enCol = strlen(getline(curField.stLine))-strlen(curField.boundsEn)
      " FIXME: This can also use <F2>.
      if oldval != ''
        if enCol < stCol " No current value.
          let cmd = oldval
        else
          let cmd = "\<Esc>".stCol."|v".enCol."|s".oldval
        endif
        if curField.selectable
          let cmd .= "\<Esc>".stCol."|\<C-V>".(stCol+strlen(oldval)-1)."|\<C-G>"
        endif
      else
          let cmd = "\<Esc>".stCol."|v".enCol."|s \<BS>"
      endif
      return cmd
    elseif s:IsVisualMode()
      return "\<Esc>"
    endif
    return ''
  endif
  call s:SetEditMode(0)
  return "\<Esc>"
endfunction

function! s:F2()
  let curFieldNr = s:GetCurFieldNr(0)
  if curFieldNr != -1
    return s:MoveToField(curFieldNr, -1, 1)
  endif
endfunction

" Carriage return
"   - in a combobox popup selects the value and moves focus
"   - on a button peforms action on the button
"   - if a default button is specified moves focus to the default button and
"     performs action.
"   - if cursor is not on any field, is ignored.
"   - in any other condition moves focus.
function! s:Return()
  if pumvisible()
    return "\<C-Y>"
  else
    let curFieldNr = s:GetCurFieldNr(1)
    if curFieldNr != -1
      let curField = b:curForm.fieldMap[b:curForm.defaultbutton]
      if ! curField.enabled
        return ''
      endif
      if curField.type == g:forms#FT_BUTTON
        return "\<Space>"
      endif
    endif
    " If a default action on form is specified then DoAction() on it, otherwise,
    " treat it like <Down>.
    let defaultButtonNr = -1
    if b:curForm.defaultbutton != ''
      let defaultButton = b:curForm.fieldMap[b:curForm.defaultbutton]
      if defaultButton.enabled
        let defaultButtonNr = index(b:curForm.fields, defaultButton)
      endif
    endif
    if defaultButtonNr != -1
      return (mode() == 'n' ? '' : "\<Plug>FormsEsc").s:MoveToField(
            \ defaultButtonNr, curFieldNr, 0).
            \ "\<Space>"
    endif
    return (mode() == 'n' ? '' : "\<Plug>FormsEsc").s:NextField(1)
  endif
endfunction

" Space
"   - on a button triggers action
"   - on a checkbox toggles the value
"   - on a textfield and combobox start editing, if not already editing.
function! s:Space()
  let curFieldNr = s:GetCurFieldNr(1)
  let cmd = ''
  if curFieldNr != -1
    let curField = b:curForm.fields[curFieldNr]
    if curField.type == g:forms#FT_BUTTON
      let cmd = s:DoAction(curField)
    else
      call s:SetEditMode(1)
      if curField.type == g:forms#FT_CHECKBOX
        " Toggle value, but don't save it yet.
        let value = (s:GetCurFieldValue(curField) ? 0 : 1)
        let cmd .= (b:curForm.maxLblSize+3)."|:setl modifiable\<CR>r".
              \ (value ? 'x' : ' ').":setl nomodifiable\<CR>"
      endif
      let cmd .= s:MoveToField(curFieldNr, -1, 1)
    endif
    let cmd = (mode() == 'n' ? '' : "\<Plug>FormsEsc").cmd
  else
    return s:Tab(1)
  endif
  return cmd
endfunction

" Tab/S-Tab (always moves focus, even on comboboxes)
"   - when popup is visible, moves focus
"   - on comboboxes, moves focus
"   - all other conditions, acts like <Down>/<Up> arrow
function! s:Tab(downwards)
  if pumvisible()
    let s:ignoreNextCursorMovedI += 1
    " Strange: both do the same, but the former is not working.
    "let cmd = "\<Plug>FormsCY\<Plug>FormsEsc".s:NextField(a:downwards)
    let cmd = "\<Plug>FormsCY\<Plug>FormsEscl".
          \ (a:downwards ? "\<Tab>" : "\<S-Tab>")
  else
    let cmd = s:Arrow(a:downwards, 1)
  endif
  return cmd
endfunction

" }}}

function! s:CursorMoved()
  if s:ignoreNextCursorMoved
    "exec BPBreak(1)
    let s:ignoreNextCursorMoved -= 1
    return
  endif
  if s:IsSelectMode() || s:IsVisualMode()
    " HACK: the markers are not updated until you clear the selection (suggested
    " by Bram).
    exec 'normal! '.(s:IsSelectMode() ? "\<C-G>" : '')."\<Esc>gv".
          \ (s:IsSelectMode() ? "\<C-G>" : '')
    if (line("'<") != line("'>"))
      call s:SetEditMode(0)
    endif
  else
    let curFieldNr = s:GetCurFieldNr(1)
    if curFieldNr == -1
      call s:SetEditMode(0)
    else
      let curField = b:curForm.fields[curFieldNr]
      if !curField.cantypein || !curField.enabled
        call s:SetEditMode(0)
      endif
    endif
  endif
endfunction

function! s:CursorMovedI()
  let curFieldNr = s:GetCurFieldNr(1)
  if curFieldNr != -1
    if s:ignoreNextCursorMovedI
      let s:ignoreNextCursorMovedI -= 1
      return ''
    endif
    let curField = b:curForm.fields[curFieldNr]
    if ! curField.cantypein || !curField.enabled
      call s:SetEditMode(0)
      return ''
    endif
    if curField.type == g:forms#FT_COMBOBOX
      " If cursor is not on at the end of the value, then don't show popup, it
      " messes up.
      if col('.') != (strlen(getline('.')) - strlen(curField.boundsEn) + 1)
        return
      endif
      let curVal = s:GetCurFieldValue(curField)
      if curField.editable
        if curVal != ''
          let stCol = b:curForm.maxLblSize+3
          let data = [curVal]+curField.data
        else
          let stCol = b:curForm.maxLblSize+2
          let data = [curField.boundsSt]+map(copy(curField.data), 'curField.boundsSt.v:val')
        endif
      else
        let stCol = b:curForm.maxLblSize+3
        let data = [curField.value]+curField.data
      endif
      call complete(stCol, data)
    elseif curField.type == g:forms#FT_TEXTFIELD
    endif
  else
    call s:SetEditMode(0)
  endif
  return ''
endfunction

function! s:NextField(forward)
  " Determine the current cursor position.
  let curFieldNr = s:GetCurFieldNr(1)
  if curFieldNr == -1
    let curFieldNr = s:GetCurFieldNr(0)
    let curFieldNr = (curFieldNr < 0) ? 0 : curFieldNr
    let curFieldNr -= (col('.') <= (b:curForm.maxLblSize+1) ? 1 : 0)
  endif
  let stopColNr = (curFieldNr < 0 ? 0 : curFieldNr)
  let tmpNr = curFieldNr
  let nRounds = 0
  while 1
    let nextFieldNr = a:forward ? tmpNr + 1 : tmpNr - 1
    if nextFieldNr >= len(b:curForm.fields)
      let nextFieldNr = 0
    elseif nextFieldNr < 0
      let nextFieldNr = len(b:curForm.fields)-1
    endif
    if nextFieldNr == stopColNr
      " Happens when all fields are disabled.
      if nRounds > 1
        return ''
      endif
      let nRounds += 1
    endif
    let tmpNr = nextFieldNr
    if ! b:curForm.fields[nextFieldNr].enabled
      " FIXME: If all fields are not enabled, this will go inifinite loop.
      continue
    endif
    break
  endwhile
  return s:MoveToField(nextFieldNr, curFieldNr, 1)
endfunction

function! s:MoveToFieldForHotkey(hotkey)
  let fieldsForHotkey = []
  for field in b:curForm.fields
    if field.enabled && field.hotkey ==# a:hotkey
      call add(fieldsForHotkey, field)
    endif
  endfor
  if len(fieldsForHotkey) == 0
    return ''
  endif
  let curFieldNr = s:GetCurFieldNr(0)
  if curFieldNr == -1
    let fieldIdx = 0
  else
    let curField = b:curForm.fields[curFieldNr]
    let fieldIdx = index(fieldsForHotkey, curField)
    if fieldIdx != -1
      let fieldIdx = (fieldIdx == (len(fieldsForHotkey) - 1)) ? 0 :
            \ (fieldIdx + 1)
    else
      let fieldIdx = 0
    endif
  endif
  let field = fieldsForHotkey[fieldIdx]

  " FIXME: What about checkbox?
  let cmd = s:MoveToField(index(b:curForm.fields, field),
        \ s:GetCurFieldNr(1), (field.type == g:forms#FT_BUTTON ? 0 : 1))
  if field.type == g:forms#FT_BUTTON || field.type == g:forms#FT_CHECKBOX
    let cmd .= "\<Space>"
  endif
  return cmd
endfunction

function! s:MoveToField(nextFieldNr, curFieldNr, selectField)
  let colnr = col('.')
  let cmd = ''
  if a:curFieldNr != -1 && colnr > (b:curForm.maxLblSize + 1)
    " Save the current value.
    let curField = b:curForm.fields[a:curFieldNr]
    if curField.type != g:forms#FT_BUTTON
      let newvalue = s:GetCurFieldValue(curField)
      let isValid = 1
      if curField.isDropdown()
        let isValid = (index(curField.data, newvalue) != -1)
      endif
      if isValid && has_key(curField, 'listener') && has_key(curField.listener, 'isValid') != 0
        let isValid = curField.listener.isValid(curField.name, newvalue)
      endif
      if !isValid
        return "\<F2>\<Plug>FormsInvVal"
      endif
      if newvalue !=# curField.value &&
            \ has_key(curField, 'listener') && has_key(curField.listener, 'valueChanged') != 0
        let cmd = curField.listener.valueChanged(curField.name, curField.value,
              \ newvalue)
        " Often users forget to return something, so treat this as empty string.
        if type(cmd) == 0
          let cmd = ''
        endif
        unlockvar! curField
        let curField.value = newvalue
        lockvar! curField
      endif
    endif
  endif
  let nextField = b:curForm.fields[a:nextFieldNr]
  if ! nextField.enabled
    return cmd
  endif
  let linenr = nextField.stLine
  let stColnr = b:curForm.maxLblSize + 2 + strlen(nextField.boundsSt)
  let enColnr = strlen(getline(nextField.stLine)) -
            \ strlen(nextField.boundsEn)
  if ! nextField.cantypein
    call s:SetEditMode(0)
  else
    call s:SetEditMode(1)
  endif
  let showPopup = 0
  let delaySel = 0
  if linenr != line('.')
    let cmd .= linenr.'G'.stColnr.'|'
    let delaySel = 1
  else
    let cmd .= stColnr.'|'
    if a:selectField && nextField.selectable
      " Note: We look at the current value on the screen rather than
      " nextField.value because, the user could have pressed <C-C> to stop
      " editing and then moved on, which means, we don't know about the new
      " value yet.
      if nextField.cantypein && type(nextField.value) == 1 &&
            \ s:GetCurFieldValue(nextField) == ''
        if nextField.boundsEn != ''
          let cmd .= 'i'
        else
          " There is no valid column in this case, so it will first end up on an
          " invalid column, we can't avoid it.
          "exec BPBreak(1)
          let s:ignoreNextCursorMoved += 1
          let cmd .= 'a'
        endif
      else
        let cmd .= "\<C-V>".enColnr.'|'.
              \ (nextField.editable ? "\<C-G>" : 'o')
      endif
    elseif a:selectField && nextField.isDropdown() && len(nextField.data) != 0
      " This handles the non-editable combobox.
      let s:ignoreNextCursorMovedI = 0
      " HACK: As we are calculating the right end column, the cursor should never
      " go past the valid line, but there seems to be some spurious movement of
      " the cursor that triggers a CursorMoved event causing the edit mode to get
      " disabled.
      let s:ignoreNextCursorMoved += 1
      let cmd .= enColnr.'|a'
      let showPopup = 1
    endif
  endif
  " Create a local temporary map so that this can be marked as a "noremap",
  " while still allowing the global maps to be recursive.
  " WARNING: The substitute() on bar has a requirement, see map_bar. 
  exec 'nnoremap <buffer> <silent> <Plug>FormsMoveToField '.
        \ substitute(substitute(cmd, '|', '\\|', 'g'), "\<C-V>", "&&", 'g')
  return "\<Plug>FormsMoveToField"
        \ .(delaySel ? "\<F2>" : (showPopup ? "\<Plug>FormsPopup" : ''))
endfunction

function! s:DoAction(field)
  if a:field.type == g:forms#FT_BUTTON
    if has_key(a:field, 'listener')
          \ && has_key(a:field.listener, 'actionPerformed')
      " NOTE: The user may not be able to hide the form in the callback, but he
      " can return a normal mode command to do this.
      let cmd = a:field.listener.actionPerformed(a:field.name)
      " Often users forget to return something, so treat this as empty string.
      if type(cmd) != 0
        return cmd
      endif
    endif
  endif
  return ''
endfunction

" Utility functions {{{

function! s:ShowInvValMsg()
  echohl WarningMsg | echo 'Invalid value for this field' | echohl NONE
  return ''
endfunction

" Extract the current field value from the buffer.
function! s:GetCurFieldValue(field)
  "exec BPBreakIf(a:field.value ==# 'Hari', 1)
  let line = getline(a:field.stLine)
  let fieldValStCol = b:curForm.maxLblSize+2+strlen(a:field.boundsSt)
  let fieldValEnCol = strlen(line) - strlen(a:field.boundsEn)
  let value = strpart(line, fieldValStCol-1, fieldValEnCol-fieldValStCol+1)
  if a:field.type == g:forms#FT_CHECKBOX
    let value = (value =~ '^\s*$' ? 0 : 1)
  endif
  return value
endfunction

" Set the value to the field in the buffer.
function! s:SetCurFieldValue(field, value)
  let label = a:field.label
  let value = a:value
  if a:field.type == g:forms#FT_BUTTON
    let value = label
    let label = ''
  elseif a:field.type == g:forms#FT_CHECKBOX
    let value = (value ? 'x' : ' ')
  endif
  let line = printf('%'.b:curForm.maxLblSize.'s %s%s%s', label,
        \ a:field.boundsSt, value, a:field.boundsEn)
  if s:IsSelectMode() || s:IsVisualMode()
    exec "normal! \<Esc>"
  endif
  silent! keepjumps call setline(a:field.stLine, line)
endfunction

" Returns -1 if cursor is outside any field.
function! s:GetCurFieldNr(exactOnly)
  let linenr = line('.')
  let colnr = col('.')
  let curFieldNr = 0
  let foundField = 0
  for field in b:curForm.fields
    if field.stLine == linenr
      let foundField = 1
      break
    endif
    let curFieldNr += 1
  endfor
  if foundField
    let curField = b:curForm.fields[curFieldNr]
    "exec BPBreakIf(colnr > (strlen(getline(linenr)) - strlen(curField.boundsEn) + (s:IsInsertMode() ? '1' : 0)), 1)
    let stCol = (b:curForm.maxLblSize + 2 + strlen(curField.boundsSt))
    let enCol = strlen(getline(linenr)) - strlen(curField.boundsEn)
    if !a:exactOnly || (enCol < stCol) ||
        \ (colnr >= stCol && colnr <= (enCol + (s:IsInsertMode() ? '1' : 0)))
      return curFieldNr
    endif
  endif
  return -1
endfunction

function! s:IsSelectMode()
  return (index(['s', 'S', "\<C-S>"], mode()) != -1)
endfunction

function! s:IsVisualMode()
  return (index(['v', 'V', "\<C-V>"], mode()) != -1)
endfunction

function! s:IsInsertMode()
  return (index(['i', 'R'], mode()) != -1)
endfunction

let s:savedGlobalSett = {}

function! s:SetGlobalSett(sett, val)
  let s:savedGlobalSett[a:sett] = eval('&'.a:sett)
  exec 'let &'.a:sett.' = a:val'
endfunction

function! s:SetEditMode(editMode)
  if a:editMode && (!exists('b:formInEditMode') || !b:formInEditMode)
    " Always for the current buffer.
    setl modifiable
    call s:SetGlobalSett('backspace', 'start')
    call s:SetGlobalSett('keymodel', 'stopsel')
    let b:formInEditMode = 1
  elseif !a:editMode && exists('b:formInEditMode') && b:formInEditMode
    setl nomodifiable
    if s:IsInsertMode()
      stopinsert
    endif
    for sett in keys(s:savedGlobalSett)
      exec 'let &'.sett.' = s:savedGlobalSett[sett]'
    endfor
    let b:formInEditMode = 0
  endif
endfunction

" }}}

" Demo form {{{

" Listener class {{{
let s:demoListener = {}

function! s:demoListener.valueChanged(name, oldval, newval)
  "call input('Value of: '.a:name.' changed from: '.a:oldval.' to: '.a:newval)
  if a:name == 'zip' && b:curForm.getFieldValue('country') ==? 'USA'
    " This updates the buffer, which can't be done as part of the callback, so
    " return a normal mode command that can do this later.
    return ":call forms#UpdateCityState()\<CR>"
  elseif a:name == 'country'
    if a:newval !=? 'USA'
      call b:curForm.fieldMap['intstate'].setEnabled(1)
      call b:curForm.fieldMap['state'].setEnabled(0)
    else
      call b:curForm.fieldMap['intstate'].setEnabled(0)
      call b:curForm.fieldMap['state'].setEnabled(1)
    endif
  endif
  return ''
endfunction

function! s:demoListener.isValid(name, val)
  if a:name == 'zip' && a:val != '' && b:curForm.getFieldValue('country') ==? 'USA'
    if a:val !~ '^\d\{5}$'
      return 0
    endif
  endif
  return 1
endfunction

function! s:demoListener.actionPerformed(name)
  "call input('Listener called for action on '.a:name)
  if a:name ==# 'ok'
    let address = 
          \ "Address:\n".
          \ b:curForm.getFieldValue('firstname').' '.
          \ b:curForm.getFieldValue('lastname')."\n".
          \ b:curForm.getFieldValue('street')."\n".
          \ b:curForm.getFieldValue('city').', '.
          \ (b:curForm.getFieldValue('country')==?'USA' ?
          \  b:curForm.getFieldValue('state') :
          \  b:curForm.getFieldValue('intstate')).' - '.
          \ b:curForm.getFieldValue('zip')."\n".
          \ b:curForm.getFieldValue('country')."\n".
          \ 'Billing address? '.
          \ (b:curForm.getFieldValue('addresstype') ? 'Yes' : 'No')
    if b:curForm.getFieldValue('clipboard')
      let @* = address
      let @+ = address
    endif
    call input(address)
  else
    call input('Form cancelled, closing window')
    return ":bw!\<CR>"
  endif
endfunction
" }}}

function! forms#demo()
  let demoform = g:forms#form.new('Address Entry Form')
  call demoform.addTextField('firstname', 'First Name:', substitute($USER, '^.', '\u&', ''), 'f')
  call demoform.addTextField('lastname', 'Last Name:', '', 'l')
  call demoform.addComboBox('country', 'Country:', 'USA', ['India', 'USA',], 'y', 1)
  call demoform.addTextField('zip', 'Zip/Postal code:', '', 'z')
  let states = ['N/A', 'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY',]
  call demoform.addComboBox('state', 'State (USA):', 'N/A', states, 's', 0)
  let _void = demoform.addTextField('intstate', 'State (international):', '', 's').setEnabled(0)
  call demoform.addTextField('city', 'City:', 'Faraway City', 'i')
  call demoform.addTextField('street', 'Street:', '12345 Unknown Rd.', 's')
  call demoform.addCheckBox('addresstype', 'Billing Addres?', 1, 'b')
  call demoform.addCheckBox('clipboard', 'Copy into System Clipboard?', 0, 'd')
  call demoform.addButton('ok', 'OK', '', 'o', s:demoListener)
  call demoform.addButton('cancel', 'Cancel', '', 'c', s:demoListener)
  call demoform.setDefaultButton('ok')

  for field in demoform.fields
    if field.type != g:forms#FT_BUTTON
      call field.setListener(s:demoListener)
    endif
  endfor

  "new Form
  new
  wincmd _
  call forms#ShowForm(demoform)
endfunction

function! forms#UpdateCityState()
  let zip = b:curForm.getFieldValue('zip')
  if zip =~ '^\s*$'
    return
  endif
  let webservres = system('wget -q -O - http://www.webservicex.net/uszip.asmx/GetInfoByZIP?USZip='.zip)
  if v:shell_error != 0
    echohl WarningMsg | echo 'Error executing wget' | echohl None
    return
  endif
  let lines = split(webservres, "\n")
  if len(lines) <= 1
    return
  endif
  let city = ''
  let state = ''
  for line in lines
    if line =~? '<city>'
      let city = matchstr(line, '>\zs[^<]\+\ze<')
    elseif line =~? '<state>'
      let state = matchstr(line, '>\zs[^<]\+\ze<')
    endif
  endfor
  if city != ''
    call b:curForm.fieldMap['city'].setValue(city)
  endif
  if state != ''
    call b:curForm.fieldMap['state'].setValue(state)
  endif
endfunction
" }}}

" Restore cpo.
let &cpo = s:save_cpo
unlet s:save_cpo

" vim6:fdm=marker et sw=2
