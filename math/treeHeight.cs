using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

    static void Main(String[] args) {
        int t = Convert.ToInt32(Console.ReadLine());
        for(int a0 = 0; a0 < t; a0++){
            int n = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine(treeHeight(n));
        }
    }

    private static int treeHeight(int cycles){
        if(cycles == 0){
            return 1;
        }
        if((cycles % 2) == 1){
            return 2*treeHeight(cycles-1);
        }
        if((cycles % 2) ==0){
            return 1+treeHeight(cycles-1);
        }
        else{
            return 0;
        }
    }
    
}
