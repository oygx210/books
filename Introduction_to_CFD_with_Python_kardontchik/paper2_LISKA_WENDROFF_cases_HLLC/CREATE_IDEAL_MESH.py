"""
    file: CREATE_IDEAL_MESH
   
    CREATE_IDEAL_MESH_RECT creates same-size rectangular triangles on a regular
       cartesian mesh, such that in each small [dx,dy] box there are two
       triangles. The size of each triangle is determined by the steps
       (dx,dy)
"""
import numpy as np
import matplotlib.pylab as plt

from scipy.spatial import Delaunay
from Meshing_Tools import *

def ccw_tri_rect(p,t):
    """
    orients all the triangles counterclockwise
    """
    # vector A from vertex 0 to vertex 1
    # vector B from vertex 0 to vertex 2
    A01x = p[t[:,1],0] - p[t[:,0],0]
    A01y = p[t[:,1],1] - p[t[:,0],1]
    B02x = p[t[:,2],0] - p[t[:,0],0]
    B02y = p[t[:,2],1] - p[t[:,0],1]
    # if vertex 2 lies to the left of vector A the component z of
    # their vectorial product A^B is positive
    Cz = A01x*B02y - A01y*B02x
    a = t[np.where(Cz<0)]
    b = t[np.where(Cz>=0)]
    a[:,[1,2]] = a[:,[2,1]]
    t = np.concatenate((a, b))
    return t

def unique_rows_rect(data):
    unique = dict()
    for row in data:
        row = tuple(row)
        if row in unique:
            unique[row] += 1
        else:
            unique[row] = 1
    data = np.asarray(unique.keys())
    return data

def plot_rect_mesh(p,tri):
    plt.figure()
    tx = p[:,0]; ty = p[:,1]
    for t in tri:
        t_i = [t[0],t[1],t[2],t[0]]
        plt.plot(tx[t_i],ty[t_i],'k')
        plt.hold('on')
    plt.title('TRIANGULAR MESH')
    plt.axis('equal')
    plt.hold('off')
    plt.show()

def find_boundary_bars_rect(t):
    """
        input: t, the triangles generated by a Delaunay triangulation
        returns: an array with the boundary bars. Each element of the
        array consists of two integers identifying the nodes of the bar
    """       
    # create the bars (edges) of every triangle
    bars = np.concatenate((t[:,[0,1]],t[:,[0,2]], t[:,[1,2]]))
    # sort all the bars
    data = np.sort(bars)
    # find the bars that are not repeated
    Delaunay_bars = dict()
    for row in data:
        row = tuple(row)
        if row in Delaunay_bars:
            Delaunay_bars[row] += 1
        else:
            Delaunay_bars[row] = 1
    # return the keys of Delaunay_bars whose value is 1 (non-repeated bars)
    bbars = []
    for key in Delaunay_bars:
        if Delaunay_bars[key] == 1:
            bbars.append(key)
    bbars = np.asarray(bbars)
    return bbars   
   

class CREATE_IDEAL_MESH_RECT:
    """
    Input:
        dx,dy: defines the granularity of the mesh in the x- and y-
               directions. Creates two rectangular triangles inside
               the small box defined by (dx,dy)
    Returns:
        p: the position of the vertices of all the triangles in the mesh
        t: the triangles defined each by its 3 vertices
        bbars: the pairs of nodes corresponding to each bar (or triangle
            edge) that lies at the boundary of the mesh
    """
    def __init__(self,x1,x2,y1,y2,dx,dy):
        self.x1,self.x2,self.y1,self.y2 = x1,x2,y1,y2
        self.dx,self.dy = dx,dy
    def __call__(self):
        x1,x2,y1,y2 = self.x1,self.x2,self.y1,self.y2
        dx, dy = self.dx, self.dy

        # define the initial number of points in the grid in both directions
        Nx = int(float(x2-x1)/dx)
        Ny = int(float(y2-y1)/dy)
        x = np.linspace(x1,x2,Nx)
        y = np.linspace(y1,y2,Ny)
        # create the grid in the (x,y) plane
        xx,yy = np.meshgrid(x,y)
        # p: points of the grid
        p = np.zeros((np.size(xx),2))
        p[:,0] = np.reshape(xx,np.size(xx))
        p[:,1] = np.reshape(yy,np.size(yy))

        # generate the triangles
        tt = Delaunay(p) # instantiate a class
        t = tt.vertices

        # orient all triangles to be ccw
        t = ccw_tri_rect(p,t)

        bars = np.concatenate((t[:,[0,1]],t[:,[0,2]], t[:,[1,2]]))
        # delete repeated bars
        bars = unique_rows_rect(np.sort(bars))
        # plot the mesh
        plot_rect_mesh(p,t)
        # find the boundary bars
        bbars = find_boundary_bars_rect(t)
        # order the boundary nodes and boundary bars ccw beginning
        # from the left bottom corner
        boundary_nodes, boundary_bars = boundary_info(p,bbars)

        return p,t,bbars,boundary_nodes,boundary_bars
    
