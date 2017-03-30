class selectionsort {
    
    public void main(String args[]) {
    	int[] array={66, 33, 99, 88, 44, 55, 33, 77};
    	System.out.print("Initial array: ");
	for(int i=0;i<array.length;i++){
		System.out.print(array[i]+" ");
	}
	System.out.println();
	int length=array.length;
    	int[] final_array=selectionSort(array, length);
	System.out.println();
	System.out.println("Sorted array: ");
	for (int i=0; i<final_array.length; i++){
		System.out.print(final_array[i]+" ");
	}
    }
    public selectionsort(int[] array){}
    	
    public int[] selectionSort(int[] array, int length){
    	int smallest;
	int smallest_index;
    	int i=0;
	for(int j=0;j<length;j++){
    		smallest=array[j];
		smallest_index=j;

		//Look through remaining unsorted array for smallest element.
    		for(i=j;i<length;i++){
    			if(array[i]<smallest){
    				smallest_index=i;
				smallest=array[i];
			}
    		}
		//Debug info
		//System.out.println("i="+i+" "+"j="+j+" "+"smallest="+smallest);
    		
		//Swap current position with smallest remaining array element.
		int temp=array[j];
    		array[j]=smallest;
    		array[smallest_index]=temp;
		
		//Output array
		//System.out.print("Current iteration array state: ");
		//for(int k=0;k<length;k++){
		//	System.out.print(array[k]+" ");
		//}
		//System.out.println();
    	}
    	return(array);
    }
}    
