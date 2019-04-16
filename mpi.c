#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include "mpi.h"

int isGolomb(int x[],int in){
	int map[100];
	for(int i=0;i<100;i++) map[i] = 0;

	for(int i=0;i<in;i++){
		for(int j=i+1;j<in;j++){
			int diff = x[j]-x[i];
			if(map[diff]==1) return 0;
			map[diff]=1;
		}
	}	
	return 1;
}

int recurse(int n,int k,int x[],int in){
	int isg = isGolomb(x,in);
	if(!isg) return 0;

	if(in==n && isg){
		return 1;
	}	

	x[in]=x[in-1]+1;
	while(x[in]<=k-n+in){
		int res = recurse(n,k,x,in+1);
		if(res==1) return 1;
		x[in]++;
	}
	return 0;
}

int main(int argc, char *argv[]){
	int s,r;
	
	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD,&s);
	MPI_Comm_rank(MPI_COMM_WORLD,&r);
	
	int n,res=1000,tn=1000;
	int x[30];
	
	if(r==0){
		scanf("%d",&n);
	}

	MPI_Bcast(&n,1,MPI_INT,0,MPI_COMM_WORLD);
	MPI_Barrier(MPI_COMM_WORLD);	

	int k = (n*(n-1))/2;
	int k2 = (int)((double)(n*n)-2*n*pow(n,0.5)+pow(n,0.5)-2);
	if(k2>k) k = k2;

	x[0] = 0;

	if(r>=k){
		x[n-1] = r;
		if(recurse(n,r,x,1)){
			res = r;
		}
	}

	MPI_Barrier(MPI_COMM_WORLD);	
	MPI_Reduce(&res,&tn,1,MPI_INT,MPI_MIN,0,MPI_COMM_WORLD);
	MPI_Barrier(MPI_COMM_WORLD);

	if(r==0){
		if(n==1) printf("\n%d\n",tn);
		else printf("\n%d\n",tn-1);
	}
	MPI_Finalize();
	return 0;
}