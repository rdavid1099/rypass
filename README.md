# README
RyPass - Password Generator
---
### Description
RyPass is a Terminal-based application that generates and stores passwords for multiple usernames on different accounts. All sensitive information is stored locally and can be accessed anytime using basic RyPass terminal commands.

### Setup
  - Clone down this repository.
  - `cd` into the rypass directory and run `./config/install.sh`
  - You may have to enter your `sudo` password to install RyPass into `/usr/local/bin`
  - Once the installation is complete, you can run any RyPass commands from the terminal using `rypass`.

### RyPass Operation
#### Commands
  - `new` or `n` - Generate a password for an account and username attached to that account.
    - Flags:
      - `--account=` or `-a` - Name of account
      - `--username=` or `-u` - Name of username
      - `--destination=` or `-d` - Path of destination for csv
      - `--length=` or `-l` - Length of generated password (12 character default)
  - `generate` or `g` - Generates a random password and displays it. Password is not attached to an account, username, or saved in the system.
    - Flags:
      - `--length=` or `-l` - Length of generated password (12 character default)
  - `account` or `a` - Displays usernames and passwords attached to account.
    - Secondary Actions:
      - `-A` or `--all` displays all usernames and passwords.
      - `-U` or `--usernames` displays only usernames attached to account.
      - `-P` or `--get-password` displays password for given username in account.
    - Flags:
      - `--account=` or `-a` - Name of account
      - `--username=` or `-u` - Name of username
  - `export` or `e` - Exports all accounts, including usernames and passwords, to a given path.
    - Flags:
      - `--path=` or `-p` - Path of RyPass data
      - `--destination=` or `-d` - Destination for the exported RyPass data
  - `uninstall` or `U` - Uninstall RyPass. All csvs and data will NOT be deleted and will still be accessible in the given directory.
