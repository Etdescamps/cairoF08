! Copyright (c) 2019 Etienne Descamps <etdescdev AT gmail.com>
! 
! Permission to use, copy, modify, and distribute this software for any
! purpose with or without fee is hereby granted, provided that the above
! copyright notice and this permission notice appear in all copies.
! 
! THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
! WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
! MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
! ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
! WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
! ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
! OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Module cairo_surface
  Use ieee_arithmetic
  Use iso_c_binding
  IMPLICIT NONE
  PRIVATE

  Type, Public :: CairoSurface
    type(c_ptr) :: surface = C_NULL_PTR
  Contains
    procedure :: createVectImg => CairoCreateVectImg
    procedure :: createFromPng => CairoCreateFromPng
    procedure :: createSurface => CairoCreateSurface
    !procedure :: createSurfaceData => CairoCreateSurfaceData
    procedure :: writeToPNG => CairoWriteToPNG
    procedure :: showPage => CairoShowPage
    final :: CairoSurfaceFinal
  End Type CairoSurface

  Integer(c_int), Parameter, Public :: FCAIRO_FILE_DET = 0, FCAIRO_FILE_PS = 1, &
                                       FCAIRO_FILE_PDF = 2, FCAIRO_FILE_SVG = 3, FCAIRO_FILE_EPS = 4

  Interface
    Function fcairoCreateVectGraph(filename, width_in_points, height_in_points, ftype) &
        Bind(C, NAME="fcairoCreateVectGraph")
      Use iso_c_binding
      type(c_ptr) :: fcairoCreateVectGraph
      character(KIND=c_char), intent(in) :: filename(*)
      real(c_double), value :: width_in_points, height_in_points
      integer(c_int), intent(in), optional :: ftype
    End Function fcairoCreateVectGraph

    Subroutine cairo_surface_finish(surface) Bind(C, NAME="cairo_surface_finish")
      Use iso_c_binding
      type(c_ptr), value :: surface
    End Subroutine cairo_surface_finish

    Subroutine cairo_surface_destroy(surface) Bind(C, NAME="cairo_surface_destroy")
      Use iso_c_binding
      type(c_ptr), value :: surface
    End Subroutine cairo_surface_destroy

    Subroutine cairo_surface_show_page(surface) Bind(C, NAME="cairo_surface_show_page")
      Use iso_c_binding
      type(c_ptr), value :: surface
    End Subroutine cairo_surface_show_page

    Function cairo_surface_write_to_png(surface, filename) Bind(C, NAME="cairo_surface_write_to_png")
      Use iso_c_binding
      type(c_ptr), value :: surface
      character(KIND=c_char), intent(in) :: filename(*)
      integer(c_int) :: cairo_surface_write_to_png
    End Function cairo_surface_write_to_png

    Function cairo_image_surface_create_from_png(filename) &
        Bind(C, NAME="cairo_image_surface_create_from_png")
      Use iso_c_binding
      type(c_ptr) :: cairo_image_surface_create_from_png
      character(KIND=c_char), intent(in) :: filename(*)
    End Function cairo_image_surface_create_from_png

    Function cairo_image_surface_create(c_format, width, height) &
        Bind(C, NAME="cairo_image_surface_create")
      Use iso_c_binding
      type(c_ptr) :: cairo_image_surface_create
      integer(c_int), value :: c_format, width, height
    End Function cairo_image_surface_create

    Function cairo_image_surface_create_for_data(array, c_format, width, height, stride) &
        Bind(C, NAME="cairo_image_surface_create_for_data")
      Use iso_c_binding
      type(c_ptr), value :: array
      type(c_ptr) :: cairo_image_surface_create_for_data
      integer(c_int), value :: c_format, width, height, stride
    End Function cairo_image_surface_create_for_data
  End Interface
Contains
  Integer Function CairoCreateVectImg(this, filename, &
      width_in_points, height_in_points, ftype) Result(info)
    class(CairoSurface), intent(inout) :: this
    character(len=*, KIND=c_char), intent(in) :: filename
    real(c_double), value :: width_in_points, height_in_points
    integer(c_int), intent(in), optional :: ftype
    character(len=:,kind=c_char), allocatable, target :: fname
    info = -1
    fname = filename//C_NULL_CHAR
    this%surface = fcairoCreateVectGraph(fname, width_in_points, &
      height_in_points, ftype)
    If(C_ASSOCIATED(this%surface)) info = 0
  End Function CairoCreateVectImg

  Integer Function CairoCreateFromPng(this, filename) Result(info)
    class(CairoSurface), intent(inout) :: this
    character(KIND=c_char), intent(in) :: filename
    character(len=:,kind=c_char), allocatable, target :: fname
    info = -1
    fname = filename//C_NULL_CHAR
    this%surface = cairo_image_surface_create_from_png(fname)
    If(C_ASSOCIATED(this%surface)) info = 0
  End Function CairoCreateFromPng

  Integer Function CairoCreateSurface(this, width, height) Result(info)
    class(CairoSurface), intent(inout) :: this
    integer(c_int), intent(in) :: width, height
    info = -1
    this%surface = cairo_image_surface_create(0, width, height)
    If(C_ASSOCIATED(this%surface)) info = 0
  End Function CairoCreateSurface

  Integer Function CairoWriteToPNG(this, filename) Result(info)
    class(CairoSurface), intent(inout) :: this
    character(KIND=c_char), intent(in) :: filename
    character(len=:,kind=c_char), allocatable, target :: fname
    fname = filename//C_NULL_CHAR
    info = cairo_surface_write_to_png(this%surface, fname)
  End Function CairoWriteToPNG

  Subroutine CairoShowPage(this)
    class(CairoSurface), intent(inout) :: this
    CALL cairo_surface_show_page(this%surface)
  End Subroutine CairoShowPage

  Subroutine CairoSurfaceFinal(this)
    type(CairoSurface) :: this
    If(C_ASSOCIATED(this%surface)) Then
      CALL cairo_surface_finish(this%surface)
      CALL cairo_surface_destroy(this%surface)
    Endif
    this%surface = C_NULL_PTR
  End Subroutine CairoSurfaceFinal
End Module cairo_surface

