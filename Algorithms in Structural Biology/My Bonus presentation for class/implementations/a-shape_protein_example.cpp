/***************************************************************************************************************************
* University/Faculty	: National Kapodistrian University of Athens - Department of Informatics and Telecommunications
* Course - Professor	: Algorithms in Structural Bioinformatics - Emiris Ioannis
* File name				: a-shape_protein.cpp
* Name/Surname			: Nikolaos Mpegetis
* A.M					: пиб0111
****************************************************************************************************************************/

#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
#include <CGAL/Delaunay_triangulation_3.h>			//used for simple points
#include <CGAL/Regular_triangulation_euclidean_traits_3.h>	//used for weighted points
#include <CGAL/Regular_triangulation_3.h>

#include <CGAL/Alpha_shape_3.h>

#include <fstream>
#include <list>
#include <cassert>
#include <time.h>
clock_t startm, stopm;
#define START if ((startm=clock())==-1){printf("Error calling clock");exit(1);}
#define STOP if ((stopm=clock())==-1){printf("Error calling clock");exit(1);}
#define PRINTTIME printf("\n Time taken to compute: %6.3f seconds!\n\n", ((double)stopm-startm)/CLOCKS_PER_SEC);


struct point{
	double* coords;		//coordinates. matrix that in index=0 holds x coordinate, in index=1 holds y coords...etc.
};

struct points2{
	point* input_points;
	int numoflines;
	int dimensions;
};


typedef CGAL::Exact_predicates_inexact_constructions_kernel K;

typedef CGAL::Regular_triangulation_euclidean_traits_3<K> Gt;

typedef CGAL::Alpha_shape_vertex_base_3<K>          Vb;
typedef CGAL::Alpha_shape_cell_base_3<K>            Fb;
typedef CGAL::Triangulation_data_structure_3<Vb,Fb>  Tds;

typedef CGAL::Alpha_shape_vertex_base_3<Gt>         rVb;
typedef CGAL::Alpha_shape_cell_base_3<Gt>           rFb;
typedef CGAL::Triangulation_data_structure_3<rVb,rFb> rTds;

typedef CGAL::Delaunay_triangulation_3<K,Tds>       Del_Triangulation_3;
typedef CGAL::Regular_triangulation_3<Gt,rTds>       Reg_Triangulation_3;
typedef CGAL::Alpha_shape_3<Del_Triangulation_3>         Del_Alpha_shape_3;
typedef CGAL::Alpha_shape_3<Reg_Triangulation_3>         Reg_Alpha_shape_3;

typedef K::Point_3                                  Point;
typedef Del_Alpha_shape_3::Alpha_iterator               Alpha_iterator;

typedef Reg_Alpha_shape_3::Cell_handle          Cell_handle;
typedef Reg_Alpha_shape_3::Vertex_handle        Vertex_handle;
typedef Reg_Alpha_shape_3::Facet                Facet;
typedef Reg_Alpha_shape_3::Edge                 Edge;
typedef Gt::Weighted_point                  Weighted_point;
typedef Gt::Bare_point                      Bare_point;


using namespace std;


void ReadFile (points2 *pts){
	
	ifstream input_file("input3d_protein.txt");		// Open the file input3d_protein.txt for reading 
   
	if (input_file.fail()) 
		exit(1);
	
	int dimensions;
	int lineCounter;
	
	input_file >> dimensions;
	input_file >> lineCounter;
	
	//dynamic allocations of matrices
	pts->input_points = new point[lineCounter];
	pts->input_points = new point[lineCounter];
	
	pts->numoflines = lineCounter;
	pts->dimensions = dimensions;

	cout << endl;
	cout << "\nPrinting the 3D dimensions of molecule - protein and its weights..." << endl;
	cout << "\t\t\t\t||     1D       2D       3D       WEIGHT\t||" << endl;
	for (int i=0 ; i<lineCounter ; i++){		// Get all dimensional coordinates

		pts->input_points[i].coords = new double[dimensions];	//allocate matrix holding coordinates of each x-dimensional point
		cout << dimensions-1 << "-dimensional protein point" << i << " = ||    " ;
		for (int j=0 ; j<dimensions ; j++){	// Get each points dimensional coordinates
		input_file >> pts->input_points[i].coords[j];
		cout << pts->input_points[i].coords[j] << "  ,  ";
		}
		cout << "\t||" << endl;
	}

	cout << "\nJust printed the 3D dimensions of molecule - protein and its weights...\n" << endl;
	
	input_file.close();
}

int main(){

	points2 pts;
	ReadFile(&pts);

  	list<Point> lp;
  	list<Weighted_point> lwp;

	START;
	

	//input: a molecule - protein
  	for (int i=0 ; i<(pts.numoflines) ; i++){
		lp.push_back(Point(pts.input_points[i].coords[0],pts.input_points[i].coords[1],pts.input_points[i].coords[2]));
	}

  	for (int i=0 ; i<(pts.numoflines) ; i++){
		lwp.push_back(Weighted_point(Bare_point(pts.input_points[i].coords[0],pts.input_points[i].coords[1],pts.input_points[i].coords[2]),pts.input_points[i].coords[3]));
	}
	
//simple points -- Delaunay triangulation
  	// compute alpha shape with delaunay triangulation
  	Del_Alpha_shape_3 as(lp.begin(),lp.end());
  	cout << "Alpha shape computed in REGULARIZED mode by default" << endl;
  	
  	// find optimal alpha value for simple points with delaunay triangulation
  	Del_Alpha_shape_3::NT alpha_solid = as.find_alpha_solid();
  	Alpha_iterator opt = as.find_optimal_alpha(1);
  	
  	cout << "\nSmallest alpha value for delaunay triangulation to get a solid through data points is " << alpha_solid << endl;
  	cout << "\nOptimal alpha value for delaunay triangulation to get one connected component is " << *opt << endl;
  	as.set_alpha(*opt);
  	assert(as.number_of_solid_components() == 1);

	STOP;
	PRINTTIME;

//weighted points -- Regular triangulation
  	//build alpha_shape  in GENERAL mode and set alpha=0
  	int a=0;
  	cout << "Give the 'a' parameter to compute the counterpart cells, facets and edges accordings to this parameter!\nType : ";
  	cin >> a;
  	Reg_Alpha_shape_3  ras(lwp.begin(), lwp.end(), a, Reg_Alpha_shape_3::GENERAL);

 	//explore the x-shape of weighted points with regular triangulation - It is dual to the boundary of the union.
  	list<Cell_handle> cells;
  	list<Facet>       facets;
  	list<Edge>        edges;
  	ras.get_alpha_shape_cells(std::back_inserter(cells), Reg_Alpha_shape_3::INTERIOR);
  	ras.get_alpha_shape_facets(std::back_inserter(facets), Reg_Alpha_shape_3::REGULAR);
  	ras.get_alpha_shape_facets(std::back_inserter(facets), Reg_Alpha_shape_3::SINGULAR);
  	ras.get_alpha_shape_edges(std::back_inserter(edges), Reg_Alpha_shape_3::SINGULAR);
  	cout << "\nThe 0-shape built with regular triangulation has : " << endl;
  	cout << cells.size() << " interior tetrahedra" << endl;
  	cout << facets.size() << " boundary facets" << endl;
  	cout << edges.size()  << " singular edges" << endl;


  	return 0;
}

