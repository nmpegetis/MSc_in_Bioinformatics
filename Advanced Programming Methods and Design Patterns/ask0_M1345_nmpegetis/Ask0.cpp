#include <map>
#include <iostream>
#include <fstream>
#include <sstream>
#include <cassert>
#include <vector>

using namespace std;

int main(int argc, char **argv)
{
    ifstream file(argv[1]);

    string line;


    map<string, map<string,int> > lines;
    map<string, int> set;
    vector<string> allLines; 

    while (getline(file, line)){
//        cout << line << endl;
        // Process line
        
        allLines.push_back(line);
        
        istringstream iss(line);
        string token,first,second;
        bool i = false;
        while (getline(iss, token, '|')){
            if (i){
                second = token;
            }
            else{
                i=true;
                first = token;
            }
        }

        map<string, map<string, int> >::iterator ir = lines.find(first);

        if(lines.find(first) == lines.end()){
            set[second] = 1;
            lines[first] = set;
        }
        else if(ir->second.size() == 0){
            set = lines.find(first)->second;
            cout << set.size();
            set[second] = set.size()+1;
            lines[first] = set;
        }
        
        
    }

    int size;
    for(vector<string>::iterator it = allLines.begin(); it != allLines.end(); ++it) {
        istringstream iss(*it);
        string token,first,second;
        bool i = false;
        while (getline(iss, token, '|')){
            if (i){
                second = token;
            }
            else{
                i=true;
                first = token;
            }
        }
        
        map<string, map<string, int> >::iterator itr = lines.find(first);
        if((size = itr->second.size()) > 1){
            
            cout << *it << "[" << ((lines.find(first))->second.find(first))->second << " of " << size<< "]" <<endl;
            
        }

    }

    return 0;
}


