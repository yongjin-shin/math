import sys
import math

def a(x):
	b = (7-(x**5))/(x**2)
	print(b)
	c = ((1+b)**3)
	print(c)
	d = (-14/(x**3) - 3*(x**2))
	print(d)
	print('\n')
	#return ((1+b)**3)+3*x*((1+b)**2)*(-14/(x**3) - 3*(x**2))
	return 1 + 3*x*(-14/(x**3) - 3*(x**2))

def b(x):
	return 1-(14/(x**3) + 3*(x**2))


def c(x):
	return 4/5 - ((28/5)*1/(x**5))	


def d(x):
	return 1-(5/12)*(x**4)


def main(argv):
	if (len(sys.argv) != 3):
		sys.exit('Usage: test1.py <a> <b>')
	
	print('The answer is: ')
	x_ = int(sys.argv[1])**(1/int(sys.argv[2]))
	print(a(x_))
	print(b(x_))
	print(c(x_))
	print(d(x_))

if __name__ == "__main__":
        main(sys.argv[1:])
