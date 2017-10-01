class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-3.0.5-source.tgz"
  sha256 "ae39ed81178d94b76990b8c89b69a5ded8910fd8f7426b800044d00373d12a93"
  head "http://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4900ad0331e78f592f48f1e501e0cf9a1b0d18dc2a6abcb0084f24d4d0ecf904" => :high_sierra
    sha256 "5e06165f6519f67ae2a0cb0a6b2ce08724e983a1ac9be481e7b62a9c5651be64" => :sierra
    sha256 "ad1632ed8421a722bb7e896c931510b2bc631b500c50d4eb5befd56a054cfe36" => :el_capitan
  end

  option "with-oce", "Build with oce support (conflicts with opencascade)"
  option "with-opencascade", "Build with opencascade support (conflicts with oce)"

  depends_on "cmake" => :build
  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90]
  depends_on "homebrew/science/oce" => :optional
  depends_on "homebrew/science/opencascade" => :optional
  depends_on "fltk" => :optional
  depends_on "cairo" if build.with? "fltk"

  if build.with?("opencascade") && build.with?("oce")
    odie "gmsh: '--with-opencascade' and '--with-oce' conflict."
  end

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

    if build.with? "oce"
      ENV["CASROOT"] = Formula["oce"].opt_prefix
      args << "-DENABLE_OCC=ON"
    elsif build.with? "opencascade"
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
