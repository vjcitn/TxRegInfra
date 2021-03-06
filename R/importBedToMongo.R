#' @importFrom IRanges IRanges
.importToMongo = function(path, collectionName, fields, dbname = "db", type = "tsv", 
    importCmd = "mongoimport", host = "127.0.0.1") {
    if (type != "tsv") 
        stop("only handling tsv at this time")
    if (!verifyHasMongoCmd("mongoimport")) 
        stop("need system command mongoimport to be available")
    cmd = paste0(importCmd, " --host ", host, " --db ", dbname, " --collection ", 
        collectionName, " --type ", type, " --fields ", fields, "  --file ", path)
    cmd2args = c(" --host ", host, " --db ", dbname, " --collection ", collectionName, 
        " --type ", type, " --fields ", fields, "  --file ", path)
    chk = try(system2(importCmd, args = cmd2args, stdout = TRUE))
    if (inherits(chk, "try-error")) 
        return(chk)
    TRUE
}

.fieldString = function(type = "broadPeak") {
    baseFields = "chrom,chromStart,chromEnd,name,score,strand,signalValue,pValue,qValue"
    if (type == "narrowPeak") 
        return(paste0(baseFields, ",peak")) else if (type == "broadPeak") 
        return(baseFields) else if (type == "chromHMM") 
        return("chrom,chromStart,chromEnd,state") else stop("type must be one of 'broadPeak', 'narrowPeak', 'chromHMM'")
}

#' arrange import to mongo using mongoimport, setting up type and fields appropriately
#' @param path path to bed file (not compressed)
#' @param collectionName name to use in mongodb
#' @param bedType one of 'narrowPeak', 'broadPeak', 'chromHMM': contact developers for other types if desired
#' @param dbname mongodb database name, used directly with system2('mongoimort ...')
#' @param importCmd how to invoke 'mongoimport', default is to assume it can be found in PATH
#' @param host host identifier for mongoimport, defaults to 127.0.0.1
#' @examples
#' f1 = dir(system.file('bedfiles', package='TxRegInfra'), full=TRUE, patt='ENCFF971VCD')
#' f2 = dir(system.file('bedfiles', package='TxRegInfra'), full=TRUE, patt='E096_imp12')
#' if (verifyHasMongoCmd('mongoimport')) {
#' chk1 = importBedToMongo(f1, 'vjc1', db='txregnet')
#' stopifnot(chk1)
#' chk2 = importBedToMongo(f2, 'vjc2', db='txregnet', bedType='chromHMM')
#' stopifnot(chk2)
#' system2("mongo", args=c("txregnet", "--eval", "'db.vjc1.remove({})'")) 
#' system2("mongo", args=c("txregnet", "--eval", "'db.vjc2.remove({})'"))
#' }
#' @return if error encountered, return the try-error content, otherwise TRUE
#' @export
importBedToMongo = function(path, collectionName, bedType = "narrowPeak", dbname = "db", 
    importCmd = "mongoimport", host = "127.0.0.1") {
    stopifnot(any(bedType %in% c("narrowPeak", "broadPeak", "chromHMM")))
    .importToMongo(path = path, collectionName = collectionName, fields = .fieldString(type = bedType), 
        dbname = dbname, type = "tsv", importCmd = importCmd, host = host)
}

