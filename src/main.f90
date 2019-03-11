!=======================================================================================
!
!     Author:   Jan Eitzinger (je), jan.treibig@gmail.com
!     Copyright (c) 2019 RRZE, University Erlangen-Nuremberg
!
!     Permission is hereby granted, free of charge, to any person obtaining a copy
!     of this software and associated documentation files (the "Software"), to deal
!     in the Software without restriction, including without limitation the rights
!     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
!     copies of the Software, and to permit persons to whom the Software is
!     furnished to do so, subject to the following conditions:
!
!     The above copyright notice and this permission notice shall be included in all
!     copies or substantial portions of the Software.
!
!     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
!     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
!     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
!     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
!     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
!     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
!     SOFTWARE.#include <stdlib.h>
!
!=======================================================================================

program bwBench
    use timing
    use constants
    use benchmarks

    implicit none

    integer, parameter :: numbench = 8
    real(kind=dp), allocatable :: a(:), b(:), c(:), d(:)
    real(kind=dp) :: scalar, tmp
    real(kind=dp) :: maxtime(numbench), mintime(numbench), avgtime(numbench), &
        times(numbench,ntimes)
    integer :: i, k
    integer :: bytes(numbench)
    integer :: bytesPerWord
    character :: label(numbench)*11

!$    INTEGER omp_get_num_threads
!$    EXTERNAL omp_get_num_threads

    !FIXME: Fuck Fortran
    bytesPerWord = 8

    bytes(1) = 1 * bytesPerWord * n ! init
    bytes(2) = 1 * bytesPerWord * n ! summ
    bytes(3) = 2 * bytesPerWord * n ! copy
    bytes(4) = 2 * bytesPerWord * n ! update
    bytes(5) = 3 * bytesPerWord * n ! triad
    bytes(6) = 3 * bytesPerWord * n ! daxpy
    bytes(7) = 4 * bytesPerWord * n ! striad
    bytes(8) = 4 * bytesPerWord * n ! sdaxpy

    label(1) = " Init:       "
    label(2) = " Sum:        "
    label(3) = " Copy:       "
    label(4) = " Update:     "
    label(5) = " Triad:      "
    label(6) = " Daxpy:      "
    label(7) = " STriad:     "
    label(8) = " SDaxpy:     "

    do  i = 1, numbench
       avgtime(i) = 0.0D0
       mintime(i) = 1.0D+36
       maxtime(i) = 0.0D0
    end do

    allocate(a(n))
    allocate(b(n))
    allocate(c(n))
    allocate(d(n))

!$omp parallel
!$omp master
      print *,'----------------------------------------------'
!$    print *,'Number of Threads = ',OMP_GET_NUM_THREADS()
!$omp end master
!$omp end parallel

      PRINT *,'----------------------------------------------'

!$OMP PARALLEL DO
    do  i = 1, n
       a(i) = 2.0d0
       b(i) = 2.0d0
       c(i) = 0.5d0
       d(i) = 1.0d0
    end do

    scalar = 3.0d0

    do  k = 1, ntimes
       times(1, k) = init(b, scalar)
       times(2, k) = summ(a)
       times(3, k) = copy(c, a)
       times(4, k) = update(a, scalar)
       times(5, k) = triad(a, b, c, scalar)
       times(6, k) = daxpy(a, b, scalar)
       times(7, k) = striad(a, b, c, d)
       times(8, k) = sdaxpy(a, b, c)
    end do

    do  k = 1, ntimes
       do  i = 1, numbench
          avgtime(i) = avgtime(i) + times(i, k)
          mintime(i) = MIN(mintime(i), times(i, k))
          maxtime(i) = MAX(mintime(i), times(i, k))
       end do
    end do

    print *,"-------------------------------------------------------------"
    print *,"Function      Rate (MB/s)   Avg time     Min time     Max time"

    do  i = 1, numbench
       avgtime(i) = avgtime(i)/dble(ntimes-1)
       print "(a,f12.2, 2x, 3 (f10.4,3x))", label(i), bytes(i)/mintime(i)/1.0D6, &
               avgtime(i), mintime(i), maxtime(i)
    end do
    print *,"-------------------------------------------------------------"

end program bwBench

