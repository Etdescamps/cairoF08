Module cairo_path
  Use ieee_arithmetic
  Use iso_c_binding
  Use cairo_surface
  IMPLICIT NONE
  PRIVATE

  Type, Public :: CairoPath
    type(c_ptr) :: path = C_NULL_PTR
  Contains
    procedure :: init => CairoPathInit
    procedure :: moveTo => Cairo_moveTo
    procedure :: lineTo => Cairo_lineTo
    procedure :: setSourceRGB => Cairo_setSourceRGB
    procedure :: setSourceRGBA => Cairo_setSourceRGBA
    procedure :: translate => Cairo_translate
    procedure :: fscale => Cairo_fscale
    procedure :: rotate => Cairo_rotate
    procedure :: arc => Cairo_arc
    procedure :: arcNegative => Cairo_arcNegative
    procedure :: curveTo => Cairo_curveTo
    procedure :: setLineWidth => Cairo_setLineWidth
    procedure :: rectangle => Cairo_rectangle
    procedure :: pushGroup => Cairo_pushGroup
    procedure :: popGroup => Cairo_popGroup
    procedure :: fill => Cairo_fill
    procedure :: paint => Cairo_paint
    procedure :: paintWithAlpha => Cairo_paintWithAlpha
    procedure :: newPath => Cairo_newPath
    procedure :: newSubPath => Cairo_newSubPath
    procedure :: closePath => Cairo_closePath
    procedure :: stroke => Cairo_stroke
    final :: CairoPathFinal
  End Type CairoPath

  Interface
    Function cairo_create(surface) Bind(C, NAME="cairo_create")
      Use iso_c_binding
      type(c_ptr), value :: surface
      type(c_ptr) :: cairo_create
    End Function cairo_create

    Subroutine cairo_destroy(path) Bind(C, NAME="cairo_destroy")
      Use iso_c_binding
      type(c_ptr), value :: path
    End Subroutine cairo_destroy

    Subroutine f_move_to(surface, x, y) &
        Bind(C, NAME="cairo_move_to")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: y, x
    End Subroutine f_move_to

    Subroutine f_line_to(surface, x, y) &
        Bind(C, NAME="cairo_line_to")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: y, x
    End Subroutine f_line_to

    Subroutine f_set_source_rgb(surface, red, green, blue) &
        Bind(C, NAME="cairo_set_source_rgb")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: blue, green, red
    End Subroutine f_set_source_rgb

    Subroutine f_set_source_rgba(surface, red, green, blue, alpha) &
        Bind(C, NAME="cairo_set_source_rgba")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: alpha, blue, green, red
    End Subroutine f_set_source_rgba

    Subroutine f_translate(surface, tx, ty) &
        Bind(C, NAME="cairo_translate")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: ty, tx
    End Subroutine f_translate

    Subroutine f_scale(surface, sx, sy) &
        Bind(C, NAME="cairo_scale")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: sy, sx
    End Subroutine f_scale

    Subroutine f_rotate(surface, angle) &
        Bind(C, NAME="cairo_rotate")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: angle
    End Subroutine f_rotate

    Subroutine f_arc(surface, xc, yc, radius, angle1, angle2) &
        Bind(C, NAME="cairo_arc")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: angle2, angle1, radius, yc, xc
    End Subroutine f_arc

    Subroutine f_arc_negative(surface, xc, yc, radius, angle1, angle2) &
        Bind(C, NAME="cairo_arc_negative")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: angle2, angle1, radius, yc, xc
    End Subroutine f_arc_negative

    Subroutine f_curve_to(surface, x1, y1, x2, y2, x3, y3) &
        Bind(C, NAME="cairo_curve_to")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: y3, x3, y2, x2, y1, x1
    End Subroutine f_curve_to

    Subroutine f_set_line_width(surface, w) &
        Bind(C, NAME="cairo_set_line_width")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: w
    End Subroutine f_set_line_width

    Subroutine f_rectangle(surface, x, y, width, height) &
        Bind(C, NAME="cairo_rectangle")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: height, width, y, x
    End Subroutine f_rectangle

    Subroutine f_push_group(surface) &
        Bind(C, NAME="cairo_push_group")
      Use iso_c_binding
      type(c_ptr), value :: surface
    End Subroutine f_push_group

    Subroutine f_pop_group(surface) &
        Bind(C, NAME="cairo_pop_group")
      Use iso_c_binding
      type(c_ptr), value :: surface
    End Subroutine f_pop_group

    Subroutine f_fill(surface) &
        Bind(C, NAME="cairo_fill")
      Use iso_c_binding
      type(c_ptr), value :: surface
    End Subroutine f_fill

    Subroutine f_paint(surface) &
        Bind(C, NAME="cairo_paint")
      Use iso_c_binding
      type(c_ptr), value :: surface
    End Subroutine f_paint

    Subroutine f_paint_with_alpha(surface, alpha) &
        Bind(C, NAME="cairo_paint_with_alpha")
      Use iso_c_binding
      type(c_ptr), value :: surface
      real(c_double), value :: alpha
    End Subroutine f_paint_with_alpha

    Subroutine f_new_path(surface) &
        Bind(C, NAME="cairo_new_path")
      Use iso_c_binding
      type(c_ptr), value :: surface
    End Subroutine f_new_path

    Subroutine f_new_sub_path(surface) &
        Bind(C, NAME="cairo_new_sub_path")
      Use iso_c_binding
      type(c_ptr), value :: surface
    End Subroutine f_new_sub_path

    Subroutine f_close_path(surface) &
        Bind(C, NAME="cairo_close_path")
      Use iso_c_binding
      type(c_ptr), value :: surface
    End Subroutine f_close_path

    Subroutine f_stroke(surface) &
        Bind(C, NAME="cairo_stroke")
      Use iso_c_binding
      type(c_ptr), value :: surface
    End Subroutine f_stroke
  End Interface
Contains
  Integer Function CairoPathInit(this, surface) Result(info)
    class(CairoPath), intent(inout) :: this
    class(CairoSurface), intent(inout) :: surface
    info = -1
    this%path = cairo_create(surface%surface)
    If(C_ASSOCIATED(this%path)) info = 0
  End Function CairoPathInit

  Subroutine Cairo_moveTo(this, x, y)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: y, x
    CALL f_move_to(this%path, x, y)
  End Subroutine Cairo_moveTo

  Subroutine Cairo_lineTo(this, x, y)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: y, x
    CALL f_line_to(this%path, x, y)
  End Subroutine Cairo_lineTo

  Subroutine Cairo_setSourceRGB(this, red, green, blue)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: blue, green, red
    CALL f_set_source_rgb(this%path, red, green, blue)
  End Subroutine Cairo_setSourceRGB

  Subroutine Cairo_setSourceRGBA(this, red, green, blue, alpha)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: alpha, blue, green, red
    CALL f_set_source_rgba(this%path, red, green, blue, alpha)
  End Subroutine Cairo_setSourceRGBA

  Subroutine Cairo_translate(this, tx, ty)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: ty, tx
    CALL f_translate(this%path, tx, ty)
  End Subroutine Cairo_translate

  Subroutine Cairo_fscale(this, sx, sy)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: sy, sx
    CALL f_scale(this%path, sx, sy)
  End Subroutine Cairo_fscale

  Subroutine Cairo_rotate(this, angle)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: angle
    CALL f_rotate(this%path, angle)
  End Subroutine Cairo_rotate

  Subroutine Cairo_arc(this, xc, yc, radius, angle1, angle2)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: angle2, angle1, radius, yc, xc
    CALL f_arc(this%path, xc, yc, radius, angle1, angle2)
  End Subroutine Cairo_arc

  Subroutine Cairo_arcNegative(this, xc, yc, radius, angle1, angle2)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: angle2, angle1, radius, yc, xc
    CALL f_arc_negative(this%path, xc, yc, radius, angle1, angle2)
  End Subroutine Cairo_arcNegative

  Subroutine Cairo_curveTo(this, x1, y1, x2, y2, x3, y3)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: y3, x3, y2, x2, y1, x1
    CALL f_curve_to(this%path, x1, y1, x2, y2, x3, y3)
  End Subroutine Cairo_curveTo

  Subroutine Cairo_setLineWidth(this, w)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: w
    CALL f_set_line_width(this%path, w)
  End Subroutine Cairo_setLineWidth

  Subroutine Cairo_rectangle(this, x, y, width, height)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: height, width, y, x
    CALL f_rectangle(this%path, x, y, width, height)
  End Subroutine Cairo_rectangle

  Subroutine Cairo_pushGroup(this)
    class(CairoPath), intent(inout) :: this
    CALL f_push_group(this%path)
  End Subroutine Cairo_pushGroup

  Subroutine Cairo_popGroup(this)
    class(CairoPath), intent(inout) :: this
    CALL f_pop_group(this%path)
  End Subroutine Cairo_popGroup

  Subroutine Cairo_fill(this)
    class(CairoPath), intent(inout) :: this
    CALL f_fill(this%path)
  End Subroutine Cairo_fill

  Subroutine Cairo_paint(this)
    class(CairoPath), intent(inout) :: this
    CALL f_paint(this%path)
  End Subroutine Cairo_paint

  Subroutine Cairo_paintWithAlpha(this, alpha)
    class(CairoPath), intent(inout) :: this
    real(c_double), intent(in) :: alpha
    CALL f_paint_with_alpha(this%path, alpha)
  End Subroutine Cairo_paintWithAlpha

  Subroutine Cairo_newPath(this)
    class(CairoPath), intent(inout) :: this
    CALL f_new_path(this%path)
  End Subroutine Cairo_newPath

  Subroutine Cairo_newSubPath(this)
    class(CairoPath), intent(inout) :: this
    CALL f_new_sub_path(this%path)
  End Subroutine Cairo_newSubPath

  Subroutine Cairo_closePath(this)
    class(CairoPath), intent(inout) :: this
    CALL f_close_path(this%path)
  End Subroutine Cairo_closePath

  Subroutine Cairo_stroke(this)
    class(CairoPath), intent(inout) :: this
    CALL f_stroke(this%path)
  End Subroutine Cairo_stroke

  Subroutine CairoPathFinal(this)
    type(CairoPath) :: this
    If(C_ASSOCIATED(this%path)) CALL cairo_destroy(this%path)
    this%path = C_NULL_PTR
  End Subroutine CairoPathFinal
End Module cairo_path

