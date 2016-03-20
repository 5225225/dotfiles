augroup filetypedetect
    au BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
    au BufNewFile,BufRead *.rs setf rust
    au BufNewFile,BufRead *.svm setf stackvm
augroup END

