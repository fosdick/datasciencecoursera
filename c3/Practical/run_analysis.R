## opens the Rmd file and makes the code book.
## Rmd file is R markdown
knit("runAnalysisCodebook.Rmd", output="codebook.md", encoding="ISO8859-1", quiet=TRUE)
markdownToHTML("codebook.md", "codebook.html")
