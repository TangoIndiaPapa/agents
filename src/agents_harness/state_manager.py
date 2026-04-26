"""
StateManager: Handles reading and writing of AGENTS.md and .agent-state/.

This class provides methods to:
- Read the AGENTS.md file.
- Write and read JSON state files in the .agent-state directory.

Attributes:
    agents_md_path (Path): Path to the AGENTS.md file.
    state_dir (Path): Path to the .agent-state directory.
"""

from pathlib import Path
import json

class StateManager:
    def __init__(self, agents_md_path: str, state_dir: str):
        self.agents_md_path = Path(agents_md_path)
        self.state_dir = Path(state_dir)
        self.state_dir.mkdir(parents=True, exist_ok=True)

    def read_agents_md(self):
        """
        Reads the AGENTS.md file and returns its content.

        Returns:
            str: The content of the AGENTS.md file.

        Raises:
            FileNotFoundError: If the AGENTS.md file does not exist.
        """
        if not self.agents_md_path.exists():
            raise FileNotFoundError(f"{self.agents_md_path} does not exist.")
        return self.agents_md_path.read_text()

    def write_state(self, filename: str, data: dict):
        """
        Writes a JSON state file to the .agent-state directory.

        Args:
            filename (str): The name of the state file to write.
            data (dict): The data to write to the state file.
        """
        state_file = self.state_dir / filename
        with state_file.open('w') as f:
            json.dump(data, f, indent=4)

    def read_state(self, filename: str):
        """
        Reads a JSON state file from the .agent-state directory.

        Args:
            filename (str): The name of the state file to read.

        Returns:
            dict: The content of the state file.

        Raises:
            FileNotFoundError: If the state file does not exist.
        """
        state_file = self.state_dir / filename
        if not state_file.exists():
            raise FileNotFoundError(f"State file {filename} does not exist.")
        with state_file.open('r') as f:
            return json.load(f)
