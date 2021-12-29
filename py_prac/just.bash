export JUST_PROJECT_ROOT="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

function just_venv_create {
  python -m venv ~/.virtualenvs/pandas_data_analytics;
}

function just_venv_install_pip_deps {
  pip install wheel; pip install -e "$JUST_PROJECT_ROOT";
}

function just_first_time_initialize_windows {
  just_first_time_initialize_generic 'win';
}

function just_first_time_initialize {
  just_first_time_initialize_generic
}

function just_venv_connect_win {
  . $HOME/.virtualenvs/pandas_data_analytics/Scripts/activate;
}

function just_venv_connect {
  . $HOME/.virtualenvs/pandas_data_analytics/bin/activate;
}

function just_venv_disconnect {
  deactivate;
}

function just_first_time_initialize_generic {
  local os="$1";
  just_venv_create;
  if [[ "$os" = "win" ]]; then
    . $HOME/.virtualenvs/pandas_data_analytics/Scripts/activate;
  else
    . $HOME/.virtualenvs/pandas_data_analytics/bin/activate;
  fi
  just_venv_install_pip_deps;
}

function just_format {
  autopep8 "$JUST_PROJECT_ROOT" && echo "Projected Formated!" || { echo "Failed to format project!"; exit 1; }
}

