import math


def f(x):
    # tmp = x**2 - 10*math.cos(x)
    tmp = 10**(-(2**x))
    print('f({input}): {result}'.format(input=x, result=tmp))
    return tmp


def f_(x):
    #tmp = 2*x + 10*math.sin(x)
    tmp = math.log(10, 2)*(-math.log(2, 2)) * (2**x) * 10**(-(2**x))
    print('f_({input}): {result}'.format(input=x, result=tmp))
    return tmp


def cal(x):
    tmp = x - f(x)/f_(x)
    print('cal({input}): {result}'.format(input=x, result=tmp))
    return tmp


threshold = 10**(-5)
target = 0 # -1.3793646
prediction = 5 # -100
n = 0
print('{iter}th iteration: \n '
      'P_{iter}: {pred} '.format(iter=n, pred=prediction))

while abs(target-prediction) > threshold:
    n = n+1
    print('\n{iter}th iteration: '.format(iter=n))
    prediction = cal(prediction)
    print('P_{iter}: {pred} '.format(iter=n, pred = prediction))

