#                       GNU GENERAL PUBLIC LICENSE
#                           Copyright 2022 jizhoulishi
#

############################  SETUP PARAMETERS
app_name='jizhoulishi-vimrc'
[ -z "$APP_PATH" ] && APP_PATH="$HOME/.vimrc_neovim"
[ -z "$REPO_URI" ] && REPO_URI='https://github.com/jizhoulishi/vimrc.git'
[ -z "$REPO_BRANCH" ] && REPO_BRANCH='vimrc_neovim'
debug_mode='0'
fork_maintainer='0'

############################  BASIC SETUP TOOLS
msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ]; then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

error() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

debug() {
    if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ]; then
        msg "An error occurred in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

program_exists() {
    local ret='0'
    command -v $1 >/dev/null 2>&1 || { local ret='1'; }

    # fail on non-zero return value
    if [ "$ret" -ne 0 ]; then
        return 1
    fi

    return 0
}

program_must_exist() {
    program_exists $1

    # throw error on non-zero return value
    if [ "$?" -ne 0 ]; then
        error "You must have '$1' installed to continue."
    fi
}

lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
    ret="$?"
    debug
}

variable_set() {
    if [ -z "$1" ]; then
        error "You must have your HOME environmental variable set to continue."
    fi
}

curl_plug(){
    local plug_path="$1"
    msg "Trying to install plug.vim"

    ## install plug
    ## curl -fLo "$plug_path" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ## TODO:
    local tmp_file="$APP_PATH/plug.vim"
    local dst_file="plug.vim"
    mkdir -p $plug_path
    cp $tmp_file $plug_path$dst_file

    success "Successfully curled Vim plug."

    debug
}

sync_repo() {
    local repo_path="$1"
    local repo_uri="$2"
    local repo_branch="$3"
    local repo_name="$4"

    msg "Trying to update $repo_name"

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone -b "$repo_branch" "$repo_uri" "$repo_path"
        ret="$?"
        success "Successfully cloned $repo_name."
    else
        cd "$repo_path" && git pull origin "$repo_branch"
        ret="$?"
        success "Successfully updated $repo_name"
    fi

    debug
}

create_symlinks() {
    local source_path="$1"
    local target_path="$2"

    lnif "$source_path/.vimrc"         "$target_path/.vimrc"
    lnif "$source_path/.vimrc.bundles" "$target_path/.vimrc.bundles"

    ret="$?"
    success "Setting up vim symlinks."
    debug
}

setup_vundle() {
    local system_shell="$SHELL"
    export SHELL='/bin/sh'

    vim \
        -u "$1" \
        "+set nomore" \
        "+PlugInstall!" \
        "+PlugClean" \
        "+qall"

    export SHELL="$system_shell"

    success "Now updating/installing plugins using Vundle"
    debug
}

############################ MAIN()
variable_set "$HOME"
program_must_exist "vim"
program_must_exist "git"

## sync repo
sync_repo       "$APP_PATH" \
                "$REPO_URI" \
                "$REPO_BRANCH" \
                "$app_name"

curl_plug       "$APP_PATH/.vim/autoload/"

create_symlinks "$APP_PATH" \
                "$HOME"


setup_vundle    "$APP_PATH/.vimrc.bundles"

msg             "\nThanks for installing $app_name."
msg             "Â© `date +%Y` jizhoulishi"

exec /bin/bash
