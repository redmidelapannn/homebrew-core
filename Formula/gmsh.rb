class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-3.0.6-source.tgz"
  sha256 "9700bcc440d7a6b16a49cbfcdcdc31db33efe60e1f5113774316b6fa4186987b"
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8878ac61ef5b6f35e2193d767e41b0d2f158cd9c3262088ebd9a3f6e66d469aa" => :high_sierra
    sha256 "2dfb841cc6ab0ef51be089c128e3e438a24f5d8b14aa0cd4593ab5d3ec257a03" => :sierra
    sha256 "2e6efa5efcd4ac870b9c3d2ac565055970483a270ad8e33cd864f41e918c618e" => :el_capitan
  end

  option "with-opencascade", "Build with opencascade support"

  depends_on "cmake" => :build
  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90]
  depends_on "homebrew/science/opencascade" => :optional
  depends_on "fltk" => :optional
  depends_on "cairo" if build.with? "fltk"

  def install
    args = std_cmake_args + %W[
      -DENABLE_OS_SPECIFIC_INSTALL=0
      -DGMSH_BIN=#{bin}
      -DGMSH_LIB=#{lib}
      -DGMSH_DOC=#{pkgshare}/gmsh
      -DGMSH_MAN=#{man}
      -DENABLE_BUILD_LIB=ON
      -DENABLE_BUILD_SHARED=ON
      -DENABLE_NATIVE_FILE_CHOOSER=ON
      -DENABLE_PETSC=OFF
      -DENABLE_SLEPC=OFF
    ]

    if build.with? "opencascade"
      ENV["CASROOT"] = Formula["opencascade"].opt_prefix
      args << "-DENABLE_OCC=ON"
    else
      args << "-DENABLE_OCC=OFF"
    end

    args << "-DENABLE_FLTK=OFF" if build.without? "fltk"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"

      # Move onelab.py into libexec instead of bin
      mkdir_p libexec
      mv bin/"onelab.py", libexec
    end
  end

  def caveats
    "To use onelab.py set your PYTHONDIR to #{libexec}"
  end

  test do
    system "#{bin}/gmsh", "#{share}/doc/gmsh/tutorial/t1.geo", "-parse_and_exit"
  end
end
