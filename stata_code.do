
/*	========================================================================

	Difference in differences illustrative figure
	Author: Alexandros Theloudis (a.theloudis@gmail.com)
	
	========================================================================  */

	
*	Initial statements:
version 16
clear all
*	- install preferred graph scheme:
net install gr0002_3, from("http://www.stata-journal.com/software/sj4-3") replace
*	- fill out the path where the figure will be saved:
global fig_path = "/Users/atheloudis/Dropbox/_Archive/Teaching/Tilburg/Microeconometrics MSc/2021-2022/Lecture Notes/Part I/Lecture 5/figures"


/*	========================================================================  */


/*	A hypothetical natural experiment has three time periods (t=-1, t=0, t=1).
*	Table of hypothetical outcomes:
	
	----------------------------------------------------------------------------
														|before 	| after  
														|t=-1 	t=0	| t=1
	----------------------------------------------------------------------------
	control group (g=0): 								|30 	40 	| 50
	treatment group if treatment occurs (g=1): 			|40 	50 	| 70
	treatment group if treatment does not occur (g=2):	|40 	50 	| 60
	----------------------------------------------------------------------------
*/

*	Add data:
input	g 	t 		y
		0 	-1		30
		0 	0 		40
		0 	1 		50
		1 	-1		40
		1 	0 		50
		1 	1 		70
		2   -1  	40
		2 	0 		50
		2   1 		60
/*	Now I add imaginary periods t=-1.5 and t=1.5 which allow some blank space 
	in the figure. Comment following part out if you don't need it */
		0 	-1.5 	.
		1 	-1.5 	.
		2 	-1.5 	.
		0 	1.5 	.
		1 	1.5 	.
		2 	1.5 	.
end

input 	y1var 	x1var 	y2var 	x2var
		61 		1.0 	69 		1.0
end


/*	========================================================================  */


*	Generate DiD graph:
#delimit;
twoway 	/* control group: 								*/
		(line y t if g==0, 
		lcolor(blue) lwidth(thick) lpattern(solid))
		/* treatment group if treatment does not occur: */
		(line y t if g==2 & t>=0, 
		lcolor(red%50) lwidth(thick) lpattern(dash))
		/* treatment group: 							*/
		(line y t if g==1, 
		lcolor(red) lwidth(thick) lpattern(solid))
		/* scatters for event times: 					*/
		(scatter y t if g==0,
		msymbol(circle) mcolor(blue))
		(scatter y t if g==2 & t==1,
		msymbol(circle) mcolor(red%60) mlwidth(none))
		(scatter y t if g==1,
		msymbol(circle) mcolor(red))
		/* double arrow for causal effect: 				*/
		(pcbarrow  y1var x1var y2var x2var),
		ylabel(20(10)80) 	ytitle("outcome")
		xlabel(-1(1)1) 		xtitle("event period")
		legend(	order(1 3)
				label(1 "control group") 
				label(3 "treatment group")
				rows(2) position(11) ring(0))
		xline(0, lpattern(dash))
		/* type "beta hat DiD"; 
		if this returns an error on Windows machines, replace the text within
		the double quotes with "{&beta}{sup:Diff-in-Diff}" */
		text(65 1.03  "`=ustrunescape("\u03B2\u0302")'{sup:Diff-in-Diff}", place(e) color(black) size(small))
		graphregion(color(white)) scheme(lean1) ;
#delimit cr

*	Save it:
graph export "$fig_path/DiD.pdf", as(pdf) replace
graph export "$fig_path/DiD.png", as(png) replace
cap : window manage close graph
