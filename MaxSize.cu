#include<bits/stdc++.h>
using namespace std;

__global__
void MaxSizeSubMat(int* d_M, int* d_S, int* d_c, int* d_r, int* N) {
	int k = threadIdx.x, i , j;
	if(*N >= (*d_c + *d_r)/2) {
		i = *d_r - (k + 1);
		j = *N + k + 2 - *d_r;
	} else {
		i = *N - k;
		j = k + 1;
	}
	if(j >= *d_c || j <= 0 || i <= 0 || i >= *d_r) {
		return;
	}
	if(d_M[ (*d_c * i) + j ] == 1) {
		int a = d_S[ (*d_c * i) + j-1] , b = d_S[ (*d_c * (i-1)) + j ], c = d_S[ (*d_c * (i-1)) + j -1 ];
		if(a <= b && a <= c) {
			d_S[ (*d_c * i) + j ] = a + 1;
			__syncthreads();
		} else if(b <= c && b <= a) {
			d_S[ (*d_c * i) + j ] = b + 1;
			__syncthreads();
		}else {
			d_S[ (*d_c * i) + j ] = c + 1;
			__syncthreads();
		}
	} else {
		d_S[ (*d_c * i) + j ] = 0;
	}
}



int main() {
	int isize = sizeof(int) ; //bsize = sizeof(bool);
	int h_r, h_c;
	//int *d_r, *d_c;
	cout << "Enter the Number of rows in the matrix." << endl;
	cin >> h_r;
	cout << "Enter the Number of columns in the matrix." << endl;
	cin >> h_c;

	int h_M[h_r][h_c];

	int  h_S[h_r][h_c];
	cout << "Enter the elements of the matrix.\n";
	for(int i = 0; i < h_r; i++) {
		for(int j = 0; j < h_c; j++) {
			cin >> h_M[i][j];
			if(i == 0 || j == 0) {
				h_S[i][j] = h_M[i][j];
			} else {

				h_S[i][j] = 0;
			}
		}
	}
	int *d_M, *d_c, *d_S, *d_r;

	cudaMalloc((void**)&d_M, h_r * h_c * isize);
	cudaMalloc((void**)&d_S, h_r * h_c * isize);
	cudaMalloc((void**)&d_c, isize);
	cudaMalloc((void**)&d_r, isize);

	for(int i = 0; i < h_r; i++) {
		for(int j = 0; j < h_c; j++) {
			cudaMemcpy( &d_M[ (h_c * i) + j ], &h_M[i][j], isize, cudaMemcpyHostToDevice);
			cudaMemcpy( &d_S[ (h_c * i) + j ], &h_S[i][j], isize, cudaMemcpyHostToDevice);
		}
	}
	puts("");
	cudaMemcpy(d_c, &h_c, isize, cudaMemcpyHostToDevice);
	cudaMemcpy(d_r, &h_r, isize, cudaMemcpyHostToDevice);

	int n = (h_r + h_c - 3), *N;
	cudaMalloc((void**)&N, isize);

	for(int i = 1; i <= (n + 1)/2; i++) {
		cudaMemcpy( N, &i, isize, cudaMemcpyHostToDevice);
		MaxSizeSubMat<<<1,i>>> (d_M, d_S, d_c, d_r, N);
		cudaDeviceSynchronize();
	}
	for(int i = (n + 3)/2; i <= n ; i++ ) {
		cudaMemcpy( N, &i, isize, cudaMemcpyHostToDevice);
		MaxSizeSubMat<<<1, (n - i + 1)>>> (d_M, d_S, d_c, d_r, N);
		cudaDeviceSynchronize();
	}
	for(int i = 0; i < h_r; i++) {
		for(int j = 0; j < h_c; j++) {
			cudaMemcpy( &h_S[i][j], &d_S[ (h_c * i) + j ], isize, cudaMemcpyDeviceToHost);
		}
	}
	cudaDeviceSynchronize();
	int max = h_S[0][0];
	//cout << " The square size matrix is" << endl;
	for(int i = 0; i < h_r; i++) {
		for(int j = 0; j < h_c; j++) {
			if(max < h_S[i][j]) {
				max = h_S[i][j];
			}
			//cout << h_S[i][j] << " ";
		}
		//cout << endl;
	}
	cout << "Max area is " << max * max << ".\n";
	cudaFree(d_M); cudaFree(d_S);
}

