# mol-data
Source files for [GitHub Pages on molecular data services](https://biodiversitydata-se.github.io/mol-data/) provided by the [Swedish Biodiversity Data Infrastructure](https://biodiversitydata.se/).

Note that content is currently written as reStructuredText files, which are then copied to where GitHub Pages want them. Files could be translated to Markdown at some point.

*rdocs*: Source and build directories for [Sphinx](http://www.sphinx-doc.org/en/master/).

*docs*: Sphinx output copied from rdocs to function as GitHub Pages source.

### Update content like this
1. If needed: Download and install [Sphinx](http://www.sphinx-doc.org/en/master/).
2. Go to *rdocs* folder and edit content in reStructuredText (rst) files.
2. Use `make github` command (i.e. `make html` + `cp -a _build/html/. ../docs`, see *rdocs/Makefile*) to build html and copy files to *docs* directory.
3. Commit and push changes.
