
# Stress From Slip Data The Michael Way
Documentation as of July 1986
Minor changes made March 1988

*put in markdown 2017 CGR*

This represents a documentation for Andrew Michael's
slickenside analysis package as of March 1988.
This version includes the bootstrap statistics, with the
ability to flip focal mechanisms from one plane to another
randomly.
For each program I will give the compile command and the run command.
The character "%" is used as the prompt.
All of this is designed and documented for UNIX Berkeley Standard
Distribution 4.3 as implemented on an Integrated Solutions computer.
Also included are sample input and output files
in the various appendices.
The tape is a tar tape that can be read on any UNIX system.
The file CONTENTS lists the contents of the tape.

The references for this package are:

Michael, A.J. (1984), Determination of stress from slip data: faults and
folds, JGR, v. 89, 11,517-11526.

This paper covers the linear stress inversion technique used in
the programs slick and slfast.

Michael, A.J. (1987a), The use of focal mechanisms to determine stress:
a control study, JGR, v. 92, 357-368.

This paper covers the bootstrap statistics and the problems associated
with using focal mechanisms instead of geological field data.

Michael, A.J. (1987b), Stress rotation during the Coalinga aftershock sequence,
JGR, v. 92, 7963-7979.

This paper covers the addition of the plane flipping ability to the
bootstrap statistics in order to account for uncertainties in
the picking of the fault plane from the two nodal planes.

## Data File Format

All of the programs start with the same style data file.  It has the
following format for a data set with n faults.


<pre>
line 1: Comment line
line 2: data for fault one
line 3: data for fault two
 .
 .
 .
line n+1: data for fault n
</pre>


Each data line consists of three numbers separated by blank space.
The first number on each line is the dip direction of the fault plane
in degrees East of North.
The second number on each line is the dip of the fault plane.
The third number on each line is the rake of the fault, such that
0 is left lateral motion, 90 is thrust motion, 180 is right lateral
motion, and 270 is normal faulting.  Of course negative rakes are
allowed as are oblique faulting.
A sample data file with 9 faults is shown here:

<pre>
Some data from Dixie Valley, NV
100 45 -112
60 45 -104
60 45 -121
115 47 -108
147 47 -85
165 55 -72
135 50 -95
137 48 -92
140 43 -83
</pre>

The whole file is in the file dixie, and is shown in appendix A.

## slick

slick is the basic program in the package, it finds the best stress
tensor and some information about the misfit based on the technique
of Michael (1984).

<pre>
To compile: % make -f makeslick
To run: % slick input_file
Output files made: input_file.oput
e.g. : % slick dixie
   makes dixie.oput
</pre>
See appendix B for an annotated copy of dixie.oput.  Note that slick will
erase the existing *.oput file and make a new one.

## slfast

slfast is a pared down version of slick, it gives only information
about the best result and is for use in the bootstrap analysis.

<pre>
To compile: % make -f makeslfast
To run : % slfast input_file
Output files made: input_file.slboot
e.g.: % slfast dixie
   makes dixie.slboot
</pre>

See appendix C for an annotated copy of dixie.slboot.
Note that slfast does not erase an existing
*.slboot file, instead it appends to it.

## bootslickw

bootslickw controls the process of bootstrap resampling a data set
many times.  It uses slfast to analyze each resampling.

<pre>
To compile: % make -f makebtslw
To run: % bootslickw input_file n w
  where n is the number of times to resample the data
  and   w is the fraction of the times to flip the focal mechanisms
Output files made: Xtemp  Xtemp.slboot
e.g.: % bootslickw dixie 2000 0.1
   will bootstrap resample the dixie data set 2000 times,
   flipping the selected fault and slip direction 10% of the time,
   and run slfast on each resampling.  The output will be in Xtemp.slboot
   while Xtemp will hold the data for the last resampling.
</pre>

Since these are fixed names you can only have
one bootslickw running in a directory at a time.
Remember that slfast (and hence bootslickw) does not remove the old
output file.  This is good and bad.  To find confidence regions
you want a file where the first two lines are the output of slfast
on the true data, and the rest are the output of slfast on resampled
data.  To do this I usually do the following:

<pre>
% rm Xtemp Xtemp.slboot
% cp dixie Xtemp
% slfast Xtemp
% bootslickw dixie 2000
% mv Xtemp.slboot dixie.slboot
</pre>

This leaves the file dixie.slboot with 4002 lines.  The first two
are the slfast of the true data, and the rest are 2000 slfasts of
resampled data sets.  An example output file with only 10 resamplings
is in Appendix D.  Remember it will be hard to duplicate Appendix D
because bootslickw seeds the random number generator off the clock.
It is important to use a pseudo-random seed, so that you can run
the program twice and compare results on a statistical basis and
not a deterministic one.  The pseudo-random seed also allows you
to run bootslickw twice and combine the results, if the same seed
is always used this is not valid since the program will always
take the same path.
The random number generator is designed after the one HP published
in the HP-25C program manual.  I can't stand the UNIX one, if you
can you should probably use it.  Just get it to output a uniformly
random number on the space 0-1.  bootslickw can take a lot of time,
depending on the number of resamplings (and your definition of a lot
of time).
2000 resamplings takes
about 25 CPU minutes on a 750 so you may want to run it in
background.  (This time is now considerable shorter due to better
programming, but you should still run it in background. -AJM, 2/3/88)

## plotboots and plotbootso

This program finds the confidence regions given a *.slboot file
as described above, that is it must have the slfast result for the
correct data at the top of the file.

<pre>

To compile: % make -f makeplbts
To run: % plotboots *.slboot output_file confidence level
Output files: as named in command line
e.g. % plotboots dixie.slboot dixie.bplots 95
   will make an output file with the 95% confidence regions for the
   dixie data, based on the resamplings in dixie.slboot.
</pre>

dixie.bplots will be a
onnet input file.  onnet is a stereonet plotting program that
is explained in it's own documentation which is enclosed.  Even
if you don't have onnet the output can be used.  dixie.bplots
is shown in annotated form in appendix E.  Also shown
in appendix E is the plot that onnet will make from dixie.bplots.
Remember that bootstrap resampling will get a better approximation
of the confidence region depending on the number of resamplings
done.  For 80% confidence regions 500 trials seems to be adequate,
for 95% confidence regions I have been using 2000 trials.
There is also a program called plotbootso with makefile makeplbtso.
They are almost identical except for the size of the plot.  plotbootso
plots every point within the prescribed confidence region, most of
these are close to the best result and plot on top of each other.
This increases the plotting time and file sizes.  Plotboots uses
a thinning algorithm to only plot points that are farther than
2 degrees apart and prefers to plot the outside points.  The result
is a plot that is much quicker to draw and shows the outside of
the interval very well.  The difference in time can be over a factor
of 100.  In the documentation is an example of plotboots versus
plotbootso.

## plata

plata makes data plots.

<pre>
To compile: % make -f makeplata
To run: % plata input_file
Output files: input_file.plodc
e.g.: % plata dixie
   makes an onnet input file called dixie.plodc
</pre>

dixie.plodc and the plot onnet will make are shown in appendix F.

## switcher

switcher takes a data file and makes a new one with the other
nodal plane as the fault plane.

<pre>
To compile: % make -f makeswitch
To run: % switcher < data_file > new_data_file
Output files: outputs to standard out.
e.g. % switcher < dixie > dixies
</pre>

dixies will be the new data file and is shown in Appendix G.
## bothplanes

bothplanes takes a data file and makes a new one with both possible
fault planes included.
<pre>
To compile: % make -f makeboth
To run: % bothplanes < data_file > new_data_file
Output files: outputs to standard out.
e.g.: % bothplanes < dixie > dixieb
</pre>

dixieb is shown in Appendix H, the format is as follows:

<pre>
line 1:  Comment line
line 2:  Original first datum
line 3:  Other plane from first datum
line 4:  Original second datum
line 5:  Other plane from second datum
 .
 .
 .
</pre>
## bootboth

WARNING: I find it difficult to attach any significance to the
confidence levels found when using both possible fault planes.
I include this program only so you can play with it.  If you
decide to publish or otherwise distribute any of its results
please mention my hesitancy.  This issue is discussed in
"The determination of stress from focal mechanisms: a control study."

bootboth finds the confidence limits for the analysis when both
nodal planes are used as fault planes.  It works just like bootslickw
except that the data are treated as pairs of faults.  To work
it must have a data file that has the two possible fault planes for
a focal mechanism next to each other in the file just as bothplanes
does it.

<pre>
To compile: % make -f makebtbo
To run: % bootboth input_file n
   where n is the number of times to resample the data
Output files: Xtemp Xtemp.slboot
e.g.: % bootboth dixieb 2000
   will bootstrap resample the dixieb data set 2000 times
   (as pairs) and run slfast on each resampling.
</pre>

Use plotboots on the bootboth output in the same way you would on
bootslickw output.
Since bootboth uses slfast to do the
real work it also uses Xtemp and Xtemp.slboot.  This can be a little
confusing since you might mistake a bootboth output file for
a bootslickw output file.  I get around this by always calling
the data files things ending in b if they have both planes involved.
Also you can only have a bootslickw or a bootboth running in a
directory at one time because both will use Xtemp and Xtemp.slboot.
Remember to have the best result at the top of the *.slboot file,
just like with bootslickw (see that section for details).
The *.slboot files from bootboth look just like the ones from
bootslickw.

## gridfix

gridfix is a program to a grid search for the best stress tensor
with an angular error criterion as described in Michael, 1986.
(It uses the 1-cos(beta) error criterion, and an L1 norm).
It can be used either with the fault planes picked _priori_,
or with the program picking the preferred fault planes as is done
by Gephart and Forsyth (1984), although this is not their error
criterion.  To run the program you first have to make a modified
data file.  On each data line you must add a 0,1, or 2 at the end
of the line.  A 0 will tell the program to pick the preferred plane,
a 1 will tell the program to use the given plane, and a 2 will
tell the program to use the auxiliary plane as the fault plane.
A sample data file is in Appendix I and in the file dixieg.
After modifying the data file you then modify the file "controls".
This is a include file that tells the program how to search the
grid.  A sample is in Appendix J.

<pre>
To compile: % cc -o gridfix -O gridfix.c -lm
To run: % gridfix input_file
Output files: input_file.goput
e.g.: % gridfix dixieg
</pre>

This will make an output file dixieg.goput,
which is shown in Appendix K.

## gridstrap

gridstrap is a fast version of gridfix for use in the bootstrap
analysis.  It uses the same file "controls" to control the grid
to be searched, so edit "controls" first.

<pre>
To compile: % cc -o gridstrap -O gridstrap.c -lm
To run: % gridstrap input_file
Output file: input_file.gboot
e.g.: % gridstrap dixieg
</pre>

will make a file called dixieg.gboot that is shown in Appendix L.

## bootgrid

bootgrid is the analog to bootslickw for the grid search method.
It controls the bootstrap resampling process, using gridstrap
to analyze the results.  To use it first compile gridstrap
with the proper grid parameters.  Since you will be doing many
gridstraps it is best to use a coarse grid limited to the area
where the result will be.  The more limited and coarser the grid,
the faster things will run.

<pre>
To compile: % make -f makebtgr
To run: % bootgrid input_file n
   where n is the number of times to resample the data.
Output files: Xtemp Xtemp.gboot
e.g.: % bootgrid dixieg 2000
   will bootstrap resample the dixieg data set 200 times
   and run gridstrap on each resampling.
   Xtemp.gboot will hold the results and Xtemp the data for the 
   last resampling.
</pre>

An example of the output with 10 resamplings is shown in Appendix M.
Remember to compute confidence intervals the best result must be at
the top of the output file before the resamplings.   See bootslickw
for details.

## plotbootg

plotbootg is the analog of plotboots for the grid search results.

<pre>
To compile: make -f makeplbtg
To run: plotbootg *.gboot output_file confidence level
Output files: as named in command line.
e.g.: % plotbootg dixieg.gboot dixieg.bplotg 95
   will make an output file with the 95% confidence regions for the
   dixieg data, based on the resamplings in dixieg.gboot.
</pre>

dixieg.gboot is an onnet input file, an example is in Appendix N.

## onnet

onnet, together with stnet and sttics, comprise a
stereonet plotting package.  You will have to modify onnet to work
with your graphics system.  It is a very useful program if you
are going to work with stereonets, so it is worth the time.
Separate documentation is supplied for onnet, and the code and
makefiles are supplied in the directory named ONNET.

## Some notes about subroutines

Most of my subroutines are pretty good, the exception may be
the eigenvalue-vector routine.  I don't use it any more.
I wrote it because I wanted to learn how they worked,
and it is a bit slow.  At the moment I am using the Eispack, but
I can't send it around due to license restrictions.  I would
suggest finding a good eigenvalue routine to use.  It will save
you time and the answers will be slightly more accurate.
