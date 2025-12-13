#!/usr/bin/env bash
[[ $* =~ \S?\-\-debug\S? ]] && set -o xtrace

#############################################################################
# Python Repository Pruner
# Deletes Python temporary/disposable files and directories
# Optimized for performance with batch operations
#############################################################################

set -euo pipefail

# Color codes for output
RED=$(tput setaf 1)
readonly RED
GREEN=$(tput setaf 2)
readonly GREEN
YELLOW=$(tput setaf 3)
readonly YELLOW
NOCOLOR=$(tput sgr0)
readonly NOCOLOR

# Script configuration
VERBOSE=0
DRY_RUN=0
REPO_ROOT="."

#############################################################################
# Helper Functions
#############################################################################

print_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Delete Python temporary and cache files from repository.

OPTIONS:
    -h, --help          Show this help message
    -v, --verbose       Enable verbose output
    -n, --dry-run       Show what would be deleted without deleting
    -d, --directory     Specify repository directory (default: current directory)

EXAMPLES:
    $(basename "$0")                    # Clean current directory
    $(basename "$0") -v                 # Clean with verbose output
    $(basename "$0") -n                 # Preview what would be deleted
    $(basename "$0") -d /path/to/repo   # Clean specific directory

EOF
}

log_info() {
    echo -e "${GREEN}[INFO]${NOCOLOR} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NOCOLOR} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NOCOLOR} $*" >&2
}

log_verbose() {
    if [[ $VERBOSE -eq 1 ]]; then
        echo -e "${GREEN}[VERBOSE]${NOCOLOR} $*"
    fi
}

#############################################################################
# Validation Functions
#############################################################################

check_directory() {
    if [[ ! -d "$REPO_ROOT" ]]; then
        log_error "Directory does not exist: $REPO_ROOT"
        exit 1
    fi

    cd "$REPO_ROOT" || exit 1
    REPO_ROOT="$(pwd)"

    log_verbose "Working in directory: $REPO_ROOT"
}

check_git_repo() {
    if [[ ! -d ".git" ]] && ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_warn "Not a git repository. Continue anyway? [y/N]"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Aborted by user"
            exit 0
        fi
    fi
}

#############################################################################
# Deletion Functions
#############################################################################

delete_directories() {
    # Patterns that match basename only
    local -a name_patterns=(
        "__pycache__"
        "__pypackages__"
        ".cache"
        ".eggs"
        ".hypothesis"
        ".ipynb_checkpoints"
        ".mypy_cache"
        ".nox"
        ".pybuilder"
        ".pyre"
        ".pytest_cache"
        ".pytype"
        ".ropeproject"
        ".ruff_cache"
        ".scrapy"
        ".spyderproject"
        ".spyproject"
        ".tox"
        ".webassets-cache"
        "*.egg-info"
        "build"
        "cover"
        "cython_debug"
        "develop-eggs"
        "dist"
        "downloads"
        "eggs"
        "htmlcov"
        "instance"
        "lib64"
        "parts"
        "profile_default"
        "sdist"
        "share"
        "target"
        "var"
        "wheels"
    )

    # Patterns that need path matching
    local -a path_patterns=(
        "*/docs/_build"
        "./docs/_build"
    )

    log_info "Scanning for directories to delete..."

    # Build find command with basename patterns
    local find_cmd="find . -type d \("
    local first=1
    for pattern in "${name_patterns[@]}"; do
        if [[ $first -eq 1 ]]; then
            find_cmd+=" -name \"$pattern\""
            first=0
        else
            find_cmd+=" -o -name \"$pattern\""
        fi
    done

    # Add path patterns
    for pattern in "${path_patterns[@]}"; do
        find_cmd+=" -o -path \"$pattern\""
    done

    find_cmd+=" \) -prune"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "Directories that would be deleted:"
        eval "$find_cmd" -print | sort
    else
        local count
        count=$(eval "$find_cmd" -print | wc -l)

        if [[ $count -gt 0 ]]; then
            log_verbose "Deleting $count directories..."
            eval "$find_cmd" -exec rm -rf {} +
            log_info "Deleted $count directories"
        else
            log_info "No directories to delete"
        fi
    fi
}

delete_files() {
    local -a file_patterns=(
        ".coverage.*"
        ".coverage"
        ".dmypy.json"
        ".pdm.toml"
        "*.cover"
        "*.egg"
        "*.log"
        "*.manifest"
        "*.mo"
        "*.pot"
        "*.py,cover"
        "*.py[cod]"
        "*.sage.py"
        "*.so"
        "*.spec"
        "*\\\$py.class"
        "celerybeat-schedule"
        "celerybeat.pid"
        "coverage.xml"
        "db.sqlite3-journal"
        "db.sqlite3"
        "dmypy.json"
        "ipython_config.py"
        "local_settings.py"
        "MANIFEST"
        "nosetests.xml"
        "pip-delete-this-directory.txt"
        "pip-log.txt"
        "poetry.toml"
        "pyrightconfig.json"
    )

    log_info "Scanning for files to delete..."

    # Build find command with all file patterns
    local find_cmd="find . -type f \("
    local first=1
    for pattern in "${file_patterns[@]}"; do
        if [[ $first -eq 1 ]]; then
            find_cmd+=" -name \"$pattern\""
            first=0
        else
            find_cmd+=" -o -name \"$pattern\""
        fi
    done
    find_cmd+=" \)"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "Files that would be deleted:"
        eval "$find_cmd" -print | sort
    else
        local count
        count=$(eval "$find_cmd" -print | wc -l)

        if [[ $count -gt 0 ]]; then
            log_verbose "Deleting $count files..."
            eval "$find_cmd" -delete
            log_info "Deleted $count files"
        else
            log_info "No files to delete"
        fi
    fi
}

delete_empty_directories() {
    log_verbose "Removing empty directories..."

    if [[ $DRY_RUN -eq 1 ]]; then
        find . -type d -empty -print
    else
        local count
        count=$(find . -type d -empty -print | wc -l)

        if [[ $count -gt 0 ]]; then
            find . -type d -empty -delete
            log_verbose "Removed $count empty directories"
        fi
    fi
}

#############################################################################
# Main Execution
#############################################################################

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h | --help)
                print_usage
                exit 0
                ;;
            --debug)
                shift
                ;;
            -v | --verbose)
                VERBOSE=1
                shift
                ;;
            -n | --dry-run)
                DRY_RUN=1
                shift
                ;;
            -d | --directory)
                REPO_ROOT="$2"
                shift 2
                ;;
            *)
                log_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done
}

main() {
    parse_arguments "$@"

    log_info "Python Repository Pruner"
    echo

    check_directory
    check_git_repo

    if [[ $DRY_RUN -eq 1 ]]; then
        log_warn "DRY RUN MODE - No files will be deleted"
        echo
    fi

    # Delete in optimal order: directories first (removes entire trees),
    # then files, then cleanup empty directories
    delete_directories
    echo
    delete_files
    echo
    delete_empty_directories

    echo
    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "Dry run complete. Use without -n to actually delete files."
    else
        log_info "Cleanup complete!"
    fi
}

main "$@"
