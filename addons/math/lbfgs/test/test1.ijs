
NB. From the Fortran:
NB.        LIMITED MEMORY BFGS METHOD FOR LARGE SCALE OPTIMIZATION
NB.                          JORGE NOCEDAL
NB.                        *** July 1990 ***

NB.    This subroutine solves the unconstrained minimization problem

NB.                     min F(x),    x= (x1,x2,...,xN),

NB.     using the limited memory BFGS method. The routine is especially
NB.     effective on problems involving a large number of variables. In
NB.     a typical iteration of this method an approximation Hk to the
NB.     inverse of the Hessian is obtained by applying M BFGS updates to
NB.     a diagonal matrix Hk0, using information from the previous M steps.
NB.     The user specifies the number M, which determines the amount of
NB.     storage required by the routine. The user may also provide the
NB.     diagonal matrices Hk0 if not satisfied with the default choice.
NB.     The algorithm is described in "On the limited memory BFGS method
NB.     for large scale optimization", by D. Liu and J. Nocedal,
NB.     Mathematical Programming B 45 (1989) 503-528.

NB.     The user is required to calculate the function value F and its
NB.     gradient G. In order to allow the user complete control over
NB.     these computations, reverse  communication is used. The routine
NB.     must be called repeatedly under the control of the parameter
NB.     IFLAG.

NB.     The steplength is determined at each iteration by means of the
NB.     line search routine MCVSRCH, which is a slight modification of
NB.     the routine CSRCH written by More' and Thuente.

NB.     The calling statement is

NB.         CALL LBFGS(N,M,X,F,G,DIAGCO,DIAG,IPRINT,EPS,XTOL,W,IFLAG)

NB.     where

NB.    N       is an INTEGER variable that must be set by the user to the
NB.            number of variables. It is not altered by the routine.
NB.            Restriction: N>0.

NB.    M       is an INTEGER variable that must be set by the user to
NB.            the number of corrections used in the BFGS update. It
NB.            is not altered by the routine. Values of M less than 3 are
NB.            not recommended; large values of M will result in excessive
NB.            computing time. 3<= M <=7 is recommended. Restriction: M>0.

NB.    X       is a DOUBLE PRECISION array of length N. On initial entry
NB.            it must be set by the user to the values of the initial
NB.            estimate of the solution vector. On exit with IFLAG=0, it
NB.            contains the values of the variables at the best point
NB.            found (usually a solution).

NB.    F       is a DOUBLE PRECISION variable. Before initial entry and on
NB.            a re-entry with IFLAG=1, it must be set by the user to
NB.            contain the value of the function F at the point X.

NB.    G       is a DOUBLE PRECISION array of length N. Before initial
NB.            entry and on a re-entry with IFLAG=1, it must be set by
NB.            the user to contain the components of the gradient G at
NB.            the point X.

NB.    DIAGCO  is a LOGICAL variable that must be set to .TRUE. if the
NB.            user  wishes to provide the diagonal matrix Hk0 at each
NB.            iteration. Otherwise it should be set to .FALSE., in which
NB.            case  LBFGS will use a default value described below. If
NB.            DIAGCO is set to .TRUE. the routine will return at each
NB.            iteration of the algorithm with IFLAG=2, and the diagonal
NB.             matrix Hk0  must be provided in the array DIAG.


NB.    DIAG    is a DOUBLE PRECISION array of length N. If DIAGCO=.TRUE.,
NB.            then on initial entry or on re-entry with IFLAG=2, DIAG
NB.            it must be set by the user to contain the values of the
NB.            diagonal matrix Hk0.  Restriction: all elements of DIAG
NB.            must be positive.

NB.    IPRINT  is an INTEGER array of length two which must be set by the
NB.            user.

NB.            IPRINT(1) specifies the frequency of the output:
NB.               IPRINT(1) < 0 : no output is generated,
NB.               IPRINT(1) = 0 : output only at first and last iteration,
NB.               IPRINT(1) > 0 : output every IPRINT(1) iterations.

NB.            IPRINT(2) specifies the type of output generated:
NB.               IPRINT(2) = 0 : iteration count, number of function
NB.                               evaluations, function value, norm of the
NB.                               gradient, and steplength,
NB.               IPRINT(2) = 1 : same as IPRINT(2)=0, plus vector of
NB.                               variables and  gradient vector at the
NB.                               initial point,
NB.               IPRINT(2) = 2 : same as IPRINT(2)=1, plus vector of
NB.                               variables,
NB.               IPRINT(2) = 3 : same as IPRINT(2)=2, plus gradient vector.
NB.            (The only value supported in this implementation is 0 0)


NB.    EPS     is a positive DOUBLE PRECISION variable that must be set by
NB.            the user, and determines the accuracy with which the solution
NB.            is to be found. The subroutine terminates when

NB.                        ||G|| < EPS max(1,||X||),

NB.            where ||.|| denotes the Euclidean norm.

NB.    XTOL    is a  positive DOUBLE PRECISION variable that must be set by
NB.            the user to an estimate of the machine precision (e.g.
NB.            10**(-16) on a SUN station 3/60). The line search routine will
NB.            terminate if the relative width of the interval of uncertainty
NB.            is less than XTOL.

NB.    W       is a DOUBLE PRECISION array of length N(2M+1)+2M used as
NB.            workspace for LBFGS. This array must not be altered by the
NB.            user.

NB.    IFLAG   is an INTEGER variable that must be set to 0 on initial entry
NB.            to the subroutine. A return with IFLAG<0 indicates an error,
NB.            and IFLAG=0 indicates that the routine has terminated without
NB.            detecting errors. On a return with IFLAG=1, the user must
NB.            evaluate the function F and gradient G. On a return with
NB.            IFLAG=2, the user must provide the diagonal matrix Hk0.

NB.            The following negative values of IFLAG, detecting an error,
NB.            are possible:

NB.             IFLAG=-1  The line search routine MCSRCH failed. The
NB.                       parameter INFO provides more detailed information
NB.                       (see also the documentation of MCSRCH):

NB.                      INFO = 0  IMPROPER INPUT PARAMETERS.

NB.                      INFO = 2  RELATIVE WIDTH OF THE INTERVAL OF
NB.                                UNCERTAINTY IS AT MOST XTOL.

NB.                      INFO = 3  MORE THAN 20 FUNCTION EVALUATIONS WERE
NB.                                REQUIRED AT THE PRESENT ITERATION.

NB.                      INFO = 4  THE STEP IS TOO SMALL.

NB.                      INFO = 5  THE STEP IS TOO LARGE.

NB.                      INFO = 6  ROUNDING ERRORS PREVENT FURTHER PROGRESS.
NB.                                THERE MAY NOT BE A STEP WHICH SATISFIES
NB.                                THE SUFFICIENT DECREASE AND CURVATURE
NB.                                CONDITIONS. TOLERANCES MAY BE TOO SMALL.


NB.             IFLAG=-2  The i-th diagonal element of the diagonal inverse
NB.                       Hessian approximation, given in DIAG, is not
NB.                       positive.

NB.             IFLAG=-3  Improper input parameters for LBFGS (N or M are
NB.                       not positive).

load 'math/lbfgs'
cocurrent 'base'

NB. =========================================================
test=: 3 : 0
NDIM=. 2000
MSAVE=. 7
NWORK=. (NDIM*(2*MSAVE+1))+2*MSAVE
X=. G=. DIAG=. NDIM$2.2-2.2
W=. NWORK$2.2-2.2
IPRINT=. 2 2-2 2

N=. ,100
M=. ,5
DIAGCO=. ,2-2
EPS=. ,1.0e_5
XTOL=. ,1.0e_16
ICALL=. 0
IFLAG=. ,2-2
for_JJ. 2*i. -:N do.
  X=. (_1.2e0 1.0e0) (JJ+0 1)}X
end.
while. 1 do.
  F=. ,0.0e0
  for_J. 2*i. -:N do.
    T1=. 1.0e0-J{X
    T2=. 1.0e1*((J+1){X)-*:J{X
    G=. (2.0e1*T2) (J+1)}G
    G=. (_2.0e0*(((J{X)*((J+1){G))+T1)) J}G
    F=. F+(*:T1)+*:T2
  end.
  'N M X F G DIAGCO DIAG IPRINT EPS XTOL W IFLAG'=. r=. }. lbfgs LASTIN=: ,&.> (N;M;X;F;G;DIAGCO;DIAG;IPRINT;EPS;XTOL;W;IFLAG)
  if. IFLAG <: 0 do. break. end.
  ICALL=. 1+ICALL
  if. ICALL > 2000 do. break. end.
end.
(<ICALL),r
)

echo >@{. test''
