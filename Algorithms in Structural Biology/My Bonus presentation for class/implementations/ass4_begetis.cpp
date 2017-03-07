/***************************************************************************************************************************
* University/Faculty	: National Kapodistrian University of Athens - Department of Informatics and Telecommunications
* Course - Professor	: Algorithms in Structural Bioinformatics - Emiris Ioannis
* File name				: ass4_begetis.cpp
* Name/Surname			: Nikolaos Mpegetis
* A.M					: PIV0111
****************************************************************************************************************************/

#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
#include <CGAL/Delaunay_triangulation_3.h>
#include <CGAL/Alpha_shape_3.h>

#include <fstream>
#include <list>
#include <cassert>
#include <time.h>
clock_t startm, stopm;
#define START if ((startm=clock())==-1){printf("Error calling clock");exit(1);}
#define STOP if ((stopm=clock())==-1){printf("Error calling clock");exit(1);}
#define PRINTTIME printf("\n Time take to compute: %6.3f seconds!\n\n", ((double)stopm-startm)/CLOCKS_PER_SEC);


typedef CGAL::Exact_predicates_inexact_constructions_kernel Gt;

typedef CGAL::Alpha_shape_vertex_base_3<Gt>          Vb;
typedef CGAL::Alpha_shape_cell_base_3<Gt>            Fb;
typedef CGAL::Triangulation_data_structure_3<Vb,Fb>  Tds;
typedef CGAL::Delaunay_triangulation_3<Gt,Tds>       Triangulation_3;
typedef CGAL::Alpha_shape_3<Triangulation_3>         Alpha_shape_3;

typedef Gt::Point_3                                  Point;
typedef Alpha_shape_3::Alpha_iterator               Alpha_iterator;

int main()
{
  std::list<Point> lp;

  std::cout << "\nThe 8 points for the a-shape are being created" << std::endl;

//create points
  Point p1 = Gt::Point_3(0,0,0);
  Point p2 = Gt::Point_3(4,0,0);
  Point p3 = Gt::Point_3(3,2,0);
  Point p4 = Gt::Point_3(3,3,0);
  Point p5 = Gt::Point_3(0,6,0);
  Point p6 = Gt::Point_3(4,7,0);
  Point p7 = Gt::Point_3(8,0,0);
  Point p8 = Gt::Point_3(5,2,0);

  START;

//push points in list
  lp.push_back(p1);
  lp.push_back(p2);
  lp.push_back(p3);
  lp.push_back(p4);
  lp.push_back(p5);
  lp.push_back(p6);
  lp.push_back(p7);
  lp.push_back(p8);


  // compute alpha shape
  Alpha_shape_3 as(lp.begin(),lp.end());
  std::cout << "Alpha shape computed in REGULARIZED mode by default"
	    << std::endl;

   // find optimal alpha values
  Alpha_shape_3::NT alpha_solid = as.find_alpha_solid();
  Alpha_iterator opt = as.find_optimal_alpha(1);
  std::cout << "Smallest alpha value to get a solid through data points is "
	    << alpha_solid << std::endl;
  assert(as.number_of_solid_components() == 1);

  //Alpha_iterator opt = as.find_optimal_alpha(1);
  std::cout << "Optimal alpha value to get one connected component is "
	    <<  *opt    << std::endl;

  as.set_alpha(*opt);
  assert(as.number_of_solid_components() == 1);
  
  STOP;
  PRINTTIME;

  return 0;
}
