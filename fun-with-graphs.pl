
:-  [fun-with-lists] .

% ====================================================================
% ====================================================================

%                      REPRESENTATION

% ====================================================================
% ====================================================================
          
%            
%                          +-----+     L2
%                          |  C  +---------+
%                          +-----+         |
%              +-----+                  +--v--+
%              |  A  +----------------> |  B  +--+
%              +-+---+       L1         +-+---+  |
%                ^                        |      |
%             L6 |                        |      | L4
%                |                        |      |
%            +---+-+          L3          |  +---v-+
%            |  D  <----------------------+  |  E  |
%            +--+--+                         +--+--+
%               |                               |
%            L5 |        L7     +-----+         |
%               |  +------------+  F  | <-------+
%               v  |            +--^--+       L8
%             +-+--v+              |
%             |  G  +--------------+
%             +-----+      L9
%            
% 

% REPRESENTATION A

g(
	[a, b, c, d, e, f, g], 
	[
		e(a, b, 'L1'), 
		e(c, b, 'L2'), 
		e(b, d, 'L3'), 
		e(b, e, 'L4'), 
		e(d, g, 'L5'), 
		e(d, a, 'L6'), 
		e(f, g, 'L7'), 
		e(e, f, 'L8'), 
		e(g, f, 'L9')
	]
) .


edgeA(g(Vs,Es), V1, V2, Label) :- 
	member(e(V1,V2,Label), Es) .

edge(G, V1, V2, Label) :- 
	call(G, Vs, Es),
	member(e(V1,V2,Label), Es) .


neighborhood(G, Source, NB) :- 
	setof(Dest-Label, edge(G, Source, Dest, Label), NB) .


edgeNotDir(G, V1, V2, Label) :-
	call(G, Vs, Es), 
	member(e(V1,V2,Label), Es) .
edgeNotDir(G, V1, V2, Label) :- 
	call(G, Vs, Es),
	member(e(V2,V1,Label), Es) .


% REPRESENTATION B
% as pairs Node - Neighborhood

g1([
	a - [b - 'L1'], 
	b - [d - 'L3', e - 'L4'], 
	c - [b - 'L2'], 
	d - [a - 'L6', g - 'L5'], 
	e - [f - 'L8'], 
	f - [g - 'L7'], 
	g - [f - 'L9']
]) .


edgeB(G, V1, V2, Label) :- 
	call(G, Dict),
	member(V1-NB, Dict),
	member(V2-Label, NB) .


neighborhoodB(G, V, NB) :- 
	call(G, Dict),
	member(V-NB, Dict) .


% ====================================================================
% ====================================================================

%                      COLORING

% ====================================================================
% ====================================================================


% The goal of graph coloring is to add a color (from limited palette 
% of colors) to each vertex in such a way that the adjacent vertices 
% (via edge) have assigned different colors. Even if the graph coloring 
% seems to be a theoretical-only problem, the algorithms for graph 
% coloring are widelly used in practical applications .


% generate and test
naive_coloring(G, Colors, Coloring) :- 
	call(G, Vs, Es), 
	generate(Vs, Colors, Coloring), 
	test(Es, Coloring) .

generate([], _, []) :- ! .
generate([V|Vs], Colors, [V-C|Coloring]) :- 
	member(C, Colors),                % non-deterministic generator of colors
	generate(Vs, Colors, Coloring) .

test([], _) .
test([e(V1,V2,L)|Es], Coloring) :- 
	member(V1-C1, Coloring), 
	member(V2-C2, Coloring), 
	C1 \= C2,                         % test if adjacent vertices have diff colors
	test(Es, Coloring) .


