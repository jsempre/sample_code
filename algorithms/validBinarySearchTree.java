    boolean checkBST(Node root) {
        return isValidBST(root, -1, 10001);
    }

    boolean isValidBST(Node root, int min, int max){
        if(root==null){
            return true;
        }
        if(root.data <= min || root.data>= max){
            return false;
        }
        return isValidBST(root.left, min, root.data) && isValidBST(root.right, root.data, max);
    }
