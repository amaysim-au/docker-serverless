# bump-version-automation

## Setup
First go to your GitHub account and create one token with read permission to repositories.

Then export this generated token in your environment.
```bash
export GITHUB_TOKEN=<token>
```

## Dependencies
- Python 3

#### Python Virtual Environment
```bash
# Create environment
python3 -m venv venv

# To activate the environment
source venv/bin/activate

# When you finish you can exit typing
deactivate
```

#### Install dependencies

```bash
pip3 install -r requirements.txt
```

#### Run
```bash
python3 main.py
```

## Author
Managed by DNX Solutions.

## License
Apache 2 Licensed. See LICENSE for full details.