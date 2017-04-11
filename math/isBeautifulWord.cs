using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
class Solution {

    static void Main(String[] args) {
        string w = Console.ReadLine();
        // Print 'Yes' if the word is beautiful or 'No' if it is not.
        int wLen = w.Length;
        string vowels = "aeiouy";
        string response = "Yes";
        for(int i = 0; i < wLen-1; i++){
            if(w[i]==w[i+1] || (vowels.Contains(w[i]) && vowels.Contains(w[i+1]))){
               response = "No"; 
            }
        }
        Console.WriteLine(response);
    }
}
