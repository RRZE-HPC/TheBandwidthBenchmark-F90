! License file

module timing
interface
      function getTimeStamp () result(seconds)
          double precision seconds
      end function getTimeStamp
end interface
end module timing
