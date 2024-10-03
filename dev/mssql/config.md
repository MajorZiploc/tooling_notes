```vim

" the following are used only when container_name is not set
let $SQLCMDSERVER="127.0.0.1" |
let $SQLCMDPORT="5432" |
" the following are used regardless
let $SQLCMDDBNAME="mssql" |
let $SQLCMDUSER="mssql" |
let $SQLCMDPASSWORD="password" |

let vim_code_runner_container_name="tooling_notes-mssql-1" |
let vim_code_runner_container_type="docker" |

let vim_code_runner_sql_as_csv="true" |
let vim_code_runner_should_convert_double_quotes="true" |

```
