#!/bin/bash

usage() {
  cat <<EOF
Usage: $(basename "$0") <input> [output_folder]

Converts FASTA files to CoGenT format.

Arguments:
  <input>           Input file (.fasta) or directory containing .fasta files
  [output_folder]   Output folder for results (default: CoGent_ID)
  -h, --help        Print this help and exit
EOF
  exit
}

parse_params() {
  input="$1"
  output_folder="${2-CoGent_ID}"
  if [[ -z "$input" || "$input" == "-h" || "$input" == "--help" ]]; then
    usage
  fi
}

parse_params "$@"

# Sanity check: input must exist
if [[ ! -e "$input" ]]; then
  echo "Error: Input '$input' does not exist." >&2
  exit 1
fi

mkdir -p "$output_folder"

# Directory mode: process all .fasta files in the directory
if [[ -d "$input" ]]; then
  for f in "$input"/*.fasta; do
    [[ ! -f "$f" ]] && continue
    title="$(basename "$f" .fasta)"
    if [[ ! -s "$f" ]]; then
      echo "Warning: File '$f' is empty, skipping." >&2
      continue
    fi
    awk -v title="$title" 'BEGIN{seq=0} \
      /^>/ {printf(">%s-01-%06d %s\n", title, seq++, substr($0,2)); next} \
      {print}' "$f" > "$output_folder/${title}.faa"
    echo "Processed $f -> $output_folder/${title}.faa"
  done
  exit 0
fi

# Single FASTA file mode
if [[ "$input" == *.fasta ]]; then
  title="$(basename "$input" .fasta)"
  if [[ ! -s "$input" ]]; then
    echo "Error: Input fasta file '$input' is empty." >&2
    exit 1
  fi
  awk -v title="$title" 'BEGIN{seq=0} \
    /^>/ {printf(">%s-01-%06d %s\n", title, seq++, substr($0,2)); next} \
    {print}' "$input" > "$output_folder/${title}.faa"
  echo "Output written to $output_folder/${title}.faa"
  exit 0
fi

# If input is not a directory or .fasta file, print error
echo "Error: Input must be a .fasta file or a directory containing .fasta files." >&2
exit 1
