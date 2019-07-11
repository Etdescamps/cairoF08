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

Program test_ps
  Use cairo_surface
  Use cairo_path
  CALL generate_ps()
Contains
  Subroutine generate_ps()
    type(CairoSurface) :: surface
    type(CairoPath) :: path
    integer :: info
    info = surface%createVectImg("file.ps", 595d0, 842d0)
    info = path%init(surface)
    CALL path%moveTo(0d0, 0d0)
    CALL path%lineTo(100d0, 100d0)
    CALL path%setLineWidth(1d0)
    CALL path%stroke()
    CALL surface%showPage()
  End Subroutine generate_ps
End

