using System;
using System.Collections.Generic;
using System.IO;
class Solution {
static void insertionSort(int[] ar) {
    
    int fullLength = ar.Length;
    for( int h = 2; h <= fullLength; h++){
        int len = h;
        int pivot = ar[len-1];
        int i = (len-2);
        while(i >=0 && pivot < ar[i]){
            ar[i+1] = ar[i];
            i--;   
        }
        ar[i+1]=pivot;
        foreach (int j in ar){
            Console.Write(j + " ");
        }
        Console.Write(Environment.NewLine);
    }

}
}
