# mol-data
Source files for [GitHub Pages on molecular data services](https://biodiversitydata-se.github.io/mol-data/) provided by the [Swedish Biodiversity Data Infrastructure](https://biodiversitydata.se/).

Currently written as reStructuredText, but could be translated to Markdown at some point.

*rdocs*: Source and build directories for [Sphinx](http://www.sphinx-doc.org/en/master/).

*docs*: Sphinx output copied from rdocs to function as GitHub Pages source.

### Update like this
1. Edit reStructuredText (rst) files in *rdocs*. 
2. Use `make github` command (as suggested by [jason-huling](https://github.com/sphinx-doc/sphinx/issues/3382#issuecomment-470772316)) to build html and copy files to *docs* directory.
3. Commit and push changes.
