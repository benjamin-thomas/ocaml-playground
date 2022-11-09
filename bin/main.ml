(*
  rg --files | entr -c dune exec tree
  while true;do rg --files | entr -c dune exec tree;sleep 1;done
*)

open Lib

let () = Tree.print "/home/benjamin/code/explore/elm/turtle/"
(* let () = Tree.print "../../elm/turtle/" *)
