class mergesort {
    
    public static void main(String args[]) {
	//int[] array={1, 2, 3, 4, 5, 6, 7, 8};
	int[] array={2,6,3,5,1,7,4,8};
	int[] temp={0,0,0,0,0,0,0,0};
	int r = array.length;
	System.out.println("the array length = " + r);

	//initialize array and call sorting function
	sort(array, temp,  0, r-1);

	//Output sorted array
	System.out.print("Final array:");
	for (int i=0; i<array.length; i++){
		System.out.print(array[i]);
	}
	System.out.println();
    }
    
    public static void sort(int[] array, int[] temp, int left, int right){
	int middle;
	
	//Continually look at smaller segments of the array, debug output included
	if (right>left){
		middle = (int) Math.floor((left+right)/2);
	        System.out.println("sort from " + left + " to " + middle);
		sort(array, temp, left, middle);
		System.out.println("sort from " + (middle+1) + " to " + right); 
		sort(array, temp, middle+1, right);

		//Debug output going into merge
		System.out.println("Array before merge: ");
		for (int i=0; i<array.length; i++){
                	System.out.print(array[i]);
		}
		System.out.println();

		//Call merge to sort the array segments
		merge(array, temp, left, middle+1, right);
    	}
    }

	//Use a temporary array to sort array segments
	public static void merge(int[] array, int[] temp, int first, int mid, int last)
	{
		System.out.println("New round of merge- first:" + first + " last:" + last + " mid:" + mid);
		int i, left_end, num_elements, tmp_pos;
		left_end=mid-1;
		tmp_pos=first;
		num_elements=last-first+1;
		while((first<=left_end)&&(mid<=last)){
			if(array[first]<=array[mid]){
				temp[tmp_pos]=array[first];
				tmp_pos++;
				first++;
			}
			else{
				temp[tmp_pos]=array[mid];
				tmp_pos++;
				mid++;
			}
		}
		while(first<=left_end){
			temp[tmp_pos]=array[first];
			first++;
			tmp_pos++;
		}
		while(mid<=last){
			temp[tmp_pos]=array[mid];
			mid++;
			tmp_pos++;
		}
		for(i=0; i<num_elements; i++){
			array[last]=temp[last];
			last--;
		}
	}
}
