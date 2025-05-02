civility () 
{ 
    : two Rules of Civilized Conduct, from Choosing Civility by P.M. Forni;
    : date: 2020-08-24;
    :;
    : -------------------------------------------------------- the Default List --;
    set -- ${1:-$HOME/lib/civilityrules.txt};
    :;
    cat $1 | awk -v today=${1:-$(date +%j)} -v rnum=${RANDOM} '
#
# --------------------------------------------------------- first the functions --
#
function abs(x)         { return ((x<0)? -x: x); }
function mod(x, y)      { return x - (int(x/y)*y); }   # prefer to "%" operator
function prline(m, n)   { print m, line[n]; }
function nprline(m, n)  { printf "%3d %s %s\n",  n, m, line[n]; }
function prmsgs( m, n ) {
    indir[m] = n; 
    prline( "Today:  ", m); 
    prline( "Random: ", indir[ mod(rnum,n-1)]);
    print   "         from \"Choosing Civility\", by P.M. Forni"
}
#
# ------------------------------------------------------------ then the program --
#
    BEGIN { LC = 0; }       # since default LC=""
          { line[LC] = $0;  # print "line[", LC, "]\t", line[LC]
            indir[LC] = LC; LC++
          }
    END   {
             prmsgs( abs( mod(today,LC) ), LC-1);
          }
'
}
