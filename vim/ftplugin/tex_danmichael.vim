
" Make tex errors readable (default is white text):
highlight texError guifg=#ff0000 guibg=#ffff00

" Define highlight groups:
highlight NearLongLine guibg=#ffffee
highlight LongLine guibg=#eeeeee

" matchadd was added in Vim 7.1

" Mark non-breaking spaces with red, as they will cause compilation failure:
let w:m1 = matchadd('ErrorMsg', "[\xA0]") 
"let w:m2 = matchadd('Search', "TODO")

" Highlight lines over 77 columns:
" let w:m2 = matchadd('NearLongLine', '\%<81v.\%>77v', -1) 
" let w:m3 = matchadd('LongLine', '\%>80v.\+', -1)

" Environments
let g:Tex_Env_subfigure = "\\begin{figure}[htbp]\<CR>\\centering\<CR>\\subfigure[<+Title1+>]{\<CR>\\includegraphics[width=6cm]{<+File1+>}\<CR>\\label{<+Label1+>}\<CR>}\<CR>\\subfigure[<+Title1+>]{\<CR>\\includegraphics[width=6cm]{<+File1+>}\<CR>\\label{<+Label1+>}\<CR>}\<CR>\\caption{<+Caption+>\<CR>\\label{<+Label+>}\<CR>\\end{figure}\<CR><++>"

