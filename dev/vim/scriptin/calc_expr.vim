function MyCalcNum(expr)
  let result = system('bc -e ' . a:expr)
  put =result
endfunction
