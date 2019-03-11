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

module benchmarks
use timing
use constants

contains

function init (a, scalar) result(seconds)
implicit none
real(kind=dp) :: seconds
real(kind=dp), allocatable, intent(inout) :: a(:)
real(kind=dp), intent(in) :: scalar
real(kind=dp) :: S, E
integer :: i

S = getTimeStamp()
!$OMP PARALLEL DO
do  i = 1, n
   a(i) = scalar
end do
E = getTimeStamp()

seconds = E-S
end function init

function summ (a) result(seconds)
implicit none
real(kind=dp) :: seconds
real(kind=dp) :: summe = 0.0d0
real(kind=dp), allocatable, intent(inout) :: a(:)
real(kind=dp) :: S, E
integer :: i

S = getTimeStamp()
!$OMP PARALLEL DO
do  i = 1, n
    summe = summe + a(i)
end do
E = getTimeStamp()

!make the compiler think this makes actually sense
a(10) = summe

seconds = E-S
end function summ

function copy (a, b) result(seconds)
implicit none
real(kind=dp) :: seconds
real(kind=dp), allocatable, intent(inout) :: a(:)
real(kind=dp), allocatable, intent(in) :: b(:)
real(kind=dp) :: S, E
integer :: i

S = getTimeStamp()
!$OMP PARALLEL DO
do  i = 1, n
   a(i) = b(i)
end do
E = getTimeStamp()

seconds = E-S
end function copy

function update (a, scalar) result(seconds)
implicit none
real(kind=dp) :: seconds
real(kind=dp), allocatable, intent(inout) :: a(:)
real(kind=dp), intent(in) :: scalar
real(kind=dp) :: S, E
integer :: i

S = getTimeStamp()
!$OMP PARALLEL DO
do  i = 1, n
   a(i) = a(i) * scalar
end do
E = getTimeStamp()

seconds = E-S
end function update

function triad (a, b, c, scalar) result(seconds)
implicit none
real(kind=dp) :: seconds
real(kind=dp), allocatable, intent(inout) :: a(:)
real(kind=dp), allocatable, intent(in) :: b(:)
real(kind=dp), allocatable, intent(in) :: c(:)
real(kind=dp), intent(in) :: scalar
real(kind=dp) :: S, E
integer :: i

S = getTimeStamp()
!$OMP PARALLEL DO
do  i = 1, n
   a(i) = b(i) + scalar * c(i)
end do
E = getTimeStamp()

seconds = E-S
end function triad

function daxpy (a, b, scalar) result(seconds)
implicit none
real(kind=dp) :: seconds
real(kind=dp), allocatable, intent(inout) :: a(:)
real(kind=dp), allocatable, intent(in) :: b(:)
real(kind=dp), intent(in) :: scalar
real(kind=dp) :: S, E
integer :: i

S = getTimeStamp()
!$OMP PARALLEL DO
do  i = 1, n
   a(i) = a(i) + scalar * b(i)
end do
E = getTimeStamp()

seconds = E-S
end function daxpy

function striad (a, b, c, d) result(seconds)
implicit none
real(kind=dp) :: seconds
real(kind=dp), allocatable, intent(inout) :: a(:)
real(kind=dp), allocatable, intent(in) :: b(:)
real(kind=dp), allocatable, intent(in) :: c(:)
real(kind=dp), allocatable, intent(in) :: d(:)
real(kind=dp) :: S, E
integer :: i

S = getTimeStamp()
!$OMP PARALLEL DO
do  i = 1, n
   a(i) = b(i) + c(i) * d(i)
end do
E = getTimeStamp()

seconds = E-S
end function striad

function sdaxpy (a, b, c) result(seconds)
implicit none
real(kind=dp) :: seconds
real(kind=dp), allocatable, intent(inout) :: a(:)
real(kind=dp), allocatable, intent(in) :: b(:)
real(kind=dp), allocatable, intent(in) :: c(:)
real(kind=dp) :: S, E
integer :: i

S = getTimeStamp()
!$OMP PARALLEL DO
do  i = 1, n
   a(i) = a(i) + b(i) * c(i)
end do
E = getTimeStamp()

seconds = E-S
end function sdaxpy

end module benchmarks
