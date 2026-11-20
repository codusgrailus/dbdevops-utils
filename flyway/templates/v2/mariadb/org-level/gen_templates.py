#!/usr/bin/env python3
"""Generate Harness stage, pipeline, and input-set YAML for a target organization and project."""

import argparse
import json
from pathlib import Path
import re
import sys


ENTITY_ROOT = re.compile(r"^(template|pipeline|inputSet):[ \t]*$", re.MULTILINE)
SCOPE_FIELD = r"^  {field}:[^\r\n]*"


def harness_identifier(value: str) -> str:
    if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_$]{0,127}", value):
        raise argparse.ArgumentTypeError(f"invalid Harness identifier: {value!r}")
    return value


def render_yaml(source: Path, org_id: str, project_id: str) -> str:
    # Update only the direct entity fields to preserve formatting and embedded scripts.
    text = source.read_text(encoding="utf-8")
    roots = ENTITY_ROOT.findall(text)
    if len(roots) != 1:
        raise ValueError(f"{source.name}: expected one template, pipeline, or input set")

    text, org_count = re.subn(
        SCOPE_FIELD.format(field="orgIdentifier"),
        lambda _: f'  orgIdentifier: "{org_id}"',
        text,
        flags=re.MULTILINE,
    )
    text, project_count = re.subn(
        SCOPE_FIELD.format(field="projectIdentifier"),
        lambda _: f'  projectIdentifier: "{project_id}"',
        text,
        flags=re.MULTILINE,
    )
    expected_project_count = int(roots[0] != "template")
    if org_count != 1 or project_count != expected_project_count:
        raise ValueError(f"{source.name}: unexpected organization or project metadata")
    return text


def main() -> int:
    source_dir = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-org_id", required=True, type=harness_identifier)
    parser.add_argument("-proj_id", required=True, type=harness_identifier)
    parser.add_argument(
        "-inputset_id",
        type=harness_identifier,
        help="override the generated sample input set identifier",
    )
    parser.add_argument(
        "-out_dir",
        type=Path,
        default=source_dir / ".generated_templates",
        help="output directory (default: .generated_templates beside the source YAML)",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="print a JSON map of filenames to rendered YAML without writing files",
    )
    for argument in sys.argv[1:]:
        option, equals, _ = argument.partition("=")
        if equals and option in ("-org_id", "-proj_id", "-inputset_id", "-out_dir"):
            parser.error(f"use {option} VALUE with a space")
    args = parser.parse_args()

    sources = sorted(source_dir.glob("*.yaml"))
    created = []
    try:
        if not sources:
            raise ValueError(f"No source YAML files found in {source_dir}")
        outputs = {
            source.name: render_yaml(source, args.org_id, args.proj_id)
            for source in sources
        }
        sample_inputset = "sample_inputset.yaml"
        if args.inputset_id is not None:
            if sample_inputset not in outputs:
                raise ValueError("-inputset_id requires sample_inputset.yaml")
            outputs[sample_inputset], count = re.subn(
                SCOPE_FIELD.format(field="identifier"),
                lambda _: f'  identifier: "{args.inputset_id}"',
                outputs[sample_inputset],
                flags=re.MULTILINE,
            )
            if count != 1:
                raise ValueError("Expected one input-set identifier in sample_inputset.yaml")
        if sample_inputset in outputs:
            sample_pipeline = "sample_pipeline_using_templates.yaml"
            pipeline_id = re.search(
                r"^  identifier:[ \t]*([A-Za-z_][A-Za-z0-9_$]{0,127})[ \t]*$",
                outputs.get(sample_pipeline, ""),
                flags=re.MULTILINE,
            )
            if pipeline_id is None:
                raise ValueError("The sample input set requires a sample pipeline identifier")
            outputs[sample_inputset], count = re.subn(
                r"(^  pipeline:[ \t]*\n    identifier:)[^\n]*",
                lambda match: f'{match[1]} "{pipeline_id[1]}"',
                outputs[sample_inputset],
                flags=re.MULTILINE,
            )
            if count != 1:
                raise ValueError("Expected one pipeline reference in sample_inputset.yaml")

        if args.json:
            print(json.dumps(outputs))
            return 0

        files = {args.out_dir / name: content for name, content in outputs.items()}
        for output in files:
            if output.exists() or output.is_symlink():
                raise FileExistsError(f"Output already exists: {output}")

        args.out_dir.mkdir(parents=True, exist_ok=True)
        for output, content in files.items():
            # Exclusive creation also protects against collisions after the preflight check.
            with output.open("x", encoding="utf-8") as stream:
                created.append(output)
                stream.write(content)
    except (OSError, ValueError) as error:
        for output in reversed(created):
            output.unlink()
        print(f"{parser.prog}: {error}", file=sys.stderr)
        return 1

    for output in created:
        print(f"Generated {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
