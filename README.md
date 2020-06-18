# mol-data
Source files for GitHub Pages on molecular data services provided by the [Swedish Biodiversity Data Infrastructure](https://biodiversitydata.se/).

*rdocs*: Source and build directories for [Sphinx](http://www.sphinx-doc.org/en/master/).

*docs*: Build output (html) copied from rdocs, used to build our [mol-data GitHub Pages](https://biodiversitydata-se.github.io/mol-data/).

### Update like this
Edit content in *rdocs*. Then use `make github` command (as suggested by [jason-huling](https://github.com/sphinx-doc/sphinx/issues/3382#issuecomment-470772316)) to build html and copy files to *docs* directory.
