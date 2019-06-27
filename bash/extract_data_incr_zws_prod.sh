#!/bin/bash
###
###
###
###   Purpose:   Get data increment numbers
###   started:   2019-06-26 14:00:10 (pvr)
###
### ###################################################################### ###

set -o errexit    # exit immediately, if single command exits with non-zero status
set -o nounset    # treat unset variables as errors
set -o pipefail   # return value of pipeline is value of last command to exit with non-zero status
                  #  hence pipe fails if one command in pipe fails

# #
# ======================================== # ============================================= #
# global constants                         #                                               #
# ---------------------------------------- # --------------------------------------------- #
# prog paths                               #                                               #
BASENAME=/usr/bin/basename                 # PATH to basename function                     #
DIRNAME=/usr/bin/dirname                   # PATH to dirname function                      #
# ---------------------------------------- # --------------------------------------------- #
# directories                              #                                               #
INSTALLDIR=`$DIRNAME ${BASH_SOURCE[0]}`    # installation dir of bashtools on host         #
UTILDIR=/Users/pvr/Data/Projects/Github/pvrqualitasag/bashtools/util
                                           # directory containing utilities of bashtools   #
# ---------------------------------------- # --------------------------------------------- #
# files                                    #                                               #
SCRIPT=`$BASENAME ${BASH_SOURCE[0]}`       # Set Script Name variable                      #
# ======================================== # ============================================= #


# Use utilities
UTIL=$UTILDIR/bash_utils.sh
source $UTIL


### # ====================================================================== #
### # functions


### # ====================================================================== #
### # Use getopts for commandline argument parsing                         ###
### # If an option should be followed by an argument, it should be followed by a ":".
### # Notice there is no ":" after "h". The leading ":" suppresses error messages from
### # getopts. This is required to get my unrecognized option code to work.
TDHASHLOG=""
b_example=""
c_example=""
while getopts ":l:h" FLAG; do
  case $FLAG in
    h) # option -h shows usage
      usage $SCRIPT "Help message" "$SCRIPT -a <a_example>"
      ;;
    l)
      check_exist_file_fail $OPTARG
      TDHASHLOG=$OPTARG
      ;;
    :)
      usage "-$OPTARG requires an argument"
      ;;
    ?)
      usage "Invalid command line argument (-$OPTARG) found"
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.


### # ====================================================================== #
### # Main part of the script starts here ...
start_msg $SCRIPT

# Check whether required arguments have been defined
if test "$TDHASHLOG" == ""; then
  usage $SCRIPT "ERROR <TDhash.log.YYMM.AR> file not specified" "$SCRIPT -l <TDhash.log.YYMM.AR>"
fi

### # Continue to put your code here
log_msg $SCRIPT "Number of Pedigree Records"
grep 'File: /qualstorzws01/data_zws/TDpe_swiss/extracts/geped' $TDHASHLOG | \
  grep 'Number of Records'

### # ====================================================================== #
### # Script ends here
end_msg $SCRIPT

### # ====================================================================== #
### # What comes below is documentation that can be used with perldoc

: <<=cut
=pod

=head1 NAME

   extract_data_incr_zws_prod - Data increments for ZWS-Prod

=head1 SYNOPSIS


=head1 DESCRIPTION

Extract data increments from logfiles of ZWS-Prod


=head2 Requirements



=head1 LICENSE

Artistic License 2.0 http://opensource.org/licenses/artistic-license-2.0


=head1 AUTHOR

Peter von Rohr <peter.vonrohr@qualitasag.ch>


=head1 DATE

2019-06-26 14:00:10


=cut
