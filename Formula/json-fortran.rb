class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/6.9.0.tar.gz"
  sha256 "bf19159372f580eab12e711fef8ac637624d32766dd3c30534007d1b4091f092"
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "631d1e434c69a98d73108cb0b9b23cb1d914a2dd070ea7dbd8a55efa9f37d168" => :mojave
    sha256 "34e24694f273e5166f1e25330a2fd833f035e57b85bfa090151eff536d1876f6" => :high_sierra
    sha256 "fe6f40087dd0c40fdfb1a0f9bae35b80f75cacc848c8c004e33b02461454eb88" => :sierra
    sha256 "bd90ff29c850036693d40fa4b92597692f5b3910c2670e4cca51f71c907afe15" => :el_capitan
  end

  option "with-unicode-support", "Build json-fortran to support unicode text in json objects and files"

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE" # Use more GNU/Homebrew-like install layout
      args << "-DENABLE_UNICODE:BOOL=TRUE" if build.with? "unicode-support"
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"json_test.f90").write <<~EOS
      program example
      use json_module, RK => json_RK
      use iso_fortran_env, only: stdout => output_unit
      implicit none
      type(json_core) :: json
      type(json_value),pointer :: p, inp
      call json%initialize()
      call json%create_object(p,'')
      call json%create_object(inp,'inputs')
      call json%add(p, inp)
      call json%add(inp, 't0', 0.1_RK)
      call json%print(p,stdout)
      call json%destroy(p)
      if (json%failed()) error stop 'error'
      end program example
    EOS
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system "./test"
  end
end
