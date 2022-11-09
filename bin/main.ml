(*
  rg --files | entr -c dune exec tree
  while true;do rg --files | entr -c dune exec tree;sleep 1;done
  clear && dune build && _build/default/bin/main.exe ~/code/explore/elm/turtle/
  rg --files | entr -c bash -c 'dune build && _build/default/bin/main.exe ~/code/explore/elm/turtle/'
  dune exec tree ~/code/explore/elm/turtle/
*)
open Lib

let () = Tree.print (Array.get Sys.argv 1)
(* let () = Tree.print "../../elm/turtle/" *)
