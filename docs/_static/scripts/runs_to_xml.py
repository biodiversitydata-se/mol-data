#!/usr/bin/env python3
"""Convert a filled ENA Webin read spreadsheet (TSV) into experiment and run XML.

The input is the read submission template from the Webin Portal (FASTQ), filled
in as usual, with any number of extra columns. Each extra column, for example
"target gene", "target subfragment" or "pcr primers", is written as an
experiment attribute (EXPERIMENT_ATTRIBUTES) with the column name as tag.

The sample and study columns must hold accessions of samples and a study that
are already registered (e.g. ERS... and PRJEB...).

Usage:
    python3 runs_to_xml.py filled_runs.tsv [output_dir]

The script writes experiment.xml and run.xml to output_dir (default: the
directory of the input file). Submit them together with a submission.xml file,
see the guide for an example.
"""

import csv
import sys
from pathlib import Path
from xml.sax.saxutils import escape, quoteattr

# Columns that Webin uses for experiments and runs; all other columns become
# experiment attributes.
WEBIN_COLUMNS = {
    "sample", "study", "instrument_model", "library_name", "library_source",
    "library_selection", "library_strategy", "library_layout", "insert_size",
    "library_construction_protocol", "design_description",
    "forward_file_name", "forward_file_md5", "reverse_file_name",
    "reverse_file_md5", "file_name", "file_md5",
}

# Platform element for each instrument model, matched on the model prefix.
PLATFORMS = [
    ("Illumina", "ILLUMINA"), ("NextSeq", "ILLUMINA"), ("HiSeq", "ILLUMINA"),
    ("Ion", "ION_TORRENT"), ("PacBio", "PACBIO_SMRT"), ("Sequel", "PACBIO_SMRT"),
    ("Revio", "PACBIO_SMRT"), ("MinION", "OXFORD_NANOPORE"),
    ("GridION", "OXFORD_NANOPORE"), ("PromethION", "OXFORD_NANOPORE"),
    ("454", "LS454"), ("BGISEQ", "BGISEQ"), ("DNBSEQ", "BGISEQ"),
    ("MGISEQ", "BGISEQ"), ("Element", "ELEMENT"),
]


def platform_for(model):
    for prefix, platform in PLATFORMS:
        if model.startswith(prefix):
            return platform
    sys.exit(f"Unknown instrument model: {model!r}. Add it to PLATFORMS.")


def read_rows(path):
    """Return the rows of a Webin read spreadsheet as dictionaries."""
    with open(path, newline="", encoding="utf-8-sig") as f:
        lines = [line for line in f.read().splitlines() if line.strip()]
    # The first line ("FileType ...") describes the template, not a record.
    if lines and lines[0].startswith("FileType"):
        lines = lines[1:]
    reader = csv.DictReader(lines, delimiter="\t")
    rows = [{k.strip(): (v or "").strip() for k, v in r.items() if k} for r in reader]
    if not rows:
        sys.exit("No records found in the spreadsheet.")
    return rows, [c.strip() for c in reader.fieldnames if c]


def element(tag, value, indent):
    return f"{indent}<{tag}>{escape(value)}</{tag}>" if value else None


def main():
    if len(sys.argv) not in (2, 3):
        sys.exit(__doc__)
    infile = Path(sys.argv[1])
    outdir = Path(sys.argv[2]) if len(sys.argv) == 3 else infile.parent
    rows, columns = read_rows(infile)
    extra = [c for c in columns if c not in WEBIN_COLUMNS]

    aliases = [r["library_name"] for r in rows]
    duplicates = {a for a in aliases if aliases.count(a) > 1}
    if duplicates:
        sys.exit(f"library_name must be unique, as it is used as alias: {sorted(duplicates)}")

    exp = ['<?xml version="1.0" encoding="UTF-8"?>', "<EXPERIMENT_SET>"]
    run = ['<?xml version="1.0" encoding="UTF-8"?>', "<RUN_SET>"]
    for r in rows:
        alias = r["library_name"]
        paired = r.get("library_layout", "").upper() == "PAIRED"
        layout = "<PAIRED/>"
        if paired and r.get("insert_size"):
            layout = f'<PAIRED NOMINAL_LENGTH="{r["insert_size"]}"/>'
        elif not paired:
            layout = "<SINGLE/>"

        exp.append(f"  <EXPERIMENT alias={quoteattr(alias)}>")
        exp.append(f"    <TITLE>{escape(alias)}</TITLE>")
        exp.append(f'    <STUDY_REF accession="{r["study"]}"/>')
        exp.append("    <DESIGN>")
        exp.append(f"      <DESIGN_DESCRIPTION>{escape(r.get('design_description', ''))}</DESIGN_DESCRIPTION>")
        exp.append(f'      <SAMPLE_DESCRIPTOR accession="{r["sample"]}"/>')
        exp.append("      <LIBRARY_DESCRIPTOR>")
        for tag, col in (("LIBRARY_NAME", "library_name"), ("LIBRARY_STRATEGY", "library_strategy"),
                         ("LIBRARY_SOURCE", "library_source"), ("LIBRARY_SELECTION", "library_selection")):
            exp.append(element(tag, r.get(col, ""), "        "))
        exp.append(f"        <LIBRARY_LAYOUT>{layout}</LIBRARY_LAYOUT>")
        protocol = element("LIBRARY_CONSTRUCTION_PROTOCOL", r.get("library_construction_protocol", ""), "        ")
        if protocol:
            exp.append(protocol)
        exp.append("      </LIBRARY_DESCRIPTOR>")
        exp.append("    </DESIGN>")
        model = r["instrument_model"]
        exp.append(f"    <PLATFORM><{platform_for(model)}><INSTRUMENT_MODEL>{escape(model)}</INSTRUMENT_MODEL></{platform_for(model)}></PLATFORM>")
        attributes = [(c, r[c]) for c in extra if r.get(c)]
        if attributes:
            exp.append("    <EXPERIMENT_ATTRIBUTES>")
            for tag, value in attributes:
                exp.append(f"      <EXPERIMENT_ATTRIBUTE><TAG>{escape(tag)}</TAG><VALUE>{escape(value)}</VALUE></EXPERIMENT_ATTRIBUTE>")
            exp.append("    </EXPERIMENT_ATTRIBUTES>")
        exp.append("  </EXPERIMENT>")

        if paired:
            files = [(r["forward_file_name"], r["forward_file_md5"]), (r["reverse_file_name"], r["reverse_file_md5"])]
        else:
            files = [(r.get("file_name") or r["forward_file_name"], r.get("file_md5") or r["forward_file_md5"])]
        run.append(f"  <RUN alias={quoteattr(alias + ' run')}>")
        run.append(f"    <EXPERIMENT_REF refname={quoteattr(alias)}/>")
        run.append("    <DATA_BLOCK>")
        run.append("      <FILES>")
        for name, md5 in files:
            run.append(f'        <FILE filename={quoteattr(name)} filetype="fastq" checksum_method="MD5" checksum="{md5}"/>')
        run.append("      </FILES>")
        run.append("    </DATA_BLOCK>")
        run.append("  </RUN>")

    exp.append("</EXPERIMENT_SET>")
    run.append("</RUN_SET>")
    outdir.mkdir(parents=True, exist_ok=True)
    (outdir / "experiment.xml").write_text("\n".join(l for l in exp if l) + "\n", encoding="utf-8")
    (outdir / "run.xml").write_text("\n".join(run) + "\n", encoding="utf-8")
    print(f"Wrote {len(rows)} experiments and runs to {outdir / 'experiment.xml'} and {outdir / 'run.xml'}")
    if extra:
        print("Experiment attributes: " + ", ".join(extra))


if __name__ == "__main__":
    main()
