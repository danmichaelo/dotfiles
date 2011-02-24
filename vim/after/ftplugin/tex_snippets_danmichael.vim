if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet eqn \\begin{equation}<CR>".st.et."<CR>\\end{equation}<CR>".st.et
exec "Snippet leqn \\begin{equation}<CR>".st.et."<CR>\\label{eq:".st.et."}<CR>\\end{equation}<CR>".st.et
exec "Snippet eal \\begin{align}<CR>".st.et."<CR>\\end{align}<CR>".st.et
exec "Snippet leal \\begin{align}<CR>".st.et."<CR>\\label{eq:".st.et."}<CR>\\end{align}<CR>".st.et

exec "Snippet fig \\begin{figure}[".st."htbp".et."]<CR>\\begin{center}<CR>\\includegraphics{".st."filename".et."}<CR>\\end{center}<CR>\\caption{".st.et."}<CR>\\label{fig:".st."filename:substitute(@z,'.','\\l&','g')".et."}<CR>\\end{figure}<CR>".st.et

exec "Snippet subfig3 \\begin{figure}[".st."htbp".et."]<CR>\\centering<CR>\\subfigure[".st.et."]{<CR>\\includegraphics[width=4cm]{".st.et."}<CR>\\label{fig:".st.et."}<CR>}<CR>\\subfigure[".st.et."]{<CR>\\includegraphics[width=4cm]{".st.et."}<CR>\\label{fig:".st.et."}<CR>}<CR>\\subfigure[".st.et."]{<CR>\\includegraphics[width=4cm]{".st.et."}<CR>\\label{fig:".st.et."}<CR>}<CR>\\caption{".st.et."}<CR>\\end{figure}<CR>".st.et

exec "Snippet tab \\begin{table}[".st."htbp".et."]<CR>\\centering<CR>\\begin{tabular}{".st."lrrr".et."}<CR>".st.et."<CR>\\end{tabular}<CR>\\caption{".st.et."}<CR>\\label{tab:".st.et."}<CR>\\end{table}<CR>".st.et

exec "Snippet mat \\begin{pmatrix}".st.et."\\end{pmatrix}".st.et
exec "Snippet cre \\hat{a}_{".st.et."}^{\\dagger}".st.et
exec "Snippet ani \\hat{a}_{".st.et."}".st.et
exec "Snippet hat \\hat{".st.et."}".st.et
exec "Snippet exv \\langle ".st.et." | ".st.et." | ".st.et." \\rangle ".st.et
exec "Snippet qw \\vec{".st.et."}".st.et
exec "Snippet fra \\begin{frame}<CR>\\begin{itemize}<CR>\\item ".st.et."<CR>\\end{itemize}<CR>\\end{frame}"
