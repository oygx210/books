%               File:    Beam_problem2_data.m
%
% The following variables are declared as global in order
% to be used by all the functions (M-files) constituting 
% the program
%
global nnd nel nne nodof eldof n geom connec ...
    prop nf  Element_loads Joint_loads Hinge
%
format short e
%
%%%%%%%%%%%%%% Beginning of data input %%%%%%%%%%%%%%%%
%
nnd = 5; % Number of nodes:
nel = 4; % Number of elements:
nne = 2 ; % Number of nodes per element:
nodof =2 ; % Number of degrees of freedom per node
eldof = nne*nodof; % Number of degrees of freedom 
                   % per element
%
% Nodes coordinates X and Y
geom=zeros(nnd,1);
geom = [0.; ... % X coord. node 1
        2.; ... % X  coord. node 2
        4.; ... % X coord. node 3
        7.; ... % X coord. node 4
        9.5] ;  % X coord. node 5
%
% Element connectivity
%
connec=zeros(nel,2);
connec = [1   2 ; ...   % 1st and 2nd node of element 1
          2   3 ; ...   % 1st and 2nd node of element 2
          3   4 ; ...   % 1st and 2nd node of element 3
          4   5];       % 1st and 2nd node of element 4
%
% Geometrical properties
%
% prop(1,1) = E; prop(1,2)= I
%
prop=zeros(nel,2);
prop  = [200e+6  600.e-6; ...  % E and I of element 1
         200e+6  600.e-6; ...  % E and I of element 2
         200e+6  300.e-6; ...  % E and I of element 3
         200e+6  300.e-6] ;    % E and I of element 4
%
% Boundary conditions
%
nf = ones(nnd, nodof); % Initialise the matrix nf to 1
nf(1,1) = 0;  ; % Prescribed nodal freedom of node 1
nf(4,1) = 0;              % Prescribed nodal freedom of node 3
%
% Counting of the free degrees of freedom
%
n=0;
for i=1:nnd
    for j=1:nodof
        if nf(i,j) ~= 0
        n=n+1;
        nf(i,j)=n;
        end
    end
end
%
%
% Internal Hinges
%
Hinge = ones(nel, 2);
%
% loading
%
Joint_loads= zeros(nnd, 2);
Joint_loads(2,:)=[-20     0]
%
Element_loads= zeros(nel, 4);
Element_loads(3,:)= [ -7.5     -3.75     -7.5    3.75];
Element_loads(4,:)= [ -4.375   -7.2916   -1.875  1.0416];
%
%%%%%%%%%%%%%%%%%%%%%%% End of input %%%%%%%%%%%%%%%%%%%%%%

