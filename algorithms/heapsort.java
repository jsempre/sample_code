class heapsort {
    
    public static void main(String args[]) {
    	int[] array={16, 4, 10, 14, 7, 9, 3, 2, 8, 1};
    	System.out.print("Initial array: ");
	for(int i=0;i<array.length;i++){
		System.out.print(array[i]+" ");
	}
	System.out.println();
	int length=array.length;
    	array=buildMaxHeap(array, length-1);
	for(int i=length-1;i>=2;i--){
		int temp=array[0];
		array[0]=array[i];
		array[i]=temp;
		maxHeapify(array,0,i-1);
	}
	System.out.println();
	System.out.println("Sorted array: ");
	for (int i=0; i<array.length; i++){
		System.out.print(array[i]+" ");
	}
    }
    	
    public static int[] maxHeapify(int[] array, int i, int n){
    	int largest=0;
		int temp;
		int left = 2*i+1;
		int right = 2*i+2;
		if(left<=n && array[left]>array[i]){
			largest=left;
		}
		else{
			largest=i;
		}
		if(right<=n && array[right]>array[largest]){
			largest=right;
		}
		System.out.println("Left: " + left + " Right: " + right + " Largest: " + largest + " I: " + i); 
		if(largest!=i){
			temp=array[i];
			array[i]=array[largest];
			array[largest]=temp;
			//added -1 to largest for debug
			maxHeapify(array, largest, n);
		}
    	return(array);
    }
	
	public static int[] buildMaxHeap(int[] array, int n){
		//check indexes in for loop
		for(int i=(int)(Math.floor(n/2));i>=0;i--)
		{
			//added to for debug
			maxHeapify(array,i,n);
		}
		return(array);
	}
}    
