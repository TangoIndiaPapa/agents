"""
ValidationMiddleware: Integrates tools like ruff, mypy, pytest for validation.

This class provides methods to:
- Run individual validation tools with specified arguments.
- Validate code paths using all configured tools.

Attributes:
    tools (dict): A dictionary mapping tool names to their executable commands.
"""

import subprocess

class ValidationMiddleware:
    def __init__(self):
        self.tools = {
            "ruff": "ruff",
            "mypy": "mypy",
            "pytest": "pytest"
        }

    def run_tool(self, tool_name: str, args: list):
        """
        Runs a validation tool with the given arguments.

        Args:
            tool_name (str): The name of the tool to run (e.g., 'ruff', 'mypy').
            args (list): A list of arguments to pass to the tool.

        Returns:
            str: The standard output of the tool.

        Raises:
            ValueError: If the tool is not supported.
            RuntimeError: If the tool execution fails.
        """
        if tool_name not in self.tools:
            raise ValueError(f"Tool {tool_name} is not supported.")
        command = [self.tools[tool_name]] + args
        result = subprocess.run(command, capture_output=True, text=True)
        if result.returncode != 0:
            raise RuntimeError(f"{tool_name} failed: {result.stderr}")
        return result.stdout

    def validate_code(self, paths: list):
        """
        Runs all validation tools on the given paths.

        Args:
            paths (list): A list of file or directory paths to validate.

        Returns:
            dict: A dictionary containing the results of each tool.
        """
        results = {}
        for tool in self.tools:
            try:
                results[tool] = self.run_tool(tool, paths)
            except RuntimeError as e:
                results[tool] = str(e)
        return results
