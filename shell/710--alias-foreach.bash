foreach () {
  local -r fn="${1}"
  local arr_input
  readarray arr_input

  for i in "${arr_input[@]}"; do
    echo $fn "'$i'"
    eval $fn "'$i'"
  done
}
