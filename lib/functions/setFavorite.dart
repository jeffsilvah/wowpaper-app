List<String> setFavorite({list, path}){
  if(!list.contains(path)){
    list.add(path);
  }else{
    list.remove(path);
  }

  return list;
}