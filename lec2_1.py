import sys
import math

def f(x):
	return math.pi/2-math.asin(x)-x*math.sqrt(1-x*x)-1.24
	#return x*x*x + x - 4

def print_ab(a1, b1, c1):
	print('[{a} - {b}] ... {c}'.format(a=a1,b=b1,c=c1))
	print('f(a={a}): {fa}'.format(a=a1, fa=f(a1)))
	print('f(b={b}): {fb}'.format(b=b1, fb=f(b1)))
	print('f(c={c}): {fc}\n'.format(c=c1, fc=f(c1)))

def bisection(a,b,tol):
	c = (a+b)/2.0
	print_ab(a,b,c)
	while (b-a)/2.0 > tol:
		if f(c) == 0:
			return c
		elif f(a)*f(c) < 0:
			b = c
		else :
			a = c
		c = (a+b)/2.0
		print_ab(a,b,c)

	return c

def main(argv):
	if (len(sys.argv) != 4):
		sys.exit('Usage: bisection.py <a> <b> <tol>')

	print('The root is: ')
	print(1-bisection(int(sys.argv[1]),int(sys.argv[2]),float(sys.argv[3])))

if __name__ == "__main__":
	main(sys.argv[1:])
