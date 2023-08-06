#! /usr/bin/env bash

file_and_dir_operations() {
  while true; do
    echo "The list of files and directories:"
    arr=(*)
    for item in "${arr[@]}"; do
      if [[ -f "$item" ]]; then
        echo "F $item"
      elif [[ -d "$item" ]]; then
        echo "D $item"
      fi
    done
    echo "---------------------------------------------------"
    echo "| 0 Main menu | 'up' To parent | 'name' To select |"
    echo "---------------------------------------------------"
    read -r subitem
    case $subitem in
    up)
      cd ..
      ;;
    0)
      break
      ;;
    [!.]*)
      if [[ " ${arr[*]} " == *" $subitem "* ]]; then
        if [[ -f "./$subitem" ]]; then
          while true; do
            echo "---------------------------------------------------------------------"
            echo "| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"
            echo "---------------------------------------------------------------------"

            read -r file_input

            case $file_input in

            1)
              rm "./$subitem"
              echo "$subitem has been deleted."
              break
              ;;
            2)
              echo "Enter the new file name: "
              read -r new_file_name
              mv "./$subitem" "./$new_file_name"
              echo "$subitem has been renamed as $new_file_name"
              break
              ;;
            3)
              chmod a+w "./$subitem"
              echo "permissions have been updated."
              ls -l "$subitem"
              break
              ;;
            4)
              chmod ug+rw,o-w "./$subitem"
              echo "permissions have been updated."
              ls -l "$subitem"
              break
              ;;
            0)
              break
              ;;
            *) ;;

            esac

          done

        elif
          [[ -d "./$subitem" ]]
        then
          cd "./$subitem" || exit
        fi
      else
        echo "Invalid input!"
      fi
      ;;

    *)
      echo "Invalid input!"
      ;;
    esac
  done
}

menu() {
  while true; do
    echo "------------------------------"
    echo "| Hyper Commander            |"
    echo "| 0: Exit                    |"
    echo "| 1: OS info                 |"
    echo "| 2: User info               |"
    echo "| 3: File and Dir operations |"
    echo "| 4: Find Executables        |"
    echo "------------------------------"

    read -r item

    case $item in
    0)
      echo "Farewell!"
      exit 1
      ;;
    1)
      echo "$(uname -s) $(uname -n)"
      ;;
    2)
      whoami
      ;;

    3)
      file_and_dir_operations
      ;;
    4)
      echo "Enter an executable name:"
      read -r executable
      # Check if the input is a regular file and executable
      if command -v "$executable" &>/dev/null; then
        command_location=$(which "$executable")
        echo "Located in: $command_location"
        echo "Enter arguments: "
        read -r args

        command_output=$($executable "$args")
        echo "$command_output"

      else

        echo "The executable with that name does not exist!"
      fi
      ;;

    *)
      echo "Invalid option!"
      ;;

    esac

  done
}
echo "Hello ${USER}!"
menu
