/*
 * Copyright (c) 2019 Etienne Descamps <etdescdev AT gmail.com>
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
 */

#include <cairo.h>
#include <cairo-ps.h>
#include <cairo-pdf.h>
#include <cairo-svg.h>
#include <string.h>
#include <strings.h>

enum type_vector_file {FCAIRO_FILE_DET = 0, FCAIRO_FILE_PS = 1,
  FCAIRO_FILE_PDF = 2, FCAIRO_FILE_SVG = 3, FCAIRO_FILE_EPS = 4};

cairo_surface_t *fcairoCreateVectGraph(const char *filename, double width_in_points, double height_in_points, const int *ftype) {
  int type = ftype ? *ftype : FCAIRO_FILE_DET;
  cairo_surface_t *surf;
  if(type == FCAIRO_FILE_DET) {
    char *ext = strrchr(filename, '.');
    if(!ext)
      return NULL;
    if(strcasecmp(".ps", ext) == 0) {
      type = FCAIRO_FILE_PS;
    }
    if(strcasecmp(".eps", ext) == 0) {
      type = FCAIRO_FILE_EPS;
    }
    else if(strcasecmp(".pdf", ext) == 0) {
      type = FCAIRO_FILE_PDF;
    }
    else if(strcasecmp(".svg", ext) == 0) {
      type = FCAIRO_FILE_SVG;
    }
  }
  switch(type) {
    case FCAIRO_FILE_PDF:
      surf = cairo_pdf_surface_create(filename, width_in_points, height_in_points);
      return surf;
    case FCAIRO_FILE_SVG:
      surf = cairo_svg_surface_create(filename, width_in_points, height_in_points);
      return surf;
    case FCAIRO_FILE_PS:
    case FCAIRO_FILE_EPS:
    default:
      surf = cairo_ps_surface_create(filename, width_in_points, height_in_points);
      cairo_ps_surface_set_eps(surf, type == FCAIRO_FILE_EPS);
      cairo_ps_surface_dsc_begin_setup(surf);
      cairo_ps_surface_dsc_begin_page_setup(surf);
      return surf;
  }
}

