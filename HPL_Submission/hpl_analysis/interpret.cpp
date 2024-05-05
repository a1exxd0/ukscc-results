// file=interpret; g++ $file.cpp -std=c++17 -o $file && time ./$file < $file.txt > $file-2.out

#include <bits/stdc++.h>
#define LEN 8
using namespace std;
struct Result{
    float n, nb, p, q, depth, align, gflops, time;
};

string pad(string tmp){
    while(tmp.length() < LEN){
        tmp.push_back(' ');
    }
    while (tmp.length() > LEN){
        tmp.pop_back();
    }
    return tmp;
}

string pad(float f){
    string tmp = to_string(f);
    size_t d = tmp.find('.');
    if (tmp.find_first_not_of('0', d + 1) == std::string::npos){
        tmp = to_string((int) f);
    } else{
        while(tmp[tmp.length()-2] != '.'){
            tmp.pop_back();
        }
    }
    
    return pad(tmp);
}

void print_result(const vector<Result*> &r){
    cout << pad("N") << pad("NB") << pad("P") << pad("Q");
    cout << pad("Depth") << pad("Align") << pad("Time") << pad("GFLOPS");
    cout << endl;
    for (int i = 0; i < r.size(); ++i){
        cout << pad(r[i]->n) << pad(r[i]->nb) << pad(r[i]->p) << pad(r[i]->q);
        cout << pad(r[i]->depth) << pad(r[i]->align) << pad(r[i]->time);
        cout << pad(r[i]->gflops);
        cout << endl;
    }   
}

Result* solve() {
    Result *r = new Result;
    cin >> r->n >> r->nb >> r->p >> r->q;
    cin >> r->depth >> r->align >> r->time >> r->gflops;

    return r;
}

struct size_by_speed{
    bool operator()(Result* x, Result* y){
        if (x->n < y->n){
            return true;
        } else if (x->n == y->n){
            if (x->gflops > y->gflops){
                return true;
            } else{
                return false;
            }
        } else{
            return false;
        }
    }
};

struct by_speed{
    bool operator()(Result* x, Result* y){
        if (x->gflops > y->gflops){
            return true;
        } else{
            return false;
        }
    }
};

int main() {
    int tc=0;
    vector<Result*> v(29);
    while(tc < 29) {
        v[tc++] = move(solve());
    }

    sort(v.begin(), v.end(), by_speed());

    print_result(v);

    for (int i = v.size()-1; i >= 0; --i)
        delete v[i];
    return 0;

}