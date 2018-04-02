class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.0.0/OpenCoarrays-2.0.0.tar.gz"
  sha256 "996633f5f7563aa516e895817f26a43ef03c652d337972d64744e40dff343301"
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "670c3cb70f388bf714a911f241f7a3602fdc790627f09eb51f32b01c8816cae8" => :high_sierra
    sha256 "e711d501e46883fe72316acd5b7f1862dc5b094eee7e5a8f298ffb1f6ed42cb8" => :sierra
    sha256 "12857ba4775ef38f4acc9c2081c6e7425672d6092e64602d7dac018390abf018" => :el_capitan
  end

  option "without-failed-image-support", "Disable F2018 failed image support that uses experimental MPI features"
  option "with-compile-time-tests", "Run the OpenCoarrays test suite at build time."

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "mpich"

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DCAF_ENABLE_FAILED_IMAGES=FALSE" if build.without? "failed-image-support"
      system "cmake", "..", *args
      system "make"
      system "make", "check" if build.with? "compile-time-tests"
      system "make", "install"
    end
  end

  test do
    (testpath/"tally.f90").write <<~EOS
      program main
        use iso_c_binding, only : c_int
        use iso_fortran_env, only : error_unit
        implicit none
        integer(c_int) :: tally
        tally = this_image() ! this image's contribution
        call co_sum(tally)
        verify: block
          integer(c_int) :: image
          if (tally/=sum([(image,image=1,num_images())])) then
             write(error_unit,'(a,i5)') "Incorrect tally on image ",this_image()
             error stop 2
          end if
        end block verify
        ! Wait for all images to pass the test
        sync all
        if (this_image()==1) write(*,*) "Test passed"
      end program
    EOS
    system "#{bin}/caf", "tally.f90", "-o", "tally"
    system "#{bin}/cafrun", "-np", "3", "./tally"
  end
end
