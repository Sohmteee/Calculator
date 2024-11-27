import os
import subprocess
import time
import sys

def run_command(command):
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    print(result.stdout)
    if result.stderr:
        print(result.stderr)

def setup_git():
    print("It looks like you haven't added this project to your GitHub yet")
    print("Let's quickly set it up!\n")

    run_command("git init")
    run_command("git add .")
    print("\nAdding commit...")
    run_command('git commit -m "commit"')
    print("Added commit successfully")
    run_command("git branch -M main")

    rep = input("Enter the name your GitHub repository here: ")
    run_command(f"git remote add origin https://github.com/Sohmteee/{rep}.git")
    print("\nPushing git...")
    run_command("git push -u origin main")

def update_git():
    print("\nChecking git status...")
    run_command("git status")
    run_command("git add .")
    print("\nAdding commits...")
    run_command('git commit -m "commit"')
    print("Added commits successfully")
    print("\nPushing git...")
    run_command("git push")

def main():
    while True:
        if os.path.exists('.git'):
            update_git()
        else:
            setup_git()

        print("\nWaiting for 60 seconds...")
        time.sleep(60)
        os.system('cls' if os.name == 'nt' else 'clear')

if __name__ == "__main__":
    script_path = os.path.abspath(__file__)
    if os.name == 'nt':
        os.system(f'start cmd /k python "{script_path}"')
    else:
        os.system(f'x-terminal-emulator -e python3 "{script_path}"')
