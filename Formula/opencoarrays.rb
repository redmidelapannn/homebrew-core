class Opencoarrays < Formula
  desc "open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/opencoarrays/releases/download/1.8.8/OpenCoarrays-1.8.8.tar.gz"
  sha256 "d31336119f5874af30305fec0be8e67838d5b3baa856338f3ef58e5742ef9949"
  revision 1

  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e16e4a21db1628f9760d8781ebcc6c77212daa2e1041728cc9926121483eb35" => :sierra
    sha256 "ae55d96c3eb5e79b324c55065c60ff33f7aa79e2981125d38e5b1138f090ee3c" => :el_capitan
    sha256 "a75da672780e9c4eed3768c3cd37da3edbbf2f1540dc8acceebf25b4f425b0f5" => :yosemite
  end

  # As long as there are known failures with Homebrew's default compiler,
  # we turn the tests off by default
  # https://github.com/sourceryinstitute/OpenCoarrays/issues/374
  # option "without-test", "Skip build time tests (not recommended)"
  option "with-test", "Perform build time tests"

  depends_on "gcc"
  depends_on :fortran
  depends_on :mpi => :cc
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "ctest", "--output-on-failure", "--schedule-random" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    ENV.fortran
    (testpath/"tally.f90").write <<-EOS.undent
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
