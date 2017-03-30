//Jordan Koch
//Implementation of quicksort on an array

class quicksort {
    
    public static void main(String args[]) {
    	int[] array={16, 4, 10, 14, 7, 9, 3, 2, 8, 1};
    	System.out.print("Initial array: ");
	for(int i=0;i<array.length;i++){
		System.out.print(array[i]+" ");
	}
	System.out.println();
	int length=array.length;
	array=quicksort(array, 0, length-1);
	System.out.println();
	System.out.println("Sorted array: ");
	for (int i=0; i<array.length; i++){
		System.out.print(array[i]+" ");
	}
    }
    
    //Sorts two subarrays defined by the call to partition.
    public static int[] quicksort(int[] array, int p, int r){
    	if(p<r){
		int q = partition(array, p, r);
		System.out.print("processing... ");
		//Debug output
		for(int i=0;i<array.length;i++){
			System.out.print(array[i] + " ");
			}
		System.out.println();
		array=quicksort(array, p, q-1);
		array=quicksort(array, q+1, r);
		}
	return(array);
	}
	
    //Divides array into two subarrays such that the first array is less
    //than the pivot and the second is larger than the pivot.
    public static int partition(int[] array, int p, int r){
	int x = array[r];
	int i = p-1;
	for(int j=p;j<=r-1;j++){
		if(array[j]<=x){
			i++;
			int temp = array[i];
			array[i] = array[j];
			array[j] = temp;
			}
		}
	int temp = array[i+1];
	array[i+1] = array[r];
	array[r] = temp;
	return(i+1);
	}
}		
		
