#include<stdio.h>
#include<stdlib.h>
#include<math.h>

int isGolomb(int x[],int in){
	int map[1000];
	for(int i=0;i<1000;i++) map[i] = 0;

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
		printf("%d  %d  ",n,x[n-1]);
		for(int i=0;i<n;i++) printf("%d ",x[i]);
		printf("\n");
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

int main(){
	int n;
	scanf("%d",&n);
	int x[n];
	
	int k = (n*(n-1))/2;
	int k2 = (int)((double)(n*n)-2*n*pow(n,0.5)+pow(n,0.5)-2);
	if(k2>k) k = k2;

	x[0] = 0;

	while(1){
		x[n-1] = k;
		if(recurse(n,k,x,1)) break;
		k++;
	}

	return 0;
}