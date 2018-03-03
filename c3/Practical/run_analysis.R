## opens the Rmd file and makes the code book.
## Rmd file is R markdown
knit("runAnalysisCodebook.Rmd", output="runAnalysisCodebook.md", encoding="ISO8859-1", quiet=TRUE)
markdownToHTML("runAnalysisCodebook.md", "runAnalysisCodebook.html")

knit("makeCodebook.Rmd", output="codebook.md", encoding="ISO8859-1", quiet=TRUE)
