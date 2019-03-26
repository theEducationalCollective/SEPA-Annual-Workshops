# "Bootstrap t CI" AKA "Studentized" Bootstrap CI
#
# CF: https://web.as.uky.edu/statistics/users/pbreheny/621/F12/notes/9-18.pdf
#
# This version: Matthew D. Turner
# mturner46@gsu.edu
# 2018.03.01

library(boot)

rats <- c(10,27,30,40,46,51,52,104,146)  # Survival times of rats

# To do a bootstrap t, you have to provide the boot function with the
# estimate of the statistic being bootstrapped, and also an estimate
# of its variance (here the square of the standard error) for each
# bootstrap resample. When the boot function gets all of this, it will
# compute the "studentized bootstrap CI" and add this to the output of
# boot.ci.

# New function with statistic and variance BOTH returned:

mean.boot <- function(d,i){
  c(mean(d[i]), var(d[i])/length(d))
}

out <- boot(rats, mean.boot, 999)  # This is the same call
boot.ci(out)

# One of the benefits of this version is that it allows the ends of
# the CI to be moved asymmetrically to better account for skew

# EOF