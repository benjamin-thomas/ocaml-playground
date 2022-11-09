(*
    Copy/paste into utop:

        > #use_output "dune ocaml top";;
        > Lib__Tree.enum_entries "/home/benjamin/code/explore/elm/turtle/";;
        > Lib.Tree.enum_entries "/home/benjamin/code/explore/elm/turtle/";;

*)
let greet = "WIP: tree"

let add_trailing_sep_char str =
  let sepChar = Filename.dir_sep in
  if String.ends_with ~suffix:sepChar str then str else str ^ sepChar
;;

let enum_entries path =
  Sys.readdir path |> Array.to_list |> List.map (fun n -> add_trailing_sep_char path ^ n)
;;

type summary =
  { name : string
  ; is_dir : bool
  ; is_hidden : bool
  ; size : int
  ; children : summary list
  ; parent_dir : string
  }

let dir_name path = Filename.dirname path |> Filename.basename
let is_hidden path = path |> Filename.basename |> String.starts_with ~prefix:"."

let rec to_summary path =
  let is_dir = Sys.is_directory path in
  let is_hidden = is_hidden path in
  let size = if is_dir then 0 else -1 in
  let children = if is_dir then enum_entries path |> List.concat_map to_summary else [] in
  [ { name = path
    ; is_dir
    ; is_hidden
    ; size
    ; children
    ; parent_dir = dir_name path |> add_trailing_sep_char
    }
  ]
;;

let rec tree_to_string depth summary =
  summary
  |> List.filter (fun s -> not s.is_hidden) (* mimic os util: "tree" *)
  |> List.concat_map (fun summary ->
       let children = summary.children in
       if children <> []
       then
         [ depth, summary.size, summary.name, summary.is_dir, summary.parent_dir ]
         |> List.append (tree_to_string (depth + 1) children |> List.map Fun.id)
       else [ depth, summary.size, summary.name, summary.is_dir, summary.parent_dir ])
;;

(*

let hiddenFile summary = summary.IsHidden

let toLowerName summary = summary.Name.ToLower()
*)

let compute path = enum_entries path |> List.concat_map to_summary

(* TODO: make private fn *)
let to_human size = "TODO:BTH:" ^ Int.to_string size
let rec repeat n s = if n = 0 then "" else s ^ repeat (n - 1) s

(* TODO: make private fn *)
let print_path
  ((depth : int), (size : int), (path : string), (is_dir : bool), (parent_dir : string))
  =
  let depth_to_ws = repeat depth "  " in
  (* let simplePath = path.Replace(parent_dir, "") in *)
  let simple_path = Str.(global_replace (regexp parent_dir) "" path) in
  let file_type_emoji = if is_dir then "📁" else "📝" in
  Printf.printf "[%d] %s [%s] %s %s" size file_type_emoji depth_to_ws simple_path
;;

let print_something = Printf.printf "Yes: %d" 1

(* |> List.sort (fun (depth, _size, path, _is_dir, _parent_dir) -> compare path *)

let print root_path =
  compute (root_path |> add_trailing_sep_char)
  |> tree_to_string 0
  |> List.iter (fun ((depth, _size, path, _d, _e) : int * int * string * bool * string) ->
       Printf.printf "[%d] %s" depth path)
;;
(* |> List.iter (fun (depth) -> print_path (depth)) *)

(*
// print "/home/benjamin/code/explore/love2d/love-typescript-template/"
 *)
