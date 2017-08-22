
:-  [fun-with-lists] .

% ====================================================================
% ====================================================================

%                      REPRESENTATION

% ====================================================================
% ====================================================================
          
%            
%                                   +-----+     L2
%                                   |  C  +---------+
%                                   +-----+         |
%           +-----+                              +--v--+
%           |  A  +----------------------------> |  B  +--+
%           +-+---+            L1                +-+---+  |
%             ^                                    |      |
%          L6 |                                    |      | L4
%             |                                    |      |
%         +---+-+              L3                  |  +---v-+
%         |  D  <----------------------------------+  |  E  |
%         +--+--+                                     +--+--+
%            |                                           |
%         L5 |               L7          +-----+         |
%            |  +------------------------+  F  | <-------+
%            v  |                        +--^--+       L8
%          +-+--v+                          |
%          |  G  +--------------------------+
%          +-----+           L9
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
	member(C, Colors),                       % non-deterministic generator of colors
	generate(Vs, Colors, Coloring) .

test([], _) .
test([e(V1,V2,L)|Es], Coloring) :- 
	member(V1-C1, Coloring), 
	member(V2-C2, Coloring), 
	C1 \= C2,                                % test if adjacent vertices have diff colors
	test(Es, Coloring) .


% smarter generate and test
% generate one color at a time and tests it against the colors already assigned
smarter_coloring(G, Colors, Coloring) :- 
	call(G, Vs, Es), 
	smarter_coloring_acc(Vs, Es, Colors, [], Coloring) .   % generate and test

smarter_coloring_acc([], _, _, Acc, Acc) :- ! .
smarter_coloring_acc([V|Vs], Es, Colors, Acc, Coloring) :- 
	member(C, Colors),                                     % generate color for vertex V
	vertex_test(Es, V, C, Acc),                            % test the validity of curr coloring
	smarter_coloring_acc(Vs, Es, Colors, [V-C|Acc], Coloring) .

vertex_test([], _, _, _) :- ! .
vertex_test([e(V1,V2,L)|Es], V, C, CurrColoring) :- 
	(V = V1 -> 
		(member(V2-C2,CurrColoring) -> 
			C \= C2 
		; true) 
	; (V = V2 -> 
		(member(V1-C1,CurrColoring) -> 
			C \= C1 
		; true) 
	; true )), 
	vertex_test(Es, V, C, CurrColoring) .



% forward checking coloring
forward_checking_coloring(G, Colors, Coloring) :- 
	call(G, Vs, Es), 
	prep(Vs, Colors, ColoredVs), 
	gtb(ColoredVs, Es, [], Coloring) .

prep([], _ , []) .
prep([V|Vs], Colors, [V-Colors|Supercoloring]) :- 
	prep(Vs, Colors, Supercoloring) .

gtb([], _, Acc, Acc) .
gtb([V-Cs|VCs], Es, Acc, Coloring) :- 
	member(C, Cs),                                    % choose a color
	forward_checking(Es, V, C, VCs, ConstrainedVCs),  % question if C is good for V if yes you have a new supercoloring (last arg) without C from V neighborhood
	gtb(ConstrainedVCs, Es, [V-C|Acc], Coloring) .

forward_checking([], _, _, VCs, VCs) .
forward_checking([e(V1,V2,L)|Es], V, C, VCs, ConstrVs) :- % iterate over edges and for each v' connected to v delete that color from its set
	(V = V1 -> 
		constr(VCs, V2, C, NewVCs)
		; (V = V2 -> 
			constr(VCs, V1, C, NewVCs)
			; NewVCs = VCs)),
	forward_checking(Es, V, C, NewVCs, ConstrVs) .

constr([V-Cs|VCs], V, C, [V-NewCs|VCs]) :-   % find V and delete C from its set if its set becomes empty then it FAILS
	delete(Cs, C, NewCs), 
	NewCs \= [] .
constr([V1-Cs|VCs], V, C, [V1-Cs|NewVCs]) :- 
	V \= V1,
	constr(VCs, V, C, NewVCs) .
constr([], _, _, []) .


delete([], _, []) .
delete([X|Xs], X, Xs) .
delete([Y|Xs], X, [Y|X1s]) :- 
	X \= Y, 
	delete(Xs, X, X1s) .

