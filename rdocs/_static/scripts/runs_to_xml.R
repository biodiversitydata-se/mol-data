# Convert a filled ENA Webin read spreadsheet (TSV) into XML files for
# programmatic submission: experiment.xml, run.xml and submission.xml.
#
# The input is the read submission template from the Webin Portal (FASTQ),
# filled in as usual, with any number of extra columns. Each extra column, for
# example "target gene", "target subfragment" or "pcr primers", is written as an
# experiment attribute (EXPERIMENT_ATTRIBUTES) with the column name as tag.
#
# The sample and study columns must hold accessions of samples and a study that
# are already registered (e.g. ERS... and PRJEB...).
#
# Usage, from a terminal:
#   Rscript runs_to_xml.R filled_runs.tsv [output_dir]
# or in R / RStudio:
#   source("runs_to_xml.R"); runs_to_xml("filled_runs.tsv")
#
# The files are written to output_dir (default: the folder of the input file).
# Only base R is used.

# Columns that Webin uses for experiments and runs; all other columns become
# experiment attributes.
webin_columns <- c(
  "sample", "study", "instrument_model", "library_name", "library_source",
  "library_selection", "library_strategy", "library_layout", "insert_size",
  "library_construction_protocol", "design_description",
  "forward_file_name", "forward_file_md5", "reverse_file_name",
  "reverse_file_md5", "file_name", "file_md5"
)

# Platform element for each instrument model, matched on the model prefix.
platforms <- c(
  Illumina = "ILLUMINA", NextSeq = "ILLUMINA", HiSeq = "ILLUMINA",
  Ion = "ION_TORRENT", PacBio = "PACBIO_SMRT", Sequel = "PACBIO_SMRT",
  Revio = "PACBIO_SMRT", MinION = "OXFORD_NANOPORE",
  GridION = "OXFORD_NANOPORE", PromethION = "OXFORD_NANOPORE",
  "454" = "LS454", BGISEQ = "BGISEQ", DNBSEQ = "BGISEQ", MGISEQ = "BGISEQ",
  Element = "ELEMENT"
)

submission_xml <- c(
  '<?xml version="1.0" encoding="UTF-8"?>', "<SUBMISSION>", "  <ACTIONS>",
  "    <ACTION>", "      <ADD/>", "    </ACTION>", "  </ACTIONS>", "</SUBMISSION>"
)

xml_escape <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x
}

xml_attr <- function(x) {
  paste0('"', gsub('"', "&quot;", xml_escape(x), fixed = TRUE), '"')
}

platform_for <- function(model) {
  hit <- names(platforms)[startsWith(model, names(platforms))]
  if (length(hit) == 0) {
    stop("Unknown instrument model: '", model, "'. Add it to 'platforms'.")
  }
  platforms[[hit[1]]]
}

read_runs <- function(path) {
  lines <- readLines(path, encoding = "UTF-8", warn = FALSE)
  lines <- sub("^﻿", "", sub("\r$", "", lines))
  lines <- lines[nzchar(trimws(lines))]
  # The first line ("FileType ...") describes the template, not a record.
  if (length(lines) > 0 && startsWith(lines[1], "FileType")) lines <- lines[-1]
  runs <- read.delim(text = lines, sep = "\t", colClasses = "character",
                     check.names = FALSE, na.strings = character(0),
                     strip.white = TRUE, quote = "")
  if (nrow(runs) == 0) stop("No records found in the spreadsheet.")
  runs
}

runs_to_xml <- function(infile, outdir = dirname(infile)) {
  runs <- read_runs(infile)
  value <- function(r, col) if (col %in% names(runs)) runs[[col]][r] else ""
  extra <- setdiff(names(runs), webin_columns)

  aliases <- runs$library_name
  if (anyDuplicated(aliases)) {
    stop("library_name must be unique, as it is used as alias: ",
         paste(unique(aliases[duplicated(aliases)]), collapse = ", "))
  }

  exp <- c('<?xml version="1.0" encoding="UTF-8"?>', "<EXPERIMENT_SET>")
  run <- c('<?xml version="1.0" encoding="UTF-8"?>', "<RUN_SET>")
  for (r in seq_len(nrow(runs))) {
    alias <- aliases[r]
    paired <- toupper(value(r, "library_layout")) == "PAIRED"
    layout <- if (!paired) "<SINGLE/>" else if (nzchar(value(r, "insert_size"))) {
      paste0('<PAIRED NOMINAL_LENGTH="', value(r, "insert_size"), '"/>')
    } else "<PAIRED/>"

    exp <- c(exp,
      paste0("  <EXPERIMENT alias=", xml_attr(alias), ">"),
      paste0("    <TITLE>", xml_escape(alias), "</TITLE>"),
      paste0('    <STUDY_REF accession="', value(r, "study"), '"/>'),
      "    <DESIGN>",
      paste0("      <DESIGN_DESCRIPTION>", xml_escape(value(r, "design_description")), "</DESIGN_DESCRIPTION>"),
      paste0('      <SAMPLE_DESCRIPTOR accession="', value(r, "sample"), '"/>'),
      "      <LIBRARY_DESCRIPTOR>")
    for (tag in c("LIBRARY_NAME", "LIBRARY_STRATEGY", "LIBRARY_SOURCE", "LIBRARY_SELECTION")) {
      v <- value(r, tolower(tag))
      if (nzchar(v)) exp <- c(exp, paste0("        <", tag, ">", xml_escape(v), "</", tag, ">"))
    }
    exp <- c(exp, paste0("        <LIBRARY_LAYOUT>", layout, "</LIBRARY_LAYOUT>"))
    protocol <- value(r, "library_construction_protocol")
    if (nzchar(protocol)) {
      exp <- c(exp, paste0("        <LIBRARY_CONSTRUCTION_PROTOCOL>", xml_escape(protocol), "</LIBRARY_CONSTRUCTION_PROTOCOL>"))
    }
    model <- value(r, "instrument_model")
    platform <- platform_for(model)
    exp <- c(exp, "      </LIBRARY_DESCRIPTOR>", "    </DESIGN>",
      paste0("    <PLATFORM><", platform, "><INSTRUMENT_MODEL>", xml_escape(model),
             "</INSTRUMENT_MODEL></", platform, "></PLATFORM>"))
    attributes <- extra[vapply(extra, function(col) nzchar(value(r, col)), logical(1))]
    if (length(attributes) > 0) {
      exp <- c(exp, "    <EXPERIMENT_ATTRIBUTES>")
      for (tag in attributes) {
        exp <- c(exp, paste0("      <EXPERIMENT_ATTRIBUTE><TAG>", xml_escape(tag), "</TAG><VALUE>",
                             xml_escape(value(r, tag)), "</VALUE></EXPERIMENT_ATTRIBUTE>"))
      }
      exp <- c(exp, "    </EXPERIMENT_ATTRIBUTES>")
    }
    exp <- c(exp, "  </EXPERIMENT>")

    if (paired) {
      files <- list(c(value(r, "forward_file_name"), value(r, "forward_file_md5")),
                    c(value(r, "reverse_file_name"), value(r, "reverse_file_md5")))
    } else {
      name <- value(r, "file_name"); md5 <- value(r, "file_md5")
      if (!nzchar(name)) { name <- value(r, "forward_file_name"); md5 <- value(r, "forward_file_md5") }
      files <- list(c(name, md5))
    }
    run <- c(run,
      paste0("  <RUN alias=", xml_attr(paste(alias, "run")), ">"),
      paste0("    <EXPERIMENT_REF refname=", xml_attr(alias), "/>"),
      "    <DATA_BLOCK>", "      <FILES>")
    for (f in files) {
      run <- c(run, paste0("        <FILE filename=", xml_attr(f[1]),
                           ' filetype="fastq" checksum_method="MD5" checksum="', f[2], '"/>'))
    }
    run <- c(run, "      </FILES>", "    </DATA_BLOCK>", "  </RUN>")
  }
  exp <- c(exp, "</EXPERIMENT_SET>")
  run <- c(run, "</RUN_SET>")

  dir.create(outdir, showWarnings = FALSE, recursive = TRUE)
  writeLines(exp, file.path(outdir, "experiment.xml"), useBytes = TRUE)
  writeLines(run, file.path(outdir, "run.xml"), useBytes = TRUE)
  writeLines(submission_xml, file.path(outdir, "submission.xml"), useBytes = TRUE)
  message("Wrote ", nrow(runs), " experiments and runs, and submission.xml, to ", outdir)
  if (length(extra) > 0) message("Experiment attributes: ", paste(extra, collapse = ", "))
  invisible(outdir)
}

if (!interactive() && sys.nframe() == 0) {
  args <- commandArgs(trailingOnly = TRUE)
  if (!length(args) %in% 1:2) {
    stop("Usage: Rscript runs_to_xml.R filled_runs.tsv [output_dir]")
  }
  if (length(args) == 2) runs_to_xml(args[1], args[2]) else runs_to_xml(args[1])
}
