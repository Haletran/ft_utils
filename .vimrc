vim9script

# === Paramètres de base ===
set number              # Affiche les numéros de ligne
set tabstop=4           # Largeur de tabulation : 4 espaces
set shiftwidth=4        # Largeur d'indentation pour les >> <<
set smartindent         # Indentation intelligente
set mouse=a             # Active la souris
syntax on               # Active la coloration syntaxique

# === Raccourcis de navigation entre les fenêtres ===
nnoremap <S-Right> <C-w><Right>
nnoremap <S-Left>  <C-w><Left>
nnoremap <S-Up>    <C-w><Up>
nnoremap <S-Down>  <C-w><Down>

# === Raccourcis pour l'indentation en mode normal et visuel ===
nnoremap <S-Tab> <<
nnoremap <Tab>    >>
vnoremap <S-Tab> <<<Esc>gv
vnoremap <Tab>    >><Esc>gv

# === Division de la fenêtre ===
nnoremap <C-d>  :vs<CR>       # Division verticale
nnoremap <S-d>  :split<CR>    # Division horizontale

# === Sauvegarde et fermeture ===
inoremap <C-q> :q!<CR>
noremap  <C-q> :q!<CR>
inoremap <C-s> :w!<CR><Esc>
noremap  <C-s> :w!<CR><Esc>

# === Onglets ===
nnoremap <C-n>     :tabnew<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-Left>  :tabprevious<CR>
inoremap <C-Right> :tabnext<CR>
inoremap <C-Left>  :tabprevious<CR>

# === Terminal intégré ===
nnoremap <silent><S-t> :horizontal botright term ++rows=15 ++kill=term<CR>
nnoremap <silent><S-g> :vertical botright term ++kill=term<CR>

# Navigation dans le terminal
tnoremap <C-q> exit<CR>
tnoremap <S-Right> <C-W>N<C-w><Right>
tnoremap <S-Left>  <C-W>N<C-w><Left>
tnoremap <S-Up>    <C-W>N<C-w><Up>
tnoremap <S-Down>  <C-W>N<C-w><Down>
tnoremap <Esc>     <C-\><C-n>
