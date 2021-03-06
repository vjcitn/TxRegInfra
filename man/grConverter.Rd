% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lite.R
\name{grConverter}
\alias{grConverter}
\title{convert a GRanges to a JSON query for mongodb}
\usage{
grConverter(queryGRange, cfields = c(chrom = "chrom", start =
  "chromStart", end = "chromEnd"))
}
\arguments{
\item{queryGRange}{a \code{\link[GenomicRanges]{GRanges-class}} instance of length 1}

\item{cfields}{a named character(3) vector with names 'chrom', 'start',
'end'; the element values will be used to name document fields in the query}
}
\value{
a JSON document generated by rjson::toJSON
}
\description{
convert a GRanges to a JSON query for mongodb
}
\examples{
gr = GenomicRanges::GRanges('chr1', IRanges(1,25000))
grConverter(gr, cfields=c(chrom='chr', start='start', end='end'))
}
