#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__device__ int isGolomb(int *x, int in) {
	int map[100];
	for (int i = 0; i<100; i++) map[i] = 0;

	for (int i = 0; i<in; i++) {
		for (int j = i + 1; j<in; j++) {
			int diff = x[j] - x[i];
			if (map[diff] == 1) return 0;
			map[diff] = 1;
		}
	}
	return 1;
}

__device__ int recurse(int n, int k, int *x,int *p, int in) {
	int isg = isGolomb(x, in);
	if (!isg) return 0;

	if (in == n-1) {
		if (isGolomb(x, n) && (x[n-1]<p[n-1] || p[n-1]==0)) { for (int i = 0; i < n; i++) p[i] = x[i];return 1; }
		else if(isGolomb(x,n)) return 1;
		else return 0;
	}

	x[in] = x[in - 1] + 1;
	while (x[in] <= k - n + in) {
		int res = recurse(n, k, x,p,in + 1);
		if (res == 1) return 1;
		x[in]++;
	}

	return 0;
}

//algo 5.3
__global__ void kernel(int *n, int *k,int *p, int *res) {
	int i1 = blockIdx.x + 1;
	int i2 = threadIdx.x + 1;
	
	int x[15];
	x[0] = 0;
	x[1] = i1;x[2] = i2;x[*n - 1] = *k;

	if (*n>3) {
		if (i2 <= i1 || i2 >= *k) return;
		int r = recurse(*n, *k, x, p,3);
		if (r == 1) res[0] = 1;
	}
	else if (*n == 3) {
		if (i2 <= i1 || i2 >= *k) return;
		x[1] = i1;
		x[2] = i2;
		if (!isGolomb(x,3)) return;
		else {
			if (x[*n - 1] < p[*n - 1] || p[*n - 1] == 0) for(int i = 0; i < *n; i++) p[i] = x[i];
			res[0] = 1;
		}
	}
	else if (*n == 2) {
		if (!isGolomb(x,2)) return;
		else {
			for (int i = 0; i < *n; i++) p[i] = x[i];
			res[0] = 1;
		}
	}
	else{
		res[0] = 1;
	}
}

int main() {
	int n, r = 0;
	int p[100];
	scanf("%d", &n);
	int *d_res,*d_p,*d_n,*d_k;
	cudaMalloc((void **)&d_res, sizeof(int));
	cudaMalloc((void **)&d_n, sizeof(int));
	cudaMalloc((void **)&d_k, sizeof(int));
	cudaMalloc((void **)&d_p, sizeof(int)*n);
	
	int k = (n*(n - 1)) / 2;
	int k2 = (int)((double)(n*n) - 2 * n*pow(n, 0.5) + pow(n, 0.5) - 2);
	if (k2>k) k = k2;

	cudaMemcpy(d_n, &n, sizeof(int), cudaMemcpyHostToDevice);
	while(1) {
		cudaMemcpy(d_k, &k, sizeof(int), cudaMemcpyHostToDevice);
		kernel<<<k-n+3,25>>>(d_n,d_k,d_p, d_res);
		cudaDeviceSynchronize();
		cudaMemcpy(&r, d_res, sizeof(int), cudaMemcpyDeviceToHost);
		cudaMemcpy(p, d_p, sizeof(int)*n, cudaMemcpyDeviceToHost);
		cudaDeviceSynchronize();
		if (r==1) {
			printf("%d  %d  ", n, p[n-1]);
			for(int i = 0;i < n;i++) printf("%d ", p[i]);
			printf("\n");
			break;
		}else k++;
	}

	return 0;
}