import matplotlib.animation as animation
import matplotlib.pyplot as plt
import numpy as np
import scipy.integrate as integrate

G = 7  # gravitational constant
M1 = 1.0  # mass of the first body
M2 = 1.0  # mass of second body
R1 = .5*M1 # radius of the first body (proportional to its mass)
R2 = .5*M2 # radius of the second body (proportional to its mass)


def derivs(state, t):

    dydx = np.zeros_like(state)

    dydx[0] = state[2]
    dydx[1] = state[3]

    d = (state[4] - state[0])**2 + (state[5] - state[1])**2

    foo1 = (G*(state[4] - state[0]))/d**1.5
    foo2 = (G*(state[5] - state[1]))/d**1.5
    dydx[2] = M2 * foo1
    dydx[3] = M2 * foo2

    dydx[4] = state[6]
    dydx[5] = state[7]

    dydx[6] = -M1*foo1
    dydx[7] = -M1*foo2

    return dydx

# time array
dt = 0.05
t = np.arange(0.0, 100, dt)

# x and y are the initial positions
# u and v are the initial velocities
x1 = -2.5
y1 = 0
u1 = 0
v1 = .5
x2 = 2.5
y2 = 0
u2 = 0
v2 = -.5

# initial state
state = np.array([x1, y1, u1, v1, x2, y2, u2, v2])

# integrate your ODE using scipy.integrate.
y = integrate.odeint(derivs, state, t)

x1 = y[:, 0]
y1 = y[:, 1]
x2 = y[:, 4]
y2 = y[:, 5]

fig = plt.figure()
ax = fig.add_subplot(111, autoscale_on=False, xlim=(-10, 10), ylim=(-10, 10))

body1 = plt.Circle([x1[0], y1[0]], R1, color='r')
body2 = plt.Circle([x2[0], y2[0]], R2, color='b')
ax.add_patch(body1)
ax.add_patch(body2)
time_template = 'Time = {0:.2f}s'
time_text = ax.text(0.05, 0.9, '', transform=ax.transAxes)


def init():
    body1.center = (x1[0], y1[0])
    body2.center = (x2[0], y2[0])

    time_text.set_text('Time = 0s')
    return body1, body2, time_text


def animate(i):
    thisx = [x1[i], x2[i]]
    thisy = [y1[i], y2[i]]

    body1.center = (x1[i], y1[i])
    body2.center = (x2[i], y2[i])

    time_text.set_text(time_template.format(i * dt))
    return body1, body2, time_text


ani = animation.FuncAnimation(
    fig, animate, np.arange(1, len(y)), interval=25, blit=True, init_func=init)

plt.show()
