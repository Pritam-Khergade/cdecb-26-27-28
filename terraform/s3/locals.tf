locals {
  tags = {
    Name        = "${var.bucketname}"
    APPCODE     = "NA"
    APPRM       = "aslawsdevops@cloudblitz.in"
    OASNUMBER   = "NA"
    APPPOC      = "aslawsdevops@.in"
    APPGH       = "aslawsdevops@cloudblitz.in"
    APPNAME     = "NA"
    PLATFORM    = "s3"
    ENV         = "${var.env}"
    ROLE        = "${var.role}"
    CRITICALITY = "${var.criticality}"
    BACKUPFREQ  = "ADHOC"
  }
}