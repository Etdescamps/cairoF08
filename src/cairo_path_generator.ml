#!/usr/bin/env ocaml

(* Copyright (c) 2019 Etienne Descamps <etdescdev AT gmail.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

let preamble = [
  "Module cairo_path";
  "  Use ieee_arithmetic";
  "  Use iso_c_binding";
  "  Use cairo_surface";
  "  IMPLICIT NONE";
  "  PRIVATE";
  "";
  "  Type, Public :: CairoPath";
  "    type(c_ptr) :: path = C_NULL_PTR";
  "  Contains";
  "    procedure :: init => CairoPathInit"
];;

let begin_interface = [
  "    final :: CairoPathFinal";
  "  End Type CairoPath";
  "";
  "  Interface";
  "    Function cairo_create(surface) Bind(C, NAME=\"cairo_create\")";
  "      Use iso_c_binding";
  "      type(c_ptr), value :: surface";
  "      type(c_ptr) :: cairo_create";
  "    End Function cairo_create";
  "";
  "    Subroutine cairo_destroy(path) Bind(C, NAME=\"cairo_destroy\")";
  "      Use iso_c_binding";
  "      type(c_ptr), value :: path";
  "    End Subroutine cairo_destroy"
];;

let end_interface = [
  "  End Interface";
  "Contains";
  "  Integer Function CairoPathInit(this, surface) Result(info)";
  "    class(CairoPath), intent(inout) :: this";
  "    class(CairoSurface), intent(inout) :: surface";
  "    info = -1";
  "    this%path = cairo_create(surface%surface)";
  "    If(C_ASSOCIATED(this%path)) info = 0";
  "  End Function CairoPathInit"
];;

let bottom = [
  "";
  "  Subroutine CairoPathFinal(this)";
  "    type(CairoPath) :: this";
  "    If(C_ASSOCIATED(this%path)) CALL cairo_destroy(this%path)";
  "    this%path = C_NULL_PTR";
  "  End Subroutine CairoPathFinal";
  "End Module cairo_path";
  ""
];;

let rec write_list os = function [] -> ()
  | (t::q) -> output_string os t; output_string os "\n"; write_list os q

let c_s = open_out "cairo_path.f90";;

type dtype = Void | Double | Integer;;

let name_of_type = function Void -> "" | Double -> "real(c_double)" | Integer -> "integer(c_int)";;

let fun_list = [
  (Void, "move_to", "moveTo", [Double, "x"; Double, "y"]);
  (Void, "line_to", "lineTo", [Double, "x"; Double, "y"]);
  (Void, "set_source_rgb", "setSourceRGB", [Double, "red"; Double, "green"; Double, "blue"]);
  (Void, "set_source_rgba", "setSourceRGBA", [Double, "red"; Double, "green";
        Double, "blue"; Double, "alpha"]);
  (Void, "translate", "translate", [Double, "tx"; Double, "ty"]);
  (Void, "scale", "fscale", [Double, "sx"; Double, "sy"]);
  (Void, "rotate", "rotate", [Double, "angle"]);
  (Void, "arc", "arc", [Double, "xc"; Double, "yc"; Double, "radius";
        Double, "angle1"; Double, "angle2"]);
  (Void, "arc_negative", "arcNegative", [Double, "xc"; Double, "yc"; Double, "radius";
        Double, "angle1"; Double, "angle2"]);
  (Void, "curve_to", "curveTo", [Double, "x1"; Double, "y1"; Double, "x2"; Double, "y2";
        Double, "x3"; Double, "y3"]);
  (Void, "set_line_width", "setLineWidth", [Double, "w"]);
  (Void, "rectangle", "rectangle", [Double, "x"; Double, "y"; Double, "width"; Double, "height"]);
  (Void, "push_group", "pushGroup", []);
  (Void, "pop_group", "popGroup", []);
  (Void, "fill", "fill", []);
  (Void, "paint", "paint", []);
  (Void, "paint_with_alpha", "paintWithAlpha", [Double, "alpha"]);
  (Void, "new_path", "newPath", []);
  (Void, "new_sub_path", "newSubPath", []);
  (Void, "close_path", "closePath", []);
  (Void, "stroke", "stroke", [])
];;

let to_head = fun (_,_,a,_) -> Printf.sprintf "    procedure :: %s => Cairo_%s" a a;;

let rec merge_l l = function [] -> l
  | ((t,b)::q) -> (
    match l with ((u,a)::v) when u = t -> merge_l ((u,b::a)::v) q
    | _ -> merge_l ((t,[b])::l) q
  );;

let to_intf os = fun (t,a,b,l) -> 
  output_string os (if t = Void then "\n    Subroutine " else "\n    Function ");
  Printf.fprintf os "f_%s(%s) &\n" a (String.concat ", " ("surface"::(List.map snd l)));
  Printf.fprintf os "        Bind(C, NAME=\"cairo_%s\")\n" a;
  Printf.fprintf os "      Use iso_c_binding\n";
  if t <> Void then Printf.fprintf os "      %s :: f_%s\n" (name_of_type t) a;
  Printf.fprintf os "      type(c_ptr), value :: surface\n";
  List.iter (fun (u,v) ->
    Printf.fprintf os "      %s, value :: %s\n" (name_of_type u) (String.concat ", " v)) (merge_l [] l);
  Printf.fprintf os (if t = Void then "    End Subroutine f_%s\n" else "    End Function f_%s\n") a;;

let to_impl os = fun (t,a,b,l) ->
  output_string os (if t = Void then "\n  Subroutine " else "\n  Function ");
  Printf.fprintf os "Cairo_%s(%s)\n" b (String.concat ", " ("this"::(List.map snd l)));
  Printf.fprintf os "    class(CairoPath), intent(inout) :: this\n";
  List.iter (fun (u,v) ->
    Printf.fprintf os "    %s, intent(in) :: %s\n" (name_of_type u) (String.concat ", " v)) (merge_l [] l);
  if t = Void then
    Printf.fprintf os "    CALL f_%s(%s)\n" a (String.concat ", " ("this%path"::(List.map snd l)))
  else (
    Printf.fprintf os "    %s :: Cairo_%s\n" (name_of_type t) b;
    Printf.fprintf os "    Cairo_%s = f_%s(%s)\n" b a (String.concat ", " ("this%path"::(List.map snd l)))
  );
  Printf.fprintf os (if t = Void then "  End Subroutine Cairo_%s\n" else "  End Function %s\n") b;;


write_list c_s preamble;;
write_list c_s (List.map to_head fun_list);;
write_list c_s begin_interface;;
List.iter (to_intf c_s) fun_list;;
write_list c_s end_interface;;
List.iter (to_impl c_s) fun_list;;
write_list c_s bottom;;

close_out c_s;;

