from robot import run_cli
 
def main():
 
    exit_code = run_cli(arguments=['--outputdir', 'results','tests/'], exit=False)
    print(f"exit code: {exit_code}")
 
if __name__ == "__main__":
    main()
''