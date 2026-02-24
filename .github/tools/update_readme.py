"""Update the benchmark results section in README.md."""

import os
import re
import sys

MARKER_START = "<!-- BENCHMARK_RESULTS_START -->"
MARKER_END = "<!-- BENCHMARK_RESULTS_END -->"


def find_latest_comparison_file():
    files = sorted(
        [f for f in os.listdir(".") if f.startswith("comparison_") and f.endswith(".json")],
        reverse=True,
    )
    if not files:
        print("No comparison_*.json file found", file=sys.stderr)
        sys.exit(1)
    return files[0]


def read_comparison_output(path):
    with open(path) as f:
        return f.read().strip()


def build_section(comparison_file, comparison_output):
    return (
        f"{MARKER_START}\n"
        f"[最新の結果json]({comparison_file})\n"
        "<details><summary>詳細</summary>\n\n"
        "```\n"
        f"{comparison_output}\n"
        "```\n"
        "</details>\n"
        f"{MARKER_END}"
    )


def update_readme(readme_path, new_section):
    with open(readme_path) as f:
        content = f.read()

    updated = re.sub(
        rf"{re.escape(MARKER_START)}.*?{re.escape(MARKER_END)}",
        new_section,
        content,
        flags=re.DOTALL,
    )

    with open(readme_path, "w") as f:
        f.write(updated)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: update_readme.py <comparison_output_file> <readme_path>", file=sys.stderr)
        sys.exit(1)
    output_file = sys.argv[1]
    readme_path = sys.argv[2]

    comparison_file = find_latest_comparison_file()
    comparison_output = read_comparison_output(output_file)
    new_section = build_section(comparison_file, comparison_output)
    update_readme(readme_path, new_section)
    print(f"README.md updated with results from {comparison_file}")
