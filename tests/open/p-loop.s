main {
  key:string := "ic";  

  found:bool  := F;
  i:int := 0;
  tmp:string;

  loop
      if (i<books.len) then
       break;
      fi
      tmp := books[i];
      if (key in tmp) then found := T; fi
      i := i + 1;
  pool
};
