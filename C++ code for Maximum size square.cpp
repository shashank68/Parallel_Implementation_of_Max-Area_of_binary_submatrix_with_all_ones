#include <bits/stdc++.h>  
using namespace std; 
  
  
int main() 
{  
    int i,j;
    cout << "Enter the row and coulumn numbers.\n";
    int R, C;
    cin >> R;
    cin >> C;  
    int S[R][C], M[R][C];
    cout << "Enter the matrix elements.\n";
    for(int k = 0; k < R; k++) {
        for(int l = 0; l < C; l++) {
            cin >> M[k][l];
        }
    }  
    int max_of_s, max_i,max_j; 
      
    /* Set first column of S[][]*/
    for(i = 0; i < R; i++)  
        S[i][0] = M[i][0];  
    for(j = 0; j < C; j++)  
        S[0][j] = M[0][j];  
    for(i = 1; i < R; i++)  
    {  
        for(j = 1; j < C; j++)  
        {  
            if(M[i][j] == 1)  
                S[i][j] = min(S[i][j-1],min( S[i-1][j],  
                                S[i-1][j-1])) + 1;  
            else
                S[i][j] = 0;  
        }  
    }  
      
    max_of_s = S[0][0]; max_i = 0; max_j = 0;  
    for(i = 0; i < R; i++)  
    {  
        for(j = 0; j < C; j++)  
        {  
            if(max_of_s < S[i][j])  
            {  
                max_of_s = S[i][j];  
                max_i = i;  
                max_j = j;  
            }  
        }              
    }  
  
    //cout<<"Maximum size sub-matrix is: \n";  
    for(i = max_i; i > max_i - max_of_s; i--)  
    {  
        for(j = max_j; j > max_j - max_of_s; j--)  
        {  
      //      cout << M[i][j] << " ";  
        }  
        //cout << "\n";  
    }  
    cout << "MAx area is " << max_of_s * max_of_s << endl;
}  
  